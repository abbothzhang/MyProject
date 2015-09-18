//
//  D_ShoppingCarController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/19.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_ShoppingCarController.h"
#import "StrikeThroughLabel.h"
#define HEIGHT 116
@interface D_ShoppingCarController ()

@end

@implementation D_ShoppingCarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"购物车";
        // Custom initialization
    }
    return self;
}

-(void)editAct
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    float money=0;
    for (NSDictionary *dict in ListArray) {
        money+=[[dict ObjectForKey:@"price"] floatValue];
    }
    PriceLabel.text=[NSString stringWithFormat:@"¥%.1f",money];
    TitleLabel.text=[NSString stringWithFormat:@"共%d项   合计：",[ListArray count]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *editBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑" forState:UIControlStateHighlighted];
    [editBtn addTarget:self action:@selector(editAct) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:editBtn]];
    
    
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/cart/list.jhtml"]];
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
                          
                      }
                      NetError:^(int error) {
                      }
     ];
   // [ListArray addObjectsFromArray:[G_ShopCar allValues]];
    NSLog(@"==%@",ListArray);
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64-40)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    UIView *downView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHE-64-40, SCREEN_WIDTH, 40)];
    [self.view addSubview:downView];
    
    [[downView layer]setBorderWidth:1];
    [[downView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    
    TitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(160, 0,100, 40)];
    TitleLabel.textColor=UIColorFromRGB(0xaeaeae);
    TitleLabel.backgroundColor=[UIColor clearColor];
    TitleLabel.font=[UIFont systemFontOfSize:13];
    TitleLabel.textAlignment=NSTextAlignmentRight;
    [downView addSubview:TitleLabel];
    
    
    PriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(260, 0,50, 40)];
    PriceLabel.text=@"¥0.0";
    PriceLabel.textColor=UIColorFromRGB(0xff5000);
    PriceLabel.backgroundColor=[UIColor clearColor];
    PriceLabel.font=[UIFont systemFontOfSize:13];
    PriceLabel.textAlignment=NSTextAlignmentLeft;
    [downView addSubview:PriceLabel];
    
    
    // Do any additional setup after loading the view.
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
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 96, 96)];
    [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageurl" ]]];
    [cell.contentView addSubview:iconImage];
    
    
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(125, 10,160, [[[ListArray ObjectAtIndex:row] ObjectForKey:@"title" ] length]>12?40:30)];
    titleLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"title"];
    titleLabel.textColor=UIColorFromRGB(0x000000);
    titleLabel.numberOfLines=2;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];
    
    UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(124, 58,100, 18)];
    moneyLabel.text=[NSString stringWithFormat:@"¥%.1f",[[[ListArray ObjectAtIndex:row] ObjectForKey:@"price"] floatValue]];
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
    
    UIImageView *lineImagel=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 1)];
    lineImagel.backgroundColor=UIColorFromRGB(0x666666);
    [originalLabel addSubview:lineImagel];
    
    
    UILabel* evaluateLabel=[[UILabel alloc] initWithFrame:CGRectMake(125, 85,100, 20)];
    evaluateLabel.text=[NSString stringWithFormat:@"%d人点评",[[[ListArray ObjectAtIndex:row] ObjectForKey:@"evaluateCount"] intValue]];
    evaluateLabel.textColor=UIColorFromRGB(0x999999);
    evaluateLabel.backgroundColor=[UIColor clearColor];
    evaluateLabel.font=[UIFont systemFontOfSize:12];
    evaluateLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:evaluateLabel];
    
    
    
    UIView *addBtn=[[UIView alloc]initWithFrame:CGRectMake(220, 75, 85, 28)];
    [cell.contentView addSubview:addBtn];
    [[addBtn layer]setBorderWidth:1];
    [[addBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    UIButton *minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minBtn.frame = CGRectMake(0, 0, 28, 28);
    [minBtn setTitle:@"—" forState:UIControlStateNormal];
    [minBtn setTitle:@"—" forState:UIControlStateHighlighted];
    [minBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [minBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    // [minBtn addTarget:self action:@selector(collectAct) forControlEvents:UIControlEventTouchUpInside];
    [addBtn addSubview:minBtn];
    
    UILabel *numLabel=[[UILabel alloc] initWithFrame:CGRectMake(28, 0, 29, 28)];
    numLabel.text=@"1";
    numLabel.textColor=UIColorFromRGB(0x666666);
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.font=[UIFont systemFontOfSize:12];
    numLabel.textAlignment=NSTextAlignmentCenter;
    [addBtn addSubview:numLabel];
    [[numLabel layer]setBorderWidth:1];
    [[numLabel layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.frame = CGRectMake(57, 0, 28, 28);
    [plusBtn setTitle:@"＋" forState:UIControlStateNormal];
    [plusBtn setTitle:@"＋" forState:UIControlStateHighlighted];
    [plusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [plusBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    // [plusBtn addTarget:self action:@selector(collectAct) forControlEvents:UIControlEventTouchUpInside];
    [addBtn addSubview:plusBtn];
    
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,HEIGHT -0.5, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}
-(void)ArrowAct:(UIButton *)sender
{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray ObjectAtIndex:[indexPath row]]];
    [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
    [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
    
//    B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
//    B_GoodsDetailView.Dict=dict;
//    B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
   // [G_ShopCar removeObjectForKey:[[ListArray ObjectAtIndex:row] ObjectForKey:@"code"]];
    [ListArray removeAllObjects];
  //  [ListArray addObjectsFromArray:[G_ShopCar allValues]];

    float money=0;
    for (NSDictionary *dict in ListArray) {
        money+=[[dict ObjectForKey:@"price"] floatValue];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        PriceLabel.text=[NSString stringWithFormat:@"¥%.1f",money];
        TitleLabel.text=[NSString stringWithFormat:@"共%lu项   合计：",[ListArray count]];
    });

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
