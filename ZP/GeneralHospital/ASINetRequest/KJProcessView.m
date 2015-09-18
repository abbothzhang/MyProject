//
//  KJProcessView.m
//  ASITest
//
//  Created by 夏科杰 on 14/12/11.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "KJProcessView.h"
#include <tgmath.h>
#define R 50
#define CENTER [UIApplication sharedApplication].keyWindow.center
#define BOUNT CGRectMake(CENTER.x-R/2,CENTER.y-R/2,R,R)
static CGFloat kRTSpinKitDegToRad = 0.0174532925;
static int   NUM  = 11;
static CATransform3D RTSpinKit3DRotationWithPerspective(CGFloat perspective,
                                                        CGFloat angle,
                                                        CGFloat x,
                                                        CGFloat y,
                                                        CGFloat z)
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = perspective;
    return CATransform3DRotate(transform, angle, x, y, z);
}
@implementation KJProcessView

/**
 *  初始化
 *
 *  @param frame
 *
 *  @return self
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        IsStop=NO;
        LayerArray =[[NSMutableArray alloc] init];
        TapView=[[UIView alloc] initWithFrame:BOUNT];
        //TapView.backgroundColor=[UIColor redColor]
        [self addSubview:TapView];
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [TapView addGestureRecognizer:singleRecognizer];
        [self initView];
        // Initialization code
    }
    return self;
}

/**
 *  初始化动画
 *
 *  @param frame CGRect
 *  @param color 颜色
 *
 *  @return self
 */

-(id)initWithFrame:(CGRect)frame setColor:(UIColor *)color
{
    StyleColor= [color copy];
    
    return [self initWithFrame:frame];
}

/**
 *   初始化
 *
 *  @param frame 尺寸
 *  @param style 类型
 *  @param color 颜色
 *
 *  @return self
 */

-(id)initWithFrame:(CGRect)frame
          setStyle:(KJViewStyle)style
          setColor:(UIColor *)color
{
    ViewStyle=style;
    return [self initWithFrame:frame setColor:color];
}

/**
 *  设置颜色和动画类型
 *
 *  @param style 动画类型
 *  @param color 设置颜色
 */

-(void)setStyle:(KJViewStyle)style setColor:(UIColor *)color
{
    
    if (ViewStyle==style) {
        [self startAnimating];
        return;
    }
    for (CALayer *layer in LayerArray) {
        [self pauseLayer:layer];
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    [LayerArray removeAllObjects];
    StyleColor=[color copy];
    ViewStyle=style;
    IsStop=NO;
    [self initView];
}

/**
 *  开始动画
 */

-(void)startAnimating {
    if (ViewStyle==KJViewUNStyle) {
        return;
    }
    if (IsStop) {
        for (CALayer *layer in LayerArray) {
            [self resumeLayer:layer];
        }
        [UIView animateWithDuration:0.1 animations:^{
            self.hidden=NO;
        }];
        IsStop=NO;
    }
    
}

/**
 *  停止沟通
 */

-(void)stopAnimating {
    
    if (!IsStop) {
        for (CALayer *layer in LayerArray) {
            [self pauseLayer:layer];
        }
        [UIView animateWithDuration:0.1 animations:^{
            self.hidden=YES;
            IsStop=YES;
        }];
    }
}

/**
 *  暂停层动画
 *
 *  @param layer 动画层
 */

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

/**
 *  继续层动画
 *
 *  @param layer 动画层
 */

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

/**
 *  类型选择
 */

-(void)initView
{
    
    switch (ViewStyle)
    {
        case KJViewStyle1:
            [self KJViewStyleMethod1];
            break;
        case KJViewStyle2:
            [self KJViewStyleMethod2];
            break;
        case KJViewStyle3:
            [self KJViewStyleMethod3];
            break;
        case KJViewStyle4:
            [self KJViewStyleMethod4];
            break;
        case KJViewStyle5:
            [self KJViewStyleMethod5];
            break;
        case KJViewStyle6:
            [self KJViewStyleMethod6];
            break;
        case KJViewStyle7:
            [self KJViewStyleMethod7];
            break;
        case KJViewStyle8:
            [self KJViewStyleMethod8];
            break;
        case  KJViewUNStyle:
            break;
        default:
            break;
    }
    
}

/**
 *  取消动画
 *
 *  @param sender UITapGestureRecognizer
 */

-(void)SingleTap:(UITapGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"process_begin" object:@2];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"process_cancel" object:@1];
}

