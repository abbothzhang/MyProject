
//
//  B_LimitDealCell.m
//  zhipin
//
//  Created by 佳李 on 15/7/8.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_LimitDealCell.h"

@implementation B_LimitDealCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 120);
        
        self.proImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 96, 96)];
        self.proImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.proImageView];
        
        
        self.proContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.proImageView.frame.origin.x+self.proImageView.frame.size.width+ 20, self.proImageView.frame.origin.y, self.proImageView.frame.size.width+40, self.frame.size.height/2-10)];
        self.proContentLabel.backgroundColor = [UIColor clearColor];
        self.proContentLabel.numberOfLines = 2;
        self.proContentLabel.text = @"蓝月亮亮白洗衣液4kg手洗专用2kg旅行装";
        self.proContentLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.proContentLabel];
        
        self.curPrise = [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, self.proContentLabel.frame.size.width/2, 20)];
        self.curPrise.textColor = [UIColor redColor];
        self.curPrise.text = @"￥99.0";
        self.curPrise.font = [UIFont systemFontOfSize:18];
        
        [self.contentView addSubview:self.curPrise];
        
        self.oldPrise= [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x+self.curPrise.frame.size.width+10, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, self.proContentLabel.frame.size.width/2, 20)];
        self.oldPrise.textColor = [UIColor grayColor];
        self.oldPrise.text = @"￥120.0";
        self.oldPrise.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.oldPrise];
        self.linePrse = [[UIView alloc]initWithFrame:CGRectMake(self.oldPrise.frame.origin.x, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height/2, self.oldPrise.frame.size.width, 0.5)];
        self.linePrse.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.linePrse];
        
        self.comment = [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x - 5, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10, 40, 20)];
        self.comment.textColor = [UIColor grayColor];
        self.comment.text = @"距开始";
        self.comment.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.comment];
        
        
        self.hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x+ 35, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10 , 15, 20   )];
        self.hourLabel.textColor = UIColorFromRGB(0x6ad3d3);
        self.hourLabel.text = @"00";
        self.hourLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.hourLabel];
        
        UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 10, 20   )];
        labelOne.center = CGPointMake(self.proContentLabel.frame.origin.x + 57.5,  self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10  + 10);
        labelOne.textColor = UIColorFromRGB(0x6ad3d3);
        labelOne.text = @":";
        labelOne.font = [UIFont systemFontOfSize:12];
        labelOne.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: labelOne];
        
        self.minLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x + 65, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10 , 15, 20   )];
        self.minLabel.textColor = UIColorFromRGB(0x6ad3d3);
        self.minLabel.text = @"00";
        self.minLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.minLabel];
        
        UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 10, 20   )];
        labelTwo.center = CGPointMake(self.proContentLabel.frame.origin.x + 87.5,  self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10  + 10);
        labelTwo.textColor = UIColorFromRGB(0x6ad3d3);
        labelTwo.text = @":";
        labelTwo.font = [UIFont systemFontOfSize:12];
        labelTwo.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: labelTwo];
        
        
        self.secLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x +95, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10 , 15, 20   )];
        self.secLabel.textColor = UIColorFromRGB(0x6ad3d3);
        self.secLabel.text = @"00";
        self.secLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.secLabel];
        
        
        self.linebottom= [[UIView alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x, self.frame.size.height-1, self.frame.size.width - self.proImageView.frame.size.width, .5)];
        self.linebottom.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.linebottom];
  
        self.dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.dealButton.backgroundColor = [UIColor grayColor];
        self.dealButton.frame = CGRectMake(self.frame.size.width - 75, self.curPrise.frame.origin.y + self.curPrise.frame.size.height, 65, 33);
        self.dealButton.layer.masksToBounds = YES;
        self.dealButton.layer.cornerRadius = 5;
        self.dealButton.backgroundColor = [UIColor blueColor];
        [self.dealButton setTitle:@"去抢购" forState:UIControlStateNormal];
        [self.dealButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.dealButton setBackgroundColor:ZPSystemColor];
        [self.contentView addSubview:self.dealButton];
        
        
        
    }
    return self;
    
}

