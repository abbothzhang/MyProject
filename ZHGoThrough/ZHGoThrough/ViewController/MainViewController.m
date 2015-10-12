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

@interface MainViewController ()<ZHPathViewDelegate>

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
    self.currentGameView = [[ZHPathView1 alloc] initWithFrame:self.view.bounds];
    self.currentGameView.delegate = self;
    [self.view addSubview:self.currentGameView];

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
    
}

- (void)succeed{
    
}

#pragma mark - 
- (void)nextGameWithCurrentLevel:(NSInteger)currentLevel{
    [self.currentGameView removeFromSuperview];
    NSString *className = [NSString stringWithFormat:@"ZHPathView%ld",currentLevel+1];
    Class nextGameViewCls = NSClassFromString(className);
    if ([nextGameViewCls isSubclassOfClass:[ZHPathBaseView class]]) {
        self.currentGameView = [[nextGameViewCls alloc] initWithFrame:self.view.bounds];
    }
    
    [self.view addSubview:self.currentGameView];
}



@end
