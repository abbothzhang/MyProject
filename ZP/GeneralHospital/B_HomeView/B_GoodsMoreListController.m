//
//  B_GoodsMoreListController.m
//  zhipin
//
//  Created by 夏科杰 on 15/2/15.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//
#import "StrikeThroughLabel.h"
#import "B_GoodsMoreListController.h"
#import "B_GoodsDetailViewController.h"
@interface B_GoodsMoreListController ()

@end

@implementation B_GoodsMoreListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    ListArray=[[NSMutableArray alloc] init];
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/product/list.jhtml?city=C0007&catId=%@",_CatId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[ReturnDict objectForKey:@"data"]];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [TableView reloadData];
                          });
                      }
                      NetError:^(int error) {
                      }
     ];
    
    
    
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
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%d",[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];
    
    UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 85, 85)];
    [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageurl" ]]];
    [cell.contentView addSubview:iconImage];
    
    
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(125, 10,160, [[[ListArray ObjectAtIndex:row] ObjectForKey:@"name" ] length]>12?40:30)];
    titleLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"name"];
    titleLabel.textColor=UIColorFromRGB(0x000000);
    titleLabel.numberOfLines=2;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];
    
    UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(124, 58,100, 18)];
    moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ListArray ObjectAtIndex:row] ObjectForKey:@"price"] floatValue]];
    moneyLabel.textColor=UIColorFromRGB(0xfc4f01);
    moneyLabel.backgroundColor=[UIColor clearColor];
    moneyLabel.font=[UIFont systemFontOfSize:16];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:moneyLabel];
    
    
    StrikeThroughLabel* originalLabel=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(190, 58,200, 16)];
    originalLabel.strikeThroughEnabled = YES;
    originalLabel.text=[NSString stringWithFormat:@"¥%.1f",[[[ListArray ObjectAtIndex:row] ObjectForKey:@"originalPrice"] floatValue]];
    [originalLabel setFont:[UIFont fontWithName:@"icomoon" size:14]];
    originalLabel.textColor=UIColorFromRGB(0x999999);
    originalLabel.backgroundColor=[UIColor clearColor];
    originalLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:originalLabel];
    
    UILabel* evaluateLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, 85,100, 20)];
    evaluateLabel.text=[NSString stringWithFormat:@"%@人点评",[[ListArray ObjectAtIndex:row] ObjectForKey:@"evaluateCount"]];
    evaluateLabel.textColor=UIColorFromRGB(0x999999);
    evaluateLabel.backgroundColor=[UIColor clearColor];
    evaluateLabel.font=[UIFont systemFontOfSize:12];
    evaluateLabel.textAlignment=NSTextAlignmentRight;
    [cell.contentView addSubview:evaluateLabel];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 104.5, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray ObjectAtIndex:[indexPath row]]];
    [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
    [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
    
    B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
    B_GoodsDetailView.Dict=dict;
    B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
    
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