- (void)showInfo:(NSDictionary *)info
{
    NSLog(@"INFO    %@",info);
    NSString *imageUrl = [info objectForKey:@"imageUrl"];
    [self.proImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
 
    NSString *curPirce =[NSString stringWithFormat:@"￥%.2f", [info [@"price"] doubleValue]];
    CGSize sCurPrice = [curPirce boundingRectWithSize:CGSizeMake(MAXFLOAT, 18)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 18]}  context:nil].size;
    self.curPrise.frame = CGRectMake(self.proContentLabel.frame.origin.x, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, sCurPrice.width, 20);
    
    
    
    NSString *oldPrice =[NSString stringWithFormat:@"￥%.2f", [info [@"orginalPrice"] doubleValue]];
    NSLog(@"OLDPRICE    %@",oldPrice);
    CGSize sOldPrice = [oldPrice boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)  options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 12]}  context:nil].size;
    self.oldPrise.font = [UIFont systemFontOfSize:12];
    self.oldPrise.frame = CGRectMake(self.curPrise.frame.origin.x + sCurPrice.width + 15, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, sOldPrice.width , 20);
    self.linePrse.frame = CGRectMake(self.oldPrise.frame.origin.x - 2, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height/2, sOldPrice.width  + 4, 0.5);
    

    if ([[info objectForKey:@"isStarted"] integerValue] == 0) {
        self.comment.text = @"距开始";
    } else {
        self.comment.text = @"剩余";
    }
    
    self.proContentLabel.text = [info objectForKey:@"productName"];
    self.curPrise.text = [NSString stringWithFormat:@"￥%.2f",[[info objectForKey:@"price"] floatValue]];
    self.oldPrise.text = oldPrice;
    
    self.dealButton.tag = [[info objectForKey:@"productId"] integerValue];
    [self.dealButton addTarget:self action:@selector(toShop:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)refreshTimeWithTime: (NSString *)time
{
//    NSInteger leftTime = [time integerValue];
//    NSInteger hour = leftTime / 3600;
//    NSInteger min = (leftTime - hour * 3600) / 60;
//    NSInteger sec = leftTime - hour * 3600 - min * 60 ;
    
    NSInteger leftTime = [time integerValue]/1000;
    NSInteger hour = leftTime / 3600;
    NSInteger min = (leftTime/ 60)%60;
    NSInteger sec = leftTime%60 ;
    
    
    self.hourLabel.text = [NSString stringWithFormat:@"%.2ld", (long)hour];
    self.minLabel.text = [NSString stringWithFormat:@"%.2d", (int)min];
    self.secLabel.text = [NSString stringWithFormat:@"%.2d", (int)sec];
    
    [countTimer invalidate];
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(minusSecond:) userInfo:nil repeats:YES];
    
    
    
}



- (void)minusSecond: (NSTimer *)timer
{
    
    int second = [_secLabel.text intValue];
    int minute = [_minLabel.text intValue];
    int hour = [_hourLabel.text intValue];
    
    if (hour == 0) {
        if (minute == 0) {
            if (second == 0) {
                countTimer = nil;
                [countTimer invalidate   ];
            }else{
                second--;
            }
        }else{
            
            if (second == 0) {
                minute--;
                second = 60;
                second--;
            }else{
                second--;
            }
        }
    }else{
        if (minute == 0) {
            if (second == 0) {
                hour--;
                minute = 59;
                second = 60;
                second--;
            }else{
                if (second < 0) {
                    second = 60;
                }
                second--;
            }
        }else{
            if (second == 0) {
                second = 60;
                minute--;
                second--;
            }else{
                
                second--;
            }
        }
    }
    
    
    _secLabel.text = [NSString stringWithFormat:@"%.2d", second];
    _minLabel.text = [NSString stringWithFormat:@"%.2d", minute];
    _hourLabel.text = [NSString stringWithFormat:@"%.2d", hour];
    
}


- (void)toShop:(UIButton *)sender
{
    NSInteger productID = sender.tag;
    [self.delegate pushToDetailWithItemID:productID andName:self.proContentLabel.text];
}

@end


