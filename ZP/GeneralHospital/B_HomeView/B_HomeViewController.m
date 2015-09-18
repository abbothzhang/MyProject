//
//  B_HomeViewController.m
//  至品购物
//
//  Created by 夏科杰 on 14-9-6.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "B_HomeViewController.h"
#import "DLIDEKeyboardView.h"
#import "ImageScale.h"
#import "B_LocationViewController.h"
#import "GlobalHead.h"
#import "B_ShopDetailViewController.h"
#import "B_GoodsDetailViewController.h"
#import "B_ShopSearchViewController.h"
#import "B_ShopListViewController.h"
#import "B_GoodsMoreListController.h"

@interface B_HomeViewController ()

@end

@implementation B_HomeViewController
@synthesize LocString;
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
    
    //LocString=@"杭州";
    
    UIView* TitleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    UILabel *lableView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    lableView.text=@"商铺推荐";
    lableView.textColor=[UIColor whiteColor];
//    lableView.shadowColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
//    lableView.shadowOffset=CGSizeMake(0, 0.2);
    lableView.textAlignment=NSTextAlignmentCenter;
    lableView.backgroundColor=[UIColor clearColor];
    lableView.font=[UIFont boldSystemFontOfSize:17];
    [TitleView addSubview:lableView];
    [self.navigationItem setTitleView:lableView];
    
    
    UISwipeGestureRecognizer *swp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickBack)];
    swp.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swp];
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
//    Locat ionManager=[[CLLocationManager alloc]init];
//    LocationManager.delegate=self;
//    [LocationManager startUpdatingLocation];
//    
//    if ([LocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [LocationManager requestWhenInUseAuthorization];
//    }
//    if ([LocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [LocationManager requestAlwaysAuthorization];
//    }

 
    
