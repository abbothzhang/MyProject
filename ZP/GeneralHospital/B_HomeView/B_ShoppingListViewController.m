//
//  ShoppingListViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-29.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "B_ShoppingListViewController.h"
#import "B_GoodsDetailViewController.h"
#import "B_MakeSureViewController.h"
#import "B_AppointViewController.h"
#import "B_ShopDetailViewController.h"
#import "B_MakeAppointViewController.h"
#import "GlobalHead.h"

#import "AESCrypt.h"
#import "D_LoginViewController.h"

#define HEIGHT 116
@interface B_ShoppingListViewController ()
{
    UIButton *appointBtn;
    UIButton *sendBtn;
}

@end

@implementation B_ShoppingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"购物车";
        ListArray =[[NSMutableArray alloc]init];
        // Custom initialization
    }
    return self;
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
        [D_LoginView setLoginBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:D_LoginView animated:YES];
    } else {
        [self showShopCart];
    }
    
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

- (void)showShopCart
{
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64-40)];
    TableView.backgroundColor=UIColorFromRGBA(0xf5f5f5,0.9);
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    UIView *downView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHE-64-40, SCREEN_WIDTH, 40)];
    [self.view addSubview:downView];
    [[downView layer]setBorderWidth:1];
    [[downView layer]setBorderColor:[UIColorFromRGB(0xeeeeee) CGColor]];
    
    TitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 0,100, 40)];
    TitleLabel.textColor=UIColorFromRGB(0xaeaeae);
    TitleLabel.backgroundColor=[UIColor clearColor];
    TitleLabel.font=[UIFont systemFontOfSize:13];
    TitleLabel.textAlignment=NSTextAlignmentLeft;
    [downView addSubview:TitleLabel];
    
    UILabel* allLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0,50, 40)];
    allLabel.text=@"合计：";
    allLabel.textColor=UIColorFromRGB(0x333333);
    allLabel.backgroundColor=[UIColor clearColor];
    allLabel.font=[UIFont systemFontOfSize:13];
    allLabel.textAlignment=NSTextAlignmentCenter;
    [downView addSubview:allLabel];
    
    PriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 0,140, 40)];
    PriceLabel.text=@"¥0.00";
    PriceLabel.textColor=UIColorFromRGB(0xff5000);
    PriceLabel.backgroundColor=[UIColor clearColor];
    PriceLabel.font=[UIFont systemFontOfSize:15];
    PriceLabel.textAlignment=NSTextAlignmentLeft;
    [downView addSubview:PriceLabel];
    
    appointBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    appointBtn.frame = CGRectMake(150*WITH_SCALE, 5, 71*WITH_SCALE, 30);
    [appointBtn setTitle:@"预约" forState:UIControlStateNormal];
    [appointBtn setTitle:@"预约" forState:UIControlStateHighlighted];
    appointBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [appointBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateNormal];
    [appointBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
    [appointBtn addTarget:self action:@selector(appointAct) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:appointBtn];
    [[appointBtn layer] setMasksToBounds:YES];
    [[appointBtn layer] setCornerRadius:2];
    
    sendBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(235*WITH_SCALE, 5, 71*WITH_SCALE, 30);
    [sendBtn setTitle:@"配送" forState:UIControlStateNormal];
    [sendBtn setTitle:@"配送" forState:UIControlStateHighlighted];
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sendBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
    [sendBtn addTarget:self action:@selector(sendAct) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:sendBtn];
    [[sendBtn layer] setMasksToBounds:YES];
    [[sendBtn layer] setCornerRadius:2];
    
    [self performSelector:@selector(LoadData) withObject:nil afterDelay:0.5];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //[self setUpBackButton];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [self isLogin];
}

-(void)LoadData
{
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
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
                              //NSLog(@"%@",ReturnDict);
                              [ListArray removeAllObjects];
                              [ListArray addObjectsFromArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"shopList"]];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ReturnDict objectForKey:@"data"] objectForKey:@"totalPrice"] floatValue]];
                                  
                                  CGFloat totalPriceAll = [[[ReturnDict objectForKey:@"data"] objectForKey:@"totalPrice"] floatValue];
                                  for (NSDictionary *dict in ListArray) {
                                      CGFloat totalPrice = [[dict objectForKey:@"totalPrice"] floatValue];
                                      if (totalPrice == totalPriceAll) {
                                          NSInteger state =  [[dict objectForKey:@"shippingType"] integerValue];
                                          if (state == 1) {
                                              [sendBtn setHidden:NO];
                                              [appointBtn setHidden:YES];
                                          } else if (state == 2)
                                          {
                                              [sendBtn setHidden:YES];
                                              [appointBtn setHidden:NO];
                                          } else
                                          {
                                              [sendBtn setHidden:NO];
                                              [appointBtn setHidden:NO];
                                          }
                                      }
                                      
                                  }
                                  
                                  [TableView reloadData];
                              });
                              
                              
                          }
                          NetError:^(int error) {
                          }
         ];
    });
}


