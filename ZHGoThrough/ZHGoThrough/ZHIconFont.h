//
//  TBIconFont.h
//
//
//  Created by lv on 14-6-10.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  iconfont相关接口。
 *  注意：bundle的工程中使用，需要在Debug环境下， 我才会自动加载iconfont.ttf字体。因为release环境是通过在info.plist中通过font provided by appliction字段指定
 */
@interface ZHIconFont : NSObject
/**
 *  返回iconfont对应字号的字体
 *
 *  @param fontSize 字号
 *
 *  @return 字体
 */
+ (UIFont*)iconFontWithSize:(NSInteger)fontSize;

/**
 *  使用iconfont的UIButton,text首页到映射表中查询，未找到则使用原始值
 *
 *  @param type     button类型
 *  @param fontSize iconfont字体大小
 *  @param text     iconfont编码，或者映射值：http://yunpan.taobao.com/share/link/D5FoiG4ZE,
 *
 *  @return 使用iconfont的UIButton
 */
+ (UIButton*)iconFontButtonWithType:(UIButtonType)type fontSize:(NSInteger)fontSize text:(NSString*)text;

/**
 *  使用iconfont的UILabel,text首页到映射表中查询，未找到则使用原始值
 *
 *  @param frame    label的frame
 *  @param fontSize iconfont字体大小
 *  @param text     iconfont编码，或者映射值：http://yunpan.taobao.com/share/link/D5FoiG4ZE
 *
 *  @return 使用iconfont的UILabel
 */
+ (UILabel*)iconFontLabelWithFrame:(CGRect)frame fontSize:(NSInteger)fontSize text:(NSString*)text;

/**
 *  根据映射表的中名称获取对应的iconfont的unicode编码
 *
 *  @param name 可以理解的名称
 *
 *  @return unicode编码
 */
+ (NSString*)iconFontUnicodeWithName:(NSString*)name;


+ (NSDictionary*)iconfontMapDict;
@end
