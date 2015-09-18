//
//  D_AboutUsViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/2/4.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "D_AboutUsViewController.h"

@interface D_AboutUsViewController ()

@end

@implementation D_AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"关于至品";
    
    UIImageView *upImage=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-124.5)/2, 60, 124.5, 52.5)];
    upImage.image=[UIImage imageNamed:@"aboutus_up.png"];
    [self.view addSubview:upImage];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    UILabel* vLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 130,SCREEN_WIDTH-20, 50)];
    vLabel.text=[NSString stringWithFormat:@"V%@",app_build];
    vLabel.textColor=UIColorFromRGB(0xd0d0d0);
    vLabel.backgroundColor=[UIColor clearColor];
    vLabel.font=[UIFont systemFontOfSize:15];
    vLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:vLabel];
    
    UIImageView *downImage=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-126.5)/2, SCREEN_HIGHE-64-80, 126.5, 26)];
    downImage.image=[UIImage imageNamed:@"aboutus_down.png"];
    [self.view addSubview:downImage];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