-(void)appointAct
{
    B_MakeAppointViewController *B_MakeAppoint=[[B_MakeAppointViewController alloc] init];
  
    [self.navigationController pushViewController:B_MakeAppoint animated:YES];
}

-(void)sendAct
{
    B_MakeSureViewController *B_MakeSure=[[B_MakeSureViewController alloc] init];
    B_MakeSure.title=@"确认配送";
    [self.navigationController pushViewController:B_MakeSure animated:YES];
}

-(void)ShopAllSelect:(UIButton *)sender
{
    NSMutableDictionary *muDict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray objectAtIndex:sender.tag]];
    NSString *shopId=[muDict objectForKey:@"shopId"];
    int isSelected=[[muDict objectForKey:@"isSelected"] intValue];
    
    /*
     shopId	long	是	店铺流水号ID
     selected	boolean	是	true：全选，false：反选
     */
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/cart/selectable.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:shopId,@"shopId",isSelected==1?@0:@1,@"selected", nil]
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          //NSLog(@"%@",ReturnDict);
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"shopList"]];
                          PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ReturnDict objectForKey:@"data"] objectForKey:@"totalPrice"] floatValue]];
                          
                          //NSLog(@"%@---------------------335544------------", [[ReturnDict objectForKey:@"data"] objectForKey:@"shopList"]  );
                          CGFloat totalPriceAll = [[[ReturnDict objectForKey:@"data"] objectForKey:@"totalPrice"] floatValue];
                          for (NSDictionary *dict in ListArray) {
                              CGFloat totalPrice = [[dict objectForKey:@"totalPrice"] floatValue];
                              if (totalPrice == totalPriceAll) {
                                 NSInteger state =  [[dict objectForKey:@"shippingType"] integerValue];
                                  if (state == 1) {
                                      [sendBtn setHidden:NO];
                                      [appointBtn setHidden:YES];
                                  } else if (state == 2)
                                  {
                                      [sendBtn setHidden:YES];
                                      [appointBtn setHidden:NO];
                                  } else
                                  {
                                      [sendBtn setHidden:NO];
                                      [appointBtn setHidden:NO];
                                  }
                              }
                              
                          }
                          
                          
                          [TableView reloadData];
                      }
                      NetError:^(int error) {
                      }
     ];}

-(void)goodSelect:(UIButton *)sender
{
    NSArray *array=[sender.accessibilityLanguage componentsSeparatedByString:@","];
    int row = [[array objectAtIndex:0] intValue];
    int section = [[array objectAtIndex:1] intValue];
    NSMutableArray *cellArray=[[NSMutableArray alloc] initWithArray:[[ListArray objectAtIndex:row] ObjectForKey:@"productList"]];
    
    NSString *cartItemId=[[cellArray objectAtIndex:section] ObjectForKey:@"cartItemId"];
    NSString *quantity=[[cellArray objectAtIndex:section] ObjectForKey:@"quantity"];
    int isSelected=[[[cellArray objectAtIndex:section] ObjectForKey:@"isSelected"] intValue];

    /*
     参数名称	数据类型	是否必须	说明
     cartItemId	long	是	清单项ID
     quantity	int	是	商品数量
     isSelected	boolean	是	商品是否选中
     */
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/cart/update.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:cartItemId,@"cartItemId",quantity,@"quantity",isSelected==1?@0:@1,@"isSelected", nil]
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                         // NSLog(@"%@",ReturnDict);
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"shopList"]];
                          PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ReturnDict objectForKey:@"data"] objectForKey:@"totalPrice"] floatValue]];
                          [TableView reloadData];
                      }
                      NetError:^(int error) {
                      }
     ];
}

