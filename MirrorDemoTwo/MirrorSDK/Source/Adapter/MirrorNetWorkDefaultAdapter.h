//
//  MirrorNetWorkManager.h
//  Mirror
//
//  Created by albert on 15/3/31.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MirrorNetworkParam.h"
#import "MirrorNetworkAdapter.h"

#define Mirror_API_GET_FACEMODEL              @"mtop.allspark.draw.getAPIData"//获取人脸定位的算法包地址
#define Mirror_API_GET_DAT                    @"mtop.allspark.draw.getDatInfo"//获取每个小的bat素材定位文件
#define Mirror_API_ISSUPPORT_MAKEUP           @"mtop.makeup.phone.support"//获取设备是否支持上妆功能



@interface MirrorNetWorkDefaultAdapter : MirrorNetworkAdapter

- (void)request:(NSString *)apiName
      withParam:(MirrorNetworkParam *)param
      onSuccess:(MirrorNetworkSucessBlock)successBlock
       onFailed:(MirrorNetworkFailedBlock)failedBlock;

@end
