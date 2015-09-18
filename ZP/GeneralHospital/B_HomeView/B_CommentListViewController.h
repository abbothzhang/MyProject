//
//  B_CommentListViewController.h
//  zhipin
//
//  Created by 夏科杰 on 15/2/13.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_CommentListViewController :  UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *TableView;
    NSMutableArray *ListArray;
}
@property(nonatomic,strong)NSString *ItemId;
@end
