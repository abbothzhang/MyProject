//
//  MirrorCameraInput.mm
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <CoreFoundation/CFString.h>
#import "MirrorCameraInput.h"
#import <sys/time.h>
#include <dispatch/object.h>
#import <objc/message.h>
#import "MirrorGLKProgram.h"
#import "MirrorOpenGLFrameBufferCache.h"
#import "Endian.h"

// BT.601, which is the standard for SDTV.
const GLfloat kColorConver601[] = {
    1.164,  1.164, 1.164,
    0.0, -0.392, 2.017,
    1.596, -0.813,   0.0,
};

// BT.709, which is the standard for HDTV.
const GLfloat kColorConver709[] = {
    1.164,  1.164, 1.164,
    0.0, -0.213, 2.112,
    1.793, -0.533,   0.0,
};

const GLfloat kColorConver601FullRange[] = {
    1.0,    1.0,    1.0,
    0.0,    -0.343, 1.765,
    1.4,    -0.711, 0.0,
};

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
#define TBPSDispatchRelease(d)
#else
#define TBPSDispatchRelease(d) (dispatch_release(d));
#endif

#define kMaxTimeSamples 10
#define clamp(a) (a>255?255:(a<0?0:a))

@interface MirrorCameraInput ()

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureVideoDataOutput *videoDataOutput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (assign, nonatomic) BOOL shouldStartCapturingWhenBecomesActive;
@property (nonatomic, strong) NSString *sessionPreset;
@property (nonatomic, strong) NSMutableArray *secondsPerFrameArray;//spfArray
@property (assign, nonatomic) BOOL secondsPerFrameArrayDirty;//这个变量感觉没什么用呀
@property (nonatomic,strong) MirrorGLKProgram *program;
@property (nonatomic,assign) GLuint luminanceTexture;
@property (nonatomic,assign) GLuint chrominanceTexture;
@property (assign, nonatomic) BOOL takeAPhotoAfterAdjustingFocus;
@property (copy, nonatomic) void (^takeAPhotoCompletion)(UIImage *image);
@property (nonatomic, strong) dispatch_source_t timerSPF;

- (void)createSPFTimer;
- (void)destroySPFTimer;
- (void)initConverProgram;

@end

@implementation MirrorCameraInput

@synthesize captureSession = _captureSession;
@synthesize videoWidth = _videoWidth,videoHeight = _videoHeight;
@synthesize device = _device;
@synthesize input = _input;
@synthesize sessionPreset = _sessionPreset;
@synthesize cameraPosition = _cameraPosition;
@synthesize waitForFocus = _waitForFocus;
@synthesize flashMode = _flashMode;
@synthesize updateSecondsPerFrame = _updateSecondsPerFrame;
@synthesize secondsPerFrame = _secondsPerFrame;
@synthesize secondsPerFrameArray = _secondsPerFrameArray;
@synthesize secondsPerFrameArrayDirty = _secondsPerFrameArrayDirty;
@synthesize rendering = _rendering;
@synthesize capturing = _capturing;
@synthesize timerSPF = _timerSPF;
@synthesize videoDataOutput = _videoDataOutput;
@synthesize stillImageOutput = _stillImageOutput;
@synthesize delegate = _delegate;
@synthesize luminanceTexture = _luminanceTexture;
@synthesize chrominanceTexture = _chrominanceTexture;
@synthesize cameraOrientation = _cameraOrientation;
@synthesize horizontallyMirrorFrontFacingCamera = _horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera = _horizontallyMirrorRearFacingCamera;
@synthesize program = _program;

