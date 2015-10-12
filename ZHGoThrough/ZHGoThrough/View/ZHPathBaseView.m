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

- (UIView *)endPointView{
    if (_endPointView == nil) {
        _endPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ENDVIEW_RADIO, self.ENDVIEW_RADIO)];
        _endPointView.center = self.endPointCenter;
        _endPointView.layer.cornerRadius = self.ENDVIEW_RADIO/2;
        _endPointView.layer.borderColor = [UIColor colorWithHex:Color_L2].CGColor;
        _endPointView.layer.borderWidth = 0.5;
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

- (void)handelMoveViewPan:(UIPanGestureRecognizer *)gestureRecognizer{}


@end