-(void)minAct:(UIButton *)sender
{
    NSArray *array=[sender.accessibilityLanguage componentsSeparatedByString:@","];
    int   row = [[array objectAtIndex:0] intValue];
    int   section = [[array objectAtIndex:1] intValue];

    long   quantity=[[[[[ListArray objectAtIndex:row] ObjectForKey:@"productList"] objectAtIndex:section] ObjectForKey:@"quantity"] integerValue];
    if (quantity<=1) {
        return;
    }else
    {
        quantity--;
    }
    

    NSMutableArray *cellArray=[[NSMutableArray alloc] initWithArray:[[ListArray objectAtIndex:row] ObjectForKey:@"productList"]];
    NSString *cartItemId=[[cellArray objectAtIndex:section] ObjectForKey:@"cartItemId"];
    int isSelected=[[[cellArray objectAtIndex:section] ObjectForKey:@"isSelected"] intValue];
    
    /*
     参数名称	数据类型	是否必须	说明
     cartItemId	long	是	清单项ID
     quantity	int	是	商品数量
     isSelected	boolean	是	商品是否选中
     */
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/cart/update.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:cartItemId,@"cartItemId",[NSString stringWithFormat:@"%ld",quantity],@"quantity",isSelected==1?@1:@0,@"isSelected", nil]
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          //NSLog(@"%@",ReturnDict);
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"shopList"]];
                          PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ReturnDict objectForKey:@"data"] objectForKey:@"totalPrice"] floatValue]];
                          [TableView reloadData];
                      }
                      NetError:^(int error) {
                      }
     ];
}

-(void)addAct:(UIButton *)sender
{
    NSArray *array=[sender.accessibilityLanguage componentsSeparatedByString:@","];
    int   row = [[array objectAtIndex:0] intValue];
    int   section = [[array objectAtIndex:1] intValue];
    int   quantity=[[[[[ListArray objectAtIndex:row] ObjectForKey:@"productList"] objectAtIndex:section] ObjectForKey:@"quantity"] integerValue];
    if (quantity<0) {
        return;
    }else{
        quantity++;
    }
    
    NSMutableArray *cellArray=[[NSMutableArray alloc] initWithArray:[[ListArray objectAtIndex:row] ObjectForKey:@"productList"]];
    NSString *cartItemId=[[cellArray objectAtIndex:section] ObjectForKey:@"cartItemId"];
    int isSelected=[[[cellArray objectAtIndex:section] ObjectForKey:@"isSelected"] intValue];
    
    /*
     参数名称	数据类型	是否必须	说明
     cartItemId	long	是	清单项ID
     quantity	int	是	商品数量
     isSelected	boolean	是	商品是否选中
     */
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/cart/update.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:cartItemId,@"cartItemId",[NSString stringWithFormat:@"%d",quantity],@"quantity",isSelected==1?@1:@0,@"isSelected", nil]
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          //NSLog(@"%@",ReturnDict);
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"shopList"]];
                          PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ReturnDict objectForKey:@"data"] objectForKey:@"totalPrice"] floatValue]];
                          [TableView reloadData];
                      }
                      NetError:^(int error) {
                      }
     ];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115+[[[ListArray objectAtIndex:[indexPath row]] ObjectForKey:@"productList"] count]*100;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}

-(void)ShopDetailAct:(UIButton *)sender
{
//    NSLog(@"++++++%@=====%d",[ListArray objectAtIndex:sender.tag],sender.tag);
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray objectAtIndex:sender.tag]];
    [dict setObject:[dict objectForKey:@"shopId"] forKey:@"code"];
    B_ShopDetailViewController *B_ShopDetailView=[[B_ShopDetailViewController alloc] init];
    B_ShopDetailView.Dict=dict;
    B_ShopDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_ShopDetailView animated:YES];
}

