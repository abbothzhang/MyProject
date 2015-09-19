//
//  AppDelegate.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-4-9.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "AppDelegate.h"
#import "UIButton+NMCategory.h"
#import "A_VoiceViewController.h"
#import "B_HomeViewController.h"
#import "B_FirstViewController.h"
#import "C_NearByViewController.h"
#import "D_PersonViewController.h"
#import "D_LoginViewController.h"
#import "AESCrypt.h"
#import <AlipaySDK/AlipaySDK.h>
#define INDEX 1//zhtest
@implementation AppDelegate
BMKMapManager* _mapManager;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 顶部字体白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     //修改导航字体格式
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    extern NSMutableDictionary      *G_UseDict;
    extern NSMutableDictionary      *G_ShopCar;
    extern CLLocationCoordinate2D   Location;
    extern NSMutableDictionary      *G_PersonDetail;
    application.applicationIconBadgeNumber=0;
    G_UseDict=[[NSMutableDictionary alloc] init];
    G_ShopCar=[[NSMutableDictionary alloc] init];
    G_PersonDetail=[[NSMutableDictionary alloc] init];
    BtnArray=[[NSMutableArray alloc] init];
    _mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:@"42db3396ae7832b8c7b8895a6aabedd3" generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    /**********************友盟***********************/
    [MobClick startWithAppkey:@"540c7514fd98c5db0503a631" reportPolicy:SEND_INTERVAL   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    
    NSData* AESData = [[AESCrypt decrypt:[[NSUserDefaults standardUserDefaults] objectForKey:[AESCrypt encrypt:@"user_model" password:@"zhipin123"]] password:@"zhipin123"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* AESDictionary = [NSPropertyListSerialization propertyListFromData:AESData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
    
    if (AESDictionary!=nil&&[AESDictionary isKindOfClass:[NSDictionary class]])
    {
        [G_UseDict setDictionary:AESDictionary];
//        NSLog(@"%@",G_UseDict);
    }
    bool isPass=NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"time"]!=nil)
    {
        isPass=[self compCurrentTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"time"]]>30;
    }
    NSLog(@"time===%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"time"],[dateFormatter stringFromDate:[NSDate date]]);


//    if ((G_UseDict==nil||[[G_UseDict allKeys] count]==0)&&!isPass) {
//        [self LoginView];
//    }else{
//        [self MainView];
//    }
    
    [self MainView];
    //self.window.rootViewController=[NSClassFromString(@"D_LoginViewController") new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#ifdef DEBUG
    //[self OpenLog];
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSLog(@"{\"oid\": \"%@\"}", deviceID);
//    [MobClick setLogEnabled:NO];
//    [MobClick setCrashReportEnabled:NO];
#else
    [MobClick setCrashReportEnabled:YES];
#endif
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(notificationSelector:)
                                                 name: @"process_begin"
                                               object: nil];

    return YES;
}

-(void)notificationSelector:(NSNotification *)notification
{
    if ([[notification object] intValue]<200) {
        if (ProcessView==nil) {
            ProcessView=[[KJProcessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE) setStyle:(KJViewStyle)[[notification object] intValue] setColor:STYLECLOLR];
            ProcessView.center=[UIApplication sharedApplication].keyWindow.center;
//            ProcessView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
            ProcessView.backgroundColor = [UIColor clearColor];
            [[UIApplication sharedApplication].keyWindow addSubview:ProcessView];
            [ProcessView setTranslatesAutoresizingMaskIntoConstraints:NO];
        }else{
            [ProcessView setStyle:(KJViewStyle)[[notification object] intValue] setColor:STYLECLOLR];
            [ProcessView startAnimating];
        }
    }else if ([[notification object] intValue]==201){
        [ProcessView stopAnimating];
    }else if ([[notification object] intValue]==202){
        [ProcessView stopAnimating];
    }
    
    NSLog(@"-----------------------------%@",[notification object]);
}
/**
 *  时间差
 *
 *  @param compareDate NSdate
 *
 *  @return NSString
 */
-(NSTimeInterval)compCurrentTime:(NSString* ) compareDate
{
    NSTimeInterval  timeInterval = [[self dateFromString:compareDate] timeIntervalSinceDate:[self getNowDate:[NSDate date]]];
    timeInterval = -timeInterval;
    NSLog(@"compCurrentTime==%lf",timeInterval);
    return  timeInterval/(3600*24*60);
}

/**
 *  获取当前时区的时间
 *
 *  @param anyDate NSDate
 *
 *  @return NSDate
 */
