//
//  D_ImageViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-30.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_ImageViewController.h"

@interface D_ImageViewController ()

@end

@implementation D_ImageViewController
@synthesize ImageName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image=[UIImage imageNamed:ImageName];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, image.size.height/2)];
    imageView.image=image;
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    scrollView.contentSize=CGSizeMake(0, image.size.height/2);
    [self.view addSubview:scrollView];
    [scrollView addSubview:imageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
