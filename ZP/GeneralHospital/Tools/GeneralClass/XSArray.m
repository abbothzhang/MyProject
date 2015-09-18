//
//  XSArray.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-7-2.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "XSArray.h"

@implementation NSArray(NSArray)
- (id)ObjectAtIndex:(NSUInteger)index
{
    if ([self count]>=index+1)
    {
        return [GeneralClass ObjectIsNotNULL:[self objectAtIndex:index] ClassName:[self class]];
    }
    [GeneralClass Assert:[NSString stringWithFormat:@"%@:count=%d;index=%d 数组越界了！！！！",[self class],[self count],index]];
    return @"";
}


@end
