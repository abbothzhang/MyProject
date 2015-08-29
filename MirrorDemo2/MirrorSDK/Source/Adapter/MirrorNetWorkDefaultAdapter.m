//
//  MirrorNetWorkManager.m
//  Mirror
//
//  Created by albert on 15/3/31.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "MirrorNetWorkDefaultAdapter.h"
#import "ApiRequest.h"
#import "MirrorNetworkParam.h"
#import "NetworkSDKDefine.h"
#import <WindVane/WindVane.h>
#import "TBErrorResponse.h"
#import "MTOPRequest.h"
#import "MirrorViewController.h"

@interface MirrorNetWorkDefaultAdapter () <TBSDKServerDelegate>

@property (nonatomic, strong) ApiRequest *apiRequest;

@property (nonatomic, strong) MirrorNetworkSucessBlock successBlock;
@property (nonatomic, strong) MirrorNetworkFailedBlock failedBlock;

@end

@implementation MirrorNetWorkDefaultAdapter

- (void)request:(NSString *)apiName
      withParam:(MirrorNetworkParam *)param
      onSuccess:(MirrorNetworkSucessBlock)successBlock
       onFailed:(MirrorNetworkFailedBlock)failedBlock
{
    _successBlock = successBlock;
    _failedBlock = failedBlock;
    
    if (apiName.length == 0) {
        _failedBlock (kMirrorErrorTypeNetWorkApinil,nil); // api name 不能为空
    }
    
    if(_apiRequest) {
        _apiRequest.delegate = nil;
        _apiRequest = nil;
    }
    
    NSString *version = param.apiVersion.length > 0 ? param.apiVersion : @"1.0";
    _apiRequest = [[ApiRequest alloc]initWithApiName:apiName version:version];
    
    if (param.needLogin) {
        [_apiRequest useEcode];
    }
    
    if (param.needWua) {
        [_apiRequest useWUA];
    }
    
    if (param.openAppkey.length > 0) {
        [_apiRequest useOpenApiProtocol];
        [_apiRequest withOpenAppkey:param.openAppkey];
    }
    
    if (param.accessToken.length > 0) {
        [_apiRequest withAccessToken:param.accessToken];
    }
    
    if (param.extraParam && param.extraParam.count > 0) {
        [_apiRequest addHttpParameters:param.extraParam];
    }
    
    if (param.needHttpPost) {
        [_apiRequest useHttpPost];
    }
    
    if (param.businessParam && param.businessParam.count > 0) {
        [_apiRequest addParameters:param.businessParam];
    }
    
    [_apiRequest withDelegate:self];
    [_apiRequest async];
}

- (void)cancel {
    _apiRequest.delegate = nil;
    _apiRequest = nil;
}

- (NSString *)jsonTopKey {
    return @"data";
}

- (void)requestSuccess:(TBSDKServer *)server {
    
    NSArray *ret = [server.responseJSON objectForKey:@"ret"];
    NSString *firstRet = [ret count] > 0 ? [ret objectAtIndex:0] : nil;
    
    if (firstRet
        && firstRet.length >= 7
        && [[firstRet substringToIndex:7] isEqualToString:@"SUCCESS"])
    {
        NSDictionary *responseDict = server.responseJSON;
        if (responseDict && responseDict[@"data"]) {
            _successBlock ( [NSDictionary dictionaryWithObject:responseDict[@"data"] forKey:[self jsonTopKey]]);
        }
    }
    else
    {
        NSString *msg = @"";
        NSString *errCode = @"";
        
        if ([ret count] > 0)
        {
            NSArray *arr = [[ret objectAtIndex:0] componentsSeparatedByString:@"::"];
            if ([arr count] == 2)
            {
                errCode = [arr count] > 0 ? [arr objectAtIndex:0] : @"";
                msg = [arr count] > 1 ? [arr objectAtIndex:1] : @"";
            }
        }
        
        if ([errCode length] &&
            [[errCode uppercaseString] hasPrefix: @"FAIL_SYS_"])
        {
            msg = kFaileSystemErrorCode;
        }
        
        // FAIL_SYS_SESSION_EXPIRED 为MTOP 4.0错误码
        if ([errCode isEqualToString:@"ERR_SID_INVALID"] || [errCode isEqualToString:@"FAIL_SYS_SESSION_EXPIRED"])
        {
            //            self.responseError.code = @"27";
            msg = @"对不起，您的登录信息已经过期";
            
        }
        // FAIL_SYS_ILEGEL_SIGN 为MTOP V4.0错误码
        else if ([errCode isEqualToString:@"ERRCODE_AUTH_REJECT"] || [errCode isEqualToString:@"FAIL_SYS_ILEGEL_SIGN"])
        {
            msg = @"对不起，您的登录信息可能已经过期，请重新登录";
        }
        
        _failedBlock(kMirrorErrorTypeNetWorkMtopError,msg);
    }
}

- (void)requestFailed:(TBSDKServer *)server {
    int errorCode = kMirrorErrorTypeNetWorkMtopError;
    if ([TBSDK_REQUEST_TIME_OUT isEqualToString: server.tbsdkError.errorCode])
    {
        errorCode = kMirrorMakeUpRequestTimedOutErrorType;
    }
    else if ([TBSDK_REQUEST_NOT_NETWORK isEqualToString: server.tbsdkError.errorCode])
    {
        errorCode = kMirrorMakeUpConnectionFailureErrorType;
    }
    NSString *errorMessage = @"数据加载失败";
    if ([server.tbsdkError.msg length])
    {
        errorMessage = server.tbsdkError.msg;
    }
    _failedBlock (errorCode,errorMessage);
}

- (void)dealloc {
    _apiRequest.delegate = nil;
    _apiRequest = nil;
}

@end
