//
//  XSMutableArray.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-7-2.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "XSMutableArray.h"

@implementation NSMutableArray(NSMutableArray)
- (void)AddObject:(id)anObject
{
    
    [self addObject:[GeneralClass ObjectIsNotNULL:anObject ClassName:[self class]]];
}

- (void)InsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if ([self count]>=index+1)
    {
        [self insertObject:[GeneralClass ObjectIsNotNULL:anObject ClassName:[self class]] atIndex:index];
    }
    [GeneralClass Assert:[NSString stringWithFormat:@"%@:count=%d;index=%d 数组越界了！！！！",[self class],[self count],index]];
}

- (void)RemoveObjectAtIndex:(NSUInteger)index
{
    if ([self count]>=index+1)
    {
        [self removeObjectAtIndex:index];
    }
    [GeneralClass Assert:[NSString stringWithFormat:@"%@:count=%d;index=%d 数组越界了！！！！",[self class],[self count],index]];
}
- (void)ReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if ([self count]>=index+1)
    {
        [self replaceObjectAtIndex:index withObject:[GeneralClass ObjectIsNotNULL:anObject ClassName:[self class]]];
    }
    [GeneralClass Assert:[NSString stringWithFormat:@"%@:count=%d;index=%d 数组越界了！！！！",[self class],[self count],index]];
}

@end
