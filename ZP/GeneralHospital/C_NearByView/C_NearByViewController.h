//
//  C_NearByViewController.h
//  至品购物
//
//  Created by 夏科杰 on 14-9-6.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C_NearByViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *BtnArray;
    UITableView    *TableView;
    NSMutableArray *ListArray;
    long           SelectIndex;
    long           PageIndex;
    
}
@end
