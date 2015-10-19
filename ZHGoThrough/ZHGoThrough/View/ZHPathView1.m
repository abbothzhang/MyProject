//
//  ZHPathView1.m
//  ZHGoThrough
//
//  Created by albert on 15/10/13.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "ZHPathView1.h"

@implementation ZHPathView1

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
    [self addSubview:self.movePointView];
    [self addSubview:self.endPointView];
}

- (void)setUpView{
    [self addSubview:self.movePointView];
    [self addSubview:self.endPointView];
    [self drawPath];
}

#pragma mark - draw Path
- (void)drawPath {
    self.testPointArray = [[NSMutableArray alloc] initWithCapacity:60];
    CGFloat baseY = 150*HEIGHT_SCALE;
    CGFloat addY = 45*HEIGHT_SCALE;
    CGFloat y;
    for(float x=5;x<280*WITH_SCALE;x=x+5){
        y = baseY;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:point];
        [self.testPointArray addObject:point];
        
        UIView *point2 = [[UIView alloc] initWithFrame:CGRectMake(x,y+addY,1, 1)];
        point2.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:point2];
        [self.testPointArray addObject:point];
    }
    
}

@end
