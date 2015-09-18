//
//  ShopDetailViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-13.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLIDEKeyboardView.h"
#import "B_LeftTableView.h"
@interface B_ShopDetailViewController : UcmedViewStyle<UISearchBarDelegate,UIScrollViewDelegate>
{
    UIScrollView    *ScrollView;
    UISearchBar     *SearchBar;
    NSDictionary    *Dictionary;
    B_LeftTableView *LeftTable;
    UILabel         *NumLabel;
    NSArray         *CategoryList;
}
@property(nonatomic,retain)NSDictionary *Dict;
@property (nonatomic, copy) NSString *shopID;
@end