//这个方法暂时还没用到
- (id)init
{
    if (self = [self initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront]) {
    }
    return self;
}

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition
{
    self = [self initWithSessionPreset:sessionPreset cameraPosition:cameraPosition captureAsYUV:YES];
    return self;
}

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition captureAsYUV:(BOOL)captureAsYUV
{
    if (self = [super init]) {
        _captureAsYUV = captureAsYUV;
        _frameRenderingSemaphore = dispatch_semaphore_create(1);
        self.videoHeight = self.videoWidth = 0;
        self.shouldStartCapturingWhenBecomesActive = NO;
        self.captureSession = [[AVCaptureSession alloc] init];
        self.sessionPreset = sessionPreset;
        self.cameraPosition = cameraPosition;
        [self setupOutputs];
        self.waitForFocus = YES;
        if (_captureAsYUV) {
            _preferConver = kColorConver601FullRange;
            [self initConverProgram];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceSubjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
    }
    return self;
}

//ConverProgram???
- (void)initConverProgram {
    runSynchronousOnContextQueue(^{
        [[MirrorOpenGLContext sharedContext] setCurrentContext];
        self.program = [MirrorGLKProgram defaultYUVProgram];
        [MirrorOpenGLContext setActiveProgram:self.program];
        assert(self.program);
        glEnableVertexAttribArray([self.program attributeIndex:@"position"]);//开启顶点属性数组
        glEnableVertexAttribArray([self.program attributeIndex:@"inputTextureCoordinate"]);//开启顶点属性数组
    });
}

#pragma mark - Private Methods

- (void)setupOutputs
{
    if (!_cameraQueue) {
        _cameraQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
    }
    [self.captureSession beginConfiguration];
    
    [self.captureSession removeOutput:self.videoDataOutput];
    [self.captureSession removeOutput:self.stillImageOutput];
    
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    if (!_captureAsYUV) {
        self.videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    }
    else {
        self.videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    }
    [self.videoDataOutput setSampleBufferDelegate:self queue:_cameraQueue];
    [self.captureSession addOutput:self.videoDataOutput];
#if 0//???
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.stillImageOutput.outputSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [self.captureSession addOutput:self.stillImageOutput];
#endif
    [self.captureSession commitConfiguration];
    //AVCaptureConnection *connection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    //connection.videoOrientation = AVCaptureVideoOrientationPortrait;
}

//设置使用前摄像头还是后摄像头
- (void)setCameraPosition:(AVCaptureDevicePosition)cameraPosition
{
    // Attempt to obtain the requested device. If not found, the state of this object is not changed and a warning is printed.
    AVCaptureDevice *newDevice = nil;
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo] && (device.position == cameraPosition)) {
            newDevice = device;
            break;
        }
    }
    if (newDevice == nil) {
        NSLog(@"TBPSOpenGLAVCamView: Failed to set camera position. No device found in the %@.", cameraPosition == AVCaptureDevicePositionFront? @"front": (cameraPosition == AVCaptureDevicePositionBack? @"back": @"unknown position"));
        return;
    }
    
    _cameraPosition = cameraPosition;
    self.device = newDevice;
    
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.input];
    
    NSError *error = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (self.input) {
        [self.captureSession addInput:self.input];
    }
    else {
        NSLog(@"TBPSOpenGLAVCamView: Failed to create device input: %@", [error localizedDescription]);
    }
    
    [self.captureSession commitConfiguration];
    if (self.videoDataOutput) {
        AVCaptureConnection *connection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
        CGFloat maxScale = connection.videoMaxScaleAndCropFactor;
        if (_cameraPosition == AVCaptureDevicePositionBack && maxScale >= 1.2f) {
            connection.videoScaleAndCropFactor = 1.2f;//后置摄像头拉近
        }
        else
        {
            connection.videoScaleAndCropFactor = 1.0f;
        }
    }
}

- (void)removeObservers
{
    [self.device removeObserver:self forKeyPath:@"adjustingFocus"];
    [self.device removeObserver:self forKeyPath:@"adjustingExposure"];
    [self.device removeObserver:self forKeyPath:@"adjustingWhiteBalance"];
}

- (void)setDevice:(AVCaptureDevice *)device
{
    [self removeObservers];
    _device = device;
    [self.device addObserver:self forKeyPath:@"adjustingFocus" options:0 context:NULL];
    [self.device addObserver:self forKeyPath:@"adjustingExposure" options:0 context:NULL];
    [self.device addObserver:self forKeyPath:@"adjustingWhiteBalance" options:0 context:NULL];
}

- (BOOL)focusPointSupported
{
    return self.device.focusPointOfInterestSupported;//是否支持聚焦
}

- (CGPoint)focusPoint
{
    return self.device.focusPointOfInterest;
}

- (void)setFocusPoint:(CGPoint)focusPoint
{
    if (!self.focusPointSupported) {
        return;
    }
    dispatch_async(_cameraQueue, ^{
        AVCaptureDevice *device = self.device;
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported]) {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                    [device setFocusMode:AVCaptureFocusModeAutoFocus];
                }
                [device setFocusPointOfInterest:focusPoint];
            }
            if ([device isExposurePointOfInterestSupported])
            {
                if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
                    [device setExposureMode:AVCaptureExposureModeAutoExpose];                    
                }
            }
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
            {
                [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            if ([device isLowLightBoostSupported]) {
                [device setAutomaticallyEnablesLowLightBoostWhenAvailable:YES];
            }
            [device setSubjectAreaChangeMonitoringEnabled:YES];
            [device unlockForConfiguration];
        }
    });
}

- (BOOL)lowLightBoostSupported
{
    if ([self.device respondsToSelector:@selector(isLowLightBoostSupported)]) {
        return ((BOOL (*)(id, SEL))objc_msgSend)(self.device, @selector(isLowLightBoostSupported));
    }
    return NO;
}

- (BOOL)lowLightBoostEnabled
{
    if ([self.device respondsToSelector:@selector(isLowLightBoostEnabled)]) {
        return ((BOOL (*)(id, SEL))objc_msgSend)(self.device, @selector(isLowLightBoostEnabled));
    }
    return NO;
}

- (BOOL)automaticallyEnablesLowLightBoostWhenAvailable
{
    if ([self.device respondsToSelector:@selector(automaticallyEnablesLowLightBoostWhenAvailable)]) {
        return ((BOOL (*)(id, SEL))objc_msgSend)(self.device, @selector(automaticallyEnablesLowLightBoostWhenAvailable));
    }
    return NO;
}

