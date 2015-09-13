//
//  MirrorNetworkAdapter.h
//  MirrorSDK
//
//  Created by iNuoXia on 14/12/10.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetworkParam.h"

#define Mirror_API_GET_FACEMODEL              @"mtop.allspark.draw.getAPIData"//获取人脸定位的算法包地址
#define Mirror_API_GET_DAT                    @"mtop.allspark.draw.getDatInfo"//获取每个小的bat素材定位文件
#define Mirror_API_ISSUPPORT_MAKEUP           @"mtop.makeup.phone.support"//获取设备是否支持上妆功能


typedef void(^MirrorNetworkSucessBlock)(NSDictionary *dic);
typedef void(^MirrorNetworkFailedBlock)(NSInteger errorCode,NSString *errorMsg);

@interface ZHNetworkAdapter : NSObject

/**
 *  async api request
 *
 *  @param apiName
 *  @param param
 *  @param successBlock
 *  @param failedBlock  
 */
- (void)request:(NSString *)apiName
      withParam:(ZHNetworkParam *)param
      onSuccess:(MirrorNetworkSucessBlock)successBlock
       onFailed:(MirrorNetworkFailedBlock)failedBlock;

/**
 *  cancel
 */
- (void)cancel;

// 返回的json数据的key值，默认为 "data"
- (NSString *)jsonTopKey;

@end
