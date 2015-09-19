//
//  D_PersonCenterViewController.m
//  至品购物
//
//  Created by 夏科杰 on 14-9-6.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_PersonViewController.h"
#import "D_SetPersonInfoController.h"
#import "B_DeliveryListViewController.h"
#import "UIImageView+WebCache.h"
#import "D_ImageViewController.h"
#import "D_CollectionViewController.h"
#import "D_SettingViewController.h"
#import "B_ShoppingListViewController.h"
#import "B_AppointViewController.h"
#import "D_MyHomeViewController.h"
#import "GlobalHead.h"
#import "AESCrypt.h"
#import "D_LoginViewController.h"

@interface D_PersonViewController ()

@end

@implementation D_PersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self isLogin];
 

  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

- (void)isLogin
{
    NSData* AESData = [[AESCrypt decrypt:[[NSUserDefaults standardUserDefaults] objectForKey:[AESCrypt encrypt:@"user_model" password:@"zhipin123"]] password:@"zhipin123"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* AESDictionary = [NSPropertyListSerialization propertyListFromData:AESData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
    
    if (AESDictionary!=nil&&[AESDictionary isKindOfClass:[NSDictionary class]])
    {
        [G_UseDict setDictionary:AESDictionary];
        //        NSLog(@"%@",G_UseDict);
    }
    bool isPass=NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"time"]!=nil)
    {
        isPass=[self compCurrentTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"time"]]>30;
    }
    NSLog(@"time===%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"time"],[dateFormatter stringFromDate:[NSDate date]]);
    
    if ((G_UseDict==nil||[[G_UseDict allKeys] count]==0)&&!isPass) {
        D_LoginViewController *D_LoginView=[[D_LoginViewController alloc] init];
         D_LoginView.isBack = TRUE;
        [D_LoginView setLoginBlock:^{
           
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:D_LoginView] animated:YES completion:nil];
    } else {
        if ([[G_PersonDetail allKeys]count]==0) {
            [self drawView];
        }
    }
    
}

-(void)RightAct:(UIButton *)sender
{
    D_SettingViewController *D_SettingView=[[D_SettingViewController alloc] init];
    D_SettingView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:D_SettingView animated:YES];
}

-(void)personBtn
{
    D_SetPersonInfoController *D_SetPersonInfo=[[D_SetPersonInfoController alloc] init];
    D_SetPersonInfo.ReturnDict=G_PersonDetail;
    D_SetPersonInfo.UseImage=HeadImage.image;
    [D_SetPersonInfo setPersonInfo:^(UIImage *image) {
        HeadImage.image=image;
    }];
    [D_SetPersonInfo setPersonString:^(NSString *string) {
        NameLabel.text=string;
        [G_PersonDetail setObject:string forKey:@"nickName"];
    }];
    [D_SetPersonInfo setPersonDes:^(NSString *des) {
        MoodLabel.text=des;
        [G_PersonDetail setObject:des forKey:@"description"];
    }];
    [D_SetPersonInfo setPersonSex:^(NSString *sex) {
        [G_PersonDetail setObject:sex forKey:@"sex"];
    }];
    D_SetPersonInfo.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:D_SetPersonInfo animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    
    UILabel *lableView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    lableView.text=@"个人中心";
    lableView.textColor=[UIColor whiteColor];
    lableView.shadowColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
    lableView.shadowOffset=CGSizeMake(0, 0.2);
    lableView.textAlignment=NSTextAlignmentCenter;
    lableView.backgroundColor=[UIColor clearColor];
    lableView.font=[UIFont boldSystemFontOfSize:20];
    UIView* TitleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    [self.navigationItem setTitleView:TitleView];
    [TitleView addSubview:lableView];
    
    UIButton *rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:23]];
    [rightBtn setTitle:@"\ue605" forState:UIControlStateNormal];
    [rightBtn setTitle:@"\ue605" forState:UIControlStateSelected];
    [rightBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightBtn setTitleColor:STYLECLOLR               forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(RightAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBtn]];
    
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
    [personBtn addTarget:self action:@selector(personBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:personBtn];
    
    HeadImage=[[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 96, 96)];

    [personBtn addSubview:HeadImage];
    [[HeadImage layer] setMasksToBounds:YES];
    [[HeadImage layer] setCornerRadius:48];
    
    NameLabel=[[UILabel alloc] initWithFrame:CGRectMake(130, 20,180, 50)];
    NameLabel.textColor=UIColorFromRGB(0x000000);
    NameLabel.backgroundColor=[UIColor clearColor];
    NameLabel.font=[UIFont systemFontOfSize:17];
    NameLabel.textAlignment=NSTextAlignmentLeft;
    [personBtn addSubview:NameLabel];
    
    UILabel* scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(130, 50,40, 40)];
    scoreLabel.text=@"\ue631";
    [scoreLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    scoreLabel.textColor=UIColorFromRGB(0xe3c840);
    scoreLabel.backgroundColor=[UIColor clearColor];
    scoreLabel.textAlignment=NSTextAlignmentLeft;
    [personBtn addSubview:scoreLabel];
    
    SLabel=[[UILabel alloc] initWithFrame:CGRectMake(130, 48,100, 50)];
    
    SLabel.textColor=UIColorFromRGB(0x666666);
    SLabel.backgroundColor=[UIColor clearColor];
    SLabel.font=[UIFont boldSystemFontOfSize:11];
    SLabel.textAlignment=NSTextAlignmentCenter;
    [personBtn addSubview:SLabel];
    
    MoodLabel=[[UILabel alloc] initWithFrame:CGRectMake(125, 90,180, 30)];
    MoodLabel.textColor=UIColorFromRGB(0x666666);
    MoodLabel.backgroundColor=[UIColor clearColor];
    MoodLabel.font=[UIFont boldSystemFontOfSize:12];
    MoodLabel.textAlignment=NSTextAlignmentLeft;
    [personBtn addSubview:MoodLabel];
    
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(270*WITH_SCALE, 0,40, 130)];
    arrowLabel.text=@"\ue629";
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel.textColor=UIColorFromRGB(0x888888);
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textAlignment=NSTextAlignmentLeft;
//    arrowLabel.backgroundColor = [UIColor greenColor];//test
    [personBtn addSubview:arrowLabel];
}