- (void)deviceSubjectAreaDidChange:(NSNotification *)notification
{
    if ([self.device isAdjustingFocus] || [self.device isAdjustingExposure])
        return;    
    CGPoint focusPoint = CGPointMake(0.5f, 0.5f);
    [self setFocusPoint:focusPoint];
}

- (void)setAutomaticallyEnablesLowLightBoostWhenAvailable:(BOOL)automaticallyEnablesLowLightBoostWhenAvailable
{
    if (self.lowLightBoostSupported && [self.device respondsToSelector:@selector(setAutomaticallyEnablesLowLightBoostWhenAvailable:)]) {
        NSError *error = nil;
        if (![self.device lockForConfiguration:&error]) {
            NSLog(@"TBPSOpenGLAVCamView: Failed to enable automatic low light boost: %@", [error localizedDescription]);
            return;
        }
        ((void(*)(id, SEL, BOOL))objc_msgSend)(self.device, @selector(setAutomaticallyEnablesLowLightBoostWhenAvailable:), automaticallyEnablesLowLightBoostWhenAvailable);
        [self.device unlockForConfiguration];
    }
}

- (void)setSessionPreset:(NSString *)sessionPreset {
    _sessionPreset = [sessionPreset copy];
    self.captureSession.sessionPreset = sessionPreset;
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode
{
    NSError *error = nil;
    if (![self.device lockForConfiguration:&error]) {
        NSLog(@"TBPSOpenGLAVCamView: Failed to set flash mode: %@", [error localizedDescription]);
        return;
    }
    self.device.flashMode = flashMode;
    _flashMode = flashMode;
    [self.device unlockForConfiguration];
}

- (BOOL)hasTorch
{
    return [self.device hasTorch];
}



- (void)startCapturing
{
    self.rendering = YES;
    [self.captureSession startRunning];
    
    if (self.updateSecondsPerFrame) {
        [self createSPFTimer];
    }
}

- (void)stopCapturing
{
    self.rendering = NO;
    [self.captureSession stopRunning];
    [self destroySPFTimer];
}


- (BOOL)isCapturing
{
    return self.captureSession.isRunning;
}

- (void)setCapturing:(BOOL)capturing
{
    capturing? [self startCapturing]: [self stopCapturing];
}

- (void)setRendering:(BOOL)rendering
{
    _rendering = rendering;
    
    if (_rendering) {
        [self.videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    else {
        [self.videoDataOutput setSampleBufferDelegate:nil queue:NULL];
    }
}

#pragma mark - spf
- (NSTimeInterval)secondsPerFrame
{
    if (!self.updateSecondsPerFrame) {
        _secondsPerFrame = 0;
    }
    else if (self.secondsPerFrameArrayDirty) {
        _secondsPerFrame = 0;
        for (NSNumber *n in self.secondsPerFrameArray) {
            _secondsPerFrame += n.doubleValue;
        }
        _secondsPerFrame /= self.secondsPerFrameArray.count;
    }
    
    return _secondsPerFrame;
}

- (void)setUpdateSecondsPerFrame:(BOOL)updateSecondsPerFrame
{
    _updateSecondsPerFrame = updateSecondsPerFrame;
    
    if (_updateSecondsPerFrame && self.isCapturing) {
        [self createSPFTimer];
    }
    else {
        [self destroySPFTimer];
    }
}

- (void)createSPFTimer
{
    [self destroySPFTimer];
    self.secondsPerFrameArray = [[NSMutableArray alloc] init];
    self.timerSPF = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timerSPF, dispatch_walltime(NULL, 0), 1e9, 1e8);//???
//    dispatch_source_set_timer(<#dispatch_source_t source#>, <#dispatch_time_t start#>, <#uint64_t interval#>, <#uint64_t leeway#>)
    dispatch_source_set_event_handler(self.timerSPF, ^{
        if (self.isCapturing && [self.delegate respondsToSelector:@selector(videoCamera:didUpdateSecondsPerFrame:)]) {
            [self.delegate videoCamera:self didUpdateSecondsPerFrame:self.secondsPerFrame];
        }
    });
    dispatch_resume(self.timerSPF);
}

- (void)destroySPFTimer
{
    if (self.timerSPF != NULL) {
        TBPSDispatchRelease(self.timerSPF);
        self.timerSPF = NULL;
    }
    self.secondsPerFrameArray = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopCapturing];
    [self removeObservers];
    if (self.timerSPF != NULL) {
        TBPSDispatchRelease(self.timerSPF);
    }
    if (_frameRenderingSemaphore != NULL)
    {
#if !OS_OBJECT_USE_OBJC   //这个宏是在sdk6.0之后才有的,如果是之前的,则OS_OBJECT_USE_OBJC为0
        dispatch_release(_frameRenderingSemaphore);
#endif
    }
    
    //渲染完毕，关闭顶点属性数组
    glDisableVertexAttribArray([self.program attributeIndex:@"position"]);
    glDisableVertexAttribArray([self.program attributeIndex:@"inputTextureCoordinate"]);

}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (!self.isRendering) {
        return;
    }
    if (dispatch_semaphore_wait(_frameRenderingSemaphore, DISPATCH_TIME_NOW) != 0) {
        return;
    }
    CFRetain(sampleBuffer);
    runAsynchronousOnContextQueue(^{
        NSTimeInterval t0 = 0, t1 = 0;
        if (self.updateSecondsPerFrame) {
            struct timeval t;
            gettimeofday(&t, NULL);
            t0 = t.tv_sec + t.tv_usec*1.0e-6;
        }
        [self updateTargetsForSampleBuffer:sampleBuffer];
        [self processOutputSampleBuffer:sampleBuffer];
        CFRelease(sampleBuffer);
        dispatch_semaphore_signal(_frameRenderingSemaphore);
        if (self.updateSecondsPerFrame) {
            struct timeval t;
            gettimeofday(&t, NULL);
            t1 = t.tv_sec + t.tv_usec*1.0e-6;
            CFTimeInterval dt = t1 - t0;
            [self.secondsPerFrameArray addObject:[NSNumber numberWithDouble:dt]];
            if (self.secondsPerFrameArray.count > kMaxTimeSamples) {
                [self.secondsPerFrameArray removeObjectAtIndex:0];
            }
            self.secondsPerFrameArrayDirty = YES;//这个变量感觉没什么用
        }
    });
}

