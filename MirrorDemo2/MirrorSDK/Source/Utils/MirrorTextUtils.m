//
//  MirrorTextUtils.m
//  MirrorSDK
//
//  Created by albert on 15/7/7.
//  Copyright (c) 2015年 Taobao. All rights reserved.
//

#import "MirrorTextUtils.h"

@interface MirrorTextUtils()

@end

@implementation MirrorTextUtils

-(BOOL)isEmpty:(NSString *)str{
    if (str && ![str isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

@end