-(NSTimeInterval)compCurrentTime:(NSString* ) compareDate
{
    NSTimeInterval  timeInterval = [[self dateFromString:compareDate] timeIntervalSinceDate:[self getNowDate:[NSDate date]]];
    timeInterval = -timeInterval;
    NSLog(@"compCurrentTime==%lf",timeInterval);
    return  timeInterval/(3600*24*60);
}

- (NSDate *)getNowDate:(NSDate *)anyDate
{
    NSTimeInterval timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate * newDate=[anyDate dateByAddingTimeInterval:timeZoneOffset];
    return newDate;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}


-(void)drawView
{
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/get_userinfo.jhtml"]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"%@",ReturnDict);
                          [G_PersonDetail setDictionary:ReturnDict];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [HeadImage sd_setImageWithURL:[NSURL URLWithString:[ReturnDict ObjectForKey:@"headImage"]] placeholderImage:[UIImage imageNamed:@"d_head_image.png"]];
                              NameLabel.text=[ReturnDict ObjectForKey:@"nickName"];
                              SLabel.text=[NSString stringWithFormat:@"积分 %@",[ReturnDict ObjectForKey:@"points"]];
                              MoodLabel.text=[NSString stringWithFormat:@"%@",([ReturnDict ObjectForKey:@"description"]==nil||[[ReturnDict ObjectForKey:@"description"] length]==0)?@"收拾心情，请继续前往":[ReturnDict ObjectForKey:@"description"]];
                          });
                          
                      }
                      NetError:^(int error) {
                      }
     ];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(33, 130, SCREEN_WIDTH-66, 0.5)];
    lineImage.backgroundColor=UIColorFromRGB(0xd3d3d3);
    [self.view addSubview:lineImage];
    
    
    CGFloat addWidth = 100;//如果直接用屏幕宽度去平分两边留空会比较多，加一段宽度后再平分看起来效果更好看
    CGFloat sepWidth = (SCREEN_WIDTH+addWidth*WITH_SCALE)/4;
    
    UIImageView *lineImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(33, 260, SCREEN_WIDTH-66, 0.5)];
    lineImage1.backgroundColor=UIColorFromRGB(0xd3d3d3);
    [self.view addSubview:lineImage1];
    
    CGFloat line2ImgOrigenX = SCREEN_WIDTH/2+sepWidth/2;
    UIImageView *lineImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(line2ImgOrigenX,  170, 0.5, 170)];
    lineImage2.backgroundColor=UIColorFromRGB(0xd3d3d3);
    [self.view addSubview:lineImage2];
    
    CGFloat line3ImageOrigenX = SCREEN_WIDTH/2-sepWidth/2;
    UIImageView *lineImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(line3ImageOrigenX, 170, 0.5, 170)];
    lineImage3.backgroundColor=UIColorFromRGB(0xd3d3d3);
    [self.view addSubview:lineImage3];
    
    
    NSArray *btnArray=@[
                        @[@"shopcart",@"购物车"],
                        @[@"peisong",@"配送订单"],
                        
                        @[@"yuyue",@"预约订单"],
                        @[@"home",@"我的主页"],
                        @[@"shoucan",@"收藏"],
                        ];
    
    for (int i=0; i<[btnArray count]; i++) {
        
        
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.frame = CGRectMake(0, 0, 32, 32);
        [menuBtn setImage:[UIImage imageNamed:[[btnArray objectAtIndex:i] objectAtIndex:0]] forState:UIControlStateNormal];
        //[menuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [menuBtn setTitle:[[btnArray objectAtIndex:i] objectAtIndex:1] forState:UIControlStateNormal];
        [menuBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        menuBtn.backgroundColor = [UIColor clearColor];
        [menuBtn setTitleEdgeInsets:UIEdgeInsetsMake(60, -55, 0, -10)];
        [menuBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [menuBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        menuBtn.userInteractionEnabled = NO;
        
        if ([menuBtn.titleLabel.text isEqualToString:@"购物车"]) {
            
            menuBtn.frame = CGRectMake(0, 0, 45, 32);
        }
        
        
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.tag=i;
        bgBtn.frame = CGRectMake(110*(i%3) + 30, 160+100*(i/3), 75*WITH_SCALE, 75*WITH_SCALE);
        bgBtn.center = CGPointMake(sepWidth*(i%3+1)-(addWidth*WITH_SCALE)/2, bgBtn.center.y);
        [bgBtn addTarget:self action:@selector(menuAct:) forControlEvents:UIControlEventTouchUpInside];
        bgBtn.backgroundColor = [UIColor clearColor];
        menuBtn.center = CGPointMake(bgBtn.frame.size.width/2, bgBtn.frame.size.height/2);
        [bgBtn addSubview:menuBtn];
        
        [self.view addSubview:bgBtn];
        
    }

}

-(void)menuAct:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            B_ShoppingListViewController *B_ShoppingList=[[B_ShoppingListViewController alloc] init];
            B_ShoppingList.hidesBottomBarWhenPushed=YES;
             [self.navigationController pushViewController:B_ShoppingList animated:YES];
        }
           
            break;
        case 1:
        {
            B_DeliveryListViewController *B_DeliveryList=[[B_DeliveryListViewController alloc] init];
            B_DeliveryList.title=@"订单配送";
            B_DeliveryList.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:B_DeliveryList animated:YES];
        };
            break;
        case 2:
        {
            B_AppointViewController *B_AppointView=[[B_AppointViewController alloc] init];
            B_AppointView.title=@"订单预约";
            B_AppointView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:B_AppointView animated:YES];
        }
            break;
        case 3:
        {
            D_MyHomeViewController *D_MyHome=[[D_MyHomeViewController alloc] init];
            D_MyHome.title=@"我的主页";
            D_MyHome.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:D_MyHome animated:YES];
        }
            break;
        case 4:
        {
            D_CollectionViewController *D_CollectionView=[[D_CollectionViewController alloc] init];
            D_CollectionView.title=@"收藏";
            D_CollectionView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:D_CollectionView animated:YES];
        }
            break;
            /*
        case 4:
        {
            D_ImageViewController *D_ImageView=[[D_ImageViewController alloc] init];
           // D_ImageView.ImageName=@"15.jpg";
            D_ImageView.title=@"消息";
            D_ImageView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:D_ImageView animated:YES];
        }
            break;
             */
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil)// 是否是正在使用的视图
        
    {
        //self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
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