- (void)updateTargetsForSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    NSArray *targets = self.targets;
    // First, update all the framebuffers in the targets
    for (id<MirrorOpenGLProtocol> currentTarget in targets)
    {
        if ([currentTarget enabled] && [currentTarget shouldUpdatesSimpleBufferToThisTarget]) {
            [currentTarget inputSampleBuffer:sampleBuffer];
        }
    }
}



- (void)processOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef cameraFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
    int bufferWidth = (int)CVPixelBufferGetWidth(cameraFrame);
    int bufferHeight = (int)CVPixelBufferGetHeight(cameraFrame);
    CMTime currentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);// 获取当前视频帧的时间
    [[MirrorOpenGLContext sharedContext] setCurrentContext];
    CFTypeRef colorAttachments = CVBufferGetAttachment(cameraFrame, kCVImageBufferYCbCrMatrixKey, NULL);//获取当前视频帧颜色格式，YUV还是RGB
    if (colorAttachments != NULL) {
        if (CFStringCompare((CFStringRef)colorAttachments, (CFStringRef)kCVImageBufferYCbCrMatrix_ITU_R_601_4, 0) == kCFCompareEqualTo)
        {
            if (_captureAsYUV) {//视频帧是否是yuv???
                _preferConver = kColorConver601FullRange;
            }
            else
            {
                _preferConver = kColorConver601;
            }
        }
        else
        {
            _preferConver = kColorConver709;
        }
    }
    else
    {
        if (_captureAsYUV)
        {
            _preferConver = kColorConver601FullRange;
        }
        else
        {
            _preferConver = kColorConver601;
        }
    }
    
    if ([MirrorOpenGLContext supportsFastTextureUpload] && _captureAsYUV) {
        CVOpenGLESTextureRef luminanceTextureRef = NULL;//luminance亮度???
        CVOpenGLESTextureRef chrominanceTextureRef = NULL;//chrominance色度???
        // Check for YUV planar inputs to do RGB conversion
        if (CVPixelBufferGetPlaneCount(cameraFrame) > 0) {
            CVPixelBufferLockBaseAddress(cameraFrame, 0);            
            if ((self.videoWidth != bufferWidth) && (self.videoHeight != bufferHeight)) {
                self.videoWidth = bufferWidth;
                self.videoHeight = bufferHeight;
            }
            CVReturn err;
            // Y-plane

            //texUnit是一个符号常量，其形式为GL_TEXTUREi，其中i的范围是从0到k-1，k是纹理单位的最大数量
            glActiveTexture(GL_TEXTURE4);
            //GLenum error = glGetError();
            assert(!glGetError());
            if ([MirrorOpenGLContext deviceSupportsRedTextures])
            {
                //err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, coreVideoTextureCache, cameraFrame, NULL, GL_TEXTURE_2D, GL_RED_EXT, bufferWidth, bufferHeight, GL_RED_EXT, GL_UNSIGNED_BYTE, 0, &luminanceTextureRef);
                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[MirrorOpenGLContext sharedContext] videoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_LUMINANCE, bufferWidth, bufferHeight, GL_LUMINANCE, GL_UNSIGNED_BYTE, 0, &luminanceTextureRef);
            }
            else
            {
                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[MirrorOpenGLContext sharedContext] videoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_LUMINANCE, bufferWidth, bufferHeight, GL_LUMINANCE, GL_UNSIGNED_BYTE, 0, &luminanceTextureRef);
            }
            if (err)
            {
                NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
            }
            self.luminanceTexture = CVOpenGLESTextureGetName(luminanceTextureRef);
            glBindTexture(GL_TEXTURE_2D, self.luminanceTexture);
            //设置纹理样式，s方向和t方向都是纹理重复使用，直到全部填充完成，
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            assert(!glGetError());
            // UV-plane
            glActiveTexture(GL_TEXTURE5);
            if ([MirrorOpenGLContext deviceSupportsRedTextures])
            {
                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[MirrorOpenGLContext sharedContext] videoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_LUMINANCE_ALPHA, bufferWidth/2, bufferHeight/2, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 1, &chrominanceTextureRef);
            }
            else
            {
                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[MirrorOpenGLContext sharedContext] videoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_LUMINANCE_ALPHA, bufferWidth/2, bufferHeight/2, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 1, &chrominanceTextureRef);
            }
            if (err)
            {
                NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
            }
            
            self.chrominanceTexture = CVOpenGLESTextureGetName(chrominanceTextureRef);
            assert(!glGetError());
            glBindTexture(GL_TEXTURE_2D, self.chrominanceTexture);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            assert(!glGetError());
            [self convertYUVToRGBOutput];
            int rotatedImageBufferWidth = bufferWidth, rotatedImageBufferHeight = bufferHeight;
            
            if (MirrorImageRotationSwapsWidthAndHeight(_internalRotation))
            {
                rotatedImageBufferWidth = bufferHeight;
                rotatedImageBufferHeight = bufferWidth;
            }

            [self updateTargetsForVideoCameraUsingCacheTextureAtWidth:rotatedImageBufferWidth height:rotatedImageBufferHeight time:currentTime];
            
            CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
            CFRelease(luminanceTextureRef);
            CFRelease(chrominanceTextureRef);
        }
    }
    else
    {
        CVPixelBufferLockBaseAddress(cameraFrame, 0);
        
        int bytesPerRow = (int) CVPixelBufferGetBytesPerRow(cameraFrame);
        MirrorOpenGLFrameBufferCache *framebufferCache = [MirrorOpenGLContext sharedContext].framebufferCache;
        self.outputFramebuffer = [framebufferCache fetchFramebufferForSize:CGSizeMake(bytesPerRow / 4, bufferHeight) onlyTexture:YES];
        [self.outputFramebuffer activateFramebuffer];
        
        glBindTexture(GL_TEXTURE_2D, [self.outputFramebuffer texture]);
        assert(!glGetError());

        //        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(cameraFrame));
        
        // Using BGRA extension to pull in video frame data directly
        // The use of bytesPerRow / 4 accounts for a display glitch present in preview video frames when using the photo preset on the camera
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bytesPerRow / 4, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(cameraFrame));
        assert(!glGetError());

        [self updateTargetsForVideoCameraUsingCacheTextureAtWidth:bytesPerRow / 4 height:bufferHeight time:currentTime];
        
        CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
    }
}

