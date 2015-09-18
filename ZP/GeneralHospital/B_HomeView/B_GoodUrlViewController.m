//
//  B_GoodUrlViewController.m
//  zhipin
//
//  Created by 夏科杰 on 15/2/13.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_GoodUrlViewController.h"

@interface B_GoodUrlViewController ()

@end

@implementation B_GoodUrlViewController
@synthesize HtmlString;
- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *WebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    WebView.backgroundColor=[UIColor whiteColor];
     WebView.scalesPageToFit = TRUE;
    [self.view addSubview:WebView];
//    for (UIView *subView in [WebView subviews]) {
//        if ([subView isKindOfClass:[UIScrollView class]]) {
//            for (UIView *shadowView in [subView subviews]) {
//                if ([shadowView isKindOfClass:[UIImageView class]]) {
//                    shadowView.hidden = YES;
//                }
//            }
//        }
//    }
    
    [WebView loadHTMLString:HtmlString baseURL:nil];
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
