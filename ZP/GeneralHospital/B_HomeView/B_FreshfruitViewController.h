//
//  B_FreshfruitViewController.h
//  zhipin
//
//  Created by liuqin on 15/7/5.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHead.h"
#import "B_LeftTableView.h"
@interface B_FreshfruitViewController : UIViewController
{
    long           PageIndex;
    NSMutableArray *BtnArray;
    long           SelectIndex;
    BOOL IsLine;
    B_LeftTableView *LeftTable;
    UIButton *rightButton;

    UILabel         *NumLabel;
    NSArray *CategoryList;
}


@property (nonatomic, copy) NSString *ShopId;
@property (nonatomic, copy) NSString *Type;
@property(nonatomic,retain)NSString *CatId;
@property (nonatomic, strong) NSMutableArray *dictArray;



@end