//???以下是怎么做到YUV转RGB的呢
- (void)convertYUVToRGBOutput;
{
    [MirrorOpenGLContext setActiveProgram:self.program];
    assert(!glGetError());
    int rotatedImageBufferWidth = (int)self.videoWidth, rotatedImageBufferHeight = (int)self.videoHeight;
    
    if (MirrorImageRotationSwapsWidthAndHeight(_internalRotation))
    {
        rotatedImageBufferWidth = (int)self.videoHeight;
        rotatedImageBufferHeight = (int)self.videoWidth;
    }
    MirrorOpenGLFrameBufferCache *framebufferCache = [MirrorOpenGLContext sharedContext].framebufferCache;
    
    self.outputFramebuffer = [framebufferCache fetchFramebufferForSize:CGSizeMake(rotatedImageBufferWidth, rotatedImageBufferHeight) textureOptions:self.outputTextureOptions onlyTexture:NO];
    [self.outputFramebuffer activateFramebuffer];
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);//背景颜色为黑
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    assert(!glGetError());
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    glActiveTexture(GL_TEXTURE4);
    glBindTexture(GL_TEXTURE_2D, self.luminanceTexture);
    glUniform1i([self.program uniformIndex:@"luminanceTexture"], 4);//???
    
    assert(!glGetError());
    
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, self.chrominanceTexture);
    glUniform1i([self.program uniformIndex:@"chrominanceTexture"], 5);
    assert(!glGetError());
    
    glUniformMatrix3fv([self.program uniformIndex:@"colorConversionMatrix"], 1, GL_FALSE, _preferConver);
    assert(!glGetError());
    
    //为顶点着色器位置信息赋值，positionSlot表示顶点着色器位置属性（即，Position）；2表示每一个顶点信息由几个值组成，这个值必须位1，2，3或4；GL_FLOAT表示顶点信息的数据类型；GL_FALSE表示不要将数据类型标准化（即fixed-point）；stride表示数组中每个元素的长度；pCoords表示数组的首地址
    glVertexAttribPointer([self.program attributeIndex:@"position"], 2, GL_FLOAT, 0, 0, squareVertices);
    glVertexAttribPointer([self.program attributeIndex:@"inputTextureCoordinate"], 2, GL_FLOAT, 0, 0, [MirrorOpenGLContext textureCoordinatesForRotation:_internalRotation]);
    assert(!glGetError());
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);//将顶点数组使用三角形渲染，GL_TRIANGLES表示三角形， 0表示数组第一个值的位置，vertexCount表示数组长度
    assert(!glGetError());
}

