//
//  AppDelegate.m
//  BallClient
//
//  Created by albert on 15/9/10.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTeamViewController.h"
#import "BallListViewController.h"
#import "VoteViewController.h"
#import "BallCircleViewController.h"
#import "BallInfoViewController.h"
#import "ImageUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MyTeamViewController *myTeamVC = [[MyTeamViewController alloc] init];
    BallListViewController *ballListVC = [[BallListViewController alloc] init];
    VoteViewController *voteVC = [[VoteViewController alloc] init];
    BallCircleViewController *ballCircleVC = [[BallCircleViewController alloc] init];
    BallInfoViewController *ballInfoVC = [[BallInfoViewController alloc] init];
    
    //set VC
    UIImage *img1Nor = [UIImage imageNamed:@"img1.png"];
    img1Nor = [ImageUtil scaleImg:img1Nor toScale:0.3];
    
    
    myTeamVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的队"image:img1Nor selectedImage:img1Nor];
    ballListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"嗨球榜" image:img1Nor tag:0];
    voteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"投票"image:img1Nor selectedImage:img1Nor];
    ballCircleVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"嗨球圈"image:img1Nor selectedImage:img1Nor];
    ballInfoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"球讯"image:img1Nor selectedImage:img1Nor];

    
    UINavigationController *nav1VC = [[UINavigationController alloc] initWithRootViewController:myTeamVC];
    UINavigationController *nav2VC = [[UINavigationController alloc] initWithRootViewController:ballListVC];
    UINavigationController *nav3VC = [[UINavigationController alloc] initWithRootViewController:voteVC];
    UINavigationController *nav4VC = [[UINavigationController alloc] initWithRootViewController:ballCircleVC];
    UINavigationController *nav5VC = [[UINavigationController alloc] initWithRootViewController:ballInfoVC];
    
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    NSArray *tabArray = [[NSArray alloc] initWithObjects:nav1VC,nav2VC,nav3VC,nav4VC,nav5VC, nil];
    tabBarVC.viewControllers = tabArray;
    tabBarVC.selectedIndex = 0;
    
    self.window.rootViewController = tabBarVC;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