//    NSMutableDictionary *dictText = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                     [UIColor whiteColor], UITextAttributeTextColor,
//                                     [UIFont systemFontOfSize:20],UITextAttributeFont,
//                                     [UIColor whiteColor],UITextAttributeTextShadowColor,
//                                     nil] ;
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8) {
//        [dictText setObject:[NSValue valueWithCGSize:CGSizeMake(0, 0.5)] forKey:UITextAttributeTextShadowOffset];
//    }else
//    {
//        NSShadow *shadow = [[NSShadow alloc] init];
//        shadow.shadowOffset = CGSizeMake(0, 2.0);
//        [dictText setObject:shadow forKey:NSShadowAttributeName];
//    }
//    [self.navigationController.navigationBar setTitleTextAttributes:dictText];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 15, 15)];
    [backButton setTitle :@"<"   forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIBarButtonItem *fixspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixspace.width = 15;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"类别" forState: UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    leftButton.frame = CGRectMake(0, 0, 40, 20);
    [leftButton addTarget:self action:@selector(showCategory) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems = @[backBarButton, barbutton];
    
    //    RightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//    [RightBtn setFrame:CGRectMake(0, 0, 40, 40)];
//    [RightBtn setTitle:LocString forState:UIControlStateNormal];
//    [RightBtn setTitle:LocString forState:UIControlStateHighlighted];
//    [RightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [RightBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    [RightBtn addTarget:self action:@selector(RightAct) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:RightBtn]];
//    
//    UIImageView *arrowImage=[[UIImageView alloc] initWithFrame:CGRectMake(40, 12.5, 15, 15)];
//    arrowImage.image=[UIImage imageNamed:@"a_down_arrow.png"];
//    [RightBtn addSubview:arrowImage];
//
//    //导航栏
//    SearchBar = [[UISearchBar alloc] init];
//    SearchBar.frame = CGRectMake(0, 0, 200, 44);
//    SearchBar.placeholder = @"寻找商铺、商品";
//    SearchBar.delegate = self;
//    SearchBar.backgroundColor=[UIColor clearColor];
//    [SearchBar setTintColor:[UIColor clearColor]];
//    
//    for (UIView* view  in SearchBar.subviews) {
//        for (UIView* view1  in view.subviews) {
//            
//            if ([view1 isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
//            {
//                [view1 removeFromSuperview];
//                
//            }
//            if ([view1 isKindOfClass:[UITextField class]]) {
//                [DLIDEKeyboardView attachToTextView:(UITextField* )view1];
//            }
//        }
//    }
//    SearchBar.keyboardType = UIKeyboardTypeDefault;
//    [self.navigationItem setTitleView:SearchBar];
//    

    
//    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
//    title.text=@"附近";
//    title.textColor=[UIColor whiteColor];
//    title.shadowColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
//    title.shadowOffset=CGSizeMake(0, 0.2);
//    title.textAlignment=NSTextAlignmentCenter;
//    title.backgroundColor=[UIColor clearColor];
//    title.font=[UIFont boldSystemFontOfSize:20];
//    UIView* titleview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
//    [titleview addSubview:lableView];
//    [self.navigationItem setTitleView:TitleView];
    
 
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    LeftTable =[[B_LeftTableView alloc] initWithFrame:CGRectMake(-WWW, 0, WWW, SCREEN_HIGHE-110)];
    LeftTable.separatorColor=[UIColor whiteColor];
    LeftTable.alpha = .85f;
    LeftTable.hidden=LeftTable.IsHid;
    LeftTable.showsHorizontalScrollIndicator=NO;
    LeftTable.showsVerticalScrollIndicator=NO;
    LeftTable.separatorStyle=UITableViewCellSeparatorStyleNone;
//    LeftTable.backgroundColor=UIColorFromRGBA(0xeeeeee, 0.88);
    LeftTable.backgroundColor = [UIColor blackColor];
    [self.view addSubview:LeftTable];
    [LeftTable SetClickBlock:^(NSString * string) {
        [self LoadTable:string];
        [self LeftViewAct];
        
    }];

    [self LoadTable:@""];
    LeftTable.tableFooterView = [[UIView alloc] init];
}

-(void)LoadTable:(NSString *)string
{
//    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[string==nil||[string length]==0||[string intValue]==0 ?[NSString stringWithFormat: @"http://app.zipn.cn/app/recommand.jhtml?city=C0007", LocString] : [NSString stringWithFormat:@"http://app.zipn.cn/app/list.jhtml?city=%@&catId=%@",LocString,string] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/recommand.jhtml?city=%@", self.cityCode] ]];

    [NetRequest setASIPostDict:@{@"principal" : @"9f3141bd0252132648ae011320d9c735@20"}
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType8
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict) {
                          NSLog(@"----->RETURNDIC---->    %@",ReturnDict);
                          if ([[ReturnDict objectForKey:@"categories"] count]>0) {
                              [LeftTable setListArray:[ReturnDict objectForKey:@"categories"]];
                          }
                          
                          ListArray=[[NSArray alloc] initWithArray:[ReturnDict objectForKey:@"data"]];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [TableView reloadData];
                          });
                          
                      }
                      NetError:^(int error) {
                          
                      }
     ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([ListArray ObjectAtIndex:indexPath.row]==nil||[[ListArray ObjectAtIndex:indexPath.row] isEqual:[NSNull null]]||![[ListArray ObjectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    switch ([[[ListArray ObjectAtIndex:indexPath.row] ObjectForKey:@"showtype"] intValue]) {
        case 1:
            return 200;//店铺收藏动态
            break;
        case 2:
            return 95;//店铺发布新品
            break;
        case 3:
            return 200;//置顶店铺或者置顶商品
            break;
        case 4:
            return 105;//广告位
            break;
            
        default:
            return 200;
            break;
    }

    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = [indexPath row];
    if (LeftTable.frame.origin.x==0) {
        [self LeftViewAct];
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSLog(@"=====%@",[ListArray ObjectAtIndex:row]);
    if ([ListArray ObjectAtIndex:row]==nil||[[ListArray ObjectAtIndex:row] isEqual:[NSNull null]]||![[ListArray ObjectAtIndex:row] isKindOfClass:[NSDictionary class]]) {
        return cell;
    }
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch ([[[ListArray ObjectAtIndex:row] ObjectForKey:@"showtype"] intValue]) {
            case 1:
                [self Type1:cell Row:row];//店铺收藏动态
                break;
            case 2:
                [self Type2:cell Row:row];//店铺发布新品
                break;
            case 3:
                [self Type3:cell Row:row];//置顶店铺或者置顶商品
                break;
            case 4:
                [self Type4:cell Row:row];//广告位
                break;
                
            default:
                break;
        }

    });
    
    
    return cell;
}

-(void)goodAct:(UIButton *)sender
{
    NSArray *array = [sender.accessibilityValue componentsSeparatedByString:@","];
    
    B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
    B_GoodsDetailView.Dict=[[[[[ListArray ObjectAtIndex:[[array objectAtIndex:0] integerValue]] ObjectForKey:@"dataList"] ObjectAtIndex:[[array objectAtIndex:1] integerValue]] objectForKey:@"list"] objectAtIndex:[[array objectAtIndex:2] integerValue]];
    B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
}

-(void)shopSingleAct:(UIButton *)sender
{
    B_ShopDetailViewController *B_ShopDetailView=[[B_ShopDetailViewController alloc] init];
    B_ShopDetailView.Dict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLong:sender.tag],@"code", nil];
    B_ShopDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_ShopDetailView animated:YES];
}
-(void)Type1:(UITableViewCell* )cell Row:(long)row
{
    
    ActiveDict=[[NSDictionary alloc] initWithDictionary:[ListArray ObjectAtIndex:row]];
    
    UILabel* titileLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10,300, 24)];
    titileLabel.text=[ActiveDict ObjectForKey:@"title"];
    titileLabel.textColor=UIColorFromRGB(0x000000);
    titileLabel.backgroundColor=[UIColor clearColor];
    titileLabel.font=[UIFont systemFontOfSize:18];
    titileLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:titileLabel];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
     [cell.contentView addSubview:lineImage];
    
    UIScrollView *ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 165)];
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.pagingEnabled=YES;
    ScrollView.delegate=self;
    ScrollView.showsVerticalScrollIndicator=NO;
    ScrollView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:ScrollView];
    
    NSArray *array=[ActiveDict ObjectForKey:@"dataList"];
    ScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*[array count], 0);
    for (int i=0; i<[array count]; i++) {
        
        UIView *BackView=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i+5, 0, 310, 70)];
        [ScrollView addSubview:BackView];
        
        UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shopBtn.frame = CGRectMake(0, 10, 50, 50);
        shopBtn.tag=[[[array ObjectAtIndex:i] ObjectForKey:@"code"] longValue];
        shopBtn.accessibilityValue=[NSString stringWithFormat:@"%ld,%d",row,i];//[[array ObjectAtIndex:i] ObjectForKey:@"code"];
        [shopBtn sd_setImageWithURL:[NSURL URLWithString:[[array ObjectAtIndex:i] ObjectForKey:@"imageurl"]] forState:UIControlStateNormal];
        [shopBtn sd_setImageWithURL:[NSURL URLWithString:[[array ObjectAtIndex:i] ObjectForKey:@"imageurl"]] forState:UIControlStateHighlighted];
        [shopBtn addTarget:self action:@selector(shopSingleAct:) forControlEvents:UIControlEventTouchUpInside];
        [BackView addSubview:shopBtn];
        [[shopBtn layer] setMasksToBounds:YES];
        [[shopBtn layer] setCornerRadius:25];
        
        UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10,240, 20)];
        nameLabel.text=[[array ObjectAtIndex:i] ObjectForKey:@"title"];
        nameLabel.textColor=UIColorFromRGB(0x000000);
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:16];
        nameLabel.numberOfLines=10;
        nameLabel.textAlignment=UITextAlignmentLeft;
        [BackView addSubview:nameLabel];
        
        UILabel* contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 32,240, 20)];
        //contentLabel.text=@"今日特别优惠7折";
        contentLabel.textColor=UIColorFromRGB(0x888888);
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.font=[UIFont systemFontOfSize:12];
        contentLabel.numberOfLines=10;
        contentLabel.textAlignment=UITextAlignmentLeft;
        [BackView addSubview:contentLabel];
        
       
        NSArray *array1=[[array ObjectAtIndex:i] objectForKey:@"list"];
        if([array1 count]==0)
        {
            return;
        }
        UIScrollView *ScrollView1=[[UIScrollView alloc] initWithFrame:CGRectMake(5+SCREEN_WIDTH*i, 70, SCREEN_WIDTH-10, 94)];
        ScrollView1.showsHorizontalScrollIndicator=NO;
        ScrollView1.pagingEnabled=YES;
        ScrollView1.showsVerticalScrollIndicator=NO;
        ScrollView1.backgroundColor=[UIColor whiteColor];
        [ScrollView addSubview:ScrollView1];

        ScrollView1.contentSize=CGSizeMake(95*[array1 count], 0);
        for (int j=0; j<[array1 count]; j++) {

            UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            goodBtn.frame = CGRectMake(j*95, 0, 85, 85);
            goodBtn.tag=[[[array1 ObjectAtIndex:j] ObjectForKey:@"code"] longValue];
            goodBtn.accessibilityValue=[NSString stringWithFormat:@"%ld,%d,%d",row,i,j];//[[array ObjectAtIndex:i] ObjectForKey:@"code"];
            [goodBtn sd_setImageWithURL:[NSURL URLWithString:[[array1 ObjectAtIndex:j] ObjectForKey:@"imageurl"]] forState:UIControlStateNormal];
            [goodBtn sd_setImageWithURL:[NSURL URLWithString:[[array1 ObjectAtIndex:j] ObjectForKey:@"imageurl"]] forState:UIControlStateHighlighted];
            [goodBtn addTarget:self action:@selector(goodAct:) forControlEvents:UIControlEventTouchUpInside];
            [ScrollView1 addSubview:goodBtn];
            [[goodBtn layer] setMasksToBounds:YES];
            [[goodBtn layer] setCornerRadius:2];
        }

    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (LeftTable.frame.origin.x <0) {
        return;
    }
    [self LeftViewAct];
}


