//
//  B_ShopIntroduceViewController.m
//  zhipin
//
//  Created by kjx on 15/3/8.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_ShopIntroduceViewController.h"

@interface B_ShopIntroduceViewController ()

@end

@implementation B_ShopIntroduceViewController
@synthesize DetailDict;

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}
- (void)viewDidLoad {
    self.title=@"店铺简介";
    
    ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    ScrollView.delegate=self;
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    ScrollView.contentSize=CGSizeMake(0, 680);
    [self.view addSubview:ScrollView];
    int h=10;
    
    UIView *upView=[[UIView alloc] initWithFrame:CGRectMake(5, h, SCREEN_WIDTH-10, 234)];
    upView.backgroundColor=[UIColor whiteColor];
    [ScrollView addSubview:upView];
    
    UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, h+1,150, 20)];
    nameLabel.text=@"商铺介绍";
    nameLabel.textColor=UIColorFromRGB(0x999999);
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.font=[UIFont systemFontOfSize:14];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:nameLabel];
    h+=20;
    
    float height=[self heightForString:[[DetailDict objectForKey:@"data"] objectForKey:@"desc"]
                              fontSize:13
                              andWidth:SCREEN_WIDTH-50]+6;
    
    UILabel* contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, h,SCREEN_WIDTH-50, height)];
    contentLabel.text=[[DetailDict objectForKey:@"data"] objectForKey:@"desc"];
    contentLabel.textColor=UIColorFromRGB(0x333333);
    contentLabel.numberOfLines=1000;
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.font=[UIFont systemFontOfSize:13];
    contentLabel.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:contentLabel];
     h+=height;
    
    UIView *lineImage = [[UIView alloc] initWithFrame:CGRectMake(5,h, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [ScrollView addSubview:lineImage];
    
    UILabel* nameLabel1=[[UILabel alloc] initWithFrame:CGRectMake(10, h,150, 35)];
    nameLabel1.text=@"经营范围";
    nameLabel1.textColor=UIColorFromRGB(0x999999);
    nameLabel1.backgroundColor=[UIColor clearColor];
    nameLabel1.font=[UIFont systemFontOfSize:14];
    nameLabel1.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:nameLabel1];
    
    UILabel* contentLabel1=[[UILabel alloc] initWithFrame:CGRectMake(80, h,SCREEN_WIDTH-50, 35)];
    contentLabel1.text=[[DetailDict objectForKey:@"data"] objectForKey:@"type"];
    contentLabel1.textColor=UIColorFromRGB(0x333333);
    contentLabel1.numberOfLines=1;
    contentLabel1.backgroundColor=[UIColor clearColor];
    contentLabel1.font=[UIFont systemFontOfSize:13];
    contentLabel1.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:contentLabel1];
    
    h+=35;
    
    UIView *lineImage1 = [[UIView alloc] initWithFrame:CGRectMake(5,h, SCREEN_WIDTH-10, 0.5)];
    lineImage1.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [ScrollView addSubview:lineImage1];
    
    UILabel* nameLabel2=[[UILabel alloc] initWithFrame:CGRectMake(10, h,150, 35)];
    nameLabel2.text=@"联系方式";
    nameLabel2.textColor=UIColorFromRGB(0x999999);
    nameLabel2.backgroundColor=[UIColor clearColor];
    nameLabel2.font=[UIFont systemFontOfSize:14];
    nameLabel2.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:nameLabel2];
    
    UILabel* contentLabel2=[[UILabel alloc] initWithFrame:CGRectMake(80, h,SCREEN_WIDTH-50, 35)];
    contentLabel2.text=[[DetailDict objectForKey:@"data"] objectForKey:@"telephone"];
    contentLabel2.textColor=UIColorFromRGB(0x333333);
    contentLabel2.numberOfLines=1;
    contentLabel2.backgroundColor=[UIColor clearColor];
    contentLabel2.font=[UIFont systemFontOfSize:13];
    contentLabel2.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:contentLabel2];
    
     h+=35;
    
    UIView *lineImage2 = [[UIView alloc] initWithFrame:CGRectMake(5,h, SCREEN_WIDTH-10, 0.5)];
    lineImage2.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [ScrollView addSubview:lineImage2];
    
    
    UILabel* nameLabel3=[[UILabel alloc] initWithFrame:CGRectMake(10, h,150, 35)];
    nameLabel3.text=@"营业时间";
    nameLabel3.textColor=UIColorFromRGB(0x999999);
    nameLabel3.backgroundColor=[UIColor clearColor];
    nameLabel3.font=[UIFont systemFontOfSize:14];
    nameLabel3.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:nameLabel3];
    
    UILabel* contentLabel3=[[UILabel alloc] initWithFrame:CGRectMake(80, h,SCREEN_WIDTH-50, 35)];
    contentLabel3.text=[[DetailDict objectForKey:@"data"] objectForKey:@"businessTime"];
    contentLabel3.textColor=UIColorFromRGB(0x333333);
    contentLabel3.numberOfLines=1;
    contentLabel3.backgroundColor=[UIColor clearColor];
    contentLabel3.font=[UIFont systemFontOfSize:13];
    contentLabel3.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:contentLabel3];
    
     h+=35;
    
    UIView *lineImage3 = [[UIView alloc] initWithFrame:CGRectMake(5,h, SCREEN_WIDTH-10, 0.5)];
    lineImage3.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [ScrollView addSubview:lineImage3];
    
    UILabel* nameLabel4=[[UILabel alloc] initWithFrame:CGRectMake(10, h,150, 35)];
    nameLabel4.text=@"地址";
    nameLabel4.textColor=UIColorFromRGB(0x999999);
    nameLabel4.backgroundColor=[UIColor clearColor];
    nameLabel4.font=[UIFont systemFontOfSize:14];
    nameLabel4.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:nameLabel4];
    
    UILabel* contentLabel4=[[UILabel alloc] initWithFrame:CGRectMake(80, h,SCREEN_WIDTH-100, 35)];
    contentLabel4.text=[[DetailDict objectForKey:@"data"] objectForKey:@"address"];
    contentLabel4.textColor=UIColorFromRGB(0x333333);
    contentLabel4.numberOfLines=2;
    contentLabel4.backgroundColor=[UIColor clearColor];
    contentLabel4.font=[UIFont systemFontOfSize:13];
    contentLabel4.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:contentLabel4];
    
    

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
