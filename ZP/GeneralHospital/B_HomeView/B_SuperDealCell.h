//
//  B_SuperDealCell.h
//  zhipin
//
//  Created by 佳李 on 15/7/12.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_SuperDealCell : UITableViewCell
@property (nonatomic, strong)UIImageView *proImageView;
@property (nonatomic,strong)UILabel *proContentLabel;
@property (nonatomic, strong)UILabel *curPrise;
@property (nonatomic, strong)UILabel *oldPrise;
@property (nonatomic, strong)UIView *linePrse;
@property (nonatomic, strong)UILabel *comment;
@property (nonatomic, strong)UIView *linebottom;

- (void)showInfo: (NSDictionary *)info;
@end
