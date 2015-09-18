//
//  AppDelegate.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-4-9.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "BMapKit.h"
#import "KJProcessView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,BMKGeneralDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    UIButton                   *LogBtn;
    UIButton                   *SelectBtn;
    UITabBarController         *TabBarController;
    UINavigationController     *NavigationController;
    NSMutableArray             *BtnArray;
    
    UIImageView *buttonIV;
    __block KJProcessView* ProcessView;
    
    UIViewController *LoadViewController;
}
@property (strong, nonatomic) UIWindow *window;

@end
