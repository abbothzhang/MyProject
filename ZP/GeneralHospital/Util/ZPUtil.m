//
//  MirrorUtils.m
//  Mirror
//
//  Created by albert on 15/4/7.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "ZPUtil.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation ZPUtil

+(CGFloat)iPhoneUIAdapterWithScale{
    static CGFloat withScale = 1.0;
    static  dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        //iPhone 6
        if ([[UIScreen mainScreen]bounds].size.width == 320.f) {
            withScale = 1;
        }else if ([[UIScreen mainScreen]bounds].size.width == 375.f){
            withScale = 375.f/320.f;
        }else if ([[UIScreen mainScreen]bounds].size.width == 414.f) {
            withScale = 414.f/320.f;
        } else {
            withScale = 1;
        }
    });
    return withScale;
}

+(CGFloat)iPhoneUIAdapterHeightScale{
    static CGFloat heightScale = 1.0;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        //iPhone 6
        if ([[UIScreen mainScreen]bounds].size.height == 568.f) {
            heightScale = 568.f/568.f;
        }else if ([[UIScreen mainScreen]bounds].size.height == 667.f){
            heightScale = 667.f/568.f;
        }else if ([[UIScreen mainScreen]bounds].size.height == 736.f) {
            heightScale = 736.f/568.f;
        } else {
            heightScale = 1;
        }
    });
    return heightScale;
}


+(NSString *)getCurrentPlatForm{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    NSString *platform = [ZPUtil getCurrentPlatForm];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

-(NSMutableDictionary*)parseJsonToDic:(id)data
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if ([data isKindOfClass:[NSString class]]) {
        NSData *dataObj = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataObj options:NSJSONReadingAllowFragments error:&err];
        paramDict = [[NSMutableDictionary alloc] initWithDictionary:dic];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        paramDict = [[NSMutableDictionary alloc] initWithDictionary:data];
    }
    return paramDict;
}

+(UIImage*)scaleImg:(UIImage*)img toScale:(float)scale
{
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width*scale, img.size.height*scale));
    [img drawInRect:CGRectMake(0, 0, img.size.width*scale, img.size.height*scale)];
    UIImage *scaledImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImg;
}

+(UIImage*)reSizeImg:(UIImage*)img toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImg;
}


@end
