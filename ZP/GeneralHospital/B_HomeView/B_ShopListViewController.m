//
//  ShopListViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-13.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "B_ShopListViewController.h"
#import "B_ShopDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface B_ShopListViewController ()

@end

@implementation B_ShopListViewController
@synthesize CatId;
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
    PageIndex=1;
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    ListArray=[[NSMutableArray alloc] init];
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/list.jhtml?catId=%@&city=C0007&page=%ld&size=10&order=4&x=1&y=3",CatId,PageIndex++] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
                          NSLog(@"RETURN    %@",ReturnDict);
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
        
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/list.jhtml?catId=%@&city=C0007&page=%ld&size=10&order=4&x=1&y=3",CatId,PageIndex++] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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

    
    
    
    // Do any additional setup after loading the view.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
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
    
    UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(205, 48,100, 16)];
    moneyLabel.text=[NSString stringWithFormat:@"¥%@/人",[[ListArray ObjectAtIndex:row] ObjectForKey:@"price"]];
    moneyLabel.textColor=UIColorFromRGB(0x000000);
    moneyLabel.backgroundColor=[UIColor clearColor];
    moneyLabel.font=[UIFont systemFontOfSize:12];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:moneyLabel];
    
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
    
    
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(290, 40,40, 40)];
    arrowLabel.text=@"\ue629";
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel.textColor=UIColorFromRGB(0x888888);
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:arrowLabel];
    
    
    
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 104.5, SCREEN_WIDTH-10, 0.5)];
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
