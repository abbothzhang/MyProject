//
//  XSMutableDictionary.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-7-2.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(NSMutableDictionary)
- (void)RemoveObjectForKey:(id)aKey;
- (void)SetObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)SetDictionary:(NSDictionary *)otherDictionary;
@end
