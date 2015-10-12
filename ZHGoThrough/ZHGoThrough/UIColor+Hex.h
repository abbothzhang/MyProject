
//
//  UIColor+Hex.h
//  taobao4iphone
//
//  Created by huanwu on 12-9-4.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Color_bg_red                    0x3d4245
#define Color_bg_orange                 0xff7100
#define Color_bg_yelllow                0xffaa00
#define Color_bg_green_light            0x52cc66
#define Color_bg_green                  0x66CD00
#define Color_bg_blue_light             0xf9f9f9

#define Color_L1  0x000000
#define Color_L2  0x222222
#define Color_L3  0xcccccc
#define Color_L4  0xdddddd
#define Color_L5  0xeeeeee

@interface UIColor (Hex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue;
//colorWithHexString：这个方法，在ios8越狱渠道装有hideme8插件的手机上，方法会被拦截，导致alpha通道设为0，致使颜色设置变为透明色，ui显示异常.
//可以用tbColorWithHexString替换
+ (UIColor*)colorWithHexString:(NSString*)hexString DEPRECATED_ATTRIBUTE;
+ (UIColor*)whiteColorWithAlpha:(CGFloat)alphaValue;
+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue;
+ (UIColor*)tbColorWithHexString:(NSString*)hexString;

@end