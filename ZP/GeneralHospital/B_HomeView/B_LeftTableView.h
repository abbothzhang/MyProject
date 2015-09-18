//
//  LeftTableView.h
//  至品购物
//
//  Created by 夏科杰 on 14-9-7.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WWW 150
typedef void(^ClickBlock)(NSString *);
@interface B_LeftTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    ClickBlock  CBlock;
}
@property(nonatomic,strong)NSArray *ListArray;
@property(nonatomic,assign)BOOL    IsHid;
-(void)SetClickBlock:(ClickBlock)clickBlock;
@end
