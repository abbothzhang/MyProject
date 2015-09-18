//
//  XSDictionary.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-7-2.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "XSDictionary.h"

@implementation NSDictionary(NSDictionary)
- (id)ObjectForKey:(id)aKey
{
    
    return [GeneralClass ObjectIsNotNULL:[self objectForKey:[GeneralClass ObjectIsNotNULL:aKey ClassName:[self class]]] ClassName:[self class]];
}
@end
