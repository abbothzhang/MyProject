//
//  MessageCell.m
//  chatView
//
//  Created by 夏科杰 on 14-3-12.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#import "MessageFrame.h"
#import "MessageCell.h"
#import "ImageScale.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@implementation MessageCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        // Initialization code
    }
    return self;
}

- (void)setMessFrame:(MessageFrame *)MessFrame{
    _MessFrame = MessFrame;
    Id =MessFrame.Message.Image;
    self.contentView.backgroundColor=[UIColor clearColor];
    UIImage* leftImage=[[[UIImage imageNamed:@"left_chat.png"] imageScaledMiniSize:CGSizeMake(39, 35)] stretchableImageWithLeftCapWidth:14 topCapHeight:20];
    
    UIImage* rightImage=[[[UIImage imageNamed:@"right_chat.png"] imageScaledMiniSize:CGSizeMake(39, 34.5)] stretchableImageWithLeftCapWidth:26 topCapHeight:20];
    
    /************************头像*****************************/
    UIImageView *headView=[[UIImageView alloc] initWithFrame:_MessFrame.IconF];
    if (MessFrame.Message.Icon==nil){
        headView.image=[UIImage imageNamed:@"head_default.png"];
    }else if (![MessFrame.Message.Icon isEqualToString:@"120.png"]){
        
        [headView sd_setImageWithURL:[NSURL URLWithString:MessFrame.Message.Icon] placeholderImage:[UIImage imageNamed:@"head_default.png"]];

    }else{
        headView.image=[UIImage imageNamed:MessFrame.Message.Icon];
    }
    [self.contentView addSubview:headView];
    [[headView layer] setMasksToBounds:YES];
    [[headView layer] setCornerRadius:_MessFrame.IconF.size.width/2];
    [[headView layer] setBorderWidth:1];
    [[headView layer] setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    /**************************时间****************************/
    
    UILabel* timeLabel=[[UILabel alloc] initWithFrame:MessFrame.TimeF];
    timeLabel.text=MessFrame.Message.Time;
    timeLabel.font=kTimeFont;
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.hidden=NO;//MessFrame.ShowTime;
    timeLabel.backgroundColor=UIColorFromRGBA(0xcccccc, 0.5);
    [self.contentView addSubview:timeLabel];
    [[timeLabel layer] setMasksToBounds:YES];
    [[timeLabel layer] setCornerRadius:5];
 
    UILabel* senderName=[[UILabel alloc] initWithFrame:MessFrame.SenderF];
    senderName.text=MessFrame.Message.Sender;
    senderName.font=kTimeFont;
    senderName.textAlignment=_MessFrame.Message.PType==PersonTypeMe?NSTextAlignmentRight:NSTextAlignmentLeft;
    senderName.backgroundColor=[UIColor clearColor];
    senderName.hidden=NO;//MessFrame.ShowTime;
    [self.contentView addSubview:senderName];
    /**************************内容*****************************/
    //NSLog(@"ContentF=%@----%@", [NSValue valueWithCGRect:MessFrame.ContentF],MessFrame.Message.Content);
    switch (_MessFrame.Message.MType) {
        case MessageTypeText:
        {
            //NSLog(@"ContentF=%@----%@", [NSValue valueWithCGRect:MessFrame.ContentF],MessFrame.Message.Content);
            
            switch (_MessFrame.Message.PType) {
                case PersonTypeMe:
                {
                    UIButton* contentButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    contentButton.frame=MessFrame.ContentF;
                    [contentButton.titleLabel setFont:kContentFont];
                    contentButton.titleLabel.numberOfLines=100;
                    [contentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    contentButton.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
                    [contentButton setTitle:MessFrame.Message.Content forState:UIControlStateNormal];
                    [contentButton setBackgroundImage:rightImage forState:UIControlStateNormal];
                    [self.contentView addSubview:contentButton];
                }
                    break;
                case PersonTypeOther:
                {
                    UIButton* contentButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    contentButton.frame=MessFrame.ContentF;
                    contentButton.titleLabel.numberOfLines=100;
                    [contentButton.titleLabel setFont:kContentFont];
                    [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    contentButton.contentEdgeInsets = UIEdgeInsetsMake( kContentTop, kContentLeft, kContentBottom, kContentRight);
                    [contentButton setTitle:MessFrame.Message.Content forState:UIControlStateNormal];
                    [contentButton setBackgroundImage:leftImage forState:UIControlStateNormal];
                    [self.contentView addSubview:contentButton];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case MessageTypeImage:
        {
             NSLog(@"++++++%@",MessFrame.Message.Image);
            switch (_MessFrame.Message.PType) {
                case PersonTypeMe:
                {
                    UIButton* contentButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    contentButton.frame=MessFrame.ContentF;
                    [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    contentButton.contentEdgeInsets = UIEdgeInsetsMake(kImageTop, kImageRight, kImageBottom,kImageLeft);
                    
                    [contentButton sd_setBackgroundImageWithURL:[NSURL URLWithString:MessFrame.Message.Image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Im_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        CellImage=image;
                    }];
                    
                    [contentButton setBackgroundImage:rightImage forState:UIControlStateNormal];
                    [contentButton addTarget:self action:@selector(ImageAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.contentView addSubview:contentButton];
                    [[contentButton.imageView layer] setMasksToBounds:YES];
                    [[contentButton.imageView layer] setCornerRadius:2];
                    [[contentButton.imageView layer]setBorderWidth:1];
                    [[contentButton.imageView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                }
                    break;
                case PersonTypeOther:
                {
                    UIButton* contentButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    contentButton.frame=MessFrame.ContentF;
                    [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    contentButton.contentEdgeInsets = UIEdgeInsetsMake( kImageTop, kImageLeft, kImageBottom, kImageRight);
                    [contentButton sd_setBackgroundImageWithURL:[NSURL URLWithString:MessFrame.Message.Image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Im_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        CellImage=image;
                    }];
                    
                    [contentButton addTarget:self action:@selector(ImageAction:) forControlEvents:UIControlEventTouchUpInside];
                    [contentButton setBackgroundImage:leftImage forState:UIControlStateNormal];
                    [self.contentView addSubview:contentButton];
                    [[contentButton.imageView layer] setMasksToBounds:YES];
                    [[contentButton.imageView layer] setCornerRadius:5];
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        case MessageTypeCheck:
        {
            switch (_MessFrame.Message.PType) {
                case PersonTypeMe:
                {
                    
                }
                    break;
                case PersonTypeOther:
                {
                    UIButton* contentButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    contentButton.frame=MessFrame.ContentF;
                    [contentButton setTitle:MessFrame.Message.Content forState:UIControlStateNormal];
                    [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    contentButton.titleEdgeInsets = UIEdgeInsetsMake( kCRTop, kCRRight, kCRBottom, kCRLeft);
                    contentButton.contentEdgeInsets = UIEdgeInsetsMake( kCRTop, kCRLeft, kCRBottom, kCRRight);
                    [contentButton setImage:[UIImage imageNamed:@"check_logo_image.png"] forState:UIControlStateNormal];
                    [contentButton setBackgroundImage:leftImage forState:UIControlStateNormal];
                    [contentButton addTarget:self action:@selector(CheckAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.contentView addSubview:contentButton];
                    UILabel* Title=[[UILabel alloc] initWithFrame:CGRectMake(75, 2, MessFrame.ContentF.size.width-80, MessFrame.ContentF.size.height)];
                    Title.text=MessFrame.Message.Content;
                    Title.numberOfLines=3;
                    Title.font=[UIFont systemFontOfSize:14];
                    Title.backgroundColor=[UIColor clearColor];
                    [contentButton addSubview:Title];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case MessageTypeReport:
        {
            switch (_MessFrame.Message.PType) {
                case PersonTypeMe:
                {

                    
                }
                    break;
                case PersonTypeOther:
                {
                    UIButton* contentButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    contentButton.frame=MessFrame.ContentF;
                    [contentButton setTitle:MessFrame.Message.Content forState:UIControlStateNormal];
                    [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    contentButton.titleEdgeInsets = UIEdgeInsetsMake( kCRTop, kCRRight, kCRBottom, kCRLeft);
                    contentButton.contentEdgeInsets = UIEdgeInsetsMake( kCRTop, kCRLeft, kCRBottom, kCRRight);
                    [contentButton setImage:[UIImage imageNamed:@"report_logo_image.png"] forState:UIControlStateNormal];
                    [contentButton setBackgroundImage:leftImage forState:UIControlStateNormal];
                    [contentButton addTarget:self action:@selector(ReportAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.contentView addSubview:contentButton];
                    UILabel* Title=[[UILabel alloc] initWithFrame:CGRectMake(75, 2, MessFrame.ContentF.size.width-80, MessFrame.ContentF.size.height)];
                    Title.text=MessFrame.Message.Content;
                    Title.numberOfLines=3;
                    Title.font=[UIFont systemFontOfSize:14];
                    Title.backgroundColor=[UIColor clearColor];
                    [contentButton addSubview:Title];
                }
                    break;
                default:
                    break;
            }
        }
            break;
 
        case MessageTypeDocument:
        {
            
        }
            break;
        case MessageTypeSound:
        {
            
        }
            break;
        case MessageTypeWeb:
        {
            
        }
            break;
        case MessageTypeScore:
        {
            headView.image=[UIImage imageNamed:@"grading_chat.png"];
            UIButton* contentButton=[UIButton buttonWithType:UIButtonTypeCustom];
            contentButton.frame=MessFrame.ContentF;
            contentButton.titleLabel.numberOfLines=100;
            [contentButton.titleLabel setFont:kContentFont];
            [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            contentButton.contentEdgeInsets = UIEdgeInsetsMake( kContentTop, kContentLeft, kContentBottom, kContentRight);
           // [contentButton setTitle:MessFrame.Message.Content forState:UIControlStateNormal];
            [contentButton setBackgroundImage:leftImage forState:UIControlStateNormal];
            [self.contentView addSubview:contentButton];
            

            float value = [MessFrame.Message.Content floatValue];
            for(int j=0;j<5;j++){
                UIImageView *imageStar = [[UIImageView alloc] initWithFrame:CGRectMake(18+26*j, 10, 20, 20)];
                if(j<(int)value){
                    imageStar.image = [UIImage imageNamed:@"online_star.png"];
                }else if(j==(int)value && (int)value < value){
                    imageStar.image = [UIImage imageNamed:@"online_star_part.png"];
                }else{
                    imageStar.image = [UIImage imageNamed:@"online_star_none.png"];
                }
                [contentButton addSubview:imageStar];
            }
        }
            break;
        case MessageTypeComment:
        {
            headView.image=[UIImage imageNamed:@"evaluation_chat.png"];
            UIButton* contentButton=[UIButton buttonWithType:UIButtonTypeCustom];
            contentButton.frame=MessFrame.ContentF;
            contentButton.titleLabel.numberOfLines=100;
            [contentButton.titleLabel setFont:kContentFont];
            [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            contentButton.contentEdgeInsets = UIEdgeInsetsMake( kContentTop, kContentLeft, kContentBottom, kContentRight);
            [contentButton setTitle:MessFrame.Message.Content forState:UIControlStateNormal];
            [contentButton setBackgroundImage:leftImage forState:UIControlStateNormal];
            [self.contentView addSubview:contentButton];
        }
            break;
        case MessageTypeOther:
        {
            
        }
            break;
            
        default:
            break;
    }
    self.contentView.backgroundColor=[UIColor clearColor];
    /*********************************************************/
    

}

-(void)ImageAction:(UIButton* )sender
{

 
}

-(void)CheckAction:(UIButton* )sender
{
    NSLog(@"Check id=====%@",Id);
    [delegate selectType:TestType Id:Id];
}

-(void)ReportAction:(UIButton* )sender
{
    [delegate selectType:CheckType Id:Id];
     NSLog(@"Report id=====%@",Id);
}


- (void)awakeFromNib
{
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
