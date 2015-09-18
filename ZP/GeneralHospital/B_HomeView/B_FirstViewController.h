//
//  B_FirstViewController.h
//  zhipin
//
//  Created by 佳李 on 15/7/1.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHead.h"
#import "B_HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface B_FirstViewController : UIViewController <UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    UISearchBar *SearchBar;
    CLLocationManager *LocationManager;
    UIButton        *leftButton;
    NSString        *LocString;
    UILabel *citylabel;
    UITableView *tbView;
}

@property (nonatomic, copy) NSString *LocString;
@property (nonatomic, copy) NSString *cityCode;
@end
