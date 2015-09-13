//
//  MirrorNetworkParam.h
//  Mirror
//
//  Created by albert on 15/3/31.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNetworkParam : NSObject

// 必选
@property (nonatomic, strong) NSString *apiVersion;
@property (nonatomic, assign) BOOL needLogin;

// (可选，和业务方有关)
@property (nonatomic, strong) NSDictionary *businessParam;

// (可选，一些额外的协议参数)
@property (nonatomic, strong) NSDictionary *extraParam;

@property (nonatomic, assign) BOOL needWua;

@property (nonatomic, assign) BOOL needHttpPost;

// (可选， isv 必选)
@property (nonatomic, strong, readonly) NSString *openAppkey;
@property (nonatomic, strong, readonly) NSString *accessToken;

- (void)useOpenAppKey:(NSString *)openAppKey;

- (void)useAccessToken:(NSString *)accessToken;

@end
