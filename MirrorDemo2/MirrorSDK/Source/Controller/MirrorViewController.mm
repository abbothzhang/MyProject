//
//  MirrorViewController.m
//  Mirror
//
//  Created by albert on 15/3/26.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "MirrorViewController.h"
#import "MirrorMakeUpModel.h"
#import "MirrorCameraInput.h"
#import "MirrorOpenGLView.h"
#import "MirrorMakeUpInput.h"
//#import "MirrorNetworkUtil.h"
#import "MirrorMakeUpManager.h"
#import "MirrorBeautyModel.h"
#import "MirrorMakeUpCenter.h"
#import "MirrorOpenGLContext.h"

@interface MirrorViewController () <MirrorCameraInputDelegate,MirrorMakeUpManagerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *sessionPreset;
@property (nonatomic,strong) MirrorCameraInput *cameraInput;
@property (nonatomic,strong) MirrorOpenGLView *glView;
@property (nonatomic,assign) AVCaptureDevicePosition cameraPosition;

@property (nonatomic,strong) UILabel                    *fpsLabel;

@end

@implementation MirrorViewController

@synthesize image = _image,sessionPreset = _sessionPreset,cameraInput = _cameraInput,glView = _glView,cameraPosition = _cameraPosition,isTapFocus = _isTapFocus,focusImage = _focusImage;

- (void)clear {
    _cameraInput = nil;
    _makeUpInput = nil;
    [_makeUpManager clear];
    _makeUpManager = nil;
    _focusImage = nil;
//    _tapGesture
    [self.view removeGestureRecognizer:_tapGesture];
    _tapGesture = nil;
    _focusView = nil;
    
    
    _image = nil;
    _cameraInput = nil;
    _glView = nil;

    
    [self cancelAllRequest];
    [[MirrorMakeUpCenter sharedCenter] clear];
}

#pragma mark - Initialization & teardown

- (id)init {
    if (self = [super init]) {
        self.sessionPreset = AVCaptureSessionPreset640x480;
        self.cameraPosition = AVCaptureDevicePositionFront;
        _makeUpManager = [[MirrorMakeUpManager alloc] init];
        [_makeUpManager addDelegate:self];
        _captureAsYUV = YES;

    }
    return self;
}

- (instancetype)initWithCameraPreset:(NSString *)preset {
    if (self = [self init]) {
        self.sessionPreset = preset;
    }
    return self;
}

- (instancetype)initWithCameraPreset:(NSString *)preset cameraPosition:(AVCaptureDevicePosition)cameraPosition {
    if (self = [self init]) {
        self.sessionPreset = preset;
        self.cameraPosition = cameraPosition;
    }
    return self;
}

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition captureAsYUV:(BOOL)captureAsYUV {
    if (self = [self initWithCameraPreset:sessionPreset cameraPosition:cameraPosition]) {
        _captureAsYUV = captureAsYUV;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [self init]) {
        self.image = image;
    }
    return self;
}

- (void)setFocusImage:(UIImage *)focusImage {
    if (_focusImage != focusImage) {
        _focusImage = focusImage;
        _focusView.image = focusImage;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if (!self.image) {
        [self setUpVideo];
        [self setUpFocus];
    }
}

- (void)setUpFocus {
    if (_isTapFocus) {
        if (!_tapGesture) {
            _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)];
            _tapGesture.delegate = self;
            [self.view addGestureRecognizer:_tapGesture];
        }
        if (!_focusView) {
            UIImage *image = self.focusImage ? self.focusImage : [UIImage imageNamed:@"mirror_touch_focus_x.png"];
            _focusView = [[UIImageView alloc] initWithImage:image];
            _focusView.alpha = 0;
            _focusView.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
            [self.view addSubview:_focusView];
        }
    }
    else {
        if (_tapGesture) {
            [self.view removeGestureRecognizer:_tapGesture];
            _tapGesture = nil;
        }
        if (_focusView) {
            [_focusView removeFromSuperview];
            _focusView = nil;
        }
    }
}

