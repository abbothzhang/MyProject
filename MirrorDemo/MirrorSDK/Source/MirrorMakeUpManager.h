//
//  MirrorMakeUpManager.h
//  MirrorSDK
//
//  Created by albert on 15/7/2.
//  Copyright (c) 2015年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MirrorResult.h"
//#import "MirrorNetworkAdapter.h"
#import "MirrorViewController.h"
#import "MirrorMaterialManager.h"
#import "MirrorMakeUpModel.h"

typedef void(^MirrorNetworkSucessBlock)(NSDictionary *dic);
typedef void(^MirrorNetworkFailedBlock)(NSInteger errorCode,NSString *errorMsg);


@protocol MirrorMakeUpManagerDelegate <NSObject>

@optional

//初始化
-(void)initSuccess;
-(void)initFailedErrorCode:(NSInteger)errorCode errMsg:(NSString *)errorMsg;

//人脸定位模型下载
- (void)initWillDownLoadFaceModelWithCallBack:(MirrorShouldDoBlock)shouldDoBolck;

- (void)downLoadFaceModelProgress:(float)progress Percentage:(NSInteger)percentage;

- (void)downLoadFaceModelSuccess;

- (void)downLoadFaceModelFailErrorCode:(NSInteger)errorCode errorMsg:(NSString *)errorMsg;


@end



@class MirrorMulticastDelegate;


@interface MirrorMakeUpManager : NSObject

@property (nonatomic,strong) MirrorMulticastDelegate<MirrorMakeUpManagerDelegate> *multicastDelegate;
//@property (nonatomic) BOOL  useMaterialCache;

@property (nonatomic) MirrorMaterialType materialType;

+(NSString *)getOSVersion;

+(void)isSupportMakeUpWithMakeUpType:(MirrorMakeUpType)makeUpType successCallBack:(MirrorNetworkSucessBlock)successCallBack failCallBack:(MirrorNetworkFailedBlock)failCallBack;

// 初始化下载试妆算法包
- (void)initialize;

// 下载素材包
- (void)downLoadFaceModel;
- (BOOL)beautyWithArrayData:(NSArray *)arrayData;
- (void)makeUpWithArrayData:(NSDictionary *)data materialType:(MirrorMaterialType)materialType resultCallBack:(MirrorCallback)resultCallBack;

-(void)clear;

// 添加注册回调通知
- (void)addDelegate:(id)delegate;
// 移除注册回调通知
- (void)removeDelegate:(id)delegate;
// 移除所有回调通知
- (void)removeAllDelegate;


//素材下载相关接口
-(void)cancelDownload;
-(void)pauseDownload;
-(void)resumeDownload;

@end
