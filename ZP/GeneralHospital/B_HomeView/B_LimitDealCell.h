//
//  B_LimitDealCell.h
//  zhipin
//
//  Created by 佳李 on 15/7/8.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LimitDealCellDelegate <NSObject>

- (void)pushToDetailWithItemID: (NSInteger)itemid andName: (NSString *)name;

@end
@interface B_LimitDealCell : UITableViewCell

{
    NSTimer *countTimer;
}
@property (nonatomic, strong)id <LimitDealCellDelegate>delegate;
@property (nonatomic, strong)UIImageView *proImageView;
@property (nonatomic,strong)UILabel *proContentLabel;
@property (nonatomic, strong)UILabel *curPrise;
@property (nonatomic, strong)UILabel *oldPrise;
@property (nonatomic, strong)UIView *linePrse;
@property (nonatomic, strong)UILabel *comment;
@property (nonatomic, strong)UIView *linebottom;
@property (nonatomic, strong) UIButton *dealButton;

@property (nonatomic, strong) NSDictionary *dictData;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *secLabel;

- (void)showInfo: (NSDictionary *)info;
- (void)refreshTimeWithTime: (NSString *)time;

@end

@interface B_LimitDealCell1 : UITableViewCell

{
    NSTimer *countTimer;
}
@property (nonatomic, strong)id <LimitDealCellDelegate>delegate;
@property (nonatomic, strong)UIImageView *proImageView;
@property (nonatomic,strong)UILabel *proContentLabel;
@property (nonatomic, strong)UILabel *curPrise;
@property (nonatomic, strong)UILabel *oldPrise;
@property (nonatomic, strong)UIView *linePrse;
@property (nonatomic, strong)UILabel *comment;
@property (nonatomic, strong)UIView *linebottom;
@property (nonatomic, strong) UIButton *dealButton;

@property (nonatomic, strong) NSDictionary *dictData;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *secLabel;

- (void)showInfo: (NSDictionary *)info;
- (void)refreshTimeWithTime: (NSString *)time;

@end