/**
 *  动画1
 */

-(void)KJViewStyleMethod1
{
    
    CALayer *layer = [CALayer layer];
    layer.frame = BOUNT;
    layer.backgroundColor = StyleColor.CGColor;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.anchorPointZ = 0.5;
    [self.layer addSublayer:layer];
    [LayerArray addObject:layer];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.removedOnCompletion = NO;
    anim.repeatCount = HUGE_VALF;
    anim.duration = 1.2;
    anim.keyTimes = @[@(0.0), @(0.5), @(1.0)];
    
    anim.timingFunctions = @[
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                             ];
    
    anim.values = @[
                    [NSValue valueWithCATransform3D:RTSpinKit3DRotationWithPerspective(1.0/120.0, 0, 0, 0, 0)],
                    [NSValue valueWithCATransform3D:RTSpinKit3DRotationWithPerspective(1.0/120.0, M_PI, 0.0, 1.0,0.0)],
                    [NSValue valueWithCATransform3D:RTSpinKit3DRotationWithPerspective(1.0/120.0, M_PI, 0.0, 0.0,1.0)]
                    ];
    
    [layer addAnimation:anim forKey:@"KJViewStyle1"];
}

-(void)KJViewStyleMethod2
{
    
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    for (NSInteger i=0; i < 2; i+=1) {
        CALayer *circle = [CALayer layer];
        circle.frame = BOUNT;
        circle.backgroundColor = StyleColor.CGColor;
        circle.anchorPoint = CGPointMake(0.5, 0.5);
        circle.opacity = 0.6;
        circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5;
        circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        anim.removedOnCompletion = NO;
        anim.repeatCount = HUGE_VALF;
        anim.duration = 2.0;
        anim.beginTime = beginTime - (1.0 * i);
        anim.keyTimes = @[@(0.0), @(0.5), @(1.0)];
        
        anim.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                 ];
        
        anim.values = @[
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)]
                        ];
        
        [self.layer addSublayer:circle];
        [circle addAnimation:anim forKey:@"KJViewStyle2"];
        [LayerArray addObject:circle];
    }
    
}
-(void)KJViewStyleMethod3
{
    NSTimeInterval beginTime = CACurrentMediaTime() + 1.2;
    CGFloat barWidth = BOUNT.size.width/5-3;
    
    for (NSInteger i=0; i < 5; i+=1) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = StyleColor.CGColor;
        layer.frame = CGRectMake(CENTER.x-BOUNT.size.width/2+BOUNT.size.width/5 * i, CENTER.y-BOUNT.size.height/2, barWidth,  BOUNT.size.height);
        
        layer.transform = CATransform3DMakeScale(1.0, 0.3, 0.0);
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        anim.removedOnCompletion = NO;
        anim.beginTime = beginTime - (1.2 - (0.1 * i));
        anim.duration = 1.2;
        anim.repeatCount = HUGE_VALF;
        anim.keyTimes = @[@(0.0), @(0.2), @(0.4), @(1.0)];
        
        anim.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                 ];
        
        anim.values = @[
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.4, 0.0)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.4, 0.0)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.4, 0.0)]
                        ];
        
        [self.layer addSublayer:layer];
        [layer addAnimation:anim forKey:@"KJViewStyle3"];
        [LayerArray addObject:layer];
    }
    
}
-(void)KJViewStyleMethod4
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    CGFloat cubeSize = floor(CGRectGetWidth(BOUNT) / 3.0);
    CGFloat widthMinusCubeSize = CGRectGetWidth(BOUNT) - cubeSize;
    
    for (NSInteger i=0; i<2; i+=1) {
        CALayer *cube = [CALayer layer];
        cube.backgroundColor = StyleColor.CGColor;
        cube.frame = CGRectMake(CENTER.x-CGRectGetWidth(BOUNT)/2, CENTER.y-CGRectGetWidth(BOUNT)/2, cubeSize, cubeSize);
        cube.anchorPoint = CGPointMake(0.5, 0.5);
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        anim.removedOnCompletion = NO;
        anim.beginTime = beginTime - (i * 0.9);
        anim.duration = 1.8;
        anim.repeatCount = HUGE_VALF;
        
        anim.keyTimes = @[@(0.0), @(0.25), @(0.50), @(0.75), @(1.0)];
        
        anim.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                 ];
        
        CATransform3D t0 = CATransform3DIdentity;
        
        CATransform3D t1 = CATransform3DMakeTranslation(widthMinusCubeSize, 0.0, 0.0);
        t1 = CATransform3DRotate(t1, -90.0 * kRTSpinKitDegToRad, 0.0, 0.0, 1.0);
        t1 = CATransform3DScale(t1, 0.5, 0.5, 1.0);
        
        CATransform3D t2 = CATransform3DMakeTranslation(widthMinusCubeSize, widthMinusCubeSize, 0.0);
        t2 = CATransform3DRotate(t2, -180.0 * kRTSpinKitDegToRad, 0.0, 0.0, 1.0);
        t2 = CATransform3DScale(t2, 1.0, 1.0, 1.0);
        
        CATransform3D t3 = CATransform3DMakeTranslation(0.0, widthMinusCubeSize, 0.0);
        t3 = CATransform3DRotate(t3, -270.0 * kRTSpinKitDegToRad, 0.0, 0.0, 1.0);
        t3 = CATransform3DScale(t3, 0.5, 0.5, 1.0);
        
        CATransform3D t4 = CATransform3DMakeTranslation(0.0, 0.0, 0.0);
        t4 = CATransform3DRotate(t4, -360.0 * kRTSpinKitDegToRad, 0.0, 0.0, 1.0);
        t4 = CATransform3DScale(t4, 1.0, 1.0, 1.0);
        
        
        anim.values = @[[NSValue valueWithCATransform3D:t0],
                        [NSValue valueWithCATransform3D:t1],
                        [NSValue valueWithCATransform3D:t2],
                        [NSValue valueWithCATransform3D:t3],
                        [NSValue valueWithCATransform3D:t4]];
        
        [self.layer addSublayer:cube];
        [cube addAnimation:anim forKey:@"KJViewStyleMethod4"];
        [LayerArray addObject:cube];
    }
    
    
}
-(void)KJViewStyleMethod5
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CALayer* layer = [CALayer layer];
    layer.frame = BOUNT;
    layer.backgroundColor = StyleColor.CGColor;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.opacity = 1.0;
    layer.cornerRadius = CGRectGetHeight(layer.bounds) * 0.5;
    layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
    
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnim.values = @[
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0)]
                         ];
    
    CAKeyframeAnimation *opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.values = @[@(1.0), @(0.0)];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.removedOnCompletion = NO;
    animGroup.beginTime = beginTime;
    animGroup.repeatCount = HUGE_VALF;
    animGroup.duration = 1.0;
    animGroup.animations = @[scaleAnim, opacityAnim];
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addSublayer:layer];
    [layer addAnimation:animGroup forKey:@"KJViewStyleMethod5"];
    [LayerArray addObject:layer];
}
-(void)KJViewStyleMethod6
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    UILabel * Label = [[UILabel alloc] initWithFrame:BOUNT];
    [Label setFont:[UIFont fontWithName:@"icomoon" size:BOUNT.size.width]];
    [Label setText:@"\ue610"];
    Label.backgroundColor=[UIColor clearColor];
    Label.textColor=STYLECLOLR;
    Label.layer.frame = BOUNT;
    Label.layer.anchorPoint = CGPointMake(0.5, 0.5);
    // cube.contents =(id)[UIImage imageNamed:@"200.png"].CGImage;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.removedOnCompletion = NO;
    anim.beginTime = beginTime;
    anim.duration = 1;
    anim.repeatCount = HUGE_VALF;
    
    NSMutableArray* keyTimeA=        [[NSMutableArray alloc] init];
    NSMutableArray* timingFunctionsA=[[NSMutableArray alloc] init];
    NSMutableArray* valuesA=         [[NSMutableArray alloc] init];
    for (float i=0; i<NUM; i++) {
        [keyTimeA addObject:@(i/(NUM-1))];
        [timingFunctionsA addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        CATransform3D t1 = CATransform3DMakeTranslation(0, 0.0, 0.0);
        t1 = CATransform3DRotate(t1,(-360.0+360/(NUM-1)*i) * kRTSpinKitDegToRad, 0.0, 0.0, 1.0);
        [valuesA addObject:[NSValue valueWithCATransform3D:i==0?CATransform3DIdentity:t1]];
    }
    
    anim.keyTimes =keyTimeA;
    anim.timingFunctions=timingFunctionsA;
    anim.values=valuesA;
    [self addSubview:Label];
    [Label.layer addAnimation:anim forKey:@"KJViewStyleMethod6"];
    [LayerArray addObject:Label.layer];
    
}
-(void)KJViewStyleMethod7
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    UILabel * Label = [[UILabel alloc] initWithFrame:BOUNT];
    [Label setFont:[UIFont fontWithName:@"icomoon" size:R]];
    [Label setText:@"\ue618"];
    Label.textColor=STYLECLOLR;
    Label.backgroundColor=[UIColor clearColor];
    Label.layer.frame = BOUNT;
    Label.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.removedOnCompletion = NO;
    anim.beginTime = beginTime;
    anim.duration = 1;
    anim.repeatCount = HUGE_VALF;
    
    NSMutableArray* keyTimeA=        [[NSMutableArray alloc] init];
    NSMutableArray* timingFunctionsA=[[NSMutableArray alloc] init];
    NSMutableArray* valuesA=         [[NSMutableArray alloc] init];
    for (float i=0; i<NUM; i++) {
        [keyTimeA addObject:@(i/(NUM-1))];
        [timingFunctionsA addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        CATransform3D t1 = CATransform3DMakeTranslation(0, 0.0, 0.0);
        t1 = CATransform3DRotate(t1,(-360.0+360/(NUM-1)*i) * kRTSpinKitDegToRad, 0.0, 0.0, 1.0);
        [valuesA addObject:[NSValue valueWithCATransform3D:i==0?CATransform3DIdentity:t1]];
    }
    
    anim.keyTimes =keyTimeA;
    anim.timingFunctions=timingFunctionsA;
    anim.values=valuesA;
    [self addSubview:Label];
    [Label.layer addAnimation:anim forKey:@"KJViewStyleMethod7"];
    [LayerArray addObject:Label.layer];
}
-(void)KJViewStyleMethod8
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.removedOnCompletion = NO;
    anim.beginTime = beginTime;
    anim.duration = 1;
    anim.repeatCount = HUGE_VALF;
    
    NSMutableArray* keyTimeA=        [[NSMutableArray alloc] init];
    NSMutableArray* timingFunctionsA=[[NSMutableArray alloc] init];
    NSMutableArray* valuesA=         [[NSMutableArray alloc] init];
    for (float i=0; i<NUM; i++) {
        [keyTimeA addObject:@(i/(NUM-1))];
        [timingFunctionsA addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        CATransform3D t1 = CATransform3DMakeTranslation(0, 0.0, 0.0);
        t1 = CATransform3DRotate(t1,(-360.0+360/(NUM-1)*i) * kRTSpinKitDegToRad, 0.0, 0.0, 1.0);
        [valuesA addObject:[NSValue valueWithCATransform3D:i==0?CATransform3DIdentity:t1]];
    }
    anim.keyTimes =keyTimeA;
    anim.timingFunctions=timingFunctionsA;
    anim.values=valuesA;
    CAShapeLayer *baShape=[self createRingLayerWithCenter:CENTER radius:R/1.5 lineWidth:6 color:[UIColor colorWithWhite:0 alpha:0.2]];
    [self.layer addSublayer:baShape];
    CAShapeLayer *caShape=[self createRingLayerWithCenter:CENTER radius:R/1.5 lineWidth:6 color:STYLECLOLR];
    caShape.strokeEnd=0.3;
    [self.layer addSublayer:caShape];
    [caShape addAnimation:anim forKey:@"KJViewStyleMethod8"];
    [LayerArray addObject:baShape];
    [LayerArray addObject:caShape];
    
}



- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x-radius, center.y-radius, radius*2, radius*2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineCapRound;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}

@end
