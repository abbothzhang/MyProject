//
//  TBMirrorSkuModel.m
//  Demo0722
//
//  Created by albert on 15/7/22.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "TBMirrorSkuModel.h"

@interface TBMirrorSkuModel()<NSCoding>



@end

@implementation TBMirrorSkuModel

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.itemId = [aDecoder decodeObjectForKey:@"itemId"];
        self.skuId = [aDecoder decodeObjectForKey:@"skuId"];
        self.quantity = [[aDecoder decodeObjectForKey:@"quantity"] integerValue];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.isSupportMakeUp = [[aDecoder decodeObjectForKey:@"isSupportMakeUp"] boolValue];
        self.cspuId = [aDecoder decodeObjectForKey:@"cspuId"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.itemId forKey:@"itemId"];
    [aCoder encodeObject:self.skuId forKey:@"skuId"];
    [aCoder encodeObject:@(self.quantity) forKey:@"quantity"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:@(self.isSupportMakeUp) forKey:@"isSupportMakeUp"];
    [aCoder encodeObject:self.cspuId forKey:@"cspuId"];
    
}


@end
