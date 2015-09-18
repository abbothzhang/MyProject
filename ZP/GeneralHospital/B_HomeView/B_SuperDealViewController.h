//
//  B_SuperDealViewController.h
//  zhipin
//
//  Created by 佳李 on 15/7/12.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B_LeftTableView.h"
@interface B_SuperDealViewController : UIViewController
{
    long           PageIndex;
    NSMutableArray *BtnArray;
    long           SelectIndex;
    BOOL IsLine;
     B_LeftTableView *LeftTable;
    UIButton *rightButton;
    NSArray         *CategoryList;
    UILabel         *NumLabel;

}


@property (nonatomic, copy) NSString *ShopId;
@property (nonatomic, copy) NSString *Type;
@property(nonatomic,retain)NSString *CatId;
@property (nonatomic, strong) NSMutableArray *dictArray;
@property(nonatomic,retain)NSArray  *CategoryList;


@end
