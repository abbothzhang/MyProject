//
//  MirrorMaterialManager.m
//  MirrorSDK
//
//  Created by albert on 15/7/21.
//  Copyright (c) 2015年 Taobao. All rights reserved.
//

#import "MirrorMaterialManager.h"
#import "MirrorMaterialUseCacheManager.h"
#import "MirrorMaterialUnUseCacheManager.h"

@implementation MirrorMaterialManager



-(instancetype)initWithType:(MirrorMaterialType)type{
    switch (type) {
        case MirrorMaterialTypeDefault:
            self = [[MirrorMaterialUnUseCacheManager alloc] init];
            break;
        case MirrorMaterialTypeUseCache:
            self = [[MirrorMaterialUseCacheManager alloc] init];
            break;
        default:
            break;
    }
    
    
    return self;
}

-(void)getMaterialWithMakeUpArrayData:(NSDictionary*)data osVersion:(NSString *)version{
    
}
-(void)getMaterialWithMakeUpModelArray:(NSArray*)makeupModelArray osVersion:(NSString *)version{
    
}




//素材下载相关接口
-(void)cancelDownload{
    
}
-(void)pauseDownload{
    
}
-(void)resumeDownload{
    
}

-(void)clear{
    
}

-(void)dealloc{
    [self clear];
}

@end
