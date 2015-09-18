//
//  B_AppointViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/4.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_AppointViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl  *SegmentedControl;
    UITableView         *TableView;
    NSMutableArray      *ListArray;
    BOOL                IsBringLeft;
    UIView              *CellMoveView;
    
}


@end
