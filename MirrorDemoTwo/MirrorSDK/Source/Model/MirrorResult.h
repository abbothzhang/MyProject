//
//  MirrorResult.h
//  Mirror
//
//  Created by albert on 15/4/15.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MirrorResult : NSObject


typedef void(^MirrorCallback)(BOOL succeed,NSInteger errorCode, NSString *errorMsg);

typedef void(^SuccessCallback)(NSDictionary *dic);
typedef void(^FailCallback)(NSString *errorCode, NSString *errorMsg);

@property (nonatomic) BOOL                      succeed;
@property (nonatomic,strong) NSString           *errrorCode;
@property (nonatomic,strong) NSString           *errorMsg;

-(NSDictionary *)toDic;
@end
