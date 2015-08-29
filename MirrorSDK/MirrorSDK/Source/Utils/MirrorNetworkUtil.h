//
//  MirrorNetworkUtil.h
//  Mirror
//
//  Created by albert on 15/4/1.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MirrorNetworkUtil : NSObject

+ (id)sharedInstance;

+(BOOL)isWIFI;

- (NSString *)getNetworkType;

@end