-(void)Type2:(UITableViewCell* )cell Row:(long)row
{
    UIScrollView *ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, 95)];
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    ScrollView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:ScrollView];
    
    NSArray *array=[[ListArray ObjectAtIndex:row] ObjectForKey:@"dataList"];
//    NSLog(@"array       %@", array);
    ScrollView.contentSize=CGSizeMake(90*[array count], 0);
    for (int i=0; i<[array count]; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(90*i, 0, 85, 85)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[array ObjectAtIndex:i] ObjectForKey:@"imageurl"]]];
        [ScrollView addSubview:imageView];
        [[imageView layer] setMasksToBounds:YES];
        [[imageView layer] setCornerRadius:2];
    }
}

-(void)Type3:(UITableViewCell* )cell Row:(long)row
{
    UILabel* titileLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10,300, 24)];
    titileLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"title"];
    titileLabel.textColor=UIColorFromRGB(0x000000);
    titileLabel.backgroundColor=[UIColor clearColor];
    titileLabel.font=[UIFont systemFontOfSize:16];
    titileLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:titileLabel];
    
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.hidden=[[[ListArray ObjectAtIndex:row] ObjectForKey:@"showmore"]intValue]==0;
    moreBtn.frame = CGRectMake(SCREEN_WIDTH-60, 10,60, 20);
    [moreBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:15]];
    moreBtn.tag=row;
    [moreBtn setTitle:@"更多\ue621" forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多\ue621" forState:UIControlStateHighlighted];
    [moreBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [moreBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateSelected];
    if([[[ListArray ObjectAtIndex:row] ObjectForKey:@"moretype"]intValue]==1)
    {
        [moreBtn addTarget:self action:@selector(MoreShopAct:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [moreBtn addTarget:self action:@selector(MoreGoodsAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.contentView addSubview:moreBtn];
    
    UIScrollView *ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(5, 40, SCREEN_WIDTH-10, 160)];
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    ScrollView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:ScrollView];

    NSArray *array=[[ListArray ObjectAtIndex:row] ObjectForKey:@"dataList"];
    ScrollView.contentSize=CGSizeMake(110*[array count], 0);
    for (int i=0; i<[array count]; i++) {
        
        UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shopBtn.frame = CGRectMake(110*i, 0, 105, 105);
        shopBtn.tag=[[[array ObjectAtIndex:i] ObjectForKey:@"code"] intValue];
        shopBtn.accessibilityValue=[NSString stringWithFormat:@"%ld,%d",row,i];//[[array ObjectAtIndex:i] ObjectForKey:@"code"];
        [shopBtn sd_setImageWithURL:[NSURL URLWithString:[[array ObjectAtIndex:i] ObjectForKey:@"imageurl"]] forState:UIControlStateNormal];
        [shopBtn sd_setImageWithURL:[NSURL URLWithString:[[array ObjectAtIndex:i] ObjectForKey:@"imageurl"]] forState:UIControlStateHighlighted];
        [shopBtn addTarget:self action:@selector(shopAct:) forControlEvents:UIControlEventTouchUpInside];
        [ScrollView addSubview:shopBtn];
        [[shopBtn layer] setMasksToBounds:YES];
        [[shopBtn layer] setCornerRadius:2];
        
//        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(110*i, 0, 105, 105)];
//        imageView.imageURL=[NSURL URLWithString:[[array ObjectAtIndex:i] ObjectForKey:@"imageurl"]];
//        [ScrollView addSubview:imageView];
//        [[imageView layer] setMasksToBounds:YES];
//        [[imageView layer] setCornerRadius:2];
        
        UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(110*i, 115,100, 20)];
        nameLabel.text=[[array ObjectAtIndex:i] ObjectForKey:@"title"];
        nameLabel.textColor=UIColorFromRGB(0x000000);
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:13];
        nameLabel.textAlignment=UITextAlignmentCenter;
        [ScrollView addSubview:nameLabel];
        
        UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(110*i, 135,100, 20)];
        switch ([[[array ObjectAtIndex:i] ObjectForKey:@"type"] intValue]) {
            case 1:
            case 4:
                priceLabel.text=[NSString stringWithFormat:@"%@",[[array ObjectAtIndex:i] ObjectForKey:@"area"]];
                break;
            case 2:
            case 3:
                priceLabel.text=[NSString stringWithFormat:@"¥%@",[[array ObjectAtIndex:i] ObjectForKey:@"price"]];
                break;
                
            default:
                break;
        }
        
        priceLabel.textColor=UIColorFromRGB(0x888888);
        priceLabel.textAlignment=UITextAlignmentCenter;
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.font=[UIFont systemFontOfSize:12];
        [ScrollView addSubview:priceLabel];
        
    }
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 199.5, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [cell.contentView addSubview:lineImage];
}

