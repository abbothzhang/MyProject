//
//  MirrorNetworkParam.m
//  Mirror
//
//  Created by albert on 15/3/31.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "ZHNetworkParam.h"

@interface ZHNetworkParam ()

@property (nonatomic, strong, readwrite) NSString *openAppkey;
@property (nonatomic, strong, readwrite) NSString *accessToken;

@end

@implementation ZHNetworkParam

- (void)useOpenAppKey:(NSString *)openAppKey {
    self.openAppkey = openAppKey;
}

- (void)useAccessToken:(NSString *)accessToken {
    self.accessToken = accessToken;
}

@end
