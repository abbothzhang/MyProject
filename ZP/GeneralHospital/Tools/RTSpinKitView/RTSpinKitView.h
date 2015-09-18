//
//  RTSpinKitView.h
//  SpinKit
//
//  Created by Ramon Torres on 1/1/14.
//  Copyright (c) 2014 Ramon Torres. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RTSpinKitViewStyle) {
    RTSpinKitViewStylePlane,
    RTSpinKitViewStyleBounce,
    RTSpinKitViewStyleWave,
    RTSpinKitViewStyleWanderingCubes,
    RTSpinKitViewStylePulse,
    RTSpinKitViewStyleCoop,
    RTSpinKitViewStyleSingle,
    RTSpinKitViewStyleHalf,
};


typedef void (^ARTSpinKitBlock)(BOOL);
@interface RTSpinKitView : UIView
{
    ARTSpinKitBlock KitBlock;
}

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL hidesWhenStopped;

-(instancetype)initWithStyle:(RTSpinKitViewStyle)style;
-(instancetype)initWithStyle:(RTSpinKitViewStyle)style color:(UIColor*)color;
-(void)setStyle:(RTSpinKitViewStyle)style setColor:(UIColor *)color;
-(void)startAnimating;
-(void)stopAnimating;
-(void)ARTSpinKitAct:(ARTSpinKitBlock )kitBlock;

@end
