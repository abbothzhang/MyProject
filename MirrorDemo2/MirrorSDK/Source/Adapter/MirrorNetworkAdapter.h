//
//  MirrorNetworkAdapter.h
//  MirrorSDK
//
//  Created by iNuoXia on 14/12/10.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MirrorNetworkParam.h"




typedef void(^MirrorNetworkSucessBlock)(NSDictionary *dic);
typedef void(^MirrorNetworkFailedBlock)(NSInteger errorCode,NSString *errorMsg);

@interface MirrorNetworkAdapter : NSObject

/**
 *  async api request
 *
 *  @param apiName
 *  @param param
 *  @param successBlock
 *  @param failedBlock  
 */
- (void)request:(NSString *)apiName
      withParam:(MirrorNetworkParam *)param
      onSuccess:(MirrorNetworkSucessBlock)successBlock
       onFailed:(MirrorNetworkFailedBlock)failedBlock;

/**
 *  cancel
 */
- (void)cancel;

// 返回的json数据的key值，默认为 "data"
- (NSString *)jsonTopKey;

@end
