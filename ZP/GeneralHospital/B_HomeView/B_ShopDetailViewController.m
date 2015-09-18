//
//  ShopDetailViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-13.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#import "GlobalHead.h"
#import "B_ShopDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "B_GoodsListViewController.h"
#import "B_GoodsDetailViewController.h"
#import "B_ShopIntroduceViewController.h"
#import "C_MapGuidanceViewController.h"
#import "D_LeaveMessageViewController.h"
@interface B_ShopDetailViewController ()

@end

@implementation B_ShopDetailViewController
@synthesize Dict;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)BarAct:(UIButton *)sender
{
    [self.navigationController pushViewController:[NSClassFromString(@"B_ShoppingListViewController") new] animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[G_ShopCar allKeys] count]];
    NumLabel.hidden=[[G_ShopCar allKeys] count]==0;
    
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"dict----    %@", Dict);
    self.title=[Dict objectForKey:@"title"];
    SearchBar = [[UISearchBar alloc] init];
    SearchBar.frame = CGRectMake(0, 0, 200, 44);
    SearchBar.placeholder = @"查找店内";
    SearchBar.delegate = self;
    SearchBar.backgroundColor=[UIColor clearColor];
    [SearchBar setTintColor:[UIColor clearColor]];
    for (UIView* view  in SearchBar.subviews) {
        for (UIView* view1  in view.subviews) {
            
            if ([view1 isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [view1 removeFromSuperview];
                
            }
            if ([view1 isKindOfClass:[UITextField class]]) {
                [DLIDEKeyboardView attachToTextView:(UITextField* )view1];
            }
        }
    }
    SearchBar.keyboardType = UIKeyboardTypeDefault;
    [self.navigationItem setTitleView:SearchBar];
    
   
    
    ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    ScrollView.delegate=self;
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    ScrollView.contentSize=CGSizeMake(0, 968);
    [self.view addSubview:ScrollView];
    
    
    UIView *BelowView=[[UIView alloc] initWithFrame:CGRectMake(-1, SCREEN_HIGHE-114, SCREEN_WIDTH+2, 51)];
    BelowView.backgroundColor=UIColorFromRGBA(0xffffff, 0.9);
    [self.view addSubview:BelowView];
    [[BelowView layer]setBorderWidth:0.5];
    [[BelowView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(21, 10, 40, 30);
    [menuBtn setTitle:@"分类" forState:UIControlStateNormal];
    [menuBtn setTitle:@"分类" forState:UIControlStateHighlighted];
    [menuBtn setTitleColor:UIColorFromRGB(0x6ad3d4) forState:UIControlStateNormal];
    [menuBtn setTitleColor:UIColorFromRGB(0x6ad3d4) forState:UIControlStateSelected];
    [menuBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:19]];
    [menuBtn addTarget:self action:@selector(menuAct) forControlEvents:UIControlEventTouchUpInside];
    [BelowView addSubview:menuBtn];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(SCREEN_WIDTH - 45, 10, 30, 30);
    [callBtn setTitle:@"\ue60c" forState:UIControlStateNormal];
    [callBtn setTitle:@"\ue60c" forState:UIControlStateSelected];
    [callBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:30]];
    [callBtn setTitleColor:UIColorFromRGB(0x83ca03) forState:UIControlStateNormal];
    [callBtn setTitleColor:UIColorFromRGB(0x83ca03) forState:UIControlStateHighlighted];
    [callBtn addTarget:self action:@selector(callAct) forControlEvents:UIControlEventTouchUpInside];
    [BelowView addSubview:callBtn];
    
    UIButton *barBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [barBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [barBtn setBackgroundImage:[UIImage imageNamed:@"shopcart1"] forState:UIControlStateNormal];
//    [barBtn setTitle:@"\ue60b" forState:UIControlStateNormal];
//    [barBtn setTitle:@"\ue60b" forState:UIControlStateHighlighted];
//    [barBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [barBtn addTarget:self action:@selector(BarAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:barBtn]];
    
    NumLabel=[[UILabel alloc] initWithFrame:CGRectMake(18, -5,10, 10)];
    NumLabel.textColor=UIColorFromRGB(0xffffff);
    NumLabel.backgroundColor=[UIColor redColor];
    NumLabel.font=[UIFont systemFontOfSize:8];
    NumLabel.textAlignment=NSTextAlignmentCenter;
    [barBtn addSubview:NumLabel];
    [[NumLabel layer] setMasksToBounds:YES];
    [[NumLabel layer] setCornerRadius:5];

    LeftTable =[[B_LeftTableView alloc] initWithFrame:CGRectMake(-WWW, 0, WWW, SCREEN_HIGHE-110)];
    LeftTable.separatorColor=[UIColor whiteColor];
    LeftTable.alpha = .85f;
    LeftTable.hidden=LeftTable.IsHid;
    LeftTable.showsHorizontalScrollIndicator=NO;
    LeftTable.showsVerticalScrollIndicator=NO;
    LeftTable.tableFooterView = [[UIView alloc] init];
    LeftTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    LeftTable.backgroundColor=UIColorFromRGBA(0xeeeeee, 0.88);
    LeftTable.backgroundColor = [UIColor blackColor];
    [self.view addSubview:LeftTable];
    [LeftTable SetClickBlock:^(NSString * string) {
        [self menuAct];
        B_GoodsListViewController *B_GoodsListView=[[B_GoodsListViewController alloc] init];
        B_GoodsListView.Type=@"3";
        B_GoodsListView.CatId=string;
        B_GoodsListView.CategoryList=CategoryList;
        B_GoodsListView.ShopId=[Dict objectForKey:@"code"];
        B_GoodsListView.title=[Dict objectForKey:@"title"];
        [self.navigationController pushViewController:B_GoodsListView animated:YES];
    }];
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/index.jhtml?id=%@",[Dict objectForKey:@"code"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType8
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          Dictionary=[[NSDictionary alloc] initWithDictionary:ReturnDict];
                          
                          if ([[ReturnDict objectForKey:@"categories"] count]>0) {
                              [LeftTable setListArray:[ReturnDict objectForKey:@"categories"]];
                              [LeftTable reloadData];
                              CategoryList=[[NSArray alloc] initWithArray:[ReturnDict objectForKey:@"categories"]];
                          }
                          
                          UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
                          scrollView.showsHorizontalScrollIndicator=NO;
                          scrollView.showsVerticalScrollIndicator=NO;
                          scrollView.pagingEnabled=YES;
                          scrollView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:scrollView];
                          
                          NSArray *shopImages=[[NSArray alloc] initWithArray: [[Dictionary objectForKey:@"data"] objectForKey:@"shopImages"]];
                          scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*[shopImages count], 0);
                          
                          for (int i=0; i<[shopImages count]; i++) {
                              UIImageView* headImage=[[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, 190)];
                              [headImage sd_setImageWithURL:[NSURL URLWithString:[shopImages objectAtIndex:i]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  if (image==nil) {
                                      return ;
                                  }
                                  float height=320/image.size.width*image.size.height;
                                  headImage.frame=CGRectMake(i*SCREEN_WIDTH, 0, 320, height);
                              }];
                              [scrollView addSubview:headImage];
                          }
                          
                          UIView *midView=[[UIView alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 780)];
                          midView.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [ScrollView addSubview:midView];
                          

                          
                          UIImageView *roundHead=[[UIImageView alloc] initWithFrame:CGRectMake(20, 120, 70, 70)];
                          [roundHead sd_setImageWithURL:[NSURL URLWithString:[[Dictionary objectForKey:@"data"] objectForKey:@"headerImageurl"]]];
                          [ScrollView addSubview:roundHead];
                          [[roundHead layer] setMasksToBounds:YES];
                          [[roundHead layer] setCornerRadius:35];
                          [[roundHead layer]setBorderWidth:2];
                          [[roundHead layer]setBorderColor:[STYLECLOLR CGColor]];
                          
                          UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(110, 135,150, 30)];
                          titleLabel.text=[Dict objectForKey:@"title"];
                          titleLabel.textColor=UIColorFromRGB(0xffffff);
                          titleLabel.backgroundColor=[UIColor clearColor];
                          titleLabel.font=[UIFont boldSystemFontOfSize:15];
                          titleLabel.textAlignment=NSTextAlignmentLeft;
                          [ScrollView addSubview:titleLabel];
                          
                          NSMutableString *score=[[NSMutableString alloc] init];
                          
                          for (int j=0; j<[[[Dictionary objectForKey:@"data"] ObjectForKey:@"score"] intValue]; j++) {
                              [score appendString:@"\ue61b"];
                          }
                          UILabel* scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(110, 150,200, 30)];
                          scoreLabel.text=score;
                          [scoreLabel setFont:[UIFont fontWithName:@"icomoon" size:15]];
                          scoreLabel.textColor=UIColorFromRGB(0xfdd532);
                          scoreLabel.backgroundColor=[UIColor clearColor];
                          scoreLabel.textAlignment=NSTextAlignmentLeft;
                          [ScrollView addSubview:scoreLabel];
                          

                          NSString *string=[NSString stringWithFormat:[[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"collectFlag"] intValue]==1?@"已收藏":@"收藏"];
                          
                          UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          collectionBtn.tag=[[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"collectFlag"] intValue];
                            collectionBtn.frame = CGRectMake(265*WITH_SCALE, 140, 40*WITH_SCALE, 25);
                          [collectionBtn setTitle:string forState:UIControlStateNormal];
                          [collectionBtn setTitle:string forState:UIControlStateHighlighted];
                            collectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                          [collectionBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xfeb65a)] forState:UIControlStateNormal];
                          [collectionBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xfeb65a)] forState:UIControlStateSelected];
                          [collectionBtn addTarget:self action:@selector(collectionAct:) forControlEvents:UIControlEventTouchUpInside];
                          [ScrollView addSubview:collectionBtn];
                          [[collectionBtn layer] setMasksToBounds:YES];
                          [[collectionBtn layer] setCornerRadius:4];
                        
                          NSArray * btnArray=@[
                                               @[@"全部",[NSString stringWithFormat:@"%@",[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"allProduct"]]],
                                               @[@"促销",[NSString stringWithFormat:@"%@",[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"saleProduct"]]],
                                               @[@"签到",@"留言"],
                                               @[@"状态",[NSString stringWithFormat:@"%@",[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"saleStatus"]]]];
                          
                          for (int k=0; k<[btnArray count]; k++) {
                              
                              UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                              selectBtn.frame = CGRectMake((4+79*k)*WITH_SCALE, 16, 75*WITH_SCALE, 40);
                              
                              [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                              [selectBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 0, 25, 0)];
                              [selectBtn setTitle:[[btnArray ObjectAtIndex:k] ObjectAtIndex:0]
                                         forState:UIControlStateNormal];
                              [selectBtn setTitle:[[btnArray ObjectAtIndex:k] ObjectAtIndex:0]
                                         forState:UIControlStateSelected];
                              [selectBtn setTitleColor:UIColorFromRGB(0x000000)
                                              forState:UIControlStateNormal];
                              [selectBtn setTitleColor:UIColorFromRGB(0x000000)
                                              forState:UIControlStateSelected];
                              [selectBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                                                   forState:UIControlStateNormal];
                              [selectBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                                                   forState:UIControlStateSelected];
                              selectBtn.userInteractionEnabled=k!=3;
                              if(k<2){
                                  [selectBtn addTarget:self
                                                action:@selector(MoreAct:)
                                      forControlEvents:UIControlEventTouchUpInside];
                              }else
                              {
                                  [selectBtn addTarget:self
                                                action:@selector(collectionAct)
                                      forControlEvents:UIControlEventTouchUpInside];
                              }

                              [midView addSubview:selectBtn];
                              [[selectBtn layer] setMasksToBounds:YES];
                              [[selectBtn layer] setCornerRadius:2];
                              
                              switch (k) {
                                  case 0:
                                  case 1:
                                  {
                                    UILabel* nLabel=[[UILabel alloc] initWithFrame:CGRectMake(00, 20,75, 20)];
                                    nLabel.text=[[btnArray ObjectAtIndex:k] ObjectAtIndex:1];
                                    nLabel.textColor=UIColorFromRGB(0xfeb85b);
                                    nLabel.backgroundColor=[UIColor clearColor];
                                    nLabel.font=[UIFont systemFontOfSize:13];
                                    nLabel.textAlignment=NSTextAlignmentCenter;
                                    [selectBtn addSubview:nLabel];
                                  }
                                      break;
                                  case 2:
                                  {
                                      UILabel* nLabel=[[UILabel alloc] initWithFrame:CGRectMake(00, 18,75, 20)];
                                      nLabel.text=[[btnArray ObjectAtIndex:k] ObjectAtIndex:1];
                                      nLabel.textColor=UIColorFromRGB(0x000000);
                                      nLabel.backgroundColor=[UIColor clearColor];
                                      nLabel.font=[UIFont systemFontOfSize:13];
                                      nLabel.textAlignment=NSTextAlignmentCenter;
                                      [selectBtn addSubview:nLabel];
                                  }
                                      break;
                                  case 3:
                                  {
                                      UIImageView *dotImage=[[UIImageView alloc] initWithFrame:CGRectMake(32.5, 25, 10, 10)];
                                      switch ([[[btnArray ObjectAtIndex:k] ObjectAtIndex:1] intValue]) {
                                          case 1:
                                              dotImage.backgroundColor=UIColorFromRGB(0x6FC90C);
                                              break;
                                          case 2:
                                              dotImage.backgroundColor=UIColorFromRGB(0xFFCC33);
                                              break;
                                          case 3:
                                              dotImage.backgroundColor=UIColorFromRGB(0xFF0000);
                                              break;
                                              
                                          default:
                                              break;
                                      }
                                      [selectBtn addSubview:dotImage];
                                      [[dotImage layer] setMasksToBounds:YES];
                                      [[dotImage layer] setCornerRadius:5];
                                  }
                                      break;
                                      
                                  default:
                                      break;
                              }
 
                          }
                          UIButton *descriptView = [UIButton buttonWithType:UIButtonTypeCustom];
                          descriptView.frame = CGRectMake(4, 66, SCREEN_WIDTH-8, 100);
                          descriptView.backgroundColor=[UIColor whiteColor];
                          [descriptView addTarget:self action:@selector(personBtn) forControlEvents:UIControlEventTouchUpInside];
                          [midView addSubview:descriptView];
                          [[descriptView layer] setMasksToBounds:YES];
                          [[descriptView layer] setCornerRadius:2];