-(void)TapGesture:(UITapGestureRecognizer *)sender
{
    
    int row=[[[sender.view.accessibilityLanguage componentsSeparatedByString:@","] firstObject] intValue];
    int i=[[[sender.view.accessibilityLanguage componentsSeparatedByString:@","] lastObject] intValue];
   // NSLog(@"%@",sender.view.accessibilityLanguage);
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[[ListArray objectAtIndex:row] ObjectForKey:@"productList"] objectAtIndex:i]];
    [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
    [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
    
    B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
    B_GoodsDetailView.Dict=dict;
    B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
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
    
    NSArray *cellArray=[[[ListArray objectAtIndex:row] ObjectForKey:@"productList"] copy];
    
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 14, SCREEN_WIDTH, 101+100*[cellArray count])];
    backView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:backView];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(15, 23, 20, 20);
    selectBtn.tag=row;
    [selectBtn setImage:[UIImage imageNamed:@"b_unselect.png"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"b_select.png"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(ShopAllSelect:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:selectBtn];
    selectBtn.selected=[[[ListArray objectAtIndex:row] ObjectForKey:@"isSelected"] integerValue]==1;
    
    UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopBtn.frame = CGRectMake(40, 14, SCREEN_WIDTH-40, 65);
    shopBtn.tag=row;
    [shopBtn addTarget:self action:@selector(ShopDetailAct:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:shopBtn];
    
    UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(45, 25,200, 15)];
    nameLabel.text=[[ListArray objectAtIndex:[indexPath row]] ObjectForKey:@"shopName"];
    nameLabel.textColor=UIColorFromRGB(0x333333);
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.font=[UIFont systemFontOfSize:13];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:nameLabel];
    
    UILabel* shopActivity=[[UILabel alloc] initWithFrame:CGRectMake(45, 38,200, 18)];
    shopActivity.text=[[ListArray objectAtIndex:row] ObjectForKey:@"shopActivity"];
    shopActivity.textColor=UIColorFromRGB(0xaeaeae);
    shopActivity.backgroundColor=[UIColor clearColor];
    shopActivity.font=[UIFont systemFontOfSize:11];
    shopActivity.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:shopActivity];

    for(int i=0;i<[cellArray count];i++)
    {
        UIView *cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 80+100*i, SCREEN_WIDTH+100, 100)];
        cellView.tag=i;
        [cell.contentView addSubview:cellView];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 100);
        deleteBtn.accessibilityLanguage=[NSString stringWithFormat:@"%d,%d",row,i];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitle:@"删除" forState:UIControlStateHighlighted];
        deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [deleteBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xff0000)] forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xff0000)] forState:UIControlStateSelected];
        [deleteBtn addTarget:self action:@selector(deleteAct:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:deleteBtn];
        
        UISwipeGestureRecognizer* leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipes:)];
        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [cellView addGestureRecognizer:leftRecognizer];
        
        UISwipeGestureRecognizer* rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipes:)];
        rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [cellView addGestureRecognizer:rightRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGesture:)];
        cellView.accessibilityLanguage=[NSString stringWithFormat:@"%d,%d",row,i];
        tapGestureRecognizer.numberOfTapsRequired=1;
        tapGestureRecognizer.numberOfTouchesRequired=1;
        
        [cellView addGestureRecognizer:tapGestureRecognizer];
       
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, SCREEN_WIDTH-20, 0.5)];
        lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
        [cellView addSubview:lineImage];
        
        UIButton *childSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        childSelectBtn.frame = CGRectMake(15, 40, 20, 20);
        childSelectBtn.accessibilityLanguage=[NSString stringWithFormat:@"%d,%d",row,i];
        [childSelectBtn setImage:[UIImage imageNamed:@"b_unselect.png"] forState:UIControlStateNormal];
        [childSelectBtn setImage:[UIImage imageNamed:@"b_select.png"] forState:UIControlStateSelected];
        [childSelectBtn addTarget:self action:@selector(goodSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:childSelectBtn];
        childSelectBtn.selected=[[[cellArray ObjectAtIndex:i] ObjectForKey:@"isSelected"] integerValue]==1;
        
        UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 60, 60)];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[[cellArray ObjectAtIndex:i] ObjectForKey:@"imageUrl"]]];
        [cellView addSubview:iconImage];
        [[iconImage layer] setMasksToBounds:YES];
        [[iconImage layer] setCornerRadius:2];
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(120,  20,120, 30)];
        titleLabel.text=[[cellArray ObjectAtIndex:i] ObjectForKey:@"name"];
        titleLabel.textColor=UIColorFromRGB(0x333333);
        titleLabel.numberOfLines=5;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:12];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:titleLabel];
        
        UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(250*WITH_SCALE, 20,57*WITH_SCALE,30)];
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
        UILabel* areaLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 50,120, 50)];
        areaLabel.text=mString;
        areaLabel.numberOfLines=10;
        areaLabel.textColor=UIColorFromRGB(0xaeaeae);
        areaLabel.backgroundColor=[UIColor clearColor];
        areaLabel.font=[UIFont systemFontOfSize:11];
        areaLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:areaLabel];
        
        UIView *addBtn=[[UIView alloc]initWithFrame:CGRectMake(220*WITH_SCALE,60, 85*WITH_SCALE, 28)];
        [cellView addSubview:addBtn];
        [[addBtn layer]setBorderWidth:1];
        [[addBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
        
        UIButton *minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        minBtn.frame = CGRectMake(0, 0, 28, 28);
        minBtn.accessibilityLanguage=[NSString stringWithFormat:@"%d,%d",row,i];
        [minBtn setTitle:@"—" forState:UIControlStateNormal];
        [minBtn setTitle:@"—" forState:UIControlStateHighlighted];
        [minBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [minBtn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
        [minBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [minBtn addTarget:self action:@selector(minAct:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addSubview:minBtn];
        
        UILabel *CodeLabel=[[UILabel alloc] initWithFrame:CGRectMake(28, 0, 29, 28)];
        CodeLabel.text=[NSString stringWithFormat:@"%@",[[cellArray ObjectAtIndex:i] ObjectForKey:@"quantity"]];
        CodeLabel.textColor=UIColorFromRGB(0x666666);
        CodeLabel.backgroundColor=[UIColor clearColor];
        CodeLabel.font=[UIFont systemFontOfSize:12];
        CodeLabel.textAlignment=NSTextAlignmentCenter;
        [addBtn addSubview:CodeLabel];
        [[CodeLabel layer]setBorderWidth:1];
        [[CodeLabel layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
        
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusBtn.frame = CGRectMake(57, 0, 28, 28);
        plusBtn.accessibilityLanguage=[NSString stringWithFormat:@"%d,%d",row,i];
        [plusBtn setTitle:@"＋" forState:UIControlStateNormal];
        [plusBtn setTitle:@"＋" forState:UIControlStateHighlighted];
        [plusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [plusBtn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
        [plusBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [plusBtn addTarget:self action:@selector(addAct:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addSubview:plusBtn];
    }
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,66+100*[cellArray count], SCREEN_WIDTH, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [backView addSubview:lineImage];
    
    UILabel* numLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 66+100*[cellArray count],130, 35)];
    numLabel.text=[NSString stringWithFormat:@"共%d项   合计：",[cellArray count]];
    numLabel.numberOfLines=1;
    numLabel.textColor=UIColorFromRGB(0xaeaeae);
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.font=[UIFont systemFontOfSize:15];
    numLabel.textAlignment=NSTextAlignmentRight;
    [backView addSubview:numLabel];
    
    UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(230, 66+100*[cellArray count],80, 35)];
    moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ListArray objectAtIndex:row] ObjectForKey:@"totalPrice"] floatValue]];
    moneyLabel.numberOfLines=1;
    moneyLabel.textColor=UIColorFromRGB(0xff5000);
    moneyLabel.backgroundColor=[UIColor clearColor];
    moneyLabel.font=[UIFont systemFontOfSize:15];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:moneyLabel];
    
    return cell;
}

-(void)deleteAct:(UIButton *)sender
{
    NSArray *array=[sender.accessibilityLanguage componentsSeparatedByString:@","];
    int row = [[array objectAtIndex:0] intValue];
    int section = [[array objectAtIndex:1] intValue];
    
    NSMutableArray *cellArray=[[NSMutableArray alloc] initWithArray:[[ListArray objectAtIndex:row] ObjectForKey:@"productList"]];
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/cart/delete.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:[[cellArray objectAtIndex:section] ObjectForKey:@"cartItemId"],@"cartItemId", nil]
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          //NSLog(@"%@",ReturnDict);
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"shopList"]];
                          PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ReturnDict objectForKey:@"data"] objectForKey:@"totalPrice"] floatValue]];
                          [TableView reloadData];
                          
                          if (IsBringLeft) {
                              IsBringLeft=NO;
                              [UIView animateWithDuration:0.5 animations:^{
                                  CellMoveView.center=CGPointMake(CellMoveView.center.x+100,CellMoveView.center.y);
                              } completion:^(BOOL finished) {
                                  
                              }];
                          }
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
    //NSLog(@"======%@====%F",sender,sender.view.center.x);


}

-(void)handleRightSwipes:(UISwipeGestureRecognizer *)sender
{
    //NSLog(@"======%@",sender);
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