- (void)didTapGesture:(UITapGestureRecognizer *)tgr {
    CGPoint point = [tgr locationInView:tgr.view];
    [_focusView.layer removeAllAnimations];
    [_cameraInput setFocusPoint:point];
    [_focusView setCenter:point];
    _focusView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusView.alpha = 1.f;
        _focusView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusView.alpha = 0.f;
        } completion:nil];
    }];
}

+(NSString *)getOSVersion{
    return [MirrorMakeUpManager getOSVersion];
}

+ (void)isSupportMakeUp:(isSupportCompletedBlock)completedBlock{
    [MirrorViewController isSupportMakeUpWithType:MirrorMakeUpTypeCosmetic completedBlock:completedBlock];
}

+ (void)isSupportMakeUpWithType:(MirrorMakeUpType )makeupType completedBlock:(isSupportCompletedBlock)completedBlock {
    [MirrorMakeUpManager isSupportMakeUpWithMakeUpType:makeupType successCallBack:^(NSDictionary *result) {
        completedBlock(YES, result, nil);
        
    } failCallBack:^(NSInteger errorCode,NSString *errorString) {
        completedBlock(NO, nil, [NSError errorWithDomain:errorString code:errorCode userInfo:nil]);
    }];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _glView = nil;
}

- (void)checkDeviceAuthorizationStatus
{
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion >= 7.0f) {
        NSString *mediaType = AVMediaTypeVideo;
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (!granted)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"请在iPhone的\"设置\"-\"隐私\"-\"相机\"选项中，允许手机淘宝访问您的相机"
                                                               delegate:self
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil];
                alert.tag = 0x3434;
                [alert show];
            }
        }];
    }
}

// 设置OpenGL默认链路
- (void)setUpVideo {
    [self checkDeviceAuthorizationStatus];
    if (!_glView) {
        _glView = [[MirrorOpenGLView alloc] initWithFrame:CGRectZero];
        _glView.fillMode = kMirrorImageFillModePreserveAspectRatioAndFill;
        [self.view addSubview:_glView];
    }
    if (!_cameraInput) {
        _cameraInput = [[MirrorCameraInput alloc] initWithSessionPreset:self.sessionPreset cameraPosition:self.cameraPosition captureAsYUV:_captureAsYUV];
        _cameraInput.cameraOrientation = UIInterfaceOrientationPortrait;
        if (self.cameraPosition == AVCaptureDevicePositionBack) {
            _cameraInput.horizontallyMirrorFrontFacingCamera = NO;
            _cameraInput.horizontallyMirrorRearFacingCamera = NO;
        }
        else {
            _cameraInput.horizontallyMirrorFrontFacingCamera = YES;
            _cameraInput.horizontallyMirrorRearFacingCamera = NO;
        }
        _cameraInput.delegate = self;
#ifdef DEBUG
        _cameraInput.updateSecondsPerFrame = YES;
        [self.view addSubview:self.fpsLabel];
#endif
        [_cameraInput addTarget:_glView];
    }
}

- (void)initMakeUpModule {
    [_makeUpManager initialize];
}

- (void)switchCamera {
    switch (_cameraInput.cameraPosition) {
        case AVCaptureDevicePositionBack:
            _cameraInput.cameraPosition = AVCaptureDevicePositionFront;
            _cameraInput.horizontallyMirrorFrontFacingCamera = YES;
            break;
        case AVCaptureDevicePositionFront:
            _cameraInput.cameraPosition = AVCaptureDevicePositionBack;
            _cameraInput.horizontallyMirrorFrontFacingCamera = NO;
            break;
        default:
            _cameraInput.cameraPosition = AVCaptureDevicePositionFront;
            _cameraInput.horizontallyMirrorFrontFacingCamera = YES;
            break;
    }
}


