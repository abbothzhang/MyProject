//
//  TBMirrorSkuModel.h
//  Demo0722
//
//  Created by albert on 15/7/22.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBMirrorSkuModel <NSObject>
@end

@interface TBMirrorSkuModel : NSObject

//detail传入
@property (nonatomic,strong) NSString           *itemId;
@property (nonatomic,strong) NSString           *skuId;
//sku 库存
@property (nonatomic, assign) NSInteger         quantity;
//sku价格
@property (nonatomic,strong) NSString           *price;


//下面两个字段从楚铮的接口中获取
@property (nonatomic) BOOL                      isSupportMakeUp;//这个sku是否支持上妆
@property (nonatomic,strong) NSString           *cspuId;//cspuId


@end
