//
//  XSMutableDictionary.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-7-2.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "XSMutableDictionary.h"

@implementation NSMutableDictionary(NSMutableDictionary)

-(void)SetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    
    [self setValue:[GeneralClass ObjectIsNotNULL:anObject ClassName:[self class]]
            forKey:[GeneralClass ObjectIsNotNULL:aKey ClassName:[self class]]];
}

- (void)RemoveObjectForKey:(id)aKey
{
    [self removeObjectForKey:[GeneralClass ObjectIsNotNULL:aKey ClassName:[self class]]];
}

- (void)SetDictionary:(NSDictionary *)otherDictionary
{
    [self setDictionary:[GeneralClass ObjectIsNotNULL:otherDictionary ClassName:[self class]]];
}

@end
