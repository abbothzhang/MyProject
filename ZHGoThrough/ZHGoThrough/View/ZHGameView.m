//
//  ZHPathView.m
//  ZHGoThrough
//
//  Created by albert on 15/10/8.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "ZHGameView.h"

@interface ZHGameView()

@property (nonatomic,strong) UIPanGestureRecognizer         *moveViewPan;

@end

@implementation ZHGameView






- (UIPanGestureRecognizer *)moveViewPan{
    if (_moveViewPan == nil) {
        _moveViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelMoveViewPan:)];
        _moveViewPan.minimumNumberOfTouches = 1;
        _moveViewPan.maximumNumberOfTouches = 1;
    }
    return _moveViewPan;
}



#pragma mark - UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p{
    
}
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2{
    
}

// The identifier of a boundary created with translatesReferenceBoundsIntoBoundary or setTranslatesReferenceBoundsIntoBoundaryWithInsets is nil
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p{
    
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier{
    
}

@end