- (NSDate *)getNowDate:(NSDate *)anyDate
{
    NSTimeInterval timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate * newDate=[anyDate dateByAddingTimeInterval:timeZoneOffset];
    return newDate;
}

/**
 *  NSString转NSDate
 *
 *  @param dateString NSString
 *
 *  @return NSDate
 */
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (NavigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }else{
        return YES;
    }
}
-(void)LoginView
{
    [[UINavigationBar appearance] setBackgroundImage:[GeneralClass CreateImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];

    
    LoadViewController=[[UIViewController alloc] init];
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE)];
//    imageView.image=[UIImage imageNamed:@"login"];
    //[LoadViewController.view addSubview:imageView];
        [self addImagePlay];
    
    NavigationController=[[UINavigationController alloc] initWithRootViewController:LoadViewController];
    NavigationController.navigationBarHidden=YES;
    if ([NavigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        NavigationController.interactivePopGestureRecognizer.enabled = YES;
        NavigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.window.rootViewController=NavigationController;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, SCREEN_HIGHE-80, 130, 40.5);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 3;
    loginBtn.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_normal"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_slected"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginAct) forControlEvents:UIControlEventTouchUpInside];
    [LoadViewController.view addSubview:loginBtn];
    
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(170, SCREEN_HIGHE-80, 130, 40.5);
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 5;
    [registBtn setBackgroundImage:[UIImage imageNamed:@"regist_normal"] forState:UIControlStateNormal];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"regist_selected"] forState:UIControlStateHighlighted];
    [registBtn addTarget:self action:@selector(registAct) forControlEvents:UIControlEventTouchUpInside];
    [LoadViewController.view addSubview:registBtn];
    

    

}

- (void)addImagePlay
{
    UIScrollView *sView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HIGHE + 20)];
    
    sView.contentSize = CGSizeMake(2*SCREEN_WIDTH, SCREEN_HIGHE);
    sView.pagingEnabled = YES;
    sView.showsHorizontalScrollIndicator = NO;
    sView.showsVerticalScrollIndicator = NO;
    //sView.scrollEnabled = NO;
    sView.tag = 200;
    //循环创建添加4张图片
    for (int i = 1; i <= 2; i ++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake((i - 1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HIGHE);
        imgView.image = [UIImage imageNamed:[NSString  stringWithFormat:@"login%d.jpg",i]];
        [sView addSubview:imgView];
    }
    
    [LoadViewController.view addSubview:sView];
    
    //创建书页控件
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.frame = CGRectMake( 100, 440, 120, 20);
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.tag = 100;
    [LoadViewController.view addSubview:pageControl];
    
    //设置scrollView的代理为当前类对象
    sView.delegate = self;
    
    //添加定时器,使用scheuled方法创建的定时器,不需要用fird方法打开(自动开启的)
    //[self addtimer];
}

-(void)nextPage{
    int page = 0;
    UIPageControl *pControl = (UIPageControl *)[LoadViewController.view viewWithTag:100];
    if (pControl.currentPage == 3) {
        page = 0;
    }else{
        page = pControl.currentPage + 1;
    }
    
    //计算滚动的位置
    UIScrollView *sView = (UIScrollView *)[LoadViewController.view viewWithTag:200];
    CGFloat offsetX = page * sView.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [sView setContentOffset:offset animated:YES];
}

#pragma  - mark UIScrollViewDelegate
//监听滚动的位置,改变pageCotrol的currentPage的值.
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UIPageControl *pControl = (UIPageControl *)[LoadViewController.view viewWithTag:100];
    CGFloat scrollW = scrollView.frame.size.width;
    
    int page = (scrollView.contentOffset.x + scrollW * 0.5 )/ scrollW;
    pControl.currentPage = page;
}