#pragma mark cell1
@implementation B_LimitDealCell1


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 120);
        
        self.proImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 96, 96)];
        self.proImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.proImageView];
        
        
        self.proContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.proImageView.frame.origin.x+self.proImageView.frame.size.width+ 20, self.proImageView.frame.origin.y, self.proImageView.frame.size.width+40, self.frame.size.height/2-10)];
        self.proContentLabel.backgroundColor = [UIColor clearColor];
        self.proContentLabel.numberOfLines = 2;
        self.proContentLabel.text = @"蓝月亮亮白洗衣液4kg手洗专用2kg旅行装";
        self.proContentLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.proContentLabel];
        
        self.curPrise = [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, self.proContentLabel.frame.size.width/2, 20)];
        self.curPrise.textColor = [UIColor redColor];
        self.curPrise.text = @"￥99.0";
        self.curPrise.font = [UIFont systemFontOfSize:18];
        
        [self.contentView addSubview:self.curPrise];
        
        self.oldPrise= [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x+self.curPrise.frame.size.width+10, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, self.proContentLabel.frame.size.width/2, 20)];
        self.oldPrise.textColor = [UIColor grayColor];
        self.oldPrise.text = @"￥120.0";
        self.oldPrise.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.oldPrise];
        self.linePrse = [[UIView alloc]initWithFrame:CGRectMake(self.oldPrise.frame.origin.x, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height/2, self.oldPrise.frame.size.width, 0.5)];
        self.linePrse.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.linePrse];
        
        self.comment = [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10, 40, 20)];
        self.comment.textColor = [UIColor grayColor];
        self.comment.text = @"距开始";
        self.comment.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.comment];
        
        
        
        self.hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+ self.proContentLabel.frame.origin.x+ 35, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10 , 15, 20   )];
        self.hourLabel.textColor = UIColorFromRGB(0x6ad3d3);
        self.hourLabel.text = @"00";
        self.hourLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.hourLabel];
        
        UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 10, 20   )];
        labelOne.center = CGPointMake(10 + self.proContentLabel.frame.origin.x + 57.5,  self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10  + 10);
        labelOne.textColor = UIColorFromRGB(0x6ad3d3);
        labelOne.text = @":";
        labelOne.font = [UIFont systemFontOfSize:12];
        labelOne.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: labelOne];
        
        self.minLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + self.proContentLabel.frame.origin.x + 65, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10 , 15, 20   )];
        self.minLabel.textColor = UIColorFromRGB(0x6ad3d3);
        self.minLabel.text = @"00";
        self.minLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.minLabel];
        
        UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 10, 20   )];
        labelTwo.center = CGPointMake(10 + self.proContentLabel.frame.origin.x + 87.5,  self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10  + 10);
        labelTwo.textColor = UIColorFromRGB(0x6ad3d3);
        labelTwo.text = @":";
        labelTwo.font = [UIFont systemFontOfSize:12];
        labelTwo.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: labelTwo];
        
        
        self.secLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + self.proContentLabel.frame.origin.x +95, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height + 10 , 15, 20   )];
        self.secLabel.textColor = UIColorFromRGB(0x6ad3d3);
        self.secLabel.text = @"00";
        self.secLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.secLabel];
        
        
        self.linebottom= [[UIView alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x, self.frame.size.height-1, self.frame.size.width - self.proImageView.frame.size.width, .5)];
        self.linebottom.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.linebottom];
        
        self.dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.dealButton.backgroundColor = [UIColor grayColor];
        self.dealButton.frame = CGRectMake(self.frame.size.width - 75, self.curPrise.frame.origin.y + self.curPrise.frame.size.height, 65, 33);
        self.dealButton.layer.masksToBounds = YES;
        self.dealButton.layer.cornerRadius = 5;
        self.dealButton.backgroundColor = [UIColor blueColor];
        [self.dealButton setTitle:@"去抢购" forState:UIControlStateNormal];
        [self.dealButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.dealButton setBackgroundColor:ZPSystemColor];
        //[self.contentView addSubview:self.dealButton];
        
        
        
    }
    return self;
    
}

