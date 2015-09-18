//
//  GoodsListViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-28.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#import "StrikeThroughLabel.h"
#import "B_GoodsListViewController.h"
#import "B_GoodsDetailViewController.h"
#import "GlobalHead.h"
#import "MJRefresh.h"
#define HEIGHT 116
#define HEIGHTN 172

@interface B_GoodsListViewController ()

@end

@implementation B_GoodsListViewController
@synthesize ShopId;
@synthesize Type;
@synthesize CatId;
@synthesize CategoryList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        BtnArray=[NSMutableArray new];
        ListArray = [[NSMutableArray alloc] init];
        IsLine=YES;
        SelectIndex=1;
        PageIndex=1;
        // Custom initialization
    }
    return self;
}
-(void)RightAct:(UIButton *)sender
{
    [self.navigationController pushViewController:[NSClassFromString(@"B_ShoppingListViewController") new] animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[G_ShopCar allKeys] count]];
    NumLabel.hidden=[[G_ShopCar allKeys] count]==0;
}
-(void)titleAct:(UIButton *)sender
{
    for (UIButton *btn in BtnArray) {
        btn.selected=NO;
    }
    sender.selected=YES;
    SelectIndex=(sender.tag+1);
    [self SearchOrder:[NSString stringWithFormat:@"%ld",SelectIndex]];
}
-(void)SearchOrder:(NSString *)string
{
    PageIndex=1;
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/productlist.jhtml?shopId=%@&type=%@&catId=%@&page=%ld&size=10&x=1000&y=1000&order=%@",ShopId,Type==nil?@"1":Type,CatId==nil?@"0":CatId,PageIndex++,string] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
        
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/productlist.jhtml?shopId=%@&type=%@&catId=%@&page=%ld&size=10&x=1000&y=1000&order=%ld",ShopId,Type==nil?@"1":Type,CatId==nil?@"0":CatId,PageIndex++,SelectIndex] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSDictionary *dictText = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), UITextAttributeTextColor,[UIFont boldSystemFontOfSize:20],UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextShadowColor, CGSizeMake(0, 2.0), UITextAttributeTextShadowOffset, nil];
//    [self.navigationController.navigationBar setTitleTextAttributes:dictText];
    
    UIButton *rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn setImage:[UIImage imageNamed:@"shopcart1"] forState:UIControlStateNormal];
    