// 屏幕坐标系转换到原始视频帧坐标系
- (CGPoint)covertToViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _glView.bounds.size;
    CGRect cleanAperture;
    for(AVCaptureInputPort *port in [[_cameraInput.captureSession.inputs lastObject] ports]) {
        if([port mediaType] == AVMediaTypeVideo) {
            cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
            CGSize apertureSize = cleanAperture.size;
            CGPoint point = viewCoordinates;
            CGFloat apertureRatio = apertureSize.height / apertureSize.width;
            CGFloat viewRatio = frameSize.width / frameSize.height;
            CGFloat xc = .5f;
            CGFloat yc = .5f;
            if (_glView.fillMode == kMirrorImageFillModePreserveAspectRatio) {
                if (viewRatio > apertureRatio) {
                    CGFloat y2 = frameSize.height;
                    CGFloat x2 = frameSize.height * apertureRatio;
                    CGFloat x1 = frameSize.width;
                    CGFloat blackBar = (x1 - x2) / 2;
                    if (point.x >= blackBar && point.x <= blackBar + x2) {
                        xc = point.y / y2;
                        yc = 1.f - ((point.x - blackBar) / x2);
                    }
                }
                else {
                    CGFloat y2 = frameSize.width / apertureRatio;
                    CGFloat y1 = frameSize.height;
                    CGFloat x2 = frameSize.width;
                    CGFloat blackBar = (y1 - y2) / 2;
                    if(point.y >= blackBar && point.y <= blackBar + y2) {
                        xc = ((point.y - blackBar) / y2);
                        yc = 1.f - (point.x / x2);
                    }
                }
            }
            else if (_glView.fillMode == kMirrorImageFillModePreserveAspectRatioAndFill) {
                if(viewRatio > apertureRatio) {
                    CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                    xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                    yc = (frameSize.width - point.x) / frameSize.width;
                } else {
                    CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                    yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                    xc = point.y / frameSize.height;
                }
            }
            pointOfInterest = CGPointMake(xc, yc);
            break;
        }
    }
    return pointOfInterest;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_makeUpManager resumeDownload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_makeUpManager pauseDownload];
    [_cameraInput stopCapturing];
}

- (void)addMakeUpNode {
    // 添加渲染节点
    if (!_makeUpInput) {
        _makeUpInput = [[MirrorMakeUpInput alloc] init];
        [_cameraInput addTarget:_makeUpInput];
    }
}

- (void)addBeautyNode {
    // 添加渲染节点
    if (!_makeUpInput) {
        _makeUpInput = [[MirrorMakeUpInput alloc] init];
        [_cameraInput addTarget:_makeUpInput];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.view.bounds;
    _glView.frame = rect;
}

-(void)downLoadFaceModel{
    [_makeUpManager downLoadFaceModel];
}

- (void)captureUseMakeUp:(BOOL)useMakeUp completed:(takeAPhotoCompletion)completionBlock {
    if (useMakeUp) {
        [_glView takeAPhotoWithCompletion:^(UIImage *image) {
            completionBlock(image);
        }];
    }
}


- (void)startCapturing {
    [_cameraInput startCapturing];
    [_cameraInput setFocusPoint:[self covertToViewCoordinates:CGPointMake(_glView.frame.size.width / 2, _glView.frame.size.height / 2)]];
}

- (void)stopCapturing {
    [_cameraInput stopCapturing];
}

- (void)makeUpWithJSONString:(NSString *)jsonString materialType:(MirrorMaterialType)materialType{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *makeUpDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self makeUpWithDict:makeUpDict materialType:materialType];
}

- (void)makeUpWithDict:(NSDictionary *)dict materialType:(MirrorMaterialType)materialType{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        __weak typeof(self) weakSelf = self;
        [_makeUpManager makeUpWithArrayData:dict materialType:materialType resultCallBack:^(BOOL success,NSInteger errorCode, NSString *errorString) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (success) {
                [strongSelf addMakeUpNode];
                if ([strongSelf.delegate respondsToSelector:@selector(makeUpDidSuccess)]) {
                    [strongSelf.delegate makeUpDidSuccess];
                }
            }
            else if ([strongSelf.delegate respondsToSelector:@selector(makeUpDidFailedWithError:)]) {
                [strongSelf.delegate makeUpDidFailedWithError:[NSError errorWithDomain:errorString code:errorCode userInfo:nil]];
            }
        }];
    }
}

