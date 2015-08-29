//
//  TBDetailSkuPropsValuesModel.h
//  Demo0722
//
//  Created by albert on 15/7/31.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol TBDetailSkuPropsValuesModel <NSObject>
@end

@interface TBDetailSkuPropsValuesModel : NSObject

//属性值对应图片
@property (nonatomic, copy) NSString *imgUrl;

//属性值id
@property (nonatomic, copy) NSString *valueId;

//属性值名称
@property (nonatomic, copy) NSString *name;

//属性值别名;用户自定义的，如颜色属性值 白色，用户自定义 白色+收纳
@property (nonatomic, copy) NSString *valueAlias;


@end
