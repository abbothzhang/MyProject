//
//  MirrorUtils.h
//  Mirror
//
//  Created by albert on 15/4/7.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define WITH_SCALE          [MirrorUtils iPhoneUIAdapterWithScale]
#define HEIGHT_SCALE        [MirrorUtils iPhoneUIAdapterHeightScale]

@interface MirrorUtils : NSObject
//以6为基础做适配
+(CGFloat)iPhoneUIAdapterWithScale;
+(CGFloat)iPhoneUIAdapterHeightScale;

//获取设备platform
+(NSString *)getCurrentPlatForm;

//获得设备型号(由platform映射)
+ (NSString *)getCurrentDeviceModel;

//获取ios系统版本号
+ (float)getIOSVersion;

//将string或者dic转为dic
-(NSMutableDictionary*)parseJsonToDic:(id)data;

+(UIImage*)scaleImg:(UIImage*)img toScale:(float)scale;
+(UIImage*)reSizeImg:(UIImage*)img toSize:(CGSize)size;
@end
