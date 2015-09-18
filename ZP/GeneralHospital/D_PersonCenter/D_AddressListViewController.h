//
//  D_AddressListViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/12/27.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddressDict)(NSDictionary *);
@interface D_AddressListViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *TableView;
    NSMutableArray *ListArray;
    UILabel        *TitleLabel;
    UILabel        *PriceLabel;
    AddressDict    AddDict;
}
-(void)setAddressDict:(AddressDict)addressDict;
@end
