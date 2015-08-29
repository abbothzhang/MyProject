//
//  MirrorMaterialUnUseCacheManager.h
//  MirrorSDK
//
//  Created by albert on 15/7/21.
//  Copyright (c) 2015年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MirrorMaterialManager.h"

@interface MirrorMaterialUnUseCacheManager : MirrorMaterialManager

//@property (nonatomic,strong) id<MirrorGetMaterialDelegate> delegate;


-(void)getMaterialWithMakeUpArrayData:(NSDictionary*)data osVersion:(NSString *)version;
-(void)getMaterialWithMakeUpModelArray:(NSArray*)makeupModelArray osVersion:(NSString *)version;
-(void)clear;

//素材下载相关接口
-(void)cancelDownload;
-(void)pauseDownload;
-(void)resumeDownload;

@end
