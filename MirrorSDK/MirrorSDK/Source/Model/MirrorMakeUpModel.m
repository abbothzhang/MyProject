//
//  MirrorMakeUpModel.m
//  Mirror
//
//  Created by albert on 15/3/31.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "MirrorMakeUpModel.h"

@interface MirrorMakeUpModel()<NSCoding>

//@property (nonatomic,strong) NSString           *action;//睫毛、口红等区分
//@property (nonatomic,strong) NSString           *modelFilePath;//模型文件地址
//@property (nonatomic,strong) NSString           *cspuId;//模板文件的id
//@property (nonatomic,strong) NSString           *cspuVersion;//模板版本号
//@property (nonatomic) double                    weight;//化妆效果的比重
//@property (nonatomic,strong) NSString           *color;//颜色
//@property (nonatomic,strong) NSString           *datUrl;//dat文件的url地址
//
//@property (nonatomic,strong) NSMutableDictionary       *feature;//请求服务器端下载地址时候返回的属性（目前里面有color选项）-- 透传
//@property (nonatomic,strong) NSMutableDictionary       *attribute;//前端传过来的化妆功能的属性 --- 透传
//
//
//// 素材内存数据
//@property (nonatomic,strong) NSData *fileData;


@end




@implementation MirrorMakeUpModel

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.makeUpType = [[aDecoder decodeObjectForKey:@"makeUpType"] intValue];
//        self.modelFilePath = [aDecoder decodeObjectForKey:@"modelFilePath"];
        self.cspuId = [aDecoder decodeObjectForKey:@"cspuId"];
        self.cspuVersion = [aDecoder decodeObjectForKey:@"cspuVersion"];
        self.weight = [[aDecoder decodeObjectForKey:@"weight"] doubleValue];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.datUrl = [aDecoder decodeObjectForKey:@"datUrl"];
        self.feature = [aDecoder decodeObjectForKey:@"feature"];
        self.attribute = [aDecoder decodeObjectForKey:@"attribute"];
        self.fileData = [aDecoder decodeObjectForKey:@"fileData"];

    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(self.makeUpType) forKey:@"makeUpType"];
//    [aCoder encodeObject:self.modelFilePath forKey:@"modelFilePath"];
    [aCoder encodeObject:self.cspuId forKey:@"cspuId"];
    [aCoder encodeObject:self.cspuVersion forKey:@"cspuVersion"];
    [aCoder encodeObject:@(self.weight) forKey:@"weight"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:self.datUrl forKey:@"datUrl"];
    [aCoder encodeObject:self.feature forKey:@"feature"];
    [aCoder encodeObject:self.attribute forKey:@"attribute"];
    [aCoder encodeObject:self.fileData forKey:@"fileData"];
    
}
    
@end
