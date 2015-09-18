//
//  D_PrivacyStatementViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/2/2.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "D_PrivacyStatementViewController.h"

@interface D_PrivacyStatementViewController ()

@end

@implementation D_PrivacyStatementViewController
@synthesize Url;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:Url]];
    UIWebView *WebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    WebView.backgroundColor=[UIColor whiteColor];
    WebView.delegate=self;
   // WebView.scalesPageToFit = YES;
    [self.view addSubview:WebView];
    for (UIView *subView in [WebView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    
    [WebView loadRequest:request];
    
    ActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //设置显示位置
    ActivityIndicator.color=STYLECLOLR;
    [ActivityIndicator setCenter:CGPointMake(WebView.center.x, WebView.center.y-32)];
    //开始显示Loading动画
    [WebView addSubview:ActivityIndicator];
    // Do any additional setup after loading the view.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [ActivityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ActivityIndicator stopAnimating];
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
