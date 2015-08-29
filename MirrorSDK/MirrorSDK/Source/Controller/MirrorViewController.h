//
//  MirrorViewController.h
//  Mirror
//
//  Created by albert on 15/3/26.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MirrorBaseViewController.h"
#import "MirrorMaterialManager.h"
#import "MirrorMakeUpModel.h"


// 试妆错误代码
typedef enum {
    //common
    
    //makeup
    kMirrorMakeUpSuccess = 1,
    kMirrorMakeUpOutOfMemoryErrorType,
    kMirrorMakeUpInitDataErrorType,
    kMirrorMakeUpRequestTimedOutErrorType,
    kMirrorMakeUpConnectionFailureErrorType,
    kMirrorMakeUpDownloadFailedErrorType,
    kMirrorMakeUpSetParamErrorType,
    kMirrorMakeUpUnKnowErrorType,
    
    //network
    kMirrorErrorTypeNetWorkApinil,//网络访问的api为空
    kMirrorErrorTypeNetWorkMtopError,
    
} kMirrorErrorType;



typedef void(^isSupportCompletedBlock)(BOOL isSupport, NSDictionary *result, NSError *error);
typedef void(^MirrorShouldDoBlock)(BOOL shouldDownload);
typedef void (^takeAPhotoCompletion)(UIImage *image);

@class MirrorMakeUpManager;

@protocol MirrorViewControllerDelegate <NSObject>

@optional




// 初始化试妆模块接口将要开始下载算法包
- (void)initWillDownLoadFaceModelWithCallBack:(MirrorShouldDoBlock)shouldDownloadBlock;

// 调用初始化试妆模块接口，失败后调用此回调，error.code详见kMirrorMakeUpErrorType
- (void)initMakeUpModuleDidFailedWithError:(NSError *)error;

// 调用初始化试妆模块接口，返回下载进度
- (void)initMakeUpModuleDidDownloadArithmeticSetProgress:(float)progress percentage:(NSInteger)percentage;

// 调用初始化试妆模块接口，成功后调用此回调
- (void)initMakeUpModuleDidSuccess;




// 设置试妆参数成功，开始渲染
- (void)makeUpDidSuccess;

// 设置试妆参数失败，返回错误信息，error.code详见kMirrorMakeUpErrorType
- (void)makeUpDidFailedWithError:(NSError *)error;

// 设置美颜参数成功，开始回调
- (void)beautyDidSuccess;

// 设置美颜参数失败，返回错误信息，error.code详见kMirrorMakeUpErrorType
- (void)beautyDidFailedWithError:(NSError *)error;

@end

@class MirrorCameraInput;
@class MirrorMakeUpInput;

@interface MirrorViewController : MirrorBaseViewController {
@private
    __unsafe_unretained id<MirrorViewControllerDelegate> _delegate;
    MirrorCameraInput *_cameraInput;
    MirrorMakeUpInput *_makeUpInput;
    MirrorMakeUpManager *_makeUpManager;
    BOOL _captureAsYUV;
    BOOL _isTapFocus;
    UIImage *_focusImage;
    UIGestureRecognizer *_tapGesture;
    UIImageView *_focusView;
}

@property (nonatomic,assign) id<MirrorViewControllerDelegate> delegate;
@property (nonatomic,assign) BOOL isTapFocus;
@property (nonatomic,strong) UIImage *focusImage;
//@property (nonatomic) BOOL      userMaterialCache;
//@property (nonatomic,assign) MirrorMaterialType    materialType;

//算法包版本号
+(NSString *)getOSVersion;

+ (void)isSupportMakeUp:(isSupportCompletedBlock)completedBlock;

// 是否支持试妆
+ (void)isSupportMakeUpWithType:(MirrorMakeUpType )makeupType completedBlock:(isSupportCompletedBlock)completedBlock;

// 默认初始化为摄像头，分辨率默认为 AVCaptureSessionPreset640x480
- (instancetype)init;

// 初始化为摄像头，传入摄像头分辨率 AVCaptureSessionPreset
- (instancetype)initWithCameraPreset:(NSString *)preset;

// 初始化为摄像头，传入摄像头分辨率，摄像头位置
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition captureAsYUV:(BOOL)captureAsYUV;

// 初始化处理一张图片
- (instancetype)initWithImage:(UIImage *)image;

// 初始化试妆模块，返回回调详见 MirrorViewControllerDelegate
- (void)initMakeUpModule;

- (void)downLoadFaceModel;

// 得到化完妆的效果图或没有化完妆的效果图
- (void)captureUseMakeUp:(BOOL)useMakeUp completed:(takeAPhotoCompletion)completionBlock;

// 切换前置和后置摄像头
- (void)switchCamera;

// 试妆组合设置，传入JSON格式配置素材数组
/*
 格式例子：
 "makeuplist" : [ {
 cspuid : "1",
 weight : "0.5",
 attrs : {}
 }, {
 cspuid : "2",
 weight : "0.5",
 attrs : {}
 }, {
 cspuid : "3",
 weight : "0.5",
 attrs : {}
 }, {
 cspuid : "4",
 weight : "0.5",
 attrs : {}
 } ]
 
 */

- (void)makeUpWithJSONString:(NSString *)jsonString materialType:(MirrorMaterialType)materialType;
- (void)makeUpWithDict:(NSDictionary *)dict materialType:(MirrorMaterialType)materialType;

// 美颜设置，传入JSON格式配置美颜数组
- (void)beautyWithJSONString:(NSString *)jsonString;
- (void)beautyWithBeautyModels:(NSArray*)beautyModels;

// 开启摄像头
- (void)startCapturing;

// 关闭摄像头
- (void)stopCapturing;

// 取消下载网络请求
- (void)cancelAllRequest;

-(void)clear;

@end
