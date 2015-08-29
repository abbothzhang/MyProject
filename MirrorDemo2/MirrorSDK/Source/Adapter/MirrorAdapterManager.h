//
//  MirrorAdapterManager.h
//  MirrorSDK
//
//  Created by iNuoXia on 14/12/10.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MirrorNetworkAdapter.h"


@interface MirrorAdapterManager : NSObject

//@property (nonatomic, strong, setter=setNetworkAdapter:) MirrorNetworkAdapter *network;


+ (MirrorAdapterManager *)sharedInstance;

@end
