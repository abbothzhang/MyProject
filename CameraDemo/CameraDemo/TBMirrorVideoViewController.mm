//
//  TBMirrorVideoViewController.m
//  TBMirror
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "TBMirrorVideoViewController.h"
#import "TBMirrorViewController_Private.h"
#import "TBMirrorCameraOpenGLView.h"
#import "TBMirrorMakeUpModel.h"
#import "TBMirrorBeautyModel.h"
#include "CosmeticEngine.h"

#define FPS 20
//???
#define MIRROR_BGR(b,g,r) (((b) << 16)+((g) << 8) + r)
#define MIRROR_ABGR(a,b,g,r) (((a) << 24)+((b) << 16)+((g) << 8) + r)

typedef struct {
    CosmeticTemplateData* pTemplateData;
    float* pWeight;
    int modelCount;
} TBCosmeticParam;

typedef struct {
    BeautyParam *pBeautyParam;
    int modelCount;
    
}TBBeautyParam;



@interface TBMirrorVideoViewController () {
    BOOL _initEngineSuccess; //初始化上妆引擎和人脸定位模型文件成功
    BOOL _initCosmeticSuccess; //设置上妆素材成功
    BOOL _initBeautySuccess; //设置美颜素材成功
    
    NSString *faceModelPath;
    
    CCosmeticEngine* engine;
    float* pRealWeight;
    int modelCount;
    
    TBCosmeticParam* pCosmeticParam;
    TBBeautyParam*  pTBBeautyParam;
    
    BeautyParam *pBeautyParam;
    
}

@property (nonatomic, strong) TBMirrorCameraOpenGLView *glView;
@property (nonatomic, strong) NSTimer *refreshTimer;

@end

@implementation TBMirrorVideoViewController

-(instancetype)initWithType:(TBMirrorMakeUpType)type delegate:(id<TBMirrorViewControllerDelegate>)delegate{
    self = [super initWithType:type delegate:delegate];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseCosmetic) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeCosmetic) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

const int width = 640;
const int height = 480;

- (void)setupView {
    EAGLContext *_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_context];
    CGFloat cameraWidth = height;
    CGFloat cameraHeight = width;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (cameraWidth/cameraHeight > screenWidth/screenHeight) {
        CGFloat scaledWidth = cameraWidth/cameraHeight*screenHeight;
        _glView = [[TBMirrorCameraOpenGLView alloc] initWithFrame:CGRectMake(-(scaledWidth-screenWidth)/2, 0, scaledWidth, screenHeight) context:_context cameraSize:CGSizeMake(width, height)];
    } else {
        CGFloat scaledHeight = cameraHeight/cameraWidth*screenWidth;
        _glView = [[TBMirrorCameraOpenGLView alloc] initWithFrame:CGRectMake(0, -(scaledHeight-screenWidth)/2, screenWidth, scaledHeight) context:_context cameraSize:CGSizeMake(width, height)];
    }
    
    [self.view addSubview:_glView];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
    unsigned char* pYuv = (unsigned char*)baseAddress;
    
    if ([faceModelPath length] > 0 && !_initEngineSuccess) {
        if ([self initEngineAndFaceModel]) {
            _initEngineSuccess = YES;
        } else {
            faceModelPath = nil;
        }
    }
    
    if (pCosmeticParam != NULL && _initEngineSuccess) {
        int setParamRet = engine->SetCosmeticParam(pCosmeticParam->pTemplateData, pCosmeticParam->modelCount, 1);
        if (setParamRet != 1) {
            [self releaseCosmeticParam];
            if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
                [self.delegate makeUpFailed:[NSString stringWithFormat:@"%@%@", MIRROR_ERROR_SET_PARAM_FAIL, @(setParamRet)] errMsg:@"试妆算法调用失败"];
            }
        } else {
            int setRotateRet = engine->SetRotate(90);
            if (setRotateRet != 1) {
                [self releaseCosmeticParam];
                if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
                    [self.delegate makeUpFailed:[NSString stringWithFormat:@"%@%@", MIRROR_MAKEUP_ERROR_SET_ROTATE_FAIL, @(setRotateRet)] errMsg:@"试妆算法调用失败"];
                }
            } else {
                if (pRealWeight != NULL) {
                    delete [] pRealWeight;
                }
                pRealWeight = new float[pCosmeticParam->modelCount];
                for (int i = 0 ; i < pCosmeticParam->modelCount; i++) {
                    pRealWeight[i] = pCosmeticParam->pWeight[i];
                }
                modelCount = pCosmeticParam->modelCount;
                [self releaseCosmeticParam];
                _initCosmeticSuccess = YES;
                if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpSuccess)]) {
                    [self.delegate makeUpSuccess];
                }
            }
        }
    }
    
    // 1、外部先调接口传入美白参数，类似于上妆素材的传入：makeUpWithModels
    // 2、将美白参数赋给实例变量
    // 3、在当前方法内判断是否有美白的实例变量，如果有就调用美白接口进行美白处理
    // 4、处理完后将美白的实例变量释放，指针赋为NULL
    //     virtual int SetBeautyParam(const BeautyParam* beautyParam, int len) = 0;
    //     BeautyParam *pTempData = new BeautyParam[totalCount];
    //  pTempData[0].id = BEAUTIFY_BUFFING_FACE  ; pTempData[0].fWeight = 0.5;
    if (pTBBeautyParam!= NULL && _initEngineSuccess) {
        int setBeautyParamRet = engine->SetBeautyParam(pTBBeautyParam->pBeautyParam, pTBBeautyParam->modelCount);
        if (setBeautyParamRet != 1) {
            [self releaseBeautyParam];
            if (self.delegate && [self.delegate respondsToSelector:@selector(beautyFailed:errMsg:)]) {
                [self.delegate beautyFailed:[NSString stringWithFormat:@"%@%@", MIRROR_ERROR_SET_PARAM_FAIL, @(setBeautyParamRet)] errMsg:@"美颜算法调用失败"];
            }
        }
        //设置美颜参数成功，开始设置摄像头旋转90度
        else{
            int setRotateRet = engine->SetRotate(90);
            if (setRotateRet != 1) {
                [self releaseBeautyParam];
                if (self.delegate && [self.delegate respondsToSelector:@selector(beautyFailed:errMsg:)]) {
                    [self.delegate beautyFailed:[NSString stringWithFormat:@"%@%@", MIRROR_MAKEUP_ERROR_SET_ROTATE_FAIL, @(setRotateRet)] errMsg:@"试妆算法调用失败"];
                }
            }
            //设置摄像头旋转90度成功
            else{
                [self releaseBeautyParam];
                _initBeautySuccess = YES;
                if (self.delegate && [self.delegate respondsToSelector:@selector(beautySuccess)]) {
                    [self.delegate beautySuccess];
                }
            }
        }
    }
    
    
    if (_initCosmeticSuccess || _initBeautySuccess) {
        engine->RealCosmeticByVideo(pYuv, width, height, pYuv, pRealWeight, modelCount);
    }
    
    BOOL isFront = ([[self.videoInput device] position] == AVCaptureDevicePositionFront);
    [self.glView updateData:pYuv isFrontCamera:isFront];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

