//
//  MainViewController.m
//  ZHGoThrough
//
//  Created by albert on 15/10/8.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "MainViewController.h"
#import "ZHPathBaseView.h"
#import "ZHPathView2.h"
#import "TipsViewController.h"

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
//    [self nextGameWithCurrentLevel:2];
    
    
}

- (void)setUpData{
    self.currentLevel = 1;
}

- (void)setUpView{
    [self setUpGameViewWithLevel:self.currentLevel];
    [self.view addSubview:self.navBar];

}

- (void)setUpGameViewWithLevel:(int)level{
    NSString *className = [NSString stringWithFormat:@"ZHPathView%d",level];
    Class nextGameViewCls = NSClassFromString(className);
    if ([nextGameViewCls isSubclassOfClass:[ZHPathBaseView class]]) {
        self.currentGameView = [[nextGameViewCls alloc] initWithFrame:self.view.bounds];
        self.currentGameView.delegate = self;
    }
    
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
        
        //tipsBtn
        UIButton *tipsBtn = [ZHIconFont iconFontButtonWithType:UIButtonTypeCustom fontSize:24 text:@"magic"];
        tipsBtn.frame = CGRectMake(_navBar.frame.size.width - 80, 0, 40, 40);
        [tipsBtn addTarget:self action:@selector(tipsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navBar addSubview:tipsBtn];
    }
    
    return _navBar;
}

#pragma mark - click
- (void)navBackBtnClick:(UIButton *)btn{
    
}

- (void)navNextBtnClick:(UIButton *)btn{
    
}

- (void)tipsBtnClick:(UIButton *)btn{
    TipsViewController *tipsVC = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:tipsVC animated:YES completion:^{
        
    }];
}

#pragma mark - ZHPathViewDelegate
- (void)failed{
    [ZHHint showToast:@"碰到障碍物"];
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.2;

    [UIView animateWithDuration:1.f animations:^{
        [self.view addSubview:bgView];
    }];
    
    MainViewController __weak *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5f animations:^{
            [weakSelf reloadGame];
            [bgView removeFromSuperview];
        }];
        
    });
    
}

- (void)succeed{
    self.currentLevel++;
    NSString *msg = [NSString stringWithFormat:@"恭喜过关!下一关:第%d关",self.currentLevel];
    [ZHHint showToast:msg];
    [self nextGameWithLevel:self.currentLevel];
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
- (void)nextGameWithLevel:(int)level{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5f animations:^{
            [self.currentGameView removeFromSuperview];
            NSString *className = [NSString stringWithFormat:@"ZHPathView%d",level];
            Class nextGameViewCls = NSClassFromString(className);
            if ([nextGameViewCls isSubclassOfClass:[ZHPathBaseView class]]) {
                self.currentGameView = [[nextGameViewCls alloc] initWithFrame:self.view.bounds];
                self.currentGameView.delegate = self;
            }
            
            [self.view addSubview:self.currentGameView];
        }];
        

    });
    
}



@end
