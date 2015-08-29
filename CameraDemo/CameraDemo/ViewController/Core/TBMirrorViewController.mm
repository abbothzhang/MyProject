//
//  TBMirrorViewController.m
//  TBMirror
//
//  Created by albert on 15/3/26.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "TBMirrorViewController.h"
#import "TBMirrorViewController_Private.h"
#import "TBMirrorMakeUpModel.h"

#define TBMirror_Default_SessionPreset AVCaptureSessionPreset640x480

@interface TBMirrorViewController ()

@end


@implementation TBMirrorViewController


#pragma mark - Initialization & teardown

-(instancetype)initWithType:(TBMirrorMakeUpType)type delegate:(id<TBMirrorViewControllerDelegate>)delegate{
    self = [super init];
    if (self) {
        //type在这里其实没有用
        self.type = type;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCamera];
    [self setupView];
}

#pragma mark - Setup camera

- (void)setupCamera {
    if(![self checkCamera]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"请在iPhone的\"设置\"-\"隐私\"-\"相机\"选项中，允许手机淘宝访问您的相机"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 默认使用前置摄像头
    AVCaptureDevice *device = [self frontFacingCamera];
    self.isFrontCamera = YES;
    
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        // 前置摄像头无法使用尝试使用后置摄像头
        NSError *backCameraError = nil;
        videoInput = [AVCaptureDeviceInput deviceInputWithDevice:[self backFacingCamera] error:&backCameraError];
        self.isFrontCamera = NO;
        if (backCameraError) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"本设备没有支持的摄像头"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    self.session = [[AVCaptureSession alloc] init];
    
    if ( [self.session canAddInput:videoInput] ) {
        [self.session addInput:videoInput];
    }
    self.videoInput = videoInput;
    
    [self.session setSessionPreset:TBMirror_Default_SessionPreset];
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [videoDataOutput setVideoSettings:videoSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    self.videoDataOutputQueue = dispatch_queue_create("TBMirrorVideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    if ([self.session canAddOutput:videoDataOutput]) {
        [self.session addOutput:videoDataOutput];
    }
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    self.videoDataOutput = videoDataOutput;
    
    if ([device lockForConfiguration:&error]) {
        if ([device respondsToSelector:@selector(isLowLightBoostSupported)] && device.lowLightBoostSupported) {
            device.automaticallyEnablesLowLightBoostWhenAvailable = NO;
        }
        if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        }
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        [device unlockForConfiguration];
    }
}

-(BOOL)checkCamera {
    if ([AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count) {
        if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
            NSInteger status = (NSInteger)[[AVCaptureDevice class] performSelector:@selector(authorizationStatusForMediaType:)
                                                                        withObject:AVMediaTypeVideo];
            if(AVAuthorizationStatusAuthorized == status || AVAuthorizationStatusNotDetermined == status) {
                return YES;
            } else {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *) frontFacingCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *) backFacingCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

#pragma mark - Release camera

- (void)releaseCamera {
    if(_session) {
        if ([_session isRunning]) {
            [_session stopRunning];
        }
        [_session beginConfiguration];
        [_session removeInput:_videoInput];
        [_session removeOutput:_videoDataOutput];
        [_session commitConfiguration];
    }
    _videoInput = nil;
    _videoDataOutput = nil;
    _session = nil;
    _videoDataOutputQueue = nil;
}

#pragma mark - Subclass implementation

-(void)setFaceModelFilePath:(NSString*)path{
    /** virtual method **/
}

-(void)makeUpWithModels:(NSArray*)models{
    
}

//美颜
-(void)beautyWithModels:(NSArray*)models{

}

//点击切换前置和后置摄像头,返回是否切换成功
-(BOOL)switchCamera{
    BOOL success = NO;
    
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1) {
        NSError *error;
        AVCaptureDeviceInput *videoInput = [self videoInput];
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInput device] position];
        if (position == AVCaptureDevicePositionBack) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
            self.isFrontCamera = YES;
        } else if (position == AVCaptureDevicePositionFront) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
            self.isFrontCamera = NO;
        } else {
            return success;
        }
        
        AVCaptureSession *session = [self session];
        if (newVideoInput != nil) {
            [session beginConfiguration];
            [session removeInput:videoInput];
            if ([session canAddInput:newVideoInput]) {
                [session addInput:newVideoInput];
                self.videoInput = newVideoInput;
            } else {
                [session addInput:videoInput];
            }
            [session commitConfiguration];
            success = YES;
        }
    }
    
    return success;
}

-(BOOL)shootBtnClickedWithAction:(TBMirrorShootBtnAction)action{
    return NO;
}

-(UIImage*)getCosmeticImg{
    return nil;
}

-(NSString*)getVersion{
    return @"2.0";
}

- (void)setupView {
    
}

@end
