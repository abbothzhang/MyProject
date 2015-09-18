//
//  XSMutableArray.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-7-2.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(NSMutableArray)
- (void)AddObject:(id)anObject;
- (void)InsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)RemoveObjectAtIndex:(NSUInteger)index;
- (void)ReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end
