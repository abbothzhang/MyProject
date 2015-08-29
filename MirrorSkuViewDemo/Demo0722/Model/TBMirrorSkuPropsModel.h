//
//  TBMirrorSkuPropsModel.h
//  Demo0722
//
//  Created by albert on 15/7/23.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TBDetailSkuPropsValuesModel.h"



@protocol TBMirrorSkuPropsModel <NSObject>
@end

@interface TBMirrorSkuPropsModel : NSObject

//属性ID
@property (nonatomic, copy) NSString* propId;

//属性值列表;例如：颜色属性：红色，蓝色
@property (nonatomic, strong) NSMutableArray<TBDetailSkuPropsValuesModel> *values;

//属性名称
@property (nonatomic, copy) NSString *propName;

@end