-(void)MainView
{
    
    [[UINavigationBar appearance] setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forBarMetrics:UIBarMetricsDefault];
    
    A_VoiceViewController  *A_VoiceView=[[A_VoiceViewController alloc] init];
    B_FirstViewController   *B_HomeView=[[B_FirstViewController alloc] init];
    C_NearByViewController *C_NearByView=[[C_NearByViewController alloc] init];
    D_PersonViewController *D_PersonView=[[D_PersonViewController alloc] init];
    TabBarController=[[UITabBarController alloc] init];
    TabBarController.viewControllers=[[NSArray alloc] initWithObjects:
                                      [[UINavigationController alloc] initWithRootViewController:A_VoiceView],
                                      [[UINavigationController alloc] initWithRootViewController:B_HomeView],
                                      [[UINavigationController alloc] initWithRootViewController:C_NearByView],
                                      [[UINavigationController alloc] initWithRootViewController:D_PersonView],nil];
    TabBarController.selectedIndex=INDEX;
    TabBarController.delegate=self;
    for (id view in TabBarController.tabBar.subviews) {
        [view removeFromSuperview];
    }
    CGFloat w = SCREEN_WIDTH / 4;
    for (int i=0; i < 4; i++) {
        UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        barBtn.frame = CGRectMake(w * i , 0, 80, 50);
        barBtn.alpha=0.9;barBtn.tag=i;
        barBtn.selected=i==INDEX;
        if (i==INDEX) {SelectBtn=barBtn;}
        barBtn.showsTouchWhenHighlighted = YES;
        
        
        [barBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"a_root_image_%d.png",i]] forState:UIControlStateNormal];
        [barBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"a_root_image_clicked_%d.png",i]] forState:UIControlStateSelected];
        [barBtn setContentMode:UIViewContentModeScaleAspectFit];
        //[barBtn setBackgroundColor:UIColorFromRGB(0x1a1a1a)];
        [barBtn addTarget:self action:@selector(SelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [TabBarController.tabBar addSubview:barBtn];
        [BtnArray addObject:barBtn];
    }
    self.window.rootViewController=TabBarController;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    SelectBtn.selected=NO;
    SelectBtn=[BtnArray objectAtIndex:TabBarController.selectedIndex];
    SelectBtn.selected=YES;
}

-(void)SelectAction:(UIButton* )sender
{
    
    TabBarController.selectedIndex=sender.tag;
    SelectBtn.selected=NO;
    SelectBtn=sender;
    SelectBtn.selected=YES;
}


-(void)loginAct
{
    D_LoginViewController *D_LoginView=[[D_LoginViewController alloc] init];
    [D_LoginView setLoginBlock:^{
        [self MainView];
    }];
    [NavigationController pushViewController:D_LoginView animated:YES];
}

-(void)registAct
{
    [NavigationController pushViewController:[NSClassFromString(@"D_RegistViewController") new] animated:YES];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if(!url){
        return NO;
    }
    
    NSString *urlString=[url absoluteString];
//    NSLog(@"%@=============================",urlString);
    return YES;
}


-(void)OpenLog
{
    if (LogBtn==nil) {
        LogBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        LogBtn.frame = CGRectMake(SCREEN_WIDTH-60, 100, 50, 50);
        [LogBtn setDragEnable:YES];
        [LogBtn setAdsorbEnable:YES];
        [LogBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:30]];
        [LogBtn setTitle:@"\ue604" forState:UIControlStateNormal];
        [LogBtn setTitle:@"\ue604" forState:UIControlStateSelected];
        [LogBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [LogBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [LogBtn addTarget:self action:@selector(logSystem) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:LogBtn];
    }

}

-(void)logSystem
{
    NSLog(@"set log!!!");
    
//    [self.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[NSClassFromString(@"PushViewController") new]] animated:YES completion:^{
//        
//    } ];
}
 

/** 接收注册推送通知功能时出现的错误，并做相关处理*/
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"apns -> 注册推送功能时发生错误， 错误信息:\n %@", err);
}

#pragma mark - 实现远程推送需要实现的监听接口
/** 接收从苹果服务器返回的唯一的设备token，该token需要发送回推送服务器*/
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
	NSLog(@"apns -> 生成的devToken:%@", token);
    token=[[[token substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"apns -> 生成的devToken:%@", token);
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"client_mobile"];
 
}

//程序处于启动状态，或者在后台运行时，会接收到推送消息，解析处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary* retDict=[[NSDictionary alloc] initWithDictionary:userInfo];
    NSLog(@"远程通知-->     %@,%@",userInfo,retDict);
    [self showNotification:retDict];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    [self showNotification:notification.userInfo];
    NSLog(@"本地通知-->     %@",notification.userInfo);
    
    //在此时设置解析notification，并展示提示视图
}


//现实推送结果
-(void)showNotification:(NSDictionary *)userInfo
{
//    if ([[userInfo objectForKey:@"password"] isEqualToString:@"ucmed"]) {
//        [self OpenLog];
//    }
    if ([[[userInfo objectForKey:@"aps"] objectForKey:@"password"] isEqualToString:@"ucmed"]) {
       [self OpenLog];
    }
    
    NSLog(@"++++++%@",userInfo);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic){
             if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000)
             {
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"支付成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
             }
         }];
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_select" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pay_select" object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
