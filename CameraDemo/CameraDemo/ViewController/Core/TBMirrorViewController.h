//
//  TBMirrorViewController.h
//  TBMirror
//
//  Created by albert on 15/3/26.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TBMirrorBeautyModel.h"

#define MIRROR_INIT_ERROR_NO_FACE_MODEL @"NO_FACE_MODEL"
#define MIRROR_INIT_ERROR_NEW_ENGINE_FAIL @"NEW_ENGINE_FAIL"
#define MIRROR_INIT_ERROR_INITIALIZE_FAIL @"INITIALIZE_FAIL"

#define MIRROR_ERROR_NOT_INIT @"NOT_INIT"
#define MIRROR_ERROR_NO_VIDEO @"NO_VIDEO"
#define MIRROR_ERROR_SET_PARAM_FAIL @"SET_PARAM_FAIL"


#define MIRROR_MAKEUP_ERROR_NO_PHOTO @"NO_PHOTO"
#define MIRROR_MAKEUP_ERROR_NO_MODEL @"NO_MODEL"
#define MIRROR_MAKEUP_ERROR_NO_AVAILABLE_MODEL @"NO_AVAILABLE_MODEL"
#define MIRROR_MAKEUP_ERROR_SET_ROTATE_FAIL @"SET_ROTATE_FAIL"
#define MIRROR_MAKEUP_ERROR_STATIC_COSMETIC_FAIL @"STATIC_COSMETIC_FAIL"

#define MIRROR_BEAUTY_ERROR_NO_MODEL @"NO_MODEL"



typedef enum{
    TBMirrorMakeUpTypePhoto = 0,//只渲染一张图片
    TBMirrorMakeUpTypeVideo //渲染视频
}TBMirrorMakeUpType;

typedef enum{
    TBMirrorShootBtnActionTakePhoto = 0,//拍照
    TBMirrorShootBtnActionCamera //显示摄像头
}TBMirrorShootBtnAction;

@protocol TBMirrorViewControllerDelegate <NSObject>

-(void)initFinished;

-(void)initFailed:(NSString *)errorCode;

-(void)makeUpSuccess;

-(void)makeUpFailed:(NSString *)errorCode errMsg:(NSString *)errorMsg;

//美颜回调
-(void)beautySuccess;
-(void)beautyFailed:(NSString *)errorCode errMsg:(NSString *)errorMsg;

@end

@interface TBMirrorViewController : UIViewController

-(instancetype)initWithType:(TBMirrorMakeUpType)type delegate:(id<TBMirrorViewControllerDelegate>)delegate;

//setFaceModelFilePath要在makeUpWithModels前调用
-(void)setFaceModelFilePath:(NSString*)path;

-(void)makeUpWithModels:(NSArray*)models;

//美颜
-(void)beautyWithModels:(NSArray*)models;


//点击切换前置和后置摄像头,返回是否切换成功
-(BOOL)switchCamera;

-(BOOL)shootBtnClickedWithAction:(TBMirrorShootBtnAction)action;

//得到化完妆的效果图
-(UIImage*)getCosmeticImg;
//
-(NSString*)getVersion;

@end
