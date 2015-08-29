//
//  TBMirrorItemModel.h
//  Demo0722
//
//  Created by albert on 15/7/23.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBMirrorSkuModel.h"
#import "TBMirrorSkuPropsModel.h"

@interface TBMirrorItemModel : NSObject


@property (nonatomic,strong) NSString                                   *itemId;
@property (nonatomic) BOOL                                              isSupprotMakeUp;

//ppath 和 skuid 的map
@property (nonatomic, strong) NSDictionary                              *ppathIdmap;
//宝贝SKU对应的宝贝属性列表,最多只有两个
@property (nonatomic, strong) NSMutableArray<TBMirrorSkuPropsModel>            *skuProps;

//sku对应的价格、库存、materialId、以及是否支持上妆，key是skuid
@property (nonatomic, strong) NSMutableDictionary<TBMirrorSkuModel>     *mirrorSkuModelDic;

@end
