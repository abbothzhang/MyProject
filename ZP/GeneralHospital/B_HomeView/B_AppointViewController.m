//
//  B_AppointViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/4.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_AppointViewController.h"
#import "B_CheckstandViewController.h"
#import "B_AppointCommetViewController.h"
#import "B_AppointDetailViewController.h"
@interface B_AppointViewController ()

@end

@implementation B_AppointViewController
-(void)backAct:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(LoadData) withObject:nil afterDelay:0.5];
    
}
-(void)LoadData
{
    [self selectIndex:SegmentedControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预约";
    ListArray=[[NSMutableArray alloc] init];
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
    [btn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [btn setTitle:@"\ue626" forState:UIControlStateNormal];
    [btn setTitle:@"\ue626" forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"处理中",@"已完成",nil];
    SegmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    SegmentedControl.frame = CGRectMake(60.0, 5.0, 200.0, 30.0);
    SegmentedControl.selectedSegmentIndex = 0;//设置默认选择项索0
    SegmentedControl.tintColor = STYLECLOLR;
    SegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;//设置样式
    [SegmentedControl addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:SegmentedControl];
    
    
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HIGHE-104)];
    TableView.backgroundColor=UIColorFromRGBA(0xf5f5f5,0.9);
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];

    // Do any additional setup after loading the view.
}

-(void)selectIndex:(UISegmentedControl *)sender
{
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/preorder/list.jhtml?status=%ld&page=1",sender.selectedSegmentIndex+1]]];
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
                                  [ListArray removeAllObjects];
                                  [ListArray addObjectsFromArray:[ReturnDict objectForKey:@"data"]];
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [TableView reloadData];
                                  });
                              }
                              NetError:^(int error) {
                              }
             ];
        });
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 168+[[[ListArray objectAtIndex:[indexPath row]] ObjectForKey:@"itemList"] count]*100;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}

-(void)ShopDetailAct:(UIButton *)sender
{
    B_AppointDetailViewController *B_AppointDetail=[[B_AppointDetailViewController alloc] init];
    B_AppointDetail.OrderId=[[ListArray objectAtIndex:sender.tag] objectForKey:@"orderId"];
    B_AppointDetail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_AppointDetail animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    NSArray *cellArray=[[[ListArray objectAtIndex:row] ObjectForKey:@"itemList"] copy];
    
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 14, SCREEN_WIDTH, 154+100*[cellArray count])];
    backView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:backView];
    
    UIButton *shopDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    shopDetail.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    shopDetail.tag=row;
    [shopDetail addTarget:self action:@selector(ShopDetailAct:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:shopDetail];
    
    UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(12.5, 0,200, 45)];
    nameLabel.text=[[ListArray objectAtIndex:row] ObjectForKey:@"shopName"];
    nameLabel.textColor=UIColorFromRGB(0x000000);
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.font=[UIFont boldSystemFontOfSize:13];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [shopDetail addSubview:nameLabel];
    
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 0,200, 45)];
    arrowLabel.text=@"\ue629";
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:18]];
    arrowLabel.textColor=UIColorFromRGB(0x666666);
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textAlignment=NSTextAlignmentRight;
    [shopDetail addSubview:arrowLabel];
    
    for(int i=0;i<[cellArray count];i++)
    {
        UIView *cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 59+100*i, SCREEN_WIDTH+100, 100)];
        cellView.tag=i;
        [cell.contentView addSubview:cellView];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 100);
        deleteBtn.accessibilityLanguage=[NSString stringWithFormat:@"%d,%d",row,i];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitle:@"删除" forState:UIControlStateHighlighted];
        deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [deleteBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xff0000)]
                             forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xff0000)]
                             forState:UIControlStateSelected];
        //[deleteBtn addTarget:self action:@selector(deleteAct:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:deleteBtn];
        
