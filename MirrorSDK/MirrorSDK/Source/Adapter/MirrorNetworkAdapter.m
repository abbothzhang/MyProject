//
//  MirrorNetworkAdapter.m
//  MirrorSDK
//
//  Created by iNuoXia on 14/12/10.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "MirrorNetworkAdapter.h"
#import "MirrorViewController.h"

@implementation MirrorNetworkAdapter

- (void)request:(NSString *)apiName
      withParam:(MirrorNetworkParam *)param
      onSuccess:(MirrorNetworkSucessBlock)successBlock
       onFailed:(MirrorNetworkFailedBlock)failedBlock
{
    successBlock(nil);
    failedBlock (kMirrorMakeUpConnectionFailureErrorType,nil);
}

- (void)cancel
{
    
}

- (NSString *)jsonTopKey {
    return @"data";
}

@end
