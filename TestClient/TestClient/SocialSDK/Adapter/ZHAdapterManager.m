//
//  MirrorAdapterManager.m
//  MirrorSDK
//
//  Created by iNuoXia on 14/12/10.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "ZHAdapterManager.h"

@interface ZHAdapterManager ()

@end

@implementation ZHAdapterManager



+ (ZHAdapterManager *)sharedInstance {
    static ZHAdapterManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZHAdapterManager alloc]init];
    });
    return instance;
}



-(void)dealloc{
    NSLog(@"MirrorAdapterManager delloc");
}

@end
