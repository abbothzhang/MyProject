//
//  GloabalDefine.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-13.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APPID        @"hzpt_iphone"
#define APPKEY       @"ZW5sNWVWOXBjR2h2Ym1VPQ=="
#define APICHANNEL   @"3"
#define USERTYPE     @"2"
#define SESSIONID    [G_UseDict ObjectForKey:@"session_id"]
#define CLIENTMOBILE [[NSUserDefaults standardUserDefaults]objectForKey:@"client_mobile"]==nil?@"":[[NSUserDefaults standardUserDefaults]objectForKey:@"client_mobile"]
#define UITYPE UIType2
#define STYLECLOLR (UIColorFromRGB(0x6AD4D4))

#ifdef  DEBUG
#define DEBUGTYPE YES  //YES:关闭DEBUG  NO:开启DEBUG
#define HTTPURL @"http://app.zipn.cn/app"
//#define HTTPURL @"http://app.hzws.gov.cn/api/exec.htm"
#else
#define DEBUGTYPE YES //必须为YES
#define HTTPURL @"http://www.zipn.cn/app"
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)a)])

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HIGHE [[UIScreen mainScreen] bounds].size.height
#define IS_IOS7_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

#define NETTYPE NETTypeAS
#define TGCOLOR 0x00b5bf
#define TOUCHGCOLOR UIColorFromRGB(0xefefef)

#define ADDRESS [POSITIONARRAY objectAtIndex:INDEX]
#define EID @"51" //检测版本号id

#define USER [G_UseDict objectForKey:@"user"]


#define ENDCITY @"杭州市"




