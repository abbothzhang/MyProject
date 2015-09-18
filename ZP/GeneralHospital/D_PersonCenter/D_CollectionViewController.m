//
//  D_CollectionViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/24.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#import "StrikeThroughLabel.h"
#import "D_CollectionViewController.h"
#import "B_GoodsDetailViewController.h"
#import "B_ShopDetailViewController.h"
#import "GlobalHead.h"
#define HEIGHT 116
#define HEIGHTN 104.5
@interface D_CollectionViewController ()

@end

@implementation D_CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        BtnArray=[NSMutableArray new];
        ListArray = [[NSMutableArray alloc] init];
        IsLine=YES;
        // Custom initialization
    }
    return self;
}

-(void)selectIndex:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex==0) {
        IsLine=YES;
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/product/collect_list.jhtml"]];
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
    }else
    {
        IsLine=NO;
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/shop/collect_list.jhtml"]];
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
}


-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(LoadData) withObject:nil afterDelay:0.5];
    
}
-(void)LoadData
{
    [self selectIndex:SegmentedControl];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"收藏商品",@"收藏店铺",nil];
    
    SegmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    SegmentedControl.frame = CGRectMake(60.0*WITH_SCALE, 5.0, SCREEN_WIDTH - 120*WITH_SCALE, 30.0);
    
    SegmentedControl.selectedSegmentIndex = 0;//设置默认选择项索0
    
    SegmentedControl.tintColor = STYLECLOLR;
    
    SegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;//设置样式
    [SegmentedControl addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:SegmentedControl];
    
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HIGHE-64-50)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
 
    [[TableView layer]setBorderWidth:1];
    [[TableView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return [ListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    if (IsLine) {
        
        UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 96, 96)];
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
        
        UILabel* evaluateLabel=[[UILabel alloc] initWithFrame:CGRectMake(125, 85,100, 20)];
        evaluateLabel.text=[NSString stringWithFormat:@"%@人点评",[[ListArray ObjectAtIndex:row] ObjectForKey:@"evaluateCount"]];
        evaluateLabel.textColor=UIColorFromRGB(0x999999);
        evaluateLabel.backgroundColor=[UIColor clearColor];
        evaluateLabel.font=[UIFont systemFontOfSize:12];
        evaluateLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:evaluateLabel];
        
        
//        
//        UIButton *addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//        [addBtn setFrame:CGRectMake(278, 75, 30, 30)];
//        addBtn.tag=row;
//        [addBtn.titleLabel setFont:[UIFont fontWithName:@"zipn" size:25]];
//        [addBtn setTitle:@"\ue605" forState:UIControlStateNormal];
//        [addBtn setTitle:@"\ue605" forState:UIControlStateSelected];
//        [addBtn setTitleColor:UIColorFromRGB(0x6bd2d2) forState:UIControlStateNormal];
//        [addBtn setTitleColor:UIColorFromRGB(0x6bd2d2)               forState:UIControlStateSelected];
//        [addBtn addTarget:self action:@selector(AddAct:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:addBtn];
        
    }else
    {
        
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
        
    }
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(290*WITH_SCALE, 40,40, 40)];
    arrowLabel.text=@"\ue629";
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel.textColor=UIColorFromRGB(0x888888);
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:arrowLabel];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,IsLine? HEIGHT:HEIGHTN, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}


-(void)AddAct:(UIButton *)sender
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray ObjectAtIndex:sender.tag]];
    [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
    [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
    
    [G_ShopCar setObject:dict forKey:[[ListArray ObjectAtIndex:sender.tag] objectForKey:@"id"]];
    NumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[G_ShopCar allKeys] count]];
    NumLabel.hidden=[[G_ShopCar allKeys] count]==0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (IsLine) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray ObjectAtIndex:[indexPath row]]];
        [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
        [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
        B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
        B_GoodsDetailView.Dict=dict;
        B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
    }else
    {
        
        B_ShopDetailViewController *B_ShopDetailView=[[B_ShopDetailViewController alloc] init];
        B_ShopDetailView.Dict=[ListArray objectAtIndex:[indexPath row]];
        B_ShopDetailView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:B_ShopDetailView animated:YES];
    }
    

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