//    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [rightBtn addTarget:self action:@selector(RightAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBtn]];
    
    NumLabel=[[UILabel alloc] initWithFrame:CGRectMake(18, -5,10, 10)];
    NumLabel.textColor=UIColorFromRGB(0xffffff);
    NumLabel.backgroundColor=[UIColor redColor];
    NumLabel.font=[UIFont systemFontOfSize:8];
    NumLabel.textAlignment=NSTextAlignmentCenter;
    [rightBtn addSubview:NumLabel];
    [[NumLabel layer] setMasksToBounds:YES];
    [[NumLabel layer] setCornerRadius:5];
    NumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[G_ShopCar allKeys] count]];
    NumLabel.hidden=[[G_ShopCar allKeys] count]==0;
    
    NSArray *titileArray=@[@"促销",@"新品",@"销量",@"价格"];
    
    for (int i=0; i<4; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(80.5*i, 0, 80.5, 41);
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
        [[titleBtn layer]setBorderColor:[UIColorFromRGB(0xc9d8d4) CGColor]];
    }
    
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, SCREEN_HIGHE-148)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    [self SearchOrder:@"3"];
    
    UIView *BelowView=[[UIView alloc] initWithFrame:CGRectMake(-1, SCREEN_HIGHE-114, SCREEN_WIDTH+2, 51)];
    BelowView.backgroundColor=UIColorFromRGBA(0xffffff, 0.6);
    [self.view addSubview:BelowView];
    [[BelowView layer]setBorderWidth:0.5];
    [[BelowView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(15, 10, 60, 30);
    [menuBtn setTitle:@"分类" forState:UIControlStateNormal];
    [menuBtn setTitle:@"分类" forState:UIControlStateHighlighted];
    [menuBtn setTitleColor:UIColorFromRGB(0x34b5e9) forState:UIControlStateNormal];
    [menuBtn setTitleColor:UIColorFromRGB(0x34b5e9) forState:UIControlStateSelected];
    [menuBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    [menuBtn addTarget:self action:@selector(menuAct) forControlEvents:UIControlEventTouchUpInside];
    [BelowView addSubview:menuBtn];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(SCREEN_WIDTH - 45, 5, 40, 40);
    [changeBtn setTitle:@"\ue601" forState:UIControlStateNormal];
    [changeBtn setTitle:@"\ue600" forState:UIControlStateSelected];
    [changeBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:35]];
    [changeBtn setTitleColor:UIColorFromRGB(0xe8c682) forState:UIControlStateNormal];
    [changeBtn setTitleColor:UIColorFromRGB(0xe8c682) forState:UIControlStateHighlighted];
    [changeBtn addTarget:self action:@selector(changeAct:) forControlEvents:UIControlEventTouchUpInside];
    [BelowView addSubview:changeBtn];
    
    LeftTable =[[B_LeftTableView alloc] initWithFrame:CGRectMake(-WWW, 0, WWW, SCREEN_HIGHE-110)];
    LeftTable.separatorColor=[UIColor whiteColor];
    LeftTable.hidden=LeftTable.IsHid;
    LeftTable.showsHorizontalScrollIndicator=NO;
    LeftTable.alpha = .85f;

    LeftTable.showsVerticalScrollIndicator=NO;
    LeftTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    LeftTable.backgroundColor=UIColorFromRGBA(0xeeeeee, 0.88);
    LeftTable.backgroundColor = [UIColor blackColor];
    [self.view addSubview:LeftTable];
    LeftTable.hidden=LeftTable.frame.origin.x==-WWW;
    [LeftTable SetClickBlock:^(NSString * string) {
        [self menuAct];
        CatId=string;
        Type=@"3";
        [self SearchOrder:@""];
        
    }];
    [LeftTable setListArray:CategoryList];
    [LeftTable reloadData];
    NSLog(@"++++____%@",CategoryList);

    // Do any additional setup after loading the view.
}
-(void)menuAct
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

-(void)changeAct:(UIButton *)sender
{
    TableView.backgroundColor=IsLine?UIColorFromRGB(0xeeeeee):UIColorFromRGB(0xffffff);
    IsLine=sender.selected;
    sender.selected=!sender.isSelected;
    [TableView reloadData];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IsLine?HEIGHT:HEIGHTN;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return IsLine?[ListArray count]:([ListArray count]/3+([ListArray count]%3>0?1:0));
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
    if (IsLine) {
        
        UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 96, 96)];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageurl" ]]];
        [cell.contentView addSubview:iconImage];
        
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width + 20, iconImage.frame.origin.y, SCREEN_WIDTH - iconImage.frame.size.width - 40, [[[ListArray ObjectAtIndex:row] ObjectForKey:@"name" ] length]>12?40:30)];
        titleLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"name"];
        titleLabel.textColor=UIColorFromRGB(0x000000);
        titleLabel.numberOfLines=2;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:titleLabel];
        
        UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y  + titleLabel.frame.size.height, titleLabel.frame.size.width / 2, 20)];
        moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[ListArray ObjectAtIndex:row] ObjectForKey:@"price"] floatValue]];
        moneyLabel.textColor=UIColorFromRGB(0xfc4f01);
        //        moneyLabel.backgroundColor=[UIColor redColor];
        moneyLabel.font=[UIFont systemFontOfSize:18];
        moneyLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:moneyLabel];
        
        
        
        NSString *oldPrice = [NSString stringWithFormat:@"¥%.2f",[[[ListArray ObjectAtIndex:row] ObjectForKey:@"originalPrice"] floatValue]];
        CGSize sOldPrice = [oldPrice boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 12]}  context:nil].size;
        
        UILabel *oldPrise= [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x+ moneyLabel.frame.size.width+10, titleLabel.frame.origin.y+ titleLabel.frame.size.height, sOldPrice.width, 20)];
        oldPrise.textColor = [UIColor grayColor];
        oldPrise.text = oldPrice;
        oldPrise.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:oldPrise];
        
        
        UIView * linePrse = [[UIView alloc]initWithFrame:CGRectMake(oldPrise.frame.origin.x- 2, oldPrise.frame.origin.y + oldPrise.frame.size.height/2, oldPrise.frame.size.width + 4, 0.5)];
        linePrse.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview: linePrse];
        
        
        UILabel* evaluateLabel=[[UILabel alloc] initWithFrame:CGRectMake(124, 85,100, 20)];
        evaluateLabel.text=[NSString stringWithFormat:@"%@人点评",[[ListArray ObjectAtIndex:row] ObjectForKey:@"evaluateCount"]];
        evaluateLabel.textColor=UIColorFromRGB(0x999999);
        evaluateLabel.backgroundColor=[UIColor clearColor];
        evaluateLabel.font=[UIFont systemFontOfSize:11];
        evaluateLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:evaluateLabel];
        
        
        UIView *linebottom= [[UIView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, 119.5f, cell.frame.size.width - iconImage.frame.size.width, .5)];
        linebottom.backgroundColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:linebottom];
        
        
        
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

    }else{
        
        for (int i=0; i<3; i++) {
            
            if (row*3+i>=[ListArray count]) {
                break;
            }
//            NSInteger index=row*3+i;
//            UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            arrowBtn.frame = CGRectMake(8+105*i, 8, 96, 156);
//            arrowBtn.tag=index;
//            [arrowBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
//            [arrowBtn addTarget:self action:@selector(ArrowAct:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:arrowBtn];
//            [[arrowBtn layer]setBorderWidth:1];
//            [[arrowBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
//            
//            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
//            [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:index] ObjectForKey:@"imageurl" ]]];
//            [arrowBtn addSubview:iconImage];
//            
//            UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(4, 90,96, 30)];
//            titleLabel.text=[[ListArray ObjectAtIndex:index] ObjectForKey:@"name"];
//            titleLabel.textColor=UIColorFromRGB(0x000000);
//            titleLabel.numberOfLines=2;
//            titleLabel.backgroundColor=[UIColor clearColor];
//            titleLabel.font=[UIFont systemFontOfSize:14];
//            titleLabel.textAlignment=NSTextAlignmentLeft;
//            [arrowBtn addSubview:titleLabel];
//
//            UIImageView *BackImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 116, 96, 0.5)];
//            BackImage.backgroundColor=UIColorFromRGB(0xeeeeee);
//            [arrowBtn addSubview:BackImage];
//
//            
//            UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(4, 126,85, 18)];
//            moneyLabel.text=[NSString stringWithFormat:@"¥%.1f",[[[ListArray ObjectAtIndex:index] ObjectForKey:@"price"] floatValue]];
//            moneyLabel.textColor=UIColorFromRGB(0xfc4f01);
//            moneyLabel.backgroundColor=[UIColor clearColor];
//            moneyLabel.font=[UIFont systemFontOfSize:16];
//            moneyLabel.textAlignment=NSTextAlignmentRight;
//            [arrowBtn addSubview:moneyLabel];
     
            
            NSInteger index=row*3+i;
            UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            arrowBtn.frame = CGRectMake(8+105*i, 8, 96, 156);
            arrowBtn.tag=index;
            [arrowBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
            [arrowBtn addTarget:self action:@selector(ArrowAct:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:arrowBtn];
            //            [[arrowBtn layer]setBorderWidth:1];
            //            [[arrowBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
            //
            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
            [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:index] ObjectForKey:@"imageurl" ]]];
            [arrowBtn addSubview:iconImage];
            
            UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(4, 96,90, 30)];
            titleLabel.text=[[ListArray ObjectAtIndex:index] ObjectForKey:@"name"];
            titleLabel.textColor=UIColorFromRGB(0x000000);
            titleLabel.numberOfLines=2;
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.font=[UIFont systemFontOfSize:11];
            titleLabel.textAlignment=NSTextAlignmentLeft;
            [arrowBtn addSubview:titleLabel];
            
            UIImageView *BackImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 130, 96, 0.5)];
            BackImage.backgroundColor=UIColorFromRGB(0xeeeeee);
            [arrowBtn addSubview:BackImage];
            
            NSString *str = [NSString stringWithFormat:@"¥%.1f",[[[ListArray ObjectAtIndex:index] ObjectForKey:@"price"] floatValue]];
            CGSize s = [str boundingRectWithSize:CGSizeMake(96 - 8, 14) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
            
            UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 134,85, 18)];
            moneyLabel.text= str;
            moneyLabel.textColor=UIColorFromRGB(0xfc4f01);
            
            moneyLabel.backgroundColor=[UIColor clearColor];
            moneyLabel.font=[UIFont systemFontOfSize:14];
            moneyLabel.textAlignment=NSTextAlignmentLeft;
            [arrowBtn addSubview:moneyLabel];
            
            
            
            
            
            
            
            
            
            
            
            
