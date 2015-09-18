//
//  RootViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-4-9.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    //NSArray *Array=[[NSArray alloc] initWithObjects:@"1", nil];
    //[Array ObjectAtIndex:0];
    
    //NSMutableArray *Array1=[[NSMutableArray alloc] init];
    //[Array1 ObjectAtIndex:0];
    
    
    //NSMutableDictionary* Dictionary=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"hos", nil];
    // [Dictionary SetObject:nil forKey:nil];
    // [Dictionary ObjectForKey:nil];
    // [Dictionary RemoveObjectForKey:nil];
    // [Dictionary SetDictionary:nil];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    btn.frame = CGRectMake(30, 360, 90, 35);
    
    [btn setTitle:@"ZoomIn" forState:UIControlStateNormal];
    
    [btn setTitle:@"ZoomIn" forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(showAlertClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    btn1.frame = CGRectMake(30, 100, 90, 35);
    
    [btn1 setTitle:@"ZoomIn" forState:UIControlStateNormal];
    
    [btn1 setTitle:@"ZoomIn" forState:UIControlStateHighlighted];
    
    [btn1 addTarget:self action:@selector(showAlertClicked1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
 
    NSTimeInterval beginTime = CACurrentMediaTime();
#define R 50
#define CENTER [UIApplication sharedApplication].keyWindow.center
#define BOUNT CGRectMake(CENTER.x-R/2,CENTER.y-R/2,R,R)
    CALayer *circle = [CALayer layer];
    circle.frame = CGRectMake(100, 100, 60, 60);
 
    circle.backgroundColor =STYLECLOLR.CGColor;
    circle.anchorPoint = CGPointMake(0.5, 0.5);
    circle.opacity = 1.0;
    circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5;
    circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
    
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D t0 = CATransform3DIdentity;
 
#define X -1.0
#define Y -1.0
#define Z 0.0
    
#define XX -1.0
#define YY 1.0
#define ZZ 0.0
    
    
    scaleAnim.values = @[
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0,  30.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0,  60.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0,  90.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 120.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 150.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 180.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 210.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 240.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 270.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 300.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 330.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 360.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0,  30.0 * 0.0174532925, X, Y, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0,  30.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0,  60.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0,  90.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 120.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 150.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 180.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 210.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 240.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 270.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 300.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 330.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0, 360.0 * 0.0174532925, XX, YY, Z)],
                         [NSValue valueWithCATransform3D: CATransform3DRotate(t0,  30.0 * 0.0174532925, XX, YY, Z)]
                         ];
    
 
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.removedOnCompletion = NO;
    animGroup.beginTime = beginTime;
    animGroup.repeatCount = HUGE_VALF;
    animGroup.duration = 4.0;
    animGroup.animations = @[scaleAnim];
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.view.layer addSublayer:circle];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(160, 100, 200, 200)];
    imageView.image=[UIImage imageNamed:@"AppIcon60x60@2x.png"];
    [self.view addSubview:imageView];
    
    UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView1.image=[UIImage imageNamed:@"HealthGadgetFirstpage3.png"];
    [imageView addSubview:imageView1];
    
    [imageView.layer addAnimation:animGroup forKey:@"spinkit-anim"];
    
    [imageView1.layer addAnimation:animGroup forKey:@"spinkit-anim"];
//
//    UILabel * tempTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
//
//    [tempTwoLabel setFont:[UIFont fontWithName:@"icomoon" size:50]];
//    [tempTwoLabel setText:@"\ue600\ue601\ue602\ue603\ue604\ue605\ue606\ue607"];
//    tempTwoLabel.textColor=[UIColor redColor];
//    tempTwoLabel.numberOfLines=10;
//    [self.view addSubview:tempTwoLabel];
    // Do any additional setup after loading the view.
}
- (IBAction)showAlertClicked1
{
    UIViewController *ViewController=[UIViewController new];
    UIView *VIEW=[[UIView alloc] initWithFrame:CGRectMake(0, 160, 160, SCREEN_HIGHE)];
    VIEW.backgroundColor=[UIColor yellowColor];
    [ViewController.view addSubview:VIEW];
    [self.navigationController pushViewController:[NSClassFromString(@"SquareUIMethodsController") new] animated:YES];
}

- (IBAction)showAlertClicked
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/login.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:@"1538",@"phone",@"kskskk",@"enpassword", nil]
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"登陆后返回---- >>> %@",ReturnDict);
                          
                      }
                      NetError:^(int error) {
                      }
     ];

//    NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
//                          //statusBarColor:[UIColor purpleColor]
//                                                      title:@"Alert View"
//                                                    message:@"This is an alert example. 大红色的噶升级换代噶机会是个电话 大师大师经典噶伤筋动骨机会撒"
//                                                   delegate:self];
//    [alert show];
    
//    UXProcessHUD *processHUD=[[UXProcessHUD alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.view addSubview:processHUD];
 
//    NSDictionary *Dict=[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"type", nil];
//    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:HTTPURL]];
//    [NetRequest setASIPostDict:Dict
//                       ApiName:@"api.fydr.user.edition"
//                     CanCancel:YES
//                     SetNotice:NoticeType1
//                    SetNetWork:NetWorkTypeAS
//                    SetProcess:ProcessType8
//                    SetEncrypt:Encryption
//                      SetCache:Cache
//                      NetBlock:^(NSDictionary *ReturnDict) {
//                        
//                      }
//                      NetError:^(int error) {
//                         
//                      }
//     ];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
