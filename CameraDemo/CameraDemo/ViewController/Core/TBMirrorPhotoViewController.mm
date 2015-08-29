//
//  TBMirrorPhotoViewController.m
//  TBMirror
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "TBMirrorPhotoViewController.h"
#import "TBMirrorViewController_Private.h"
#import "TBMirrorMakeUpModel.h"
#include "CosmeticEngine.h"

@interface TBMirrorPhotoViewController () {
    volatile BOOL _takePhotoNow; //标识是否需要拍摄照片
    volatile BOOL _hasTookPhoto; //标识是否已拍摄照片
    
    CCosmeticEngine* engine;
    unsigned char *pYuv;
}

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIImageView *photoView;

@end

@implementation TBMirrorPhotoViewController

const int width = 640;
const int height = 480;

- (void)setupView {
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [_previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [self.view layer];
    [_previewLayer setFrame:[rootLayer bounds]];
    [rootLayer insertSublayer:_previewLayer atIndex:0];
    
    [self.view addSubview:self.photoView];
}

- (UIImageView *)photoView{
    if (!_photoView) {
        // setup photoView frame
        CGFloat cameraWidth = height;
        CGFloat cameraHeight = width;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if (cameraWidth/cameraHeight > screenWidth/screenHeight) {
            CGFloat scaledWidth = cameraWidth/cameraHeight*screenHeight;
            _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(-(scaledWidth-screenWidth)/2, 0, scaledWidth, screenHeight)];
        } else {
            CGFloat scaledHeight = cameraHeight/cameraWidth*screenWidth;
            _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -(scaledHeight-screenWidth)/2, screenWidth, scaledHeight)];
        }
        _photoView.hidden = YES;
    }
    return _photoView;
}

-(BOOL)shootBtnClickedWithAction:(TBMirrorShootBtnAction)action{
    if (action == TBMirrorShootBtnActionTakePhoto) {
        [self takePhoto];
    } else {
        [self resumeCamera];
    }
    
    return YES;
}

- (void)takePhoto{
    if (_takePhotoNow) {
        return;
    }
    if (_hasTookPhoto) {
        return;
    }
    _takePhotoNow = YES;
}

- (void)resumeCamera{
    if (_hasTookPhoto) {
        [self.session startRunning];
        self.photoView.hidden = YES;
        _hasTookPhoto = NO;
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (!_takePhotoNow) {
        return;
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t imgWidth = CVPixelBufferGetWidth(imageBuffer);
    size_t imgHeight = CVPixelBufferGetHeight(imageBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
    if (pYuv == NULL) {
        pYuv = (unsigned char*)malloc(sizeof(unsigned char)*imgWidth*imgHeight*1.5);
    }
    memcpy(pYuv, (unsigned char*)baseAddress, imgWidth*imgHeight*1.5);
    
    NSDictionary *option =  @{ (id)kCVPixelBufferPixelFormatTypeKey :
                                @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) };
    CIImage *cimage = [CIImage imageWithCVPixelBuffer:imageBuffer options:option];
    UIImage *image = nil;
    if (self.isFrontCamera) {
        image = [UIImage imageWithCIImage:cimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationLeftMirrored];
    } else {
        image = [UIImage imageWithCIImage:cimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationRight];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photoView setImage:image];
        self.photoView.hidden = NO;
        [self.session stopRunning];
        _hasTookPhoto = YES;
        _takePhotoNow = NO;
    });
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

-(void)setFaceModelFilePath:(NSString*)path{
    if ([path length] == 0) {
        return;
    }
    NSData *faceData = [NSData dataWithContentsOfFile:path];
    if (!faceData || [faceData length] == 0) {
        return;
    }
    engine = CCosmeticEngine::GetInstanse();
    if (engine == NULL) {
        return;
    }
    bool isSuccess = engine->Initialize(width, height, (unsigned char*)faceData.bytes, (int)[faceData length]);
    if (isSuccess) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(initFinished)]) {
            [self.delegate initFinished];
        }
    }
}

