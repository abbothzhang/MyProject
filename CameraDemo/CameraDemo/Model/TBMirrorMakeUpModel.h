//
//  TBMirrorMakeUpModel.h
//  TBMirror
//
//  Created by albert on 15/3/31.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBMirrorMakeUpModel : NSObject

@property (nonatomic,strong) NSString           *action;//睫毛、口红等区分
//@property (nonatomic,strong) NSString           *modelFilePath;//模型文件地址
@property (nonatomic,strong) NSData             *fileData;
@property (nonatomic,strong) NSString           *cspuId;//模板文件的id
@property (nonatomic,strong) NSString           *cspuVersion;//模板版本号
@property (nonatomic) double                    weight;//化妆效果的比重
@property (nonatomic,strong) NSString           *color;//颜色
@property (nonatomic,strong) NSString           *datUrl;//dat文件的url地址

@property (nonatomic,strong) NSDictionary       *feature;//请求服务器端下载地址时候返回的属性（目前里面有color选项）-- 透传
@property (nonatomic,strong) NSDictionary       *attribute;//前端传过来的化妆功能的属性 --- 透传


@end
