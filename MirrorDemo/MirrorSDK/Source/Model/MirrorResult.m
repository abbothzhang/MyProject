//
//  MirrorResult.m
//  Mirror
//
//  Created by albert on 15/4/15.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "MirrorResult.h"

@implementation MirrorResult

-(instancetype)init{
    self = [super init];
    if (self) {
        _succeed = YES;
    }
    return self;
}


-(void)setErrrorCode:(NSString *)errrorCode{
    _errrorCode = errrorCode;
    _succeed = NO;
}

-(void)setErrorMsg:(NSString *)errorMsg{
    _errorMsg = errorMsg;
    _succeed = NO;
}

-(NSDictionary *)toDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dic setValue:@(_succeed) forKey:@"succeed"];
    if (_errrorCode) {
        [dic setValue:_errrorCode forKey:@"errorCode"];
    }
    if (_errorMsg) {
        [dic setValue:_errorMsg forKey:@"errorMsg"];
    }
    return dic;
}

@end
