//
//  MirrorAdapterManager.m
//  MirrorSDK
//
//  Created by iNuoXia on 14/12/10.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "MirrorAdapterManager.h"

@interface MirrorAdapterManager ()

@end

@implementation MirrorAdapterManager



+ (MirrorAdapterManager *)sharedInstance {
    static MirrorAdapterManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MirrorAdapterManager alloc]init];
    });
    return instance;
}

-(void)dealloc{
    NSLog(@"MirrorAdapterManager delloc");
}

@end
