//
//  SocialParam.m
//  SocializeSDK
//
//  Created by Wan Wentao on 14/11/25.
//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import "ZHSocialParam.h"

@implementation ZHSocialParam

- (ZHSocialParam*)initWithTargetId:(NSString *)targetId targetType:(int)targetType subType:(int)subType
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _targetId = targetId;
    _targetType = targetType;
    _subType = subType;
    return self;
}

@end