//            UIButton *addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//            [addBtn setFrame:CGRectMake(60, 120, 30, 30)];
//            addBtn.tag=row;
//            [addBtn.titleLabel setFont:[UIFont fontWithName:@"zipn" size:25]];
//            [addBtn setTitle:@"\ue605" forState:UIControlStateNormal];
//            [addBtn setTitle:@"\ue605" forState:UIControlStateSelected];
//            [addBtn setTitleColor:UIColorFromRGB(0x6bd2d2) forState:UIControlStateNormal];
//            [addBtn setTitleColor:UIColorFromRGB(0x6bd2d2)               forState:UIControlStateSelected];
//            [addBtn addTarget:self action:@selector(AddAct:) forControlEvents:UIControlEventTouchUpInside];
//            [arrowBtn addSubview:addBtn];
        }
        
        
    }
    
//    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,IsLine? HEIGHT:HEIGHTN -0.5, SCREEN_WIDTH-10, 0.5)];
//    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
//    [cell.contentView addSubview:lineImage];
//    
    return cell;
}
-(void)ArrowAct:(UIButton *)sender
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray ObjectAtIndex:sender.tag]];
    [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
    [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
    B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
    B_GoodsDetailView.Dict=dict;
    B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray ObjectAtIndex:[indexPath row]]];
    [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
    [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
    
    B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
    B_GoodsDetailView.Dict=dict;
    B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
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