- (void)releaseCosmeticParam {
    CosmeticTemplateData* pTemplateData = pCosmeticParam->pTemplateData;
    for (int i = 0 ; i < pCosmeticParam->modelCount; i++) {
        free(pTemplateData[i].pData);
    }
    delete [] pTemplateData;
    delete [] pCosmeticParam->pWeight;
    free(pCosmeticParam);
    pCosmeticParam = NULL;
}

-(void)releaseBeautyParam{
    BeautyParam *pBeautyParam = pTBBeautyParam->pBeautyParam;

    delete []pBeautyParam;
    free(pTBBeautyParam);

    pTBBeautyParam = NULL;
}

-(void)setFaceModelFilePath:(NSString*)path{
    if ([path length] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(initFailed:)]) {
            [self.delegate initFailed:MIRROR_INIT_ERROR_NO_FACE_MODEL];
        }
        return;
    }
    faceModelPath = path;
}

- (BOOL)initEngineAndFaceModel {
    NSData *faceData = [NSData dataWithContentsOfFile:faceModelPath];
    if (!faceData || [faceData length] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(initFailed:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate initFailed:MIRROR_INIT_ERROR_NO_FACE_MODEL];
            });
        }
        return NO;
    }
    engine = CCosmeticEngine::GetInstanse();
    if (engine == NULL) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(initFailed:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate initFailed:MIRROR_INIT_ERROR_NEW_ENGINE_FAIL];
            });
        }
        return NO;
    }
    int ret = engine->Initialize(width, height, (unsigned char*)faceData.bytes, (int)[faceData length]);
    if (ret == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(initFinished)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate initFinished];
            });
        }
        return YES;
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(initFailed:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate initFailed:[NSString stringWithFormat:@"%@%@", MIRROR_INIT_ERROR_INITIALIZE_FAIL, @(ret)]];
            });
        }
        return NO;
    }
}

