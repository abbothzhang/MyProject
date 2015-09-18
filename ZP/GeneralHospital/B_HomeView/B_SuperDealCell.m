



//
//  B_SuperDealCell.m
//  zhipin
//
//  Created by 佳李 on 15/7/12.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_SuperDealCell.h"

@implementation B_SuperDealCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 100);
        
        self.proImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width/3, self.frame.size.height-20)];
        self.proImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.proImageView];
        
        
        self.proContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.proImageView.frame.origin.x+self.proImageView.frame.size.width+10, self.proImageView.frame.origin.y, SCREEN_WIDTH - self.proImageView.frame.size.width - 40, self.frame.size.height/2-10)];
        self.proContentLabel.backgroundColor = [UIColor clearColor];
        self.proContentLabel.numberOfLines = 2;
        self.proContentLabel.text = @"蓝月亮亮白洗衣液4kg手洗专用2kg旅行装";
        self.proContentLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.proContentLabel];
        
        self.curPrise = [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, self.proContentLabel.frame.size.width/2, 20)];
        self.curPrise.textColor = [UIColor redColor];
        self.curPrise.text = @"￥99.0";
        self.curPrise.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:self.curPrise];
        
        self.oldPrise= [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x+self.curPrise.frame.size.width+10, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, self.proContentLabel.frame.size.width/2, 20)];
        self.oldPrise.textColor = [UIColor grayColor];
        self.oldPrise.text = @"￥120.0";
        self.oldPrise.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.oldPrise];
        self.linePrse = [[UIView alloc]initWithFrame:CGRectMake(self.oldPrise.frame.origin.x, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height/2, self.oldPrise.frame.size.width, 0.5)];
        self.linePrse.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.linePrse];
        
        self.comment = [[UILabel alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height, self.proContentLabel.frame.size.width/2, 20)];
        self.comment.textColor = [UIColor grayColor];
        self.comment.text = @"0点评";
        self.comment.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.comment];
        
        self.linebottom= [[UIView alloc]initWithFrame:CGRectMake(self.proContentLabel.frame.origin.x, self.frame.size.height-1, self.frame.size.width - self.proImageView.frame.size.width, .5)];
        self.linebottom.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.linebottom];
        
        
        
        
        
    }
    
        return self;
}


- (void)showInfo:(NSDictionary *)info
{
    
    NSLog(@"超值好货    %@", info);
    self.proImageView.backgroundColor = [UIColor whiteColor];
    [self.proImageView sd_setImageWithURL:[NSURL URLWithString:info [@"imageurl"]]];
    self.proImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.proContentLabel.text = info [@"name"];
 
    
    NSString *curPirce =[NSString stringWithFormat:@"￥%.1f", [info [@"price"] doubleValue]];
    CGSize sCurPrice = [curPirce boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 14]}  context:nil].size;
    self.curPrise.frame = CGRectMake(self.proContentLabel.frame.origin.x, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, sCurPrice.width, 20);
    
    
    
    NSString *oldPrice =[NSString stringWithFormat:@"￥%.2f", [info [@"originalPrice"] doubleValue]];
    CGSize sOldPrice = [oldPrice boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)  options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 12]}  context:nil].size;
    
    self.oldPrise.frame = CGRectMake(self.curPrise.frame.origin.x + sCurPrice.width + 15, self.proContentLabel.frame.origin.y+self.proContentLabel.frame.size.height, sOldPrice.width, 20);
    self.linePrse.frame = CGRectMake(self.oldPrise.frame.origin.x - 2, self.oldPrise.frame.origin.y+self.oldPrise.frame.size.height/2, sOldPrice.width +4, 0.5);
    
    
    self.curPrise.text = [NSString stringWithFormat:@"￥%.1f", [info [@"price"] floatValue]];
    self.oldPrise.text = [NSString stringWithFormat:@"￥%.2f", [info [@"originalPrice"] floatValue]];
    self.comment.text = [NSString stringWithFormat:@"%ld点评", (long)[info [@"evaluteCount"] integerValue]];
}

@end