-(void)shopAct:(UIButton *)sender
{
    NSLog(@"====%@",sender.accessibilityValue);
    
    NSArray *array = [sender.accessibilityValue componentsSeparatedByString:@","];
    
    
    switch ([[[[[ListArray ObjectAtIndex:[[array objectAtIndex:0] intValue]] ObjectForKey:@"dataList"] ObjectAtIndex:[[array objectAtIndex:1] intValue]] ObjectForKey:@"type"] intValue]) {
        case 1:
        case 4:
        {
            B_ShopDetailViewController *B_ShopDetailView=[[B_ShopDetailViewController alloc] init];
            B_ShopDetailView.Dict=[[[ListArray ObjectAtIndex:[[array objectAtIndex:0] intValue]] ObjectForKey:@"dataList"] ObjectAtIndex:[[array objectAtIndex:1] intValue]];
            B_ShopDetailView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:B_ShopDetailView animated:YES];
        }
            break;
        case 2:
        case 3:
        {
            B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
            B_GoodsDetailView.Dict=[[[ListArray ObjectAtIndex:[[array objectAtIndex:0] intValue]] ObjectForKey:@"dataList"] ObjectAtIndex:[[array objectAtIndex:1] intValue]];
            B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
        }
            break;
            
        default:
            break;
    }
    

}

