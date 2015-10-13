//
//  ZHPathView.m
//  ZHGoThrough
//
//  Created by albert on 15/10/11.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "ZHPathView2.h"
#import "ZHUtil.h"

@interface ZHPathView2()



@end

@implementation ZHPathView2

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpData];
        [self setUpView];
    }
    return self;
}

- (void)setUpData{
    self.movePointStartCenter = CGPointMake(10, 205);
    self.MOVEVIEW_RADIO = 20;
    self.endPointCenter = CGPointMake(self.frame.size.width/2, 400);
    self.ENDVIEW_RADIO = 60;
    
    self.isEnd = NO;
}

- (void)setUpView{
    [self addSubview:self.movePointView];
    [self addSubview:self.endPointView];
    [self drawPath];
}

#pragma mark - draw Path
- (void)drawPath {
    self.testPointArray = [[NSMutableArray alloc] initWithCapacity:60];
    CGFloat baseY = 30;
    CGFloat addY = 80;
    CGFloat y;
    for(float x=5;x<320;x = x+5){
        y = baseY + sin(x/180*3.14)*100+120.0;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:point];
        [self.testPointArray addObject:point];
    }
    
    for(float x=5;x<320;x = x+5){
        y = baseY + sin(x/180*3.14)*100+120.0 + addY;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:point];
        [self.testPointArray addObject:point];
    }

    
    
}

@end