- (void)updateTargetsForVideoCameraUsingCacheTextureAtWidth:(int)bufferWidth height:(int)bufferHeight time:(CMTime)currentTime;
{
    NSArray *targets = self.targets;
    // First, update all the framebuffers in the targets
    for (id<MirrorOpenGLProtocol> currentTarget in targets)
    {
        if ([currentTarget enabled] && ![currentTarget shouldUpdatesSimpleBufferToThisTarget])
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[self.targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            if (currentTarget != self.targetToIgnoreForUpdates)
            {
                [currentTarget setInputRotation:_outputRotation atIndex:textureIndexOfTarget];
                [currentTarget setInputSize:CGSizeMake(bufferWidth, bufferHeight) atIndex:textureIndexOfTarget];
                
                if ([currentTarget wantsMonochromeInput])
                {
                    [currentTarget setCurrentMonochromeInput:YES];
                    // TODO: Replace optimization for monochrome output
                    [currentTarget setInputFramebuffer:self.outputFramebuffer atIndex:textureIndexOfTarget];
                }
                else
                {
                    [currentTarget setCurrentMonochromeInput:NO];
                    [currentTarget setInputFramebuffer:self.outputFramebuffer atIndex:textureIndexOfTarget];
                }
            }
            else
            {
                [currentTarget setInputRotation:_outputRotation atIndex:textureIndexOfTarget];
                [currentTarget setInputFramebuffer:self.outputFramebuffer atIndex:textureIndexOfTarget];
            }
        }
    }
    
    // Then release our hold on the local framebuffer to send it back to the cache as soon as it's no longer needed
    [self.outputFramebuffer unlock];
    self.outputFramebuffer = nil;
    
    // Finally, trigger rendering as needed
    for (id<MirrorOpenGLProtocol> currentTarget in targets)
    {
        if ([currentTarget enabled] && ![currentTarget shouldUpdatesSimpleBufferToThisTarget])
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[self.targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            if (currentTarget != self.targetToIgnoreForUpdates)
            {
                [currentTarget inputFramebufferAtTime:currentTime atIndex:textureIndexOfTarget];
            }
        }
    }
}



