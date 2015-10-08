//
//  ZIOMenuView.m
//  左右抽屉效果
//
//  Created by ziooooo on 15/2/4.
//  Copyright (c) 2015年 zio. All rights reserved.
//

#import "ZIOMenuView.h"
#define kMinSK 0.2
#define kDefaultMoveRatio 0.3
#define kDefaultAnimTime 0.3
@interface ZIOMenuView()
/**
 *  遮盖view
 */
@property(weak,nonatomic)UIView *coverView;
@end

@implementation ZIOMenuView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //初始化信息
        [self setupView];
        //添加手势
        [self setupGestureRecognizer];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化信息
        [self setupView];
        //添加手势
        [self setupGestureRecognizer];
    }
    return self;
}
-(instancetype)initWithLeftViewWidth:(CGFloat)leftW andRightWidth:(CGFloat)rightW
{
    if (self = [super init]) {
        self.leftViewWidth = leftW;
        self.rightViewWidth = rightW;
    }
    return self;
}
+(instancetype)menuViewWithLeftViewWidth:(CGFloat)leftW andRightWidth:(CGFloat)rightW
{
    return [[self alloc] initWithLeftViewWidth:leftW andRightWidth:rightW];
}
#pragma mark - 初始化
-(void)setupView
{
    //默认白色背景
    self.backgroundColor = [UIColor whiteColor];
    //默认动画时间
    self.animateTime = kDefaultAnimTime;
    //默认移动比例
    self.moveRatio = kDefaultMoveRatio;
    //默认关闭遮盖view
    self.cover = NO;
    //设置阴影效果
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 5;
    //设置遮盖view
    [self setupCoverView];
}
#pragma mark - 设置coverView
-(void)setupCoverView
{
    //默认的coverview
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    if ([self.delegate respondsToSelector:@selector(menuViewForCoverView:)]) {
        UIView *customCoverView = [self.delegate menuViewForCoverView:self];
        
        if (customCoverView) {//如果用户有自定义的coverView
            coverView = customCoverView;
        }
    }
    
    self.coverView = coverView;
    self.coverView.alpha = 0;
    if (self.cover)
    {
        [self.coverView removeFromSuperview];
        [self addSubview:self.coverView];
    }
}
//重写set方法重新设置遮盖view
-(void)setCover:(BOOL)cover
{
    _cover = cover;
    [self setupCoverView];
}
#pragma mark - 添加手势
-(void)setupGestureRecognizer
{
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:pan];
//    //点击手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
//    [self addGestureRecognizer:tap];
}
#pragma mark - 点击
- (void)tapView:(UITapGestureRecognizer *)tap
{
    CGRect tempF = tap.view.frame;
    if ((int)tempF.origin.x == 0) return;
    [self moveViewWithX:0];
}
#pragma mark - 设置frame
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = self.superview.bounds;
    self.coverView.frame = self.bounds;
}
#pragma mark - 拖拽
- (void)panView:(UIPanGestureRecognizer *)pan
{
    //在view上面挪动的距离
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint center = pan.view.center;
    CGFloat viewW = self.frame.size.width / 2;
    if (translation.x > kMinSK) {//view向右移动
        for (float i = 0; i < translation.x; i += kMinSK) {//细化移动距离，防止移动超过下面的view宽度
            if (center.x > viewW + self.leftViewWidth)
            {
                break;
            }
            center.x += kMinSK;
        }
    }
    if(translation.x < - kMinSK){//view向左移动
        for (float i = 0; i > translation.x; i -= kMinSK) {
            if (center.x < viewW - self.rightViewWidth)
            {
                break;
            }
            center.x -= kMinSK;
        }
    }
    pan.view.center = center;
    int viewX = pan.view.frame.origin.x;
    
    //清空移动的距离
    [pan setTranslation:CGPointZero inView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
        { // 手势结束,判断view位置
            if (viewX == 0)return;
            
            CGFloat endX = 0;
            if (viewX < self.leftViewWidth * self.moveRatio && viewX > 0) {//左边关闭
                endX = 0;
            }
            else if(viewX > self.leftViewWidth * self.moveRatio && viewX <= self.leftViewWidth){//左边打开
                endX = self.leftViewWidth;
            }
            else if (viewX < 0 && viewX > -self.rightViewWidth * self.moveRatio){//右边关闭
                endX = 0;
            }
            else if (viewX < -self.rightViewWidth * self.moveRatio){//右边打开
                endX = -self.rightViewWidth;
            }
            //移动view
            [self moveViewWithX:endX];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 根据x移动menuview
-(void)moveViewWithX:(CGFloat)x
{
    CGRect tempF = self.frame;
    tempF.origin.x = x;
    __weak ZIOMenuView *weakSelf = self;
    [UIView animateWithDuration:self.animateTime animations:^{
        self.frame = tempF;
        self.coverView.alpha = !x == 0;
    } completion:^(BOOL finished) {
        if (x == 0) {//关闭目录时
            if ([weakSelf.delegate respondsToSelector:@selector(menuViewDidCloseMenu:)]) {
                [weakSelf.delegate menuViewDidCloseMenu:weakSelf];
            }
        }
        else{//打开目录时
            if ([weakSelf.delegate respondsToSelector:@selector(menuViewDidOpenMenu:)]) {
                [weakSelf.delegate menuViewDidOpenMenu:weakSelf];
            }
        }
    }];
}
#pragma mark - 打开左边目录
-(void)openLeftMenuView
{
    [self moveViewWithX:self.leftViewWidth];
}
#pragma mark - 打开右边目录
-(void)openRightMenuView
{
    [self moveViewWithX:-self.leftViewWidth];
}
#pragma mark - 关闭目录
-(void)closeMenuView
{
    [self moveViewWithX:0];
}


#pragma mark - 获得view当前的状态
-(ZIOMenuViewStatus)menuViewStatus
{
    CGFloat viewX = self.frame.origin.x;
    
    if (viewX == 0) {
        return ZIOMenuViewClose;
    }
    else if(viewX == self.leftViewWidth){
        return ZIOMenuViewLeftOpen;
    }
    else{
        return ZIOMenuViewRightOpen;
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com