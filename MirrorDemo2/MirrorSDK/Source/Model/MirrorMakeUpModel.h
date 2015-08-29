//
//  MirrorMakeUpModel.h
//  Mirror
//
//  Created by albert on 15/3/31.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MirrorMakeUpTypeCosmetic = 1,//化妆
    MirrorMakeUpTypeGlass//眼镜
}MirrorMakeUpType;

@interface MirrorMakeUpModel : NSObject

@property (nonatomic,assign) MirrorMakeUpType   makeUpType;//上妆类型，化妆或者眼镜等
@property (nonatomic,strong) NSString           *action;//睫毛、口红等区分
//@property (nonatomic,strong) NSString           *modelFilePath;//模型文件地址
@property (nonatomic,strong) NSString           *cspuId;//模板文件的id
@property (nonatomic,strong) NSString           *cspuVersion;//模板版本号
@property (nonatomic) double                    weight;//化妆效果的比重
@property (nonatomic,strong) NSString           *color;//颜色
@property (nonatomic,strong) NSString           *datUrl;//dat文件的url地址

@property (nonatomic,strong) NSMutableDictionary       *feature;//请求服务器端下载地址时候返回的属性（目前里面有color选项）-- 透传
@property (nonatomic,strong) NSMutableDictionary       *attribute;//前端传过来的化妆功能的属性 --- 透传


// 素材内存数据
@property (nonatomic,strong) NSData *fileData;
@property (nonatomic) BOOL   isCache;//这个model是否是缓存在disk中的，上妆时候用。如果已经缓存，会先拿缓存的进行上妆，后面再请求是否需要更新

@end
