//
//  ViewController.m
//  ZHGoThrough
//
//  Created by albert on 15/10/8.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "ViewController.h"
#import "ZHGameView.h"

@interface ViewController ()<UICollisionBehaviorDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UIView *greenView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;

@property(nonatomic,strong)UIDynamicAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)btnClick:(id)sender {
    //1.重力行为
    UIGravityBehavior *gravity=[[UIGravityBehavior alloc]init];
    [gravity addItem:self.greenView];
    
    //2碰撞检测行为
    UICollisionBehavior *collision=[[UICollisionBehavior alloc]init];
    [collision addItem:self.greenView];
//    [collision addItem:self.btn];
//    [collision addItem:self.segControl];
    collision.collisionDelegate = self;
    
    
    CGFloat y;
    for(float x=0;x<320;x = x+0.1){
        y=sin(x/180*3.14)*100+340.0;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
        point.backgroundColor = [UIColor redColor];
        [collision addItem:point];
        [self.view addSubview:point];
    }
    
    //让参照视图的边框成为碰撞检测的边界
    collision.translatesReferenceBoundsIntoBoundary=YES;
    
    //3.执行仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
    
    
}



- (UIDynamicAnimator *)animator{
    if (_animator == nil) {
       _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _animator;
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
