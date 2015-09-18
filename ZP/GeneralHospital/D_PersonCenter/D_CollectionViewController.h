//
//  D_CollectionViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/24.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D_CollectionViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *BtnArray;
    UITableView    *TableView;
    NSMutableArray *ListArray;
    BOOL           IsLine;
    UILabel        *NumLabel;
    UISegmentedControl *SegmentedControl;
}
@end
