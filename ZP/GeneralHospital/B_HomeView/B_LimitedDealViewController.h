//
//  B_LimitedDealViewController.h
//  zhipin
//
//  Created by 佳李 on 15/7/8.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_LimitedDealViewController : UIViewController{
    UILabel *lableView;
}
@property (nonatomic, strong) NSMutableArray *productListArray;
@property (nonatomic, copy) NSString *countDownTime;
@property (nonatomic, assign)NSInteger promotionId;
@property (nonatomic, assign)NSInteger currentPromotionId;
@property (nonatomic, assign)NSInteger nextPromotionId;
@end
