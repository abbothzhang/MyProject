//
//  ZHSocailBar.m
//  TestClient
//
//  Created by albert on 15/9/13.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "ZHSocailBar.h"
#import "ZHSocialParam.h"
#import "TBSCConst.h"
#import "ZHPraiseView.h"

@interface ZHSocailBar()

@property (nonatomic,strong) ZHSocialParam          *socialParam;

@end


@implementation ZHSocailBar

//- (void)initWithFrame:(CGRect)frame

- (instancetype)initWithFrame:(CGRect)frame socialParam:(ZHSocialParam *)socialParam{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        self.socialParam = socialParam;
    }
    return self;
}

- (void)setUpView{
    self.backgroundColor = [UIColor orangeColor];//test
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    topLine.backgroundColor = RGB(221, 221, 221);
    [self addSubview:topLine];
    
    CGRect praiseFrame = CGRectMake(0, 0, SCITEM_WIDTH, self.frame.size.height);
    ZHPraiseView *praiseView = [[ZHPraiseView alloc] initWithFrame:praiseFrame socialParam:self.socialParam];
    
    [self addSubview:praiseView];
    
}

- (void)clear{
    
}

- (void)dealloc{
    [self clear];
}

@end
