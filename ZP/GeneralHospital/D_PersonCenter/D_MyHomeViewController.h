//
//  D_MyHomeViewController.h
//  zhipin
//
//  Created by kjx on 15/3/31.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D_MyHomeViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView         *TableView;
    NSMutableArray      *ListArray;
    NSDictionary        *DetailDict;
    UIImageView         *HeadImage;
}
@end
