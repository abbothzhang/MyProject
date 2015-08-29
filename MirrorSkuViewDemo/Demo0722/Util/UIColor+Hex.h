
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
+ (UIColor*)colorWithHexString:(NSString*)hexString;
+ (UIColor*)whiteColorWithAlpha:(CGFloat)alphaValue;
+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue;
@end