//        UISwipeGestureRecognizer* leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
//                                                                                             action:@selector(handleLeftSwipes:)];
//        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//        [cellView addGestureRecognizer:leftRecognizer];
//        
//        UISwipeGestureRecognizer* rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
//                                                                                              action:@selector(handleRightSwipes:)];
//        rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//        [cellView addGestureRecognizer:rightRecognizer];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, SCREEN_WIDTH-20, 0.5)];
        lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
        [cellView addSubview:lineImage];
        
        UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(12.5, 20, 60, 60)];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[[cellArray ObjectAtIndex:i] ObjectForKey:@"image"]]];
        [cellView addSubview:iconImage];
        [[iconImage layer] setMasksToBounds:YES];
        [[iconImage layer] setCornerRadius:2];
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(82.5,  20,180, 30)];
        titleLabel.text=[[cellArray ObjectAtIndex:i] ObjectForKey:@"name"];
        titleLabel.textColor=UIColorFromRGB(0x333333);
        titleLabel.numberOfLines=5;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:12];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:titleLabel];
        
        UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(250, 20,57,20)];
        priceLabel.text=[NSString stringWithFormat:@"¥%@",[[cellArray ObjectAtIndex:i] ObjectForKey:@"price"]];
        priceLabel.textColor=UIColorFromRGB(0x333333);
        priceLabel.numberOfLines=5;
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.font=[UIFont systemFontOfSize:12];
        priceLabel.textAlignment=NSTextAlignmentRight;
        [cellView addSubview:priceLabel];
        
        NSMutableString *mString=[[NSMutableString alloc] init];
        for(NSString *string in [[cellArray ObjectAtIndex:i] ObjectForKey:@"specificationList"])
        {
            [mString appendFormat:@"%@\n",string];
        }
        UILabel* areaLabel=[[UILabel alloc] initWithFrame:CGRectMake(82.5, 50,120, 50)];
        areaLabel.text=mString;
        areaLabel.numberOfLines=10;
        areaLabel.textColor=UIColorFromRGB(0xaeaeae);
        areaLabel.backgroundColor=[UIColor clearColor];
        areaLabel.font=[UIFont systemFontOfSize:11];
        areaLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:areaLabel];
        
        UILabel *CodeLabel=[[UILabel alloc] initWithFrame:CGRectMake(250, 40, 57, 28)];
        CodeLabel.text=[NSString stringWithFormat:@"x%@",[[cellArray ObjectAtIndex:i] ObjectForKey:@"quantity"]];
        CodeLabel.textColor=UIColorFromRGB(0x666666);
        CodeLabel.backgroundColor=[UIColor clearColor];
        CodeLabel.font=[UIFont systemFontOfSize:12];
        CodeLabel.textAlignment=NSTextAlignmentRight;
        [cellView addSubview:CodeLabel];
        
        
    }
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,45+100*[cellArray count], SCREEN_WIDTH, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [backView addSubview:lineImage];
    
    UILabel* timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,45+100*[cellArray count],SCREEN_WIDTH-20, 33)];
    timeLabel.text=[NSString stringWithFormat:@"预约时间：%@    %@人",[[ListArray objectAtIndex:row] ObjectForKey:@"bookTime"],[[ListArray objectAtIndex:row] ObjectForKey:@"persons"]];
    timeLabel.numberOfLines=1;
    timeLabel.textColor=UIColorFromRGB(0x555555);
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[UIFont systemFontOfSize:13];
    timeLabel.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:timeLabel];
    
    UIImageView *lineImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,33+45+100*[cellArray count], SCREEN_WIDTH, 0.5)];
    lineImage1.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [backView addSubview:lineImage1];
    
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,33+45+100*[cellArray count],50, 35)];
    titleLabel.text=[NSString stringWithFormat:@"状态："];
    titleLabel.numberOfLines=1;
    titleLabel.textColor=UIColorFromRGB(0xaeaeae);
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:titleLabel];
    
    UILabel* stateLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 33+45+100*[cellArray count],80, 35)];
    stateLabel.text=[[ListArray objectAtIndex:row] ObjectForKey:@"orderStatus"];
    stateLabel.numberOfLines=1;
    stateLabel.textColor=UIColorFromRGB(0xff5000);
    stateLabel.backgroundColor=[UIColor clearColor];
    stateLabel.font=[UIFont systemFontOfSize:15];
    stateLabel.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:stateLabel];
    
    
    UILabel* numLabel=[[UILabel alloc] initWithFrame:CGRectMake(120,33+ 45+100*[cellArray count],130, 35)];
    numLabel.text=[NSString stringWithFormat:@"共%ld项   金额：",[cellArray count]];
    numLabel.numberOfLines=1;
    numLabel.textColor=UIColorFromRGB(0xaeaeae);
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.font=[UIFont systemFontOfSize:15];
    numLabel.textAlignment=NSTextAlignmentRight;
    [backView addSubview:numLabel];
    
    UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(250,33+ 45+100*[cellArray count],80, 35)];
    moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ListArray objectAtIndex:row] ObjectForKey:@"amount"] floatValue]];
    moneyLabel.numberOfLines=1;
    moneyLabel.textColor=UIColorFromRGB(0xff5000);
    moneyLabel.backgroundColor=[UIColor clearColor];
    moneyLabel.font=[UIFont systemFontOfSize:15];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:moneyLabel];
    
    /*
     预约状态，1-待付款，7-待确认，4-已完成，5-已取消，6-已点评
     
     预约状态，1-待付款，7-待确认，8-待点评，4-已完成，5-已取消，6-已点评
     
     待付款------>>付款+取消
     待确认-----
     （用户与商家共同确认订单）
     待点评------>>点评
     已完成------>>点评（系统自动完成的订单）
     
     */
    
    switch ([[[ListArray objectAtIndex:row] ObjectForKey:@"status"] intValue]) {
        case 1:
        {
            UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            payBtn.tag=row;
            payBtn.frame = CGRectMake(SCREEN_WIDTH-170, 33+80+100*[cellArray count], 70, 30);
            [payBtn setTitle:@"付款" forState:UIControlStateNormal];
            [payBtn setTitle:@"付款" forState:UIControlStateHighlighted];
            [payBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
            payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [payBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                              forState:UIControlStateNormal];
            [payBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                              forState:UIControlStateSelected];
            [payBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:payBtn];
            [[payBtn layer] setMasksToBounds:YES];
            [[payBtn layer] setCornerRadius:2];
            [[payBtn layer]setBorderWidth:1];
            [[payBtn layer]setBorderColor:[STYLECLOLR CGColor]];
            
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.tag=row;
            cancelBtn.frame = CGRectMake(SCREEN_WIDTH-90, 33+80+100*[cellArray count], 70, 30);
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
            cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [cancelBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                                 forState:UIControlStateNormal];
            [cancelBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                                 forState:UIControlStateSelected];
            [cancelBtn addTarget:self action:@selector(cancelAct:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:cancelBtn];
            [[cancelBtn layer] setMasksToBounds:YES];
            [[cancelBtn layer] setCornerRadius:2];
            [[cancelBtn layer]setBorderWidth:1];
            [[cancelBtn layer]setBorderColor:[STYLECLOLR CGColor]];
        }
            break;

        case 8:
        {

            UIButton *reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            reviewBtn.tag=row;
            reviewBtn.frame = CGRectMake(SCREEN_WIDTH-90, 33+80+100*[cellArray count], 70, 30);
            [reviewBtn setTitle:@"点评" forState:UIControlStateNormal];
            [reviewBtn setTitle:@"点评" forState:UIControlStateHighlighted];
            reviewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [reviewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [reviewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [reviewBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                                 forState:UIControlStateNormal];
            [reviewBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                                 forState:UIControlStateSelected];
            [reviewBtn addTarget:self action:@selector(reviewAct:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:reviewBtn];
            [[reviewBtn layer] setMasksToBounds:YES];
            [[reviewBtn layer] setCornerRadius:2];
            [[reviewBtn layer]setBorderWidth:1];
            [[reviewBtn layer]setBorderColor:[STYLECLOLR CGColor]];
        }
            break;
            
        default:
            break;
    }
    return cell;
}



-(void)sureAct:(UIButton *)sender
{
    
}

-(void)logisticsAct:(UIButton *)sender
{
//    B_CheckLogisticsController *B_CheckLogistics=[[B_CheckLogisticsController alloc] init];
//    B_CheckLogistics.UrlString=[[ListArray objectAtIndex:sender.tag] objectForKey:@"deliveryURL"];
//    [self.navigationController pushViewController:B_CheckLogistics animated:YES];
}

-(void)reviewAct:(UIButton *)sender
{
    
    B_AppointCommetViewController *B_AppointCommet=[[B_AppointCommetViewController alloc] init];
    B_AppointCommet.UseDict=[ListArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:B_AppointCommet animated:YES];
}

-(void)payAct:(UIButton *)sender
{
    B_CheckstandViewController *B_Checkstand=[[B_CheckstandViewController alloc] init];
    B_Checkstand.SellDict=[ListArray objectAtIndex:sender.tag];
    B_Checkstand.AllPrice=[NSString stringWithFormat:@"¥%.2f",[[[ListArray objectAtIndex:sender.tag]objectForKey:@"amount"] floatValue]];
    [self.navigationController pushViewController:B_Checkstand animated:YES];
}

-(void)cancelAct:(UIButton *)sender
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/preorder/cancel.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:[[ListArray objectAtIndex:sender.tag] objectForKey:@"orderId"],@"orderId", nil]
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType8
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"%@",ReturnDict);
                          [self selectIndex:SegmentedControl];
                      }
                      NetError:^(int error) {
                      }
     ];
    
}

-(void)handleLeftSwipes:(UISwipeGestureRecognizer *)sender
{
    
    if (!IsBringLeft) {
        CellMoveView=sender.view;
        [UIView animateWithDuration:0.5 animations:^{
            sender.view.center=CGPointMake(sender.view.center.x-100, sender.view.center.y);
        }];
        IsBringLeft=YES;
    }
    NSLog(@"======%@====%F",sender,sender.view.center.x);
    
    
}

-(void)handleRightSwipes:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"======%@",sender);
    if (IsBringLeft) {
        IsBringLeft=NO;
        [UIView animateWithDuration:0.1 animations:^{
            sender.view.center=CGPointMake(sender.view.center.x+100, sender.view.center.y);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)ArrowAct:(UIButton *)sender
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    B_OrderDetailViewController *B_OrderDetail=[[B_OrderDetailViewController alloc] init];
//    B_OrderDetail.OrderId=[[ListArray objectAtIndex:[indexPath row]] objectForKey:@"orderId"];
//    [self.navigationController pushViewController:B_OrderDetail animated:YES];
//    
    
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
