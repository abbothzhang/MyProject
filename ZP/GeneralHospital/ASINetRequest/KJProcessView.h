//
//  KJProcessView.h
//  ASITest
//
//  Created by 夏科杰 on 14/12/11.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KJViewStyle) {
    KJViewStyle1=0,
    KJViewStyle2,
    KJViewStyle3,
    KJViewStyle4,
    KJViewStyle5,
    KJViewStyle6,
    KJViewStyle7,
    KJViewStyle8,
    KJViewUNStyle
};
@interface KJProcessView : UIView
{
    KJViewStyle    ViewStyle;
    BOOL           IsStop;
    UIColor        *StyleColor;
    NSMutableArray *LayerArray;
    UIView         *TapView;
}
-(instancetype)initWithFrame:(CGRect)frame setColor:(UIColor *)color;
-(instancetype)initWithFrame:(CGRect)frame setStyle:(KJViewStyle)style setColor:(UIColor *)color;;
-(void)setStyle:(KJViewStyle)style setColor:(UIColor *)color;
-(void)startAnimating;
-(void)stopAnimating;
@end
