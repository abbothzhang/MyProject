//
//  RTSpinKitView.m
//  SpinKit
//
//  Created by Ramon Torres on 1/1/14.
//  Copyright (c) 2014 Ramon Torres. All rights reserved.
//

#import "RTSpinKitView.h"

#include <tgmath.h>
#define R 40
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

@interface RTSpinKitView ()
@property (nonatomic, assign) RTSpinKitViewStyle style;
@property (nonatomic, assign) BOOL stopped;
@end

@implementation RTSpinKitView
-(instancetype)initWithStyle:(RTSpinKitViewStyle)style {
    
    return [self initWithStyle:style color:[UIColor grayColor]];
}

-(instancetype)initWithStyle:(RTSpinKitViewStyle)style color:(UIColor*)color {
    self = [super init];
    if (self) {
        _style = style;
        _color = color;
        [self setStyle:style setColor:color];
    }
    return self;
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


-(void)applicationWillEnterForeground {
    if (self.stopped) {
        [self pauseLayers];
    } else {
        [self resumeLayers];
    }
}

-(void)setStyle:(RTSpinKitViewStyle)style setColor:(UIColor *)color
{
    [self sizeToFit];
    NSLog(@"%@",self.layer.sublayers);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    if (style == RTSpinKitViewStylePlane) {
        CALayer *plane = [CALayer layer];
        plane.frame = BOUNT;
        plane.backgroundColor = color.CGColor;
        plane.anchorPoint = CGPointMake(0.5, 0.5);
        plane.anchorPointZ = 0.5;
        [self.layer addSublayer:plane];
        
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
        
        [plane addAnimation:anim forKey:@"spinkit-anim"];
    }
    else if (style == RTSpinKitViewStyleBounce) {
        NSTimeInterval beginTime = CACurrentMediaTime();
        
        for (NSInteger i=0; i < 2; i+=1) {
            CALayer *circle = [CALayer layer];
            circle.frame = BOUNT;
            circle.backgroundColor = color.CGColor;
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
            [circle addAnimation:anim forKey:@"spinkit-anim"];
        }
    }
    else if (style == RTSpinKitViewStyleWave) {
        NSTimeInterval beginTime = CACurrentMediaTime() + 1.2;
        CGFloat barWidth = BOUNT.size.width/5-3;
        
        for (NSInteger i=0; i < 5; i+=1) {
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = color.CGColor;
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
            [layer addAnimation:anim forKey:@"spinkit-anim"];
        }
    }
    else if (style == RTSpinKitViewStyleWanderingCubes) {
        NSTimeInterval beginTime = CACurrentMediaTime();
        CGFloat cubeSize = floor(CGRectGetWidth(BOUNT) / 3.0);
        CGFloat widthMinusCubeSize = CGRectGetWidth(BOUNT) - cubeSize;
        
        for (NSInteger i=0; i<2; i+=1) {
            CALayer *cube = [CALayer layer];
            cube.backgroundColor = color.CGColor;
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
            [cube addAnimation:anim forKey:@"spinkit-anim"];
        }
    }
    else if (style == RTSpinKitViewStylePulse) {
        NSTimeInterval beginTime = CACurrentMediaTime();
        
        CALayer *circle = [CALayer layer];
        circle.frame = BOUNT;
        circle.backgroundColor = color.CGColor;
        circle.anchorPoint = CGPointMake(0.5, 0.5);
        circle.opacity = 1.0;
        circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5;
        circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
        
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
        
        [self.layer addSublayer:circle];
        [circle addAnimation:animGroup forKey:@"spinkit-anim"];
    }
    else if (style == RTSpinKitViewStyleCoop) {
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
        [Label.layer addAnimation:anim forKey:@"spinkit-anim"];
        
    }else if (style == RTSpinKitViewStyleSingle){
        
        NSTimeInterval beginTime = CACurrentMediaTime();
        UILabel * Label = [[UILabel alloc] initWithFrame:BOUNT];
        [Label setFont:[UIFont fontWithName:@"icomoon" size:R]];
        [Label setText:@"\ue618"];
        Label.textColor=STYLECLOLR;
        Label.backgroundColor=[UIColor clearColor];
        Label.layer.frame = BOUNT;
        Label.layer.anchorPoint = CGPointMake(0.5, 0.5);
        // cube.contents =(id)[UIImage imageNamed:@"200.png"].CGImage;
        
        //            UIImageView* Logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"200.png"]];
        //            Logo.layer.frame = CGRectMake(0.0, 0.0,20, 20);
        //            Logo.layer.anchorPoint = CGPointMake(0.5, 0.5);
        //            Logo.center=Label.center;
        //            [self addSubview:Logo];
        
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
        [Label.layer addAnimation:anim forKey:@"spinkit-anim"];
        
    }else if (style == RTSpinKitViewStyleHalf){
        
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
        
        [self.layer addSublayer:[self createRingLayerWithCenter:CENTER radius:R/1.5 lineWidth:6 color:[UIColor colorWithWhite:0 alpha:0.2]]];
        CAShapeLayer *caShape=[self createRingLayerWithCenter:CENTER radius:R/1.5 lineWidth:6 color:STYLECLOLR];
        caShape.strokeEnd=0.3;
        [self.layer addSublayer:caShape];
        [caShape addAnimation:anim forKey:@"spinkit-anim"];
    }
    UIView *fontView=[[UIView alloc] initWithFrame:BOUNT];
    [self addSubview:fontView];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [fontView addGestureRecognizer:singleRecognizer];
}
-(void)ARTSpinKitAct:(ARTSpinKitBlock )kitBlock
{
    KitBlock=kitBlock;
}
-(void)SingleTap:(UITapGestureRecognizer *)sender
{
    if (KitBlock) {
        KitBlock(YES);
    }
}

-(void)applicationDidEnterBackground {
    [self pauseLayers];
}

-(void)startAnimating {
    self.hidden = NO;
    self.stopped = NO;
    [self resumeLayers];
}

-(void)stopAnimating {
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }

    self.stopped = YES;
    [self pauseLayers];
}

-(void)pauseLayers {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

-(void)resumeLayers {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

-(CGSize)sizeThatFits:(CGSize)size {
    return  [[UIScreen mainScreen] bounds].size;
}

-(void)setColor:(UIColor *)color {
    _color = color;

    for (CALayer *l in self.layer.sublayers) {
        l.backgroundColor = color.CGColor;
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
