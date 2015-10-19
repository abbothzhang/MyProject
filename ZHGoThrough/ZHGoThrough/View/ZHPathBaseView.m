//
//  ZHPathBaseView.m
//  ZHGoThrough
//
//  Created by albert on 15/10/11.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "ZHPathBaseView.h"

@interface ZHPathBaseView()



@end

@implementation ZHPathBaseView

#pragma mark - getter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isEnd = NO;
    }
    
    return self;
}

- (UIView *)movePointView{
    if (_movePointView == nil) {
        _movePointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.MOVEVIEW_RADIO, self.MOVEVIEW_RADIO)];
        _movePointView.center = self.movePointStartCenter;
        _movePointView.backgroundColor = [UIColor colorWithHex:Color_bg_green];
        _movePointView.layer.cornerRadius = self.MOVEVIEW_RADIO/2;
        [_movePointView addGestureRecognizer:self.moveViewPan];
    }
    return _movePointView;
}

- (UIButton *)endPointView{
    if (_endPointView == nil) {
//        _endPointView = [ZHIconFont iconFontButtonWithType:UIButtonTypeCustom fontSize:self.ENDVIEW_RADIO text:@"round"];
        CGRect frame = CGRectMake(0, 0, self.ENDVIEW_RADIO, self.ENDVIEW_RADIO);
        _endPointView = [[UIButton alloc] initWithFrame:frame];
        _endPointView.center = self.endPointCenter;
        _endPointView.layer.cornerRadius = self.ENDVIEW_RADIO/2;
        _endPointView.layer.borderColor = [UIColor colorWithHex:Color_L1].CGColor;
        _endPointView.layer.borderWidth = 0.8;
    }
    
    return _endPointView;
}

- (UIPanGestureRecognizer *)moveViewPan{
    if (_moveViewPan == nil) {
        _moveViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelMoveViewPan:)];
        _moveViewPan.minimumNumberOfTouches = 1;
        _moveViewPan.maximumNumberOfTouches = 1;
    }
    return _moveViewPan;
}

//- (void)handelMoveViewPan:(UIPanGestureRecognizer *)gestureRecognizer{}

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
        if (isIn && !self.isEnd) {
            NSLog(@"collide");
            if (self.delegate && [self.delegate respondsToSelector:@selector(failed)]) {
                self.isEnd = YES;
                [self.delegate failed];
            }
        }
    }
    
    
    
    float distanceBetweenEndPoint = [ZHUtil distanceFromPointX:curPoint distanceToPointY:self.endPointCenter];
    BOOL isInEndPoint = self.ENDVIEW_RADIO/2 - self.MOVEVIEW_RADIO/2 - distanceBetweenEndPoint > 0;
    if (isInEndPoint && !self.isEnd) {
        NSLog(@"inEndPoint");
        if (self.delegate && [self.delegate respondsToSelector:@selector(succeed)]) {
            self.isEnd = YES;
            [self.delegate succeed];
        }
    }
    
}


@end