- (void)beautyWithJSONString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *beautyDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (beautyDict && [beautyDict isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *beautyArray = [[NSMutableArray alloc] init];
        NSString *beautyWhiteWeight = [beautyDict objectForKey:@"beauty_white_weight"];
        NSString *beautyBuffingWeight = [beautyDict objectForKey:@"beauty_buffing_weight"];
        MirrorBeautyModel *white = [[MirrorBeautyModel alloc] init];
        white.beautyType = MirrorBeautyTypeWhite;
        white.weight = [beautyWhiteWeight floatValue];
        if (!white.weight) {
            white.weight = 0.7f;
        }
        MirrorBeautyModel *buffing = [[MirrorBeautyModel alloc] init];
        buffing.beautyType = MirrorBeautyTypeBuffing;
        buffing.weight = [beautyBuffingWeight floatValue];
        if (!buffing.weight) {
            buffing.weight = 0.5f;
        }
        [beautyArray addObject:white];
        [beautyArray addObject:buffing];
        [self beautyWithBeautyModels:beautyArray];
    }
}

- (void)beautyWithBeautyModels:(NSArray *)beautyModels {
    if (beautyModels && [beautyModels isKindOfClass:[NSArray class]]) {
        BOOL success = [_makeUpManager beautyWithArrayData:beautyModels];
        if (success) {
            [self addBeautyNode];
            if ([self.delegate respondsToSelector:@selector(beautyDidSuccess)]) {
                [self.delegate beautyDidSuccess];
            }
        }
        else if ([self.delegate respondsToSelector:@selector(beautyDidFailedWithError:)]) {
            [self.delegate beautyDidFailedWithError:[NSError errorWithDomain:@"error" code:kMirrorMakeUpSetParamErrorType userInfo:nil]];
        }

    }
}

- (void)dealloc {
    [_makeUpManager removeDelegate:self];
    [self clear];
    [[MirrorOpenGLContext sharedContext] clearResource];
}

- (void)cancelAllRequest {
    [_makeUpManager cancelDownload];
}

#pragma mark - getter

-(UILabel *)fpsLabel{
    if (_fpsLabel == nil) {
        _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 30)];
        _fpsLabel.textAlignment = NSTextAlignmentCenter;
        _fpsLabel.backgroundColor = [UIColor orangeColor];
        _fpsLabel.textColor = [UIColor whiteColor];
        _fpsLabel.alpha = 0.8f;
    }
    
    return _fpsLabel;
}

#pragma mark MirrorMakeUpManagerDelegate
- (void)initSuccess {
    if ([self.delegate respondsToSelector:@selector(initMakeUpModuleDidSuccess)]) {
        [self.delegate initMakeUpModuleDidSuccess];
    }
}

- (void)initWillDownLoadFaceModelWithCallBack:(MirrorShouldDoBlock)shouldDoBolck {
    if ([self.delegate respondsToSelector:@selector(initWillDownLoadFaceModelWithCallBack:)]) {
        [self.delegate initWillDownLoadFaceModelWithCallBack:shouldDoBolck];
    }
}

- (void)initFailedErrorCode:(NSInteger)errorCode errMsg:(NSString *)errorString {
    if ([self.delegate respondsToSelector:@selector(initMakeUpModuleDidFailedWithError:)]) {
        [self.delegate initMakeUpModuleDidFailedWithError:[NSError errorWithDomain:errorString code:errorCode  userInfo:nil]];
    }
}

- (void)downLoadFaceModelProgress:(float)progress Percentage:(NSInteger)percentage {
    if ([self.delegate respondsToSelector:@selector(initMakeUpModuleDidDownloadArithmeticSetProgress:percentage:)]) {
        [self.delegate initMakeUpModuleDidDownloadArithmeticSetProgress:progress percentage:(NSInteger)percentage];
    }
}

- (void)downLoadFaceModelFailErrorCode:(NSInteger)errorCode errorMsg:(NSString *)errorString {
    if ([self.delegate respondsToSelector:@selector(initMakeUpModuleDidFailedWithError:)]) {
        [self.delegate initMakeUpModuleDidFailedWithError:[NSError errorWithDomain:errorString code:errorCode userInfo:nil]];
    }
}

#pragma mark - MirrorCameraInputDelegate
- (void)videoCamera:(MirrorCameraInput *)camera didUpdateSecondsPerFrame:(NSTimeInterval)secondsPerFrame{
    self.fpsLabel.text = [NSString stringWithFormat:@"%f",1/secondsPerFrame];
}

@end
