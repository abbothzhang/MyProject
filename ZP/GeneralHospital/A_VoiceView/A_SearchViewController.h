//
//  A_SearchViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-30.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SearchBlock)(NSDictionary*);
@interface A_SearchViewController : UITableViewController
{
    NSMutableArray  *ListArray;
    SearchBlock     SBlock;
}

-(void)SearchOrder:(NSString *)keyWord;
-(void)setBlock:(SearchBlock)sBlock;
@end
