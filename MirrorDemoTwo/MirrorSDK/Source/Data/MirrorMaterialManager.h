//
//  MirrorMaterialManager.h
//  MirrorSDK
//
//  Created by albert on 15/7/21.
//  Copyright (c) 2015年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MirrorMaterialTypeDefault,//默认使用
    MirrorMaterialTypeUseCache,
}MirrorMaterialType;

@protocol MirrorGetMaterialDelegate <NSObject>

-(void)startGetMaterialFromServer;
//素材准备好，可以上妆了 result为makeupModel的array
-(void)getMaterialSuccess:(NSArray*)result;
-(void)getMaterialFailWithMsg:(NSString *)msg;

@end

@interface MirrorMaterialManager : NSObject

@property (nonatomic,strong) id<MirrorGetMaterialDelegate> delegate;

-(instancetype)initWithType:(MirrorMaterialType)type;

-(void)getMaterialWithMakeUpArrayData:(NSDictionary*)data osVersion:(NSString *)version;
-(void)getMaterialWithMakeUpModelArray:(NSArray*)makeupModelArray osVersion:(NSString *)version;
-(void)clear;

//素材下载相关接口
-(void)cancelDownload;
-(void)pauseDownload;
-(void)resumeDownload;

@end
