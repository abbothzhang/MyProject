//
//  ZHPathView2.m
//  ZHGoThrough
//
//  Created by albert on 15/10/11.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "ZHPathView2.h"
#import "ZHUtil.h"


@implementation ZHPathView2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self drawPath];
        self.movePointStartCenter = CGPointMake(10, 205);
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
    CGFloat baseY = 30;
    CGFloat addY = 80;
    CGFloat y;
    for(float x=5;x<320;x = x+5){
        y = baseY + sin(x/180*3.14)*100+120.0;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor blackColor];
        [self addSubview:point];
        [self.testPointArray addObject:point];
    }
    
    for(float x=5;x<320;x = x+5){
        y = baseY + sin(x/180*3.14)*100+120.0 + addY;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor blackColor];
        [self addSubview:point];
        [self.testPointArray addObject:point];
    }
    
    
    
}



#pragma mark - click

- (void)handelMoveViewPan:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint curPoint = [gestureRecognizer locationInView:self];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGFloat x = self.movePointView.center.x - curPoint.x;
            CGFloat y = self.movePointView.center.y - curPoint.y;
            self.distance = CGPointMake(x, y);
        }
            break;
        case UIGestureRecognizerStateEnded:
            
            break;
        default:
            break;
    }
    
    self.movePointView.center = CGPointMake(curPoint.x + self.distance.x, curPoint.y + self.distance.y);
    
    for (UIView *point in self.testPointArray) {
        BOOL isIn =  CGRectIntersectsRect(self.movePointView.frame, point.frame);
        if (isIn) {
            NSLog(@"collide");
            if (self.delegate && [self.delegate respondsToSelector:@selector(failed)]) {
                [self.delegate failed];
            }
        }
    }
    
    
    
    float distanceBetweenEndPoint = [ZHUtil distanceFromPointX:curPoint distanceToPointY:self.endPointCenter];
    BOOL isInEndPoint = self.ENDVIEW_RADIO/2 - self.MOVEVIEW_RADIO/2 - distanceBetweenEndPoint > 0;
    if (isInEndPoint) {
        NSLog(@"inEndPoint");
        if (self.delegate && [self.delegate respondsToSelector:@selector(succeed)]) {
            [self.delegate succeed];
        }
    }
    
}

@end
