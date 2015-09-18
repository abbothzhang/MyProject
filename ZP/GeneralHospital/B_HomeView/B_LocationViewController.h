//
//  B_LocationViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/29.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^LocationBlock)(NSString *);
@interface B_LocationViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    UITableView               *TableView;
    NSMutableArray            *ListArray;
    LocationBlock             LocationB;
    NSMutableDictionary       *CityDict;
 }

@property(nonatomic,assign)CLLocationCoordinate2D Location;
@property (nonatomic, copy) NSString *cityName;
-(void)setLocationBlock:(LocationBlock)locationBlock;
@end
