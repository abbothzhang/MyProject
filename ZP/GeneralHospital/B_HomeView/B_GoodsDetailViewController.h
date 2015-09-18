//
//  B_GoodsDetailViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-15.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_GoodsDetailViewController : UcmedViewStyle
{
    UIScrollView    *ScrollView;
    UIButton        *ShopListBtn;
    UIButton        *RightBtn;
    UILabel         *NumLabel;
    UILabel         *CodeLabel;
    UIView          *BackView;
    UIView          *BelowView;
    NSDictionary    *GoodDict;
    NSMutableArray  *BtnArray;
    int             selectIndex;
    UILabel         *PriceLabel;
    NSMutableArray  *CommentImageArray;
    NSMutableArray  *aryPots;
    
    NSInteger indexPot ;
    NSArray *imageList;
}
@property(nonatomic,retain)NSDictionary *Dict;
@property (nonatomic ,copy) NSString *shopID;
@end
