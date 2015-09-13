
//
//  UIColor+Hex.h
//  taobao4iphone
//
//  Created by huanwu on 12-9-4.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue;
//colorWithHexString：这个方法，在ios8越狱渠道装有hideme8插件的手机上，方法会被拦截，导致alpha通道设为0，致使颜色设置变为透明色，ui显示异常.
//可以用colorWithHex替换
+ (UIColor*)colorWithHexString:(NSString*)hexString DEPRECATED_ATTRIBUTE;
+ (UIColor*)whiteColorWithAlpha:(CGFloat)alphaValue;
+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue;
@end