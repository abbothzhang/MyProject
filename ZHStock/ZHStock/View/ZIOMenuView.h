//
//  ZIOMenuView.h
//  左右抽屉效果
//
//  Created by ziooooo on 15/2/4.
//  Copyright (c) 2015年 zio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    ZIOMenuViewClose = 0,//关闭
    ZIOMenuViewLeftOpen,//左边打开
    ZIOMenuViewRightOpen//右边打开
    
}ZIOMenuViewStatus;

@class ZIOMenuView;
@protocol ZIOMenuViewDelegate<NSObject>

@optional
/**
 *  打开目录时
 */
-(void)menuViewDidOpenMenu:(ZIOMenuView *)menuView;
/**
 *  关闭目录时
 */
-(void)menuViewDidCloseMenu:(ZIOMenuView *)menuView;
/**
 *  自定义的coverView
 */
-(UIView *)menuViewForCoverView:(ZIOMenuView *)menuView;

@end
@interface ZIOMenuView : UIView
/**
 *  左边view宽度
 *  默认0
 */
@property(assign,nonatomic)CGFloat leftViewWidth;
/**
 *  右边view宽度
 *  默认0
 */
@property(assign,nonatomic)CGFloat rightViewWidth;
/**
 *  动画时间
 *  默认0.3秒
 */
@property(assign,nonatomic)NSTimeInterval animateTime;
/**
 *  移动比例，默认0.3（移动到左/右view宽度的0.3自动打开）
 */
@property (assign,nonatomic)float moveRatio;

/**
 *  代理
 */
@property(weak,nonatomic)id<ZIOMenuViewDelegate>delegate;

/**
 *  目录view的状态
 */
@property(assign,nonatomic,readonly)ZIOMenuViewStatus menuViewStatus;
/**
 *  是否需要遮盖
 *  默认NO
 */
@property(assign,nonatomic) BOOL cover;
/**
 *  @param leftW 左边view宽度
 *  @param rightW 右边view宽度
 */
-(instancetype)initWithLeftViewWidth:(CGFloat)leftW andRightWidth:(CGFloat)rightW;
/**
 *  @param leftW 左边view宽度
 *  @param rightW 右边view宽度
 */
+(instancetype)menuViewWithLeftViewWidth:(CGFloat)leftW andRightWidth:(CGFloat)rightW;
/**
 *  打开左边目录
 */
-(void)openLeftMenuView;
/**
 *  打开右边目录
 */
-(void)openRightMenuView;
/**
 *  关闭目录
 */
-(void)closeMenuView;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com