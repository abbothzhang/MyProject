//
//  ZHPathView2.m
//  ZHGoThrough
//
//  Created by albert on 15/10/11.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "ZHPathView3.h"
#import "ZHUtil.h"


@implementation ZHPathView3


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        [self drawPath];
        self.movePointStartCenter = CGPointMake(10*WITH_SCALE, 195*HEIGHT_SCALE);
        self.MOVEVIEW_RADIO = 20;
        self.endPointCenter = CGPointMake(self.frame.size.width/2, 400);
        self.ENDVIEW_RADIO = 60;
        [self addSubview:self.movePointView];
        [self addSubview:self.endPointView];
        
    }
    
    
    return self;
}



#pragma mark - draw Path
- (void)drawPath {
    self.testPointArray = [[NSMutableArray alloc] initWithCapacity:60];
    CGFloat baseY = 150*HEIGHT_SCALE;
    CGFloat addY = 70*HEIGHT_SCALE;
    int y;
    for(int x=5;x<70*WITH_SCALE;x = x+5){
        y = x+baseY;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:point];
        [self.testPointArray addObject:point];
        
        CGFloat y2 = y+addY;
        UIView *p2 = [[UIView alloc] initWithFrame:CGRectMake(x, y2, 1, 1)];
        p2.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:p2];
        [self.testPointArray addObject:p2];
        
        
        NSString *msg = [NSString stringWithFormat:@"x->%d  y->%d",x,y];
        NSLog(msg);
    }
    NSLog(@"----1-----");
    
    for(int x=70*WITH_SCALE;x<140*WITH_SCALE;x = x+5){
        y = -x+baseY+160;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:point];
        [self.testPointArray addObject:point];
        
        CGFloat y2 = y+addY;
        UIView *p2 = [[UIView alloc] initWithFrame:CGRectMake(x, y2, 1, 1)];
        p2.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:p2];
        [self.testPointArray addObject:p2];
        
        NSString *msg = [NSString stringWithFormat:@"x->%d  y->%d",x,y];
        NSLog(msg);
    }
    
    NSLog(@"-----2----");
    for(int x=140*WITH_SCALE;x<210*WITH_SCALE;x = x+5){
        y = x+baseY-166;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:point];
        [self.testPointArray addObject:point];
        
        CGFloat y2 = y+addY;
        UIView *p2 = [[UIView alloc] initWithFrame:CGRectMake(x, y2, 1, 1)];
        p2.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:p2];
        [self.testPointArray addObject:p2];
        
        NSString *msg = [NSString stringWithFormat:@"x->%d  y->%d",x,y];
        NSLog(msg);
    }
    
    NSLog(@"-----3----");
    
    for(int x=210*WITH_SCALE;x<280*WITH_SCALE;x = x+5){
        y = -x+baseY+324;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:point];
        [self.testPointArray addObject:point];
        
        CGFloat y2 = y+addY;
        UIView *p2 = [[UIView alloc] initWithFrame:CGRectMake(x, y2, 1, 1)];
        p2.backgroundColor = [UIColor colorWithHex:Color_L1];
        [self addSubview:p2];
        [self.testPointArray addObject:p2];
        
        NSString *msg = [NSString stringWithFormat:@"x->%d  y->%d",x,y];
        NSLog(msg);
    }
    
}


@end