-(void)makeUpWithModels:(NSArray*)models{
    if (engine == NULL) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_ERROR_NOT_INIT errMsg:@"算法未初始化"];
        }
        return;
    }
    
    if (!self.session || ![self.session isRunning]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_ERROR_NO_VIDEO errMsg:@"没有权限访问摄像头或者摄像头不支持"];
        }
        return;
    }
    
    if ([models count] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_MAKEUP_ERROR_NO_MODEL errMsg:@"未选择试妆效果"];
        }
        return;
    }
    
    int totalCount = (int)[models count];
    CosmeticTemplateData *pTempData = new CosmeticTemplateData[totalCount];
    float *tempRealWeight = new float[totalCount];
    int realCount = 0;
    for (int i = 0; i < totalCount; i++) {
        TBMirrorMakeUpModel* model = (TBMirrorMakeUpModel*)[models objectAtIndex:i];
        NSData *templateData = [NSData dataWithContentsOfFile:model.modelFilePath];
        if (!templateData || [templateData length] == 0) {
            continue;
        }
        pTempData[realCount].pData = (unsigned char *)malloc([templateData length]);
        [templateData getBytes:pTempData[realCount].pData length:[templateData length]];
        pTempData[realCount].lenData = (int)[templateData length];
//        pTempData[realCount].bgr = MIRROR_ABGR(255, 255, 255, 255);
        pTempData[realCount].bgr = [self getBGRFromColor:model.color];
        tempRealWeight[realCount] = model.weight;
        realCount++;
    }
    if (realCount == 0) {
        delete [] pTempData;
        delete [] tempRealWeight;
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_MAKEUP_ERROR_NO_AVAILABLE_MODEL errMsg:@"没有试妆素材"];
        }
        return;
    }
    
    TBCosmeticParam* tempCosmeticParam = (TBCosmeticParam*)malloc(sizeof(TBCosmeticParam));
    tempCosmeticParam->pTemplateData = pTempData;
    tempCosmeticParam->pWeight = tempRealWeight;
    tempCosmeticParam->modelCount = realCount;
    pCosmeticParam = tempCosmeticParam;
}

//美颜
-(void)beautyWithModels:(NSArray*)models{
    if (engine == NULL) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(beautyFailed:errMsg:)]) {
            [self.delegate beautyFailed:MIRROR_ERROR_NOT_INIT errMsg:@"算法未初始化"];
        }
        return;
    }
    
    if (!self.session || ![self.session isRunning]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(beautyFailed:errMsg:)]) {
            [self.delegate beautyFailed:MIRROR_ERROR_NO_VIDEO errMsg:@"没有权限访问摄像头或者摄像头不支持"];
        }
        return;
    }
    
    if ([models count] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(beautyFailed:errMsg:)]) {
            [self.delegate beautyFailed:MIRROR_BEAUTY_ERROR_NO_MODEL errMsg:@"美颜数据为空"];
        }
        return;
    }
    
    int totalCount = (int)[models count];
    BeautyParam *pTempBeautyParam = new BeautyParam[totalCount];
    for (int i = 0; i < totalCount; i++) {
        id model = [models objectAtIndex:i];
        if (![model isKindOfClass:[TBMirrorBeautyModel class]]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(beautyFailed:errMsg:)]) {
                [self.delegate beautyFailed:MIRROR_BEAUTY_ERROR_NO_MODEL errMsg:@"美颜model类型不对"];
            }
            return;
        }
        TBMirrorBeautyModel *beautyModel = (TBMirrorBeautyModel*)model;
        pTempBeautyParam[i].id = beautyModel.beautyType;
        pTempBeautyParam[i].fWeight = beautyModel.weight;
    }
    
    
    
    TBBeautyParam *tempBeautyParam = (TBBeautyParam*)malloc(sizeof(TBBeautyParam));
    tempBeautyParam->pBeautyParam = pTempBeautyParam;
    tempBeautyParam->modelCount = totalCount;
    pTBBeautyParam = tempBeautyParam;

}

- (int)getBGRFromColor:(NSString *)color{
    // 默认不设置颜色参数
    int bgr = MIRROR_ABGR(255, 255, 255, 255);
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return bgr;
    }
   
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString length] != 6) {
        return bgr;
    }

    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return MIRROR_BGR(b, g, r);
}

-(BOOL)switchCamera {
    BOOL isSuccess = [super switchCamera];

//    if (self.isFrontCamera) {
//        engine->SetRotate(90);
//    } else {
//        engine->SetRotate(90);
//    }
    
    return isSuccess;
}

-(UIImage*)getCosmeticImg {
    return self.glView.snapshot;
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self resumeCosmetic];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self pauseCosmetic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self releaseCamera];
    _glView = nil;
    [super viewDidUnload];
}

- (void)dealloc{
    [self releaseCamera];
    if (engine != NULL) {
        engine->Uninitialize();
        CCosmeticEngine::ReleaseInstance(engine);
    }
    if (pRealWeight != NULL) {
        delete [] pRealWeight;
    }
    if (pCosmeticParam != NULL) {
        [self releaseCosmeticParam];
    }
    if (pBeautyParam != NULL) {
        [self releaseBeautyParam];
    }
    
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshGLView{
    [self.glView display];
}

- (void)pauseCosmetic {
    if (self.session && [self.session isRunning]) {
        [self.session stopRunning];
    }
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}

- (void)resumeCosmetic {
    if (self.session && ![self.session isRunning]) {
        [self.session startRunning];
    }
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
    _refreshTimer = [NSTimer timerWithTimeInterval:1.0f/FPS target:self selector:@selector(refreshGLView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_refreshTimer forMode:NSRunLoopCommonModes];
}

@end
