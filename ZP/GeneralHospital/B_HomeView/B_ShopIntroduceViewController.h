//
//  B_ShopIntroduceViewController.h
//  zhipin
//
//  Created by kjx on 15/3/8.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_ShopIntroduceViewController : UcmedViewStyle<UIScrollViewDelegate>
{
    UIScrollView *ScrollView;
}
@property(nonatomic,strong)NSDictionary *DetailDict;

@end
