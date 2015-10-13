//
//  ZHPathBaseView.h
//  ZHGoThrough
//
//  Created by albert on 15/10/11.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZHPathViewDelegate <NSObject>

- (void)failed;
- (void)succeed;

@end

@interface ZHPathBaseView : UIView

@property (nonatomic,strong) UIView                         *movePointView;
@property (nonatomic,strong) UIButton                       *endPointView;
@property (nonatomic,strong) UIPanGestureRecognizer         *moveViewPan;

@property (nonatomic) CGPoint                               movePointStartCenter;
@property (nonatomic) CGFloat                               MOVEVIEW_RADIO;
@property (nonatomic) CGPoint                               endPointCenter;
@property (nonatomic) CGFloat                               ENDVIEW_RADIO;

@property (nonatomic,strong) NSMutableArray                 *testPointArray;
@property (nonatomic) CGPoint                               distance;

@property (nonatomic) id<ZHPathViewDelegate>                delegate;
@property (nonatomic) BOOL                                  isEnd;


- (void)handelMoveViewPan:(UIPanGestureRecognizer *)gestureRecognizer;

@end
