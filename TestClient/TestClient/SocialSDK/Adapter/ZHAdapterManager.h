//
//  MirrorAdapterManager.h
//  MirrorSDK
//
//  Created by iNuoXia on 14/12/10.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetworkAdapter.h"


@interface ZHAdapterManager : NSObject

@property (nonatomic, strong) ZHNetworkAdapter *network;


+ (ZHAdapterManager *)sharedInstance;

@end
