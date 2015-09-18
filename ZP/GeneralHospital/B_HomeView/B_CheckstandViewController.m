//
//  B_CheckstandViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/25.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_CheckstandViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "B_DeliveryListViewController.h"
@implementation B_CheckstandViewController
@synthesize AllPrice,SellDict,Tag;

-(void)PaySelect:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backAction:(UIButton *)sender
{
    switch (Tag) {
        case 1:
        {
            [self.navigationController pushViewController:[NSClassFromString(@"B_DeliveryListViewController") new] animated:NO];
        }
            break;
        case 2:
        {
            [self.navigationController pushViewController:[NSClassFromString(@"B_AppointViewController") new] animated:NO];
        }
            break;
            
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
    [btn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [btn setTitle:@"\ue626" forState:UIControlStateNormal];
    [btn setTitle:@"\ue626" forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    
    
    [WXApi registerApp:@"wxc027a1a50a576776" withDescription:@"至品"];
    self.title=@"收银台";
//    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(0, 0, 30, 30)];
//    [btn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
//    [btn setTitle:@"\ue626" forState:UIControlStateNormal];
//    [btn setTitle:@"\ue626" forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(PaySelect:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(PaySelect:)
                                                 name: @"pay_select"
                                               object: nil];
    
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backImage.backgroundColor=UIColorFromRGB(0xececec);
    [self.view addSubview:backImage];
    
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,SCREEN_WIDTH, 40)];
    titleLabel.text=@"请选择支付方式";
    titleLabel.textColor=UIColorFromRGB(0xa1a1a1);
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:titleLabel];
    
    UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH-20, 40)];
    priceLabel.text=AllPrice;
    priceLabel.textColor=UIColorFromRGB(0xe85829);
    priceLabel.backgroundColor=[UIColor clearColor];
    priceLabel.font=[UIFont systemFontOfSize:16];
    priceLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:priceLabel];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,39.5, SCREEN_WIDTH, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [self.view addSubview:lineImage];
    
    UIButton *zhifubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifubaoBtn.frame = CGRectMake(0, 40, SCREEN_WIDTH, 55);
    [zhifubaoBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
    [zhifubaoBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xeeeeee)] forState:UIControlStateHighlighted];
    [zhifubaoBtn addTarget:self action:@selector(zhifubaoAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhifubaoBtn];
    
    UIImageView *lineImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10,94.5, SCREEN_WIDTH-20, 0.5)];
    lineImage1.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [self.view addSubview:lineImage1];
    
    UIImageView *aliImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 17.25, 67.5, 22.5)];
    aliImage.image=[UIImage imageNamed:@"alipay.png"];
    [zhifubaoBtn addSubview:aliImage];
    
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(290, 0,30, 55)];
    arrowLabel.text=@"\ue629";
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel.textColor=UIColorFromRGB(0x888888);
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textAlignment=NSTextAlignmentCenter;
    [zhifubaoBtn addSubview:arrowLabel];
    
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(0, 95, SCREEN_WIDTH, 55);
    [weixinBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
    [weixinBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xeeeeee)] forState:UIControlStateHighlighted];
    [weixinBtn addTarget:self action:@selector(weixinAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    
    UIImageView *lineImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(10,149.5, SCREEN_WIDTH-20, 0.5)];
    lineImage2.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [self.view addSubview:lineImage2];
    
    UIImageView *weixinImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    weixinImage.image=[UIImage imageNamed:@"weixin.png"];
    [weixinBtn addSubview:weixinImage];
    
    UILabel* weixinLabel=[[UILabel alloc] initWithFrame:CGRectMake(55, 10,200, 20)];
    weixinLabel.text=@"微信支付";
    weixinLabel.textColor=UIColorFromRGB(0x000000);
    weixinLabel.backgroundColor=[UIColor clearColor];
    weixinLabel.font=[UIFont systemFontOfSize:15];
    weixinLabel.textAlignment=NSTextAlignmentLeft;
    [weixinBtn addSubview:weixinLabel];
    
    UILabel* weicLabel=[[UILabel alloc] initWithFrame:CGRectMake(55, 30,200, 20)];
    weicLabel.text=@"微信安全支付";
    weicLabel.textColor=UIColorFromRGB(0xbababa);
    weixinLabel.backgroundColor=[UIColor clearColor];
    weicLabel.font=[UIFont systemFontOfSize:13];
    weicLabel.textAlignment=NSTextAlignmentLeft;
    [weixinBtn addSubview:weicLabel];
    
    UILabel* arrowLabel1=[[UILabel alloc] initWithFrame:CGRectMake(290, 0,30, 55)];
    arrowLabel1.text=@"\ue629";
    [arrowLabel1 setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel1.textColor=UIColorFromRGB(0x888888);
    arrowLabel1.backgroundColor=[UIColor clearColor];
    arrowLabel1.textAlignment=NSTextAlignmentCenter;
    [weixinBtn addSubview:arrowLabel1];
    // Do any additional setup after loading the view.
}

-(void)zhifubaoAct
{
    [[AlipaySDK defaultService] payOrder:[SellDict objectForKey:@"alipayParam"]
                              fromScheme:@"zhipin"
                                callback:^(NSDictionary *resultDic) {
                                    NSLog(@"reslut = %@",resultDic);
                                    B_DeliveryListViewController *B_DeliveryList=[[B_DeliveryListViewController alloc] init];
                                    B_DeliveryList.title=@"订单配送";
                                    B_DeliveryList.hidesBottomBarWhenPushed=YES;
                                    [self.navigationController pushViewController:B_DeliveryList animated:YES];
                                }];
}

-(void)weixinAct
{
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSData* xmlData = [[SellDict objectForKey:@"wxpayParam"] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = NULL;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    dict = [NSJSONSerialization JSONObjectWithData:xmlData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dict);

    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    
    if ([WXApi sendReq:req]) {
        NSLog(@"sucess");
    }else{
        NSLog(@"fault");
    }
 
//    [WXApi openWXApp];
   // [WXApi sendReq:[SellDict objectForKey:@"wxpayParam"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
