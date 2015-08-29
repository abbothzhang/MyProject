//
//  TBMirrorSkuViewHead.m
//  Demo0722
//
//  Created by albert on 15/7/24.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "TBMirrorSkuViewHead.h"
#import "UIColor+Hex.h"

#define TBMIRROR_SKUVIEW_HEAD_HEIGHT        45
#define WITH_SCALE                          1

#define TBMIRROR_COLOR_ORANGE               [UIColor colorWithHex:0xff5000]

@interface TBMirrorSkuViewHead()

@property (nonatomic,strong) UIButton       *arrowBtn;
@property (nonatomic,strong) UILabel        *pricePreLabel;
@property (nonatomic,strong) UILabel        *priceLabel;
@property (nonatomic) BOOL                  isFold;

@end

@implementation TBMirrorSkuViewHead

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFold = NO;
        [self setUpView];
    }
    
    return self;
}


-(void)setUpView{
    
    //arrowBtn
    _arrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    _arrowBtn.center = CGPointMake(self.frame.size.width/2, 12);
//    arrowBtn.backgroundColor = [UIColor orangeColor];
    _arrowBtn.titleLabel.font = [UIFont systemFontOfSize:16];//[TBIconFont iconFontWithSize:24*WITH_SCALE];
    NSString * iconFontUnFold = @"^";//[TBIconFont iconFontUnicodeWithName:@"unfold"];
    [_arrowBtn setTitle:iconFontUnFold forState:UIControlStateNormal];
    [_arrowBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [_arrowBtn addTarget:self action:@selector(arrowClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //buyBtn
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-(12+72)*WITH_SCALE, 0, 72*WITH_SCALE, 24)];
    buyBtn.center = CGPointMake(buyBtn.center.x, self.frame.size.height/2);
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:TBMIRROR_COLOR_ORANGE forState:UIControlStateNormal];
    buyBtn.backgroundColor = [UIColor whiteColor];
    //设置边框
    buyBtn.layer.cornerRadius = 2.f;//圆角半径
    buyBtn.layer.borderWidth = 0.5f;//边框宽度
    [buyBtn.layer setBorderColor:TBMIRROR_COLOR_ORANGE.CGColor];
    [buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    

    [self addSubview:_arrowBtn];
    [self addSubview:self.pricePreLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:buyBtn];
    [self addSubview:lineView];
}

-(void)hideArrowBtn:(BOOL)isHide{
    _arrowBtn.hidden = isHide;
}

#pragma mark - click 
-(void)arrowClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(arrowBtnClicked:)]) {
        [self.delegate arrowBtnClicked:self.isFold];
    }
    
    TBMirrorSkuViewHead __weak *weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{
        if (weakSelf.isFold) {
            btn.transform = CGAffineTransformMakeRotation(0);
        }else{
           btn.transform = CGAffineTransformMakeRotation(M_PI);
        }
        
    }];
    
    self.isFold = !self.isFold;
    
}

-(void)buyBtnClicked:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyBtnClicked)]) {
        [self.delegate buyBtnClicked];
    }
}


#pragma mark - setter
-(void)setPrice:(NSString *)price{
    _price = price;
    self.priceLabel.text = price;
    
}

#pragma mark - getter
-(UILabel *)pricePreLabel{
    if (_pricePreLabel == nil) {
        _pricePreLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 21, 14, 14)];
//        _pricePreLabel.center = CGPointMake(_pricePreLabel.center.x, self.frame.size.height/2);
        _pricePreLabel.font = [UIFont systemFontOfSize:14.f];
        _pricePreLabel.textColor = TBMIRROR_COLOR_ORANGE;
        _pricePreLabel.text = @"￥";
    }
    return _pricePreLabel;
}

-(UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 15, 150*WITH_SCALE, 21)];
        _priceLabel.font = [UIFont systemFontOfSize:21.f];
        _priceLabel.textColor = TBMIRROR_COLOR_ORANGE;//[UIColor alloc] initWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>
    }
    //如果价格为空，那么隐藏价格前缀￥
    if (self.price == nil || [self.price isEqualToString:@""]) {
        self.pricePreLabel.hidden = YES;
    }else{
        self.pricePreLabel.hidden = NO;
    }
    
    return _priceLabel;
}




@end