-(void)makeUpWithModels:(NSArray*)models{
    if (engine == NULL) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_ERROR_NOT_INIT errMsg:@"算法未初始化"];
        }
        return;
    }
    
    if (!_hasTookPhoto || pYuv == NULL) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_MAKEUP_ERROR_NO_PHOTO errMsg:@"请先拍一张照片哦"];
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
    CosmeticTemplateData pTempData[totalCount];
    float pRealWeight[totalCount];
    int realCount = 0;
    for (int i = 0; i < totalCount; i++) {
        TBMirrorMakeUpModel* model = (TBMirrorMakeUpModel*)[models objectAtIndex:i];
        NSData *templateData = model.fileData;//[NSData dataWithContentsOfFile:model.modelFilePath];
        if (!templateData || [templateData length] == 0) {
            continue;
        }
        pTempData[realCount].pData = (unsigned char *)templateData.bytes;
        pTempData[realCount].lenData = (int)[templateData length];
        pTempData[realCount].bgr = 255;
        pRealWeight[realCount] = model.weight;
        realCount++;
    }
    if (realCount == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_MAKEUP_ERROR_NO_AVAILABLE_MODEL errMsg:@"没有试妆素材"];
        }
        return;
    }

    bool isSetParamSuccess = engine->SetCosmeticParam(pTempData, realCount, 1);
    if (!isSetParamSuccess) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_ERROR_SET_PARAM_FAIL errMsg:@"试妆算法调用失败"];
        }
        return;
    }
    
    bool isSetRotateSuccess = engine->SetRotate(90);
    if (!isSetRotateSuccess) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_MAKEUP_ERROR_SET_ROTATE_FAIL errMsg:@"试妆算法调用失败"];
        }
        return;
    }
    
    CVPixelBufferRef pixelBuffer = NULL;
    NSDictionary *pixelBufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSDictionary dictionary], (id)kCVPixelBufferIOSurfacePropertiesKey,
                                           nil];
    CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, (__bridge CFDictionaryRef)pixelBufferAttributes, &pixelBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0 );
    unsigned char *pYuvRet = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    bool isSuccess = engine->StaticCosmeticByImage(pYuv, width, height, pYuvRet, pRealWeight, realCount);
    if (!isSuccess) {
        CVPixelBufferUnlockBaseAddress(pixelBuffer,0);
        CVPixelBufferRelease(pixelBuffer);
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpFailed:errMsg:)]) {
            [self.delegate makeUpFailed:MIRROR_MAKEUP_ERROR_STATIC_COSMETIC_FAIL errMsg:@"试妆算法调用失败"];
        }
        return;
    }

    NSDictionary *option =  @{ (id)kCVPixelBufferPixelFormatTypeKey :
                                @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) };
    CIImage *cimage = [CIImage imageWithCVPixelBuffer:pixelBuffer options:option];
    UIImage *image = nil;
    if (self.isFrontCamera) {
        image = [UIImage imageWithCIImage:cimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationLeftMirrored];
    } else {
        image = [UIImage imageWithCIImage:cimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationRight];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photoView setImage:image];
    });
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer,0);
    CVPixelBufferRelease(pixelBuffer);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeUpSuccess)]) {
        [self.delegate makeUpSuccess];
    }
}

-(BOOL)switchCamera{
    if (!_hasTookPhoto) {
        return [super switchCamera];
    }
    return NO;
}

-(UIImage*)getCosmeticImg{
    UIGraphicsBeginImageContextWithOptions(self.photoView.frame.size, NO, [UIScreen mainScreen].scale);  //NO，YES 控制是否透明
    [self.photoView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_hasTookPhoto && ![self.session isRunning]) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (!_hasTookPhoto && [self.session isRunning]) {
        [self.session stopRunning];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [self releaseCamera];
    if (engine != NULL) {
        engine->Uninitialize();
        CCosmeticEngine::ReleaseInstance(engine);
    }
    if (pYuv != NULL) {
        free(pYuv);
    }
}

@end