//                          UIView *descriptView=[[UIView alloc] initWithFrame:CGRectMake(4, 66, SCREEN_WIDTH-8, 100)];
//                          descriptView.backgroundColor=[UIColor whiteColor];
//                          [midView addSubview:descriptView];

                          
                          UILabel* homeLabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 10,30, 30)];
                          homeLabel.text=@"\ue608";
                          [homeLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
                          homeLabel.textColor=STYLECLOLR;
                          homeLabel.backgroundColor=[UIColor clearColor];
                          homeLabel.textAlignment=NSTextAlignmentLeft;
                          [descriptView addSubview:homeLabel];
                          
                          UILabel* homeDetailLabel=[[UILabel alloc] initWithFrame:CGRectMake(35, 5,250, 50)];
                          homeDetailLabel.text=[[Dictionary objectForKey:@"data"] objectForKey:@"desc"];
                          [homeDetailLabel setFont:[UIFont systemFontOfSize:12]];
                          homeDetailLabel.numberOfLines=3;
                          homeDetailLabel.textColor=[UIColor blackColor];
                          homeDetailLabel.backgroundColor=[UIColor clearColor];
                          homeDetailLabel.textAlignment=NSTextAlignmentLeft;
                          [descriptView addSubview:homeDetailLabel];
                          
                          
                          UILabel* mesLabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 50,50, 50)];
                          mesLabel.text=@"\ue609";
                          [mesLabel setFont:[UIFont fontWithName:@"zipn" size:20]];
                          mesLabel.textColor=STYLECLOLR;
                          mesLabel.backgroundColor=[UIColor clearColor];
                          mesLabel.textAlignment=NSTextAlignmentLeft;
                          [descriptView addSubview:mesLabel];
                          
                          UILabel* mesDetailLabel=[[UILabel alloc] initWithFrame:CGRectMake(35, 60,250, 40)];
                          mesDetailLabel.text=[[Dictionary objectForKey:@"data"] objectForKey:@"evaluate"]==nil||[[[Dictionary objectForKey:@"data"] objectForKey:@"evaluate"] length]==0?@"暂无数据":[[Dictionary objectForKey:@"data"] objectForKey:@"evaluate"];
                          [mesDetailLabel setFont:[UIFont systemFontOfSize:12]];
                          mesDetailLabel.numberOfLines=2;
                          mesDetailLabel.textColor=[UIColor blackColor];
                          mesDetailLabel.backgroundColor=[UIColor clearColor];
                          mesDetailLabel.textAlignment=NSTextAlignmentLeft;
                          [descriptView addSubview:mesDetailLabel];
                          
                          UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(290*WITH_SCALE, 0,30*WITH_SCALE, 100)];
                          arrowLabel.text=@"\ue629";
                          [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
                          arrowLabel.textColor=UIColorFromRGB(0x888888);
                          arrowLabel.backgroundColor=[UIColor clearColor];
                          arrowLabel.textAlignment=NSTextAlignmentCenter;
                          [descriptView addSubview:arrowLabel];
                          
                          UIView *addView=[[UIView alloc] initWithFrame:CGRectMake(4*WITH_SCALE, 176, 233*WITH_SCALE, 50)];
                          addView.backgroundColor=[UIColor whiteColor];
                          [midView addSubview:addView];
                          [[addView layer] setMasksToBounds:YES];
                          [[addView layer] setCornerRadius:2];
                          
                          UILabel* addLabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 0,30, 50)];
                          addLabel.text=@"\ue62b";
                          [addLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
                          addLabel.textColor=STYLECLOLR;
                          addLabel.backgroundColor=[UIColor clearColor];
                          addLabel.textAlignment=NSTextAlignmentLeft;
                          [addView addSubview:addLabel];
                          
                          
                          UILabel* tLabel=[[UILabel alloc] initWithFrame:CGRectMake(35,2,200*WITH_SCALE,14)];
                          tLabel.text=[[Dictionary objectForKey:@"data"] objectForKey:@"title"];
                          [tLabel setFont:[UIFont systemFontOfSize:12]];
                          tLabel.textColor=[UIColor blackColor];
                          tLabel.backgroundColor=[UIColor clearColor];
                          tLabel.textAlignment=NSTextAlignmentLeft;
                          [addView addSubview:tLabel];
                          
                          
                          UILabel* addDetailLabel=[[UILabel alloc] initWithFrame:CGRectMake(35, 13,200*WITH_SCALE, 40)];
                          addDetailLabel.numberOfLines=10;
                          addDetailLabel.text=[[Dictionary objectForKey:@"data"] objectForKey:@"address"];
                          [addDetailLabel setFont:[UIFont systemFontOfSize:12]];
                          addDetailLabel.textColor=[UIColor blackColor];
                          addDetailLabel.backgroundColor=[UIColor clearColor];
                          addDetailLabel.textAlignment=NSTextAlignmentLeft;
                          [addView addSubview:addDetailLabel];
                          

                          
                          UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          addressBtn.frame = CGRectMake(240*WITH_SCALE, 176, 75*WITH_SCALE, 50);
                          [addressBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
                          [addressBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateSelected];
                          [addressBtn addTarget:self action:@selector(addressAct) forControlEvents:UIControlEventTouchUpInside];
                          [midView addSubview:addressBtn];
                          [[addressBtn layer] setMasksToBounds:YES];
                          [[addressBtn layer] setCornerRadius:2];
                          
                          
                          UILabel* locLabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 0,70, 34)];
                          locLabel.text=@"\ue62c";
                          [locLabel setFont:[UIFont fontWithName:@"icomoon" size:30]];
                          locLabel.textColor=UIColorFromRGB(0x039bdd);
                          locLabel.backgroundColor=[UIColor clearColor];
                          locLabel.textAlignment=NSTextAlignmentCenter;
                          [addressBtn addSubview:locLabel];
                          
                          UILabel* locDetailLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 32,70*WITH_SCALE, 15)];
                          locDetailLabel.text=@"地图导航";
                          [locDetailLabel setFont:[UIFont systemFontOfSize:10]];
                          locDetailLabel.textColor=UIColorFromRGB(0x5b6869);
                          locDetailLabel.backgroundColor=[UIColor clearColor];
                          locDetailLabel.textAlignment=NSTextAlignmentCenter;
                          [addressBtn addSubview:locDetailLabel];
                          
                          
                          UILabel* noticeLabel=[[UILabel alloc] initWithFrame:CGRectMake(50*WITH_SCALE, 236,220*WITH_SCALE, 30)];
                          noticeLabel.text=[[Dictionary objectForKey:@"data"] objectForKey:@"notice"];
                          [noticeLabel setFont:[UIFont systemFontOfSize:12]];
                          noticeLabel.numberOfLines=2;
                          noticeLabel.textColor=UIColorFromRGB(0x000000);
                          noticeLabel.backgroundColor=[UIColor clearColor];
                          noticeLabel.textAlignment=NSTextAlignmentLeft;
                          [midView addSubview:noticeLabel];
                          
                          
                          
                          UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 270, SCREEN_WIDTH, 640)];
                          backView.backgroundColor=[UIColor whiteColor];
                          [midView addSubview:backView];
                          
                          NSArray *activityList=[[NSArray alloc] initWithArray:[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"activityList"]];
                          
                          int height=5;
                          if ([activityList count]==1||[activityList count]==2) {
                              
                              UIImageView* upImage=[[UIImageView alloc] initWithFrame:CGRectMake(4, height, SCREEN_WIDTH-8, 75)];
                              [upImage sd_setImageWithURL:[NSURL URLWithString:[[activityList objectAtIndex:0] ObjectForKey:@"imageurl"]]];
                              
                              [backView addSubview:upImage];                              

                              height+=80;
                          }else
                          {
                                  ScrollView.contentSize=CGSizeMake(0, ScrollView.contentSize.height-80);
                          }
                          if ([activityList count]==2) {
                              UIImageView* downImage=[[UIImageView alloc] initWithFrame:CGRectMake(4, height, SCREEN_WIDTH-8, 150)];
                              [downImage sd_setImageWithURL:[NSURL URLWithString:[[activityList objectAtIndex:1] ObjectForKey:@"imageurl"]]];
                              [backView addSubview:downImage];
                              height+=160;
                          }else
                          {
                              ScrollView.contentSize=CGSizeMake(0, ScrollView.contentSize.height-160);
                          }

                          if ([Dictionary objectForKey:@"data"]==nil||[[Dictionary objectForKey:@"data"] objectForKey:@"recommend"]==nil||[[[Dictionary objectForKey:@"data"] objectForKey:@"recommend"] isEqual:[NSNull null]]) {
                              ScrollView.contentSize=CGSizeMake(0, ScrollView.contentSize.height-205);
                              return ;
                          }
                          
                          UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 0.5)];
                          lineImage.backgroundColor=UIColorFromRGB(0x888888);
                          [backView addSubview:lineImage];
                          
                          
                          UILabel* groupLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, height,200, 50)];
                          groupLabel.text=@"最受欢迎";
                          groupLabel.textColor=UIColorFromRGB(0x000000);
                          groupLabel.backgroundColor=[UIColor clearColor];
                          groupLabel.font=[UIFont boldSystemFontOfSize:15];
                          groupLabel.textAlignment=NSTextAlignmentLeft;
                          [backView addSubview:groupLabel];
                          
                          UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          moreBtn.frame = CGRectMake(SCREEN_WIDTH-60,height,60, 50);
                          [moreBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:15]];
                          [moreBtn setTitle:@"更多\ue621" forState:UIControlStateNormal];
                          [moreBtn setTitle:@"更多\ue621" forState:UIControlStateHighlighted];
                          [moreBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
                          [moreBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateSelected];
                          [moreBtn addTarget:self action:@selector(MoreAct:) forControlEvents:UIControlEventTouchUpInside];
                          [backView addSubview:moreBtn];
                          height+=50;
                          NSArray *productList=[[NSArray alloc] initWithArray:[[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"recommend"] ObjectForKey:@"dataList"]];
                          UIScrollView *productScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 165)];
                          [backView addSubview:productScrollView];
                          
                          productScrollView.contentSize=CGSizeMake(110*[productList count], 0);
                          for (int j=0; j<[productList count]; j++) {
//                              UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5+j*110, 0, 105, 105)];
//                              [imageView sd_setImageWithURL:[NSURL URLWithString:[[productList ObjectAtIndex:j] ObjectForKey:@"imageurl"]]];
//                              [productScrollView addSubview:imageView];
//                              [[imageView layer] setMasksToBounds:YES];
//                              [[imageView layer] setCornerRadius:2];
                              
                              UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                              goodBtn.frame = CGRectMake(5+j*110, 0, 105, 105);
                              goodBtn.tag=j;
                              [goodBtn sd_setImageWithURL:[NSURL URLWithString:[[productList ObjectAtIndex:j] ObjectForKey:@"imageurl"]] forState:UIControlStateNormal];
                              [goodBtn sd_setImageWithURL:[NSURL URLWithString:[[productList ObjectAtIndex:j] ObjectForKey:@"imageurl"]] forState:UIControlStateHighlighted];
                              [goodBtn addTarget:self action:@selector(goodAct:) forControlEvents:UIControlEventTouchUpInside];
                              [productScrollView addSubview:goodBtn];
                              [[goodBtn layer] setMasksToBounds:YES];
                              [[goodBtn layer] setCornerRadius:2];
                              
                              
                              UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(5+j*110, 105,105, 30)];
                              titleLabel.text=[[productList ObjectAtIndex:j] ObjectForKey:@"title"];
                              titleLabel.textColor=UIColorFromRGB(0x666666);
                              titleLabel.backgroundColor=[UIColor clearColor];
                              titleLabel.font=[UIFont systemFontOfSize:13];
                              titleLabel.textAlignment=NSTextAlignmentCenter;
                              [productScrollView addSubview:titleLabel];
                              
                              UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(5+j*110, 135,105, 30)];
                              priceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[productList ObjectAtIndex:j] ObjectForKey:@"price"] floatValue]];
                              priceLabel.textColor=UIColorFromRGB(0x666666);
                              priceLabel.backgroundColor=[UIColor clearColor];
                              priceLabel.font=[UIFont systemFontOfSize:13];
                              priceLabel.textAlignment=NSTextAlignmentCenter;
                              [productScrollView addSubview:priceLabel];
                          }
                          height+=165;
                          UIImageView *lineImage1=[[UIImageView alloc] initWithFrame:CGRectMake(0,height, SCREEN_WIDTH, 0.5)];
                          lineImage1.backgroundColor=UIColorFromRGB(0x888888);
                          [backView addSubview:lineImage1];


                      }
                      NetError:^(int error) {
                      }
     ];

    
}