- (void)showInfo:(NSDictionary *)info
{
    NSLog(@"INFO    %@",info);
    NSString *imageUrl = [info objectForKey:@"imageUrl"];
    [self.proImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    
    NSString *curPirce =[NSString stringWithFormat:@"￥%.2f", [info [@"price"] doubleValue]];
    CGSize sCurPrice = [curPirce boundingRectWithSize:CGSizeMake(MAXFLOAT, 18)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 18]}  context:nil].size;
    self.curPrise.frame = CGRectMake(self.proContentLabel.frame.origin.x, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, sCurPrice.width, 20);
    
    
    NSLog(@"%@", [info objectForKey:@"isStarted"]);
    
    if ([[info objectForKey:@"isStarted"] integerValue] == 0) {
        self.comment.text = @"距开始";
    } else {
        self.comment.text = @"剩余";
    }
    
    NSString *oldPrice =[NSString stringWithFormat:@"￥%.2f", [info [@"orginalPrice"] doubleValue]];
    NSLog(@"OLDPRICE    %@",oldPrice);
    CGSize sOldPrice = [oldPrice boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)  options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 12]}  context:nil].size;
    self.oldPrise.font = [UIFont systemFontOfSize:12];
    self.oldPrise.frame = CGRectMake(self.curPrise.frame.origin.x + sCurPrice.width + 15, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, sOldPrice.width , 20);
    self.linePrse.frame = CGRectMake(self.oldPrise.frame.origin.x - 2, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height/2, sOldPrice.width  + 4, 0.5);
    
    
    
    
    self.proContentLabel.text = [info objectForKey:@"productName"];
    self.curPrise.text = [NSString stringWithFormat:@"￥%.2f",[[info objectForKey:@"price"] floatValue]];
    self.oldPrise.text = oldPrice;
    
    self.dealButton.tag = [[info objectForKey:@"productId"] integerValue];
    [self.dealButton addTarget:self action:@selector(toShop:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)refreshTimeWithTime: (NSString *)time
{
    //    NSInteger leftTime = [time integerValue];
    //    NSInteger hour = leftTime / 3600;
    //    NSInteger min = (leftTime - hour * 3600) / 60;
    //    NSInteger sec = leftTime - hour * 3600 - min * 60 ;
    
    NSInteger leftTime = [time integerValue]/1000;
    NSInteger hour = leftTime / 3600;
    NSInteger min = (leftTime/ 60)%60;
    NSInteger sec = leftTime%60 ;
    
    
    self.hourLabel.text = [NSString stringWithFormat:@"%.2ld", (long)hour];
    self.minLabel.text = [NSString stringWithFormat:@"%.2d", (int)min];
    self.secLabel.text = [NSString stringWithFormat:@"%.2d", (int)sec];
    
    [countTimer invalidate];
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(minusSecond:) userInfo:nil repeats:YES];
    
    
    
}



- (void)minusSecond: (NSTimer *)timer
{
    
    int second = [_secLabel.text intValue];
    int minute = [_minLabel.text intValue];
    int hour = [_hourLabel.text intValue];
    
    if (hour == 0) {
        if (minute == 0) {
            if (second == 0) {
                countTimer = nil;
                [countTimer invalidate   ];
            }else{
                second--;
            }
        }else{
            
            if (second == 0) {
                minute--;
                second = 60;
                second--;
            }else{
                second--;
            }
        }
    }else{
        if (minute == 0) {
            if (second == 0) {
                hour--;
                minute = 59;
                second = 60;
                second--;
            }else{
                if (second < 0) {
                    second = 60;
                }
                second--;
            }
        }else{
            if (second == 0) {
                second = 60;
                minute--;
                second--;
            }else{
                
                second--;
            }
        }
    }
    
    
    _secLabel.text = [NSString stringWithFormat:@"%.2d", second];
    _minLabel.text = [NSString stringWithFormat:@"%.2d", minute];
    _hourLabel.text = [NSString stringWithFormat:@"%.2d", hour];
    
}


- (void)toShop:(UIButton *)sender
{
    NSInteger productID = sender.tag;
    [self.delegate pushToDetailWithItemID:productID andName:self.proContentLabel.text];
}

@end