-(void)Type4:(UITableViewCell* )cell Row:(long)row
{
    UIScrollView *ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,  0, SCREEN_WIDTH, 110)];
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    ScrollView.pagingEnabled=YES;
    ScrollView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:ScrollView];
    
    NSArray *array=[[ListArray ObjectAtIndex:row] ObjectForKey:@"dataList"];
    ScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*[array count], 0);
    for (int i=0; i<[array count]; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 110)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[array ObjectAtIndex:i] ObjectForKey:@"imageurl"]]];
        [ScrollView addSubview:imageView];
        [[imageView layer] setMasksToBounds:YES];
        [[imageView layer] setCornerRadius:2];
        
    }

}

-(void)MoreShopAct:(UIButton *)sender
{
    B_ShopListViewController *B_ShopListView=[[B_ShopListViewController alloc] init];
    B_ShopListView.title=[[ListArray ObjectAtIndex:sender.tag] ObjectForKey:@"title"];
    B_ShopListView.CatId=[[ListArray ObjectAtIndex:sender.tag] ObjectForKey:@"code"];
    [B_ShopListView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:B_ShopListView animated:YES];
}

-(void)MoreGoodsAct:(UIButton *)sender
{
    B_GoodsMoreListController *B_GoodsMoreList=[[B_GoodsMoreListController alloc] init];
    B_GoodsMoreList.title=[[ListArray ObjectAtIndex:sender.tag] ObjectForKey:@"title"];
    B_GoodsMoreList.CatId=[[ListArray ObjectAtIndex:sender.tag] ObjectForKey:@"code"];
    [B_GoodsMoreList setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:B_GoodsMoreList animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)RightAct
{
    B_LocationViewController *B_LocationView=[[B_LocationViewController alloc] init];
    B_LocationView.Location=Location;
    [B_LocationView setLocationBlock:^(NSString *city) {
        [RightBtn setTitle:city forState:UIControlStateNormal];
        [RightBtn setTitle:city forState:UIControlStateHighlighted];
        LocString=city;
        [self LoadTable:@""];
    }];
    [B_LocationView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:B_LocationView animated:NO];
}

-(void)LeftViewAct
{
    if (LeftTable.hidden == YES) {
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            LeftTable.hidden=!LeftTable.isHidden;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.25f animations:^{
                LeftTable.frame=CGRectMake(LeftTable.frame.origin.x==-WWW?0:-WWW, 0, WWW, SCREEN_HIGHE-114);
            }];
        }];
    }else{
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            LeftTable.frame=CGRectMake(LeftTable.frame.origin.x==-WWW?0:-WWW, 0, WWW, SCREEN_HIGHE-114);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1f animations:^{
                LeftTable.hidden=!LeftTable.isHidden;
            }];
        }];

    }
    
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showCategory
{
    [self LeftViewAct];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
     [searchBar resignFirstResponder];
    B_ShopSearchViewController *B_ShopSearch=[[B_ShopSearchViewController alloc] init];
    B_ShopSearch.KeyWord=searchBar.text;
    B_ShopSearch.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_ShopSearch animated:YES];
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

@end
