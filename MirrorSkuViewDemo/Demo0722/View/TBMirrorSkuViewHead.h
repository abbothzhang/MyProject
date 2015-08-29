//
//  TBMirrorSkuViewHead.h
//  Demo0722
//
//  Created by albert on 15/7/24.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBMirrorSkuViewHeadDelegate <NSObject>

-(void)arrowBtnClicked:(BOOL)isFold;

-(void)buyBtnClicked;

@end

@interface TBMirrorSkuViewHead : UIView

@property (nonatomic,strong) id<TBMirrorSkuViewHeadDelegate>            delegate;
@property (nonatomic,strong) NSString                                   *price;

-(void)hideArrowBtn:(BOOL)isHide;

@end