- (void)updateOrientationSendToTargets;
{
    runSynchronousOnContextQueue(^{
        //    From the iOS 5.0 release notes:
        //    In previous iOS versions, the front-facing camera would always deliver buffers in AVCaptureVideoOrientationLandscapeLeft and the back-facing camera would always deliver buffers in AVCaptureVideoOrientationLandscapeRight.
        if (_captureAsYUV && [MirrorOpenGLContext supportsFastTextureUpload]) {
            _outputRotation = kMirrorImageNoRotation;
            if ([self cameraPosition] == AVCaptureDevicePositionBack)
            {
                if (_horizontallyMirrorRearFacingCamera)
                {
                    switch(_cameraOrientation)
                    {
                        case UIInterfaceOrientationPortrait:
                            _internalRotation = kMirrorImageRotateRightFlipVertical;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            _internalRotation = kMirrorImageRotate180;
                            break;
                        case UIInterfaceOrientationLandscapeLeft:
                            _internalRotation = kMirrorImageFlipHorizonal;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            _internalRotation = kMirrorImageFlipVertical;
                            break;
                        default:
                            _internalRotation = kMirrorImageNoRotation;
                            break;
                    }
                }
                else
                {
                    switch(_cameraOrientation)
                    {
                        case UIInterfaceOrientationPortrait:
                            _internalRotation = kMirrorImageRotateRight;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            _internalRotation = kMirrorImageRotateLeft;
                            break;
                        case UIInterfaceOrientationLandscapeLeft:
                            _internalRotation = kMirrorImageRotate180;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            _internalRotation = kMirrorImageNoRotation;
                            break;
                        default:
                            _internalRotation = kMirrorImageNoRotation;
                            break;
                    }
                }
            }
            else
            {
                if (_horizontallyMirrorFrontFacingCamera)
                {
                    switch(_cameraOrientation)
                    {
                        case UIInterfaceOrientationPortrait:
                            _internalRotation = kMirrorImageRotateRightFlipVertical;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            _internalRotation = kMirrorImageRotateRightFlipHorizontal;
                            break;
                        case UIInterfaceOrientationLandscapeLeft:
                            _internalRotation = kMirrorImageFlipHorizonal;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            _internalRotation = kMirrorImageFlipVertical;
                            break;
                        default:
                            _internalRotation = kMirrorImageNoRotation;
                            break;
                    }
                }
                else
                {
                    switch(_cameraOrientation)
                    {
                        case UIInterfaceOrientationPortrait:
                            _internalRotation = kMirrorImageRotateRight;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            _internalRotation = kMirrorImageRotateLeft;
                            break;
                        case UIInterfaceOrientationLandscapeLeft:
                            _internalRotation = kMirrorImageNoRotation;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            _internalRotation = kMirrorImageRotate180;
                            break;
                        default:
                            _internalRotation = kMirrorImageNoRotation;
                            break;
                    }
                }
            }
        }
        else
        {
            if ([self cameraPosition] == AVCaptureDevicePositionBack)
            {
                if (_horizontallyMirrorRearFacingCamera)
                {
                    switch(_cameraOrientation)
                    {
                        case UIInterfaceOrientationPortrait:
                            _outputRotation = kMirrorImageRotateRightFlipVertical;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            _outputRotation = kMirrorImageRotate180; break;
                        case UIInterfaceOrientationLandscapeLeft:
                            _outputRotation = kMirrorImageFlipHorizonal;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            _outputRotation = kMirrorImageFlipVertical;
                            break;
                        default:
                            _outputRotation = kMirrorImageNoRotation;
                            break;
                    }
                }
                else
                {
                    switch(_cameraOrientation)
                    {
                        case UIInterfaceOrientationPortrait:
                            _outputRotation = kMirrorImageRotateRight;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            _outputRotation = kMirrorImageRotateLeft;
                            break;
                        case UIInterfaceOrientationLandscapeLeft:
                            _outputRotation = kMirrorImageRotate180;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            _outputRotation = kMirrorImageNoRotation;
                            break;
                        default:
                            _outputRotation = kMirrorImageNoRotation;
                            break;
                    }
                }
            }
            else
            {
                if (_horizontallyMirrorFrontFacingCamera)
                {
                    switch(_cameraOrientation)
                    {
                        case UIInterfaceOrientationPortrait:
                            _outputRotation = kMirrorImageRotateRightFlipVertical;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            _outputRotation = kMirrorImageRotateRightFlipHorizontal;
                            break;
                        case UIInterfaceOrientationLandscapeLeft:
                            _outputRotation = kMirrorImageFlipHorizonal;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            _outputRotation = kMirrorImageFlipVertical;
                            break;
                        default:
                            _outputRotation = kMirrorImageNoRotation;
                            break;
                    }
                }
                else
                {
                    switch(_cameraOrientation)
                    {
                        case UIInterfaceOrientationPortrait:
                            _outputRotation = kMirrorImageRotateRight;
                            break;
                        case UIInterfaceOrientationPortraitUpsideDown:
                            _outputRotation = kMirrorImageRotateLeft;
                            break;
                        case UIInterfaceOrientationLandscapeLeft:
                            _outputRotation = kMirrorImageNoRotation;
                            break;
                        case UIInterfaceOrientationLandscapeRight:
                            _outputRotation = kMirrorImageRotate180;
                            break;
                        default:
                            _outputRotation = kMirrorImageNoRotation;
                            break;
                    }
                }
            }
        }
        NSArray *targets = [self targets];
        for (id<MirrorOpenGLProtocol> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            [currentTarget setInputRotation:_outputRotation atIndex:[[self.targetTextureIndices objectAtIndex:indexOfObject] integerValue]];
        }
    });
}

- (void)setCameraOrientation:(UIInterfaceOrientation)cameraOrientation {
    _cameraOrientation = cameraOrientation;
    [self updateOrientationSendToTargets];
}

- (UIImage *)makeUIImage:(uint8_t *)inBaseAddress bufferInfo:(CVPlanarPixelBufferInfo_YCbCrBiPlanar *)inBufferInfo width:(size_t)inWidth height:(size_t)inHeight bytesPerRow:(size_t)inBytesPerRow {
    
    NSUInteger yPitch = EndianU32_BtoN(inBufferInfo->componentInfoY.rowBytes);
    NSUInteger cbCrOffset = EndianU32_BtoN(inBufferInfo->componentInfoCbCr.offset);
    uint8_t *rgbBuffer = (uint8_t *)malloc(inWidth * inHeight * 4);
    NSUInteger cbCrPitch = EndianU32_BtoN(inBufferInfo->componentInfoCbCr.rowBytes);
    uint8_t *yBuffer = (uint8_t *)inBaseAddress;
    uint8_t *cbCrBuffer = inBaseAddress + cbCrOffset;
    int bytesPerPixel = 4;
    
    for(int y = 0; y < inHeight; y++)
    {
        uint8_t *rgbBufferLine = &rgbBuffer[y * inWidth * bytesPerPixel];
        uint8_t *yBufferLine = &yBuffer[y * yPitch];
        uint8_t *cbCrBufferLine = &cbCrBuffer[(y >> 1) * cbCrPitch];
        
        for(int x = 0; x < inWidth; x++)
        {
            int16_t y = yBufferLine[x];
            int16_t cb = cbCrBufferLine[x & ~1] - 128;
            int16_t cr = cbCrBufferLine[x | 1] - 128;
            
            uint8_t *rgbOutput = &rgbBufferLine[x*bytesPerPixel];
            
            int16_t r = (int16_t)roundf( y + cr *  1.4 );
            int16_t g = (int16_t)roundf( y + cb * -0.343 + cr * -0.711 );
            int16_t b = (int16_t)roundf( y + cb *  1.765);
            
            //ABGR
            rgbOutput[0] = 0xff;
            rgbOutput[1] = clamp(b);
            rgbOutput[2] = clamp(g);
            rgbOutput[3] = clamp(r);
        }
    }
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbBuffer, yPitch, inHeight, 8,
                                                 yPitch*bytesPerPixel, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    CGImageRelease(quartzImage);
    free(rgbBuffer);
    return  image;
}

