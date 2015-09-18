//
//  D_AddressListViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14/12/27.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_AddressListViewController.h"
#import "D_AddAddressViewController.h"
#import "D_EditAddressViewController.h"
#import "MJRefresh.h"
#define HEIGHT 85
@interface D_AddressListViewController ()

@end

@implementation D_AddressListViewController

-(void)addAct
{
    D_AddAddressViewController *D_AddAddress=[[D_AddAddressViewController alloc] init];
    D_AddAddress.title=@"新增地址";
    [self.navigationController pushViewController:D_AddAddress animated:YES];
}

-(void)setAddressDict:(AddressDict)addressDict
{
    AddDict=addressDict;
}

- (void)requestAddressData
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/receiver/list.jhtml?page=1"]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"%@",ReturnDict);
                          [TableView.header endRefreshing];

                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[ReturnDict objectForKey:@"data"]];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [TableView reloadData];
                          });
                          NSLog(@"====%@",ListArray);
                      }
                      NetError:^(int error) {
                      }
     ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAddressData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAddress:) name:@"updateAddress" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title=@"我的地址";
    ListArray=[[NSMutableArray alloc] init];
    self.view.backgroundColor=UIColorFromRGB(0xf8f8f8);
    UIButton *addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitle:@"添加" forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addAct) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:addBtn]];
    
    
    NSLog(@"==%@",ListArray);
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, SCREEN_HIGHE-64-16)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    __weak __typeof(self)weakSelf = self;

    [TableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requestAddressData];
    }];
 
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
    cell.backgroundColor=[UIColor whiteColor];
    
    
    
    UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10,100,20)];
    nameLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"consignee"];
    nameLabel.textColor=UIColorFromRGB(0x000000);
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:nameLabel];
    
    UILabel* phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 10,100,20)];
    phoneLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"phone"];
    phoneLabel.textColor=UIColorFromRGB(0x888888);
    phoneLabel.backgroundColor=[UIColor clearColor];
    phoneLabel.font=[UIFont systemFontOfSize:14];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:phoneLabel];
    
    UILabel* addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 40,280,35)];
    addressLabel.text=[[[ListArray ObjectAtIndex:row] ObjectForKey:@"areaName"] stringByAppendingString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"address"]];
    addressLabel.textColor=UIColorFromRGB(0x888888);
    addressLabel.backgroundColor=[UIColor clearColor];
    addressLabel.font=[UIFont systemFontOfSize:14];
    addressLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:addressLabel];

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
    if (AddDict==nil) {
        D_EditAddressViewController *D_EditAddress=[[D_EditAddressViewController alloc] init];
        D_EditAddress.title=@"修改地址";
        D_EditAddress.InfoDict=[ListArray ObjectAtIndex:[indexPath row]];
        NSLog(@"DIC     %@", ListArray [indexPath.row   ]);
        [self.navigationController pushViewController:D_EditAddress animated:YES];
    }else
    {
        AddDict([ListArray ObjectAtIndex:[indexPath row]]);
        [self.navigationController popViewControllerAnimated:YES];
    }

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
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/receiver/delete.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:[[ListArray ObjectAtIndex:row] ObjectForKey:@"id"],@"id", nil]
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
                          [ListArray removeObjectAtIndex:row];
                          [TableView reloadData];
                      }
                      NetError:^(int error) {
                      }
     ];
    
 
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark - 通知 Notification
- (void)updateAddress: (NSNotification *)noti
{
    NSDictionary *dic = [noti object];
    NSInteger index = [[[dic allKeys] firstObject] integerValue];
    NSDictionary *updatedDic = [[dic allKeys] firstObject];
    [ListArray replaceObjectAtIndex:index withObject:updatedDic];
    [TableView reloadData];
}


- (void)didReceiveMemoryWarning
{
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
