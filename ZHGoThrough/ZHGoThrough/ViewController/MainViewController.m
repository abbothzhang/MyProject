//
//  MainViewController.m
//  ZHGoThrough
//
//  Created by albert on 15/10/8.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "MainViewController.h"
#import "ZHPathBaseView.h"
#import "ZHPathView1.h"

@interface MainViewController ()<ZHPathViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIView                     *navBar;

@property (nonatomic,strong) ZHPathBaseView             *currentGameView;
@property (nonatomic) int                               currentLevel;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpData];
    [self setUpView];
    [self nextGameWithCurrentLevel:2];
    
    
}

- (void)setUpData{
    self.currentLevel = 1;
}

- (void)setUpView{
    [self.view addSubview:self.navBar];
    [self setUpGameViewWithLevel:self.currentLevel];

}

- (void)setUpGameViewWithLevel:(int)level{
    self.currentGameView = [[ZHPathView1 alloc] initWithFrame:self.view.bounds];
    self.currentGameView.delegate = self;
    [self.view addSubview:self.currentGameView];
}

- (void)reloadGame{
    [self.currentGameView removeFromSuperview];
    [self setUpGameViewWithLevel:self.currentLevel];
}

- (UIView *)navBar{
    if (_navBar == nil) {
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _navBar.frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor colorWithHex:Color_L4];
        [_navBar addSubview:topLine];
        
        //backBtn
        UIButton *backBtn = [ZHIconFont iconFontButtonWithType:UIButtonTypeCustom fontSize:24 text:@"back"];
        backBtn.frame = CGRectMake(0, 0, 40, 40);
        [backBtn addTarget:self action:@selector(navBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navBar addSubview:backBtn];
        
        //nextBtn
        UIButton *nextBtn = [ZHIconFont iconFontButtonWithType:UIButtonTypeCustom fontSize:24 text:@"right"];
        nextBtn.frame = CGRectMake(40, 0, 40, 40);
        [nextBtn addTarget:self action:@selector(navNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navBar addSubview:nextBtn];
    }
    
    return _navBar;
}

#pragma mark - click
- (void)navBackBtnClick:(UIButton *)btn{
    
}

- (void)navNextBtnClick:(UIButton *)btn{
    
}

#pragma mark - ZHPathViewDelegate
- (void)failed{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"game over" message:@"rePlay?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
//    [alert show];
    [ZHHint showToast:@"碰到障碍物"];
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self.view addSubview:bgView];
    MainViewController __weak *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf reloadGame];
        [bgView removeFromSuperview];
    });
    
}

- (void)succeed{
    [ZHHint showToast:@"恭喜过关!下一关:第二关"];
    [self nextGameWithCurrentLevel:self.currentLevel];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
            
        default:
            break;
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    
}

#pragma mark - 
- (void)nextGameWithCurrentLevel:(NSInteger)currentLevel{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.currentGameView removeFromSuperview];
        NSString *className = [NSString stringWithFormat:@"ZHPathView%ld",currentLevel+1];
        Class nextGameViewCls = NSClassFromString(className);
        if ([nextGameViewCls isSubclassOfClass:[ZHPathBaseView class]]) {
            self.currentGameView = [[nextGameViewCls alloc] initWithFrame:self.view.bounds];
            self.currentGameView.delegate = self;
        }
        
        [self.view addSubview:self.currentGameView];

    });
    
}



@end
