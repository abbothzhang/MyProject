//
//  ZHPraiseView.m
//  TestClient
//
//  Created by albert on 15/9/13.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "ZHPraiseView.h"
#import "ZHSocialParam.h"
#import "ZHNetworkAdapter.h"
#import "ZHAdapterManager.h"

@interface ZHPraiseView()

@property (nonatomic,strong) UIImageView                *iconImgView;
@property (nonatomic,strong) UILabel                    *textLabel;
@property (nonatomic,strong) UIView                     *praiseView;

@property (nonatomic,strong) UITapGestureRecognizer     *tap;

@property (nonatomic) BOOL                          isPraised;

@end

@implementation ZHPraiseView

- (instancetype)initWithFrame:(CGRect)frame socialParam:(ZHSocialParam *)socialParam{
    self = [super initWithFrame:frame];
    if (self) {
        [self addClickFun];
        [self queryPraiseState];
    }
    return self;
}



- (void)setUpView{
    self.backgroundColor = [UIColor greenColor];//test
    [self addSubview:self.praiseView];
//    [self addSubview:self.iconImgView];
//    [self addSubview:self.textLabel];
}

- (void)addClickFun{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [self addGestureRecognizer:_tap];
}

- (void)onClick{
    self.isPraised = !self.isPraised;
}

- (void)queryPraiseState{
    
    //mock
    self.isPraised = YES;
    [self setUpView];
    
    ZHNetworkAdapter *netWorkManager = [ZHAdapterManager sharedInstance].network;
    if (netWorkManager == nil) {
        //error，ZHNetworkAdapter为空
//        return;
    }
    
//    netWorkManager request:<#(NSString *)#> withParam:<#(ZHNetworkParam *)#> onSuccess:<#^(NSDictionary *dic)successBlock#> onFailed:<#^(NSInteger errorCode, NSString *errorMsg)failedBlock#>
}

#pragma mark - setter
- (void)setIsPraised:(BOOL)isPraised{
    _isPraised = isPraised;
    if (_isPraised) {
        self.iconImgView.image = [UIImage imageNamed:@"feed_praise"];
        self.textLabel.text = @"已赞";
    }else{
        self.iconImgView.image = [UIImage imageNamed:@"feed_unpraise"];
        self.textLabel.text = @"点赞";
    }
    
    [self.iconImgView sizeToFit];
    [self.textLabel sizeToFit];

    CGFloat textLabelCenterX = self.iconImgView.frame.origin.x+self.iconImgView.frame.size.width+self.textLabel.frame.size.width/2;
    self.textLabel.center = CGPointMake(textLabelCenterX, self.iconImgView.center.y);
    
    CGFloat iconImgViewHeight = self.iconImgView.frame.size.height;
    CGFloat textLabelHeight = self.textLabel.frame.size.height;
    CGFloat praiseViewWith = self.iconImgView.frame.size.width+self.textLabel.frame.size.width;
    CGFloat praiseViewHeight = iconImgViewHeight > textLabelHeight?iconImgViewHeight:textLabelHeight;
    self.praiseView.frame = CGRectMake(0, 0, praiseViewWith, praiseViewHeight);
    self.praiseView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    
}

#pragma mark - getter
- (UIImageView *)iconImgView{
    if (_iconImgView == nil) {
        _iconImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _iconImgView.backgroundColor = [UIColor redColor];
    }
    return _iconImgView;
}

- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _textLabel.backgroundColor = [UIColor yellowColor];
    }
    return _textLabel;
}

- (UIView *)praiseView{
    if (_praiseView == nil) {
        _praiseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _praiseView.backgroundColor = [UIColor blueColor];
        [_praiseView addSubview:self.iconImgView];
        [_praiseView addSubview:self.textLabel];
    }
    return _praiseView;
}




- (void)clear{
    [self removeGestureRecognizer:_tap];
}

- (void)dealloc{
    [self clear];
}

@end