- (void)takeAPhotoWithCompletion:(void (^)(UIImage *))completion
{
    if (self.waitForFocus && self.device.isAdjustingFocus) {
        self.takeAPhotoAfterAdjustingFocus = YES;
        self.takeAPhotoCompletion = completion;
        return;
    }
    self.rendering = NO;
    AVCaptureConnection *imageConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([port.mediaType isEqualToString:AVMediaTypeVideo]) {
                imageConnection = connection;
                break;
            }
        }
        
        if (imageConnection != nil) {
            break;
        }
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:imageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        [self stopCapturing]; // This frees a lot of memory (!)
        
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(imageDataSampleBuffer);
        
        // Compensate for padding. A small black line will be visible on the right. Adjust the texture coordinate transform to fix this.
        GLint width = (GLint)CVPixelBufferGetWidth(imageBuffer);
        GLint height = (GLint)CVPixelBufferGetHeight(imageBuffer);
        
        if (width > 0 && height > 0) {
//            if ([self.delegate respondsToSelector:@selector(willOutputSampleBuffer:)]) {
//                [self.delegate willOutputSampleBuffer:imageDataSampleBuffer];
//            }
            //Lock the imagebuffer
            CVPixelBufferLockBaseAddress(imageBuffer,0);
            
            // Get information about the image
            uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
            
            //    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
            size_t width = CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
            
            CVPlanarPixelBufferInfo_YCbCrBiPlanar *bufferInfo = (CVPlanarPixelBufferInfo_YCbCrBiPlanar *)baseAddress;
            
            // This just moved the pointer past the offset
            baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
            
            // convert the image
            UIImage *image = [self makeUIImage:baseAddress bufferInfo:bufferInfo width:width height:height bytesPerRow:bytesPerRow];
            CVPixelBufferUnlockBaseAddress(imageBuffer,0);
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                });
            }
        }        
    }];

}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.device) {
        if ([keyPath isEqualToString:@"adjustingFocus"]) {
            if (self.device.adjustingFocus && [self.delegate respondsToSelector:@selector(videoCameraDidBeginAdjustingFocus:)]) {
                [self.delegate videoCameraDidBeginAdjustingFocus:self];
            }
            else if (!self.device.adjustingFocus) {
                //[self.cameraTargetView setVisible:NO animated:YES];
                if ([self.delegate respondsToSelector:@selector(videoCameraDidFinishAdjustingFocus:)]) {
                    [self.delegate videoCameraDidFinishAdjustingFocus:self];
                }
            }
            
            if (!self.device.adjustingFocus && self.takeAPhotoAfterAdjustingFocus) {
                [self takeAPhotoWithCompletion:self.takeAPhotoCompletion];
                self.takeAPhotoAfterAdjustingFocus = NO;
                self.takeAPhotoCompletion = nil;
            }
        }
        else if ([keyPath isEqualToString:@"adjustingExposure"]) {
            if (self.device.adjustingExposure && [self.delegate respondsToSelector:@selector(videoCameraDidBeginAdjustingExposure:)]) {
                [self.delegate videoCameraDidBeginAdjustingExposure:self];
            }
            else if (!self.device.adjustingExposure) {
                //[self.cameraTargetView setVisible:NO animated:YES];
                if ([self.delegate respondsToSelector:@selector(videoCameraDidFinishAdjustingExposure:)]) {
                    [self.delegate videoCameraDidFinishAdjustingExposure:self];
                }
            }
        }
        else if ([keyPath isEqualToString:@"adjustingWhiteBalance"]) {
            if (self.device.adjustingWhiteBalance && [self.delegate respondsToSelector:@selector(videoCameraDidBeginAdjustingWhiteBalance:)]) {
                [self.delegate videoCameraDidBeginAdjustingWhiteBalance:self];
            }
            else if (!self.device.adjustingWhiteBalance && [self.delegate respondsToSelector:@selector(videoCameraDidFinishAdjustingWhiteBalance:)]) {
                [self.delegate videoCameraDidFinishAdjustingWhiteBalance:self];
            }
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setHorizontallyMirrorFrontFacingCamera:(BOOL)newValue
{
    _horizontallyMirrorFrontFacingCamera = newValue;
    [self updateOrientationSendToTargets];
}

- (void)setHorizontallyMirrorRearFacingCamera:(BOOL)newValue
{
    _horizontallyMirrorRearFacingCamera = newValue;
    [self updateOrientationSendToTargets];
}

#pragma mark - Notifications

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    self.shouldStartCapturingWhenBecomesActive = self.captureSession.running;
    [self stopCapturing];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    if (self.shouldStartCapturingWhenBecomesActive) {
        [self startCapturing];
    }
}

@end
