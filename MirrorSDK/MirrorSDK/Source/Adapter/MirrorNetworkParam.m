//
//  MirrorNetworkParam.m
//  Mirror
//
//  Created by albert on 15/3/31.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "MirrorNetworkParam.h"

@interface MirrorNetworkParam ()

@property (nonatomic, strong, readwrite) NSString *openAppkey;
@property (nonatomic, strong, readwrite) NSString *accessToken;

@end

@implementation MirrorNetworkParam

- (void)useOpenAppKey:(NSString *)openAppKey {
    self.openAppkey = openAppKey;
}

- (void)useAccessToken:(NSString *)accessToken {
    self.accessToken = accessToken;
}

@end
