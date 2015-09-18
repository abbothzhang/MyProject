//
//  C_NearByViewController.m
//  至品购物
//
//  Created by 夏科杰 on 14-9-6.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "C_NearByViewController.h"
#import "UIImageView+WebCache.h"
#import "B_ShopDetailViewController.h"
#import "GlobalHead.h"
#import "MJRefresh.h"

#define HEIGHT 105
@interface C_NearByViewController ()
{
    NSString *cityCode;
}

@end

@implementation C_NearByViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        BtnArray=[NSMutableArray new];
        ListArray = [[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}

-(void)LocalAct:(UIButton *)sender
{
    [self.navigationController pushViewController:[NSClassFromString(@"B_ShoppingListViewController") new] animated:YES];
}

-(void)titleAct:(UIButton *)sender
{
    for (UIButton *btn in BtnArray) {
        btn.selected=NO;
    }
    sender.selected=YES;
    SelectIndex=sender.tag+1;
     [self SearchShoppingOrder:[NSString stringWithFormat:@"%ld",SelectIndex]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    cityCode = [defaults objectForKey:@"cityCode"];
    SelectIndex=1;
    PageIndex=1;
    [self SearchShoppingOrder:[NSString stringWithFormat:@"%ld",SelectIndex]];
 
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SelectIndex=1;
    PageIndex=1;

    
    UILabel *lableView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    lableView.text=@"附近";
    lableView.textColor=[UIColor whiteColor];
    lableView.shadowColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
    lableView.shadowOffset=CGSizeMake(0, 0.2);
    lableView.textAlignment=NSTextAlignmentCenter;
    lableView.backgroundColor=[UIColor clearColor];
    lableView.font=[UIFont boldSystemFontOfSize:20];
    UIView* TitleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    [TitleView addSubview:lableView];
    [self.navigationItem setTitleView:TitleView];
    
    UIButton *leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [leftBtn setTitle:@"\ue615" forState:UIControlStateNormal];
    [leftBtn setTitle:@"\ue615" forState:UIControlStateSelected];
    [leftBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [leftBtn setTitleColor:STYLECLOLR               forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(LocalAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftBtn]];
    
//    UIButton *rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
//    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:30]];
//    [rightBtn setTitle:@"\ue62f" forState:UIControlStateNormal];
//    [rightBtn setTitle:@"\ue62f" forState:UIControlStateSelected];
//    [rightBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    [rightBtn setTitleColor:STYLECLOLR               forState:UIControlStateSelected];
//    [rightBtn addTarget:self action:@selector(LocalAct:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBtn]];
    
    NSArray *titileArray=@[@"推荐",@"人气",@"距离",@"价格"];
    float w = SCREEN_WIDTH / 4;
    for (int i=0; i<4; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(w * i, 0, w, 33);
        titleBtn.tag=i;
        if (i==0) {
            titleBtn.selected=YES;
        }
        [titleBtn setTitle:[titileArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitle:[titileArray objectAtIndex:i] forState:UIControlStateHighlighted];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [titleBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [titleBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(titleAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:titleBtn];
        [BtnArray addObject:titleBtn];
        [[titleBtn layer]setBorderWidth:0.5];
        [[titleBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    }
    
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HIGHE-148)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
//    TableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:TableView];
    

    [self SearchShoppingOrder:[NSString stringWithFormat:@"%ld",SelectIndex]];


    
    // Do any additional setup after loading the view.
}

-(void)SearchShoppingOrder:(NSString *)string
{

    PageIndex=1;
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/near/list.jhtml?city=%@&order=%@&page=%ld&size=10&x=%lf&y=%lf",cityCode ,string,PageIndex++,Location.longitude,Location.latitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessUnType
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"%@",ReturnDict);
                          if ([[ReturnDict objectForKey:@"data"] count]<10) {
                              [TableView removeFooter];
                          }
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[ReturnDict objectForKey:@"data"]];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [TableView reloadData];
                          });
                      }
                      NetError:^(int error) {
                      }
     ];
    
    // 上拉刷新
    __weak UITableView* tableView=TableView;
    __weak NSMutableArray *listArray=ListArray;
    [TableView addLegendFooterWithRefreshingBlock:^{
        
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/near/list.jhtml?city=杭州&order=%ld&page=%ld&size=10&x=%lf&y=%lf",SelectIndex,PageIndex++,Location.longitude,Location.latitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [NetRequest setASIPostDict:nil
                           ApiName:@""
                         CanCancel:YES
                       SetHttpType:HttpGet
                         SetNotice:NoticeType1
                        SetNetWork:NetWorkTypeAS
                        SetProcess:ProcessUnType
                        SetEncrypt:Encryption
                          SetCache:Cache
                          NetBlock:^(NSDictionary *ReturnDict){
                              if ([[ReturnDict objectForKey:@"data"] count]<10) {
                                  [TableView removeFooter];
                              }
                              [listArray addObjectsFromArray:[ReturnDict objectForKey:@"data"]];
                              [tableView.footer endRefreshing];
                              [tableView reloadData];
                          }
                          NetError:^(int error) {
                          }
         ];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];
    
    UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 75, 75)];
    [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageurl" ]]];
    [cell.contentView addSubview:iconImage];
    
    
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(105, 10,160, [[[ListArray ObjectAtIndex:row] ObjectForKey:@"title" ] length]>12?40:30)];
    titleLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"title"];
    titleLabel.textColor=UIColorFromRGB(0x000000);
    titleLabel.numberOfLines=2;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];
    
    NSMutableString *starString=[[NSMutableString alloc] init];
    for (int i=0; i<[[[ListArray ObjectAtIndex:row] ObjectForKey:@"score"] intValue]; i++) {
        [starString appendString:@"\ue630"];
    }
    
    UILabel* starLabel=[[UILabel alloc] initWithFrame:CGRectMake(105, 48,200, 16)];
    starLabel.text=starString;
    [starLabel setFont:[UIFont fontWithName:@"icomoon" size:13]];
    starLabel.textColor=UIColorFromRGB(0xfad72e);
    starLabel.backgroundColor=[UIColor clearColor];
    starLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:starLabel];
    
    UIImageView *dotImage=[[UIImageView alloc] initWithFrame:CGRectMake(182, 51, 10, 10)];
    switch ([[[ListArray ObjectAtIndex:row] ObjectForKey:@"status"] intValue]) {
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
    [cell.contentView  addSubview:dotImage];
    [[dotImage layer] setMasksToBounds:YES];
    [[dotImage layer] setCornerRadius:5];
    
    UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(205, 48,100, 16)];
    moneyLabel.text=[NSString stringWithFormat:@"¥%@/人",[[ListArray ObjectAtIndex:row] ObjectForKey:@"price"]];
    moneyLabel.textColor=UIColorFromRGB(0x000000);
    moneyLabel.backgroundColor=[UIColor clearColor];
    moneyLabel.font=[UIFont systemFontOfSize:12];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:moneyLabel];
        ;
    
    UILabel* addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(105, 73,200, 16)];
    addressLabel.text=[NSString stringWithFormat:@"%@         %@",[[ListArray ObjectAtIndex:row] ObjectForKey:@"area"],[[ListArray ObjectAtIndex:row] ObjectForKey:@"category"]];
    addressLabel.textColor=UIColorFromRGB(0x000000);
    addressLabel.backgroundColor=[UIColor clearColor];
    addressLabel.font=[UIFont systemFontOfSize:12];
    addressLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:addressLabel];
    
    UILabel* distanceLabel=[[UILabel alloc] initWithFrame:CGRectMake(265, 23,50, 16)];
    distanceLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"distance"];
    distanceLabel.textColor=UIColorFromRGB(0x000000);
    distanceLabel.backgroundColor=[UIColor clearColor];
    distanceLabel.font=[UIFont systemFontOfSize:10];
    distanceLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:distanceLabel];
    
    
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(290*WITH_SCALE, 40,40,40)];
    arrowLabel.text=@"\ue629";
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel.textColor=UIColorFromRGB(0x888888);
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:arrowLabel];
    
    
       
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, HEIGHT-0.5, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    B_ShopDetailViewController *B_ShopDetailView=[[B_ShopDetailViewController alloc] init];
    B_ShopDetailView.Dict=[ListArray objectAtIndex:[indexPath row]];
    B_ShopDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_ShopDetailView animated:YES];

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