-(void)collectionAct
{
    D_LeaveMessageViewController *D_LeaveMessage=[[D_LeaveMessageViewController alloc] init];
    D_LeaveMessage.ShopId = [Dict objectForKey:@"code"];
    [self.navigationController pushViewController:D_LeaveMessage animated:YES];
}

-(void)addressAct
{
    C_MapGuidanceViewController *C_MapGuidance=[[C_MapGuidanceViewController alloc] init];
    CLLocationCoordinate2D target;
    target.latitude=[[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"latitude"] floatValue];
    target.longitude=[[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"longitude"] floatValue];
    C_MapGuidance.target=target;
    C_MapGuidance.pharmacyName=[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"address"];
    [self.navigationController pushViewController:C_MapGuidance animated:YES];
}

-(void)goodAct:(UIButton *)sender
{
    B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
    B_GoodsDetailView.Dict=[[[[Dictionary ObjectForKey:@"data"] ObjectForKey:@"recommend"] ObjectForKey:@"dataList"] objectAtIndex:sender.tag];

    [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
}

-(void)MoreAct:(UIButton *)sender
{
    B_GoodsListViewController *B_GoodsListView=[[B_GoodsListViewController alloc] init];
    B_GoodsListView.CategoryList=[Dictionary objectForKey:@"categories"];
    B_GoodsListView.ShopId=[Dict objectForKey:@"code"];
    B_GoodsListView.title=[Dict objectForKey:@"title"];
    [self.navigationController pushViewController:B_GoodsListView animated:YES];
}

-(void)collectionAct:(UIButton *)sender
{
    if (sender.tag==1) {
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/cancal_collect.jhtml?shopId=%@",[Dict objectForKey:@"code"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [NetRequest setASIPostDict:nil
                           ApiName:@""
                         CanCancel:YES
                       SetHttpType:HttpGet
                         SetNotice:NoticeType1
                        SetNetWork:NetWorkTypeAS
                        SetProcess:ProcessType8
                        SetEncrypt:Encryption
                          SetCache:Cache
                          NetBlock:^(NSDictionary *ReturnDict){
                              NSLog(@"%@",ReturnDict);
                              sender.tag=0;
                              NSString *string=[NSString stringWithFormat:sender.tag==1?@"已收藏":@"收藏"];
                              [sender setTitle:string forState:UIControlStateNormal];
                              [sender setTitle:string forState:UIControlStateHighlighted];
                          }
                          NetError:^(int error) {
                          }
         ];

    }else
    {
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/collect.jhtml?shopId=%@",[Dict objectForKey:@"code"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [NetRequest setASIPostDict:nil
                           ApiName:@""
                         CanCancel:YES
                       SetHttpType:HttpGet
                         SetNotice:NoticeType1
                        SetNetWork:NetWorkTypeAS
                        SetProcess:ProcessType8
                        SetEncrypt:Encryption
                          SetCache:Cache
                          NetBlock:^(NSDictionary *ReturnDict){
                              NSLog(@"%@",ReturnDict);
                              sender.tag=1;
                              NSString *string=[NSString stringWithFormat:sender.tag==1?@"已收藏":@"收藏"];
                              [sender setTitle:string forState:UIControlStateNormal];
                              [sender setTitle:string forState:UIControlStateHighlighted];
                          }
                          NetError:^(int error) {
                          }
         ];

    }
    
    
}

-(void)menuAct
{
    LeftTable.hidden=!LeftTable.isHidden;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        LeftTable.frame=CGRectMake(LeftTable.frame.origin.x==-WWW?0:-WWW, 0, WWW, SCREEN_HIGHE-114);
    } completion:^(BOOL finished) {
    }];
}

-(void)callAct
{
    if (Dictionary==nil||[[Dictionary objectForKey:@"data"] objectForKey:@"telephone"]==nil){
        [GeneralClass ShowNotice:@"温馨提示"
                      setContent:@"店铺尚未填写"
                       setResult:NZAlertStyleInfo
                         setType:NoticeType0];
    }else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",[[Dictionary objectForKey:@"data"] objectForKey:@"telephone"]]]];
    }

}
-(void)personBtn
{
    B_ShopIntroduceViewController *B_ShopIntro=[[B_ShopIntroduceViewController alloc] init];
    B_ShopIntro.DetailDict=Dictionary;
    B_ShopIntro.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_ShopIntro animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil) {
        for (id view in ScrollView.subviews) {
            [view removeFromSuperview];
        }
        Dictionary =nil;
        [ScrollView removeFromSuperview];
        self.view=nil;
    }

    // Dispose of any resources that can be recreated.
}

@end
