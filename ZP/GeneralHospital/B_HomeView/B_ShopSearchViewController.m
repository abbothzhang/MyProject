//
//  B_ShopSearchViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-16.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#import "StrikeThroughLabel.h"
#import "B_ShopSearchViewController.h"
#import "UIImageView+WebCache.h"
#import "DLIDEKeyboardView.h"
#import "B_ShopDetailViewController.h"
#import "B_GoodsDetailViewController.h"
#import "StrikeThroughLabel.h"
@interface B_ShopSearchViewController ()

@end

@implementation B_ShopSearchViewController
@synthesize KeyWord;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        BtnArray=[NSMutableArray new];
        ListArray = [[NSMutableArray alloc]init];
        // Custom initialization
    }
    return self;
}

-(void)LocalAct:(UIButton *)sender
{
    
}

-(void)titleAct:(UIButton *)sender
{
    for (UIButton *btn in BtnArray) {
        btn.selected=NO;
    }
    sender.selected=YES;
    
    [self SearchOrder:sender.tag+1];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NowType=2;
    UIButton *rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:30]];
    [rightBtn setTitle:@"\ue601" forState:UIControlStateNormal];
    [rightBtn setTitle:@"\ue601" forState:UIControlStateSelected];
    [rightBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightBtn setTitleColor:STYLECLOLR               forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(LocalAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBtn]];
    
    NSArray *titileArray=@[@"推荐\ue627",@"销量\ue627",@"价格\ue628",@"商铺"];
    
    for (int i=0; i<4; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(80.5*i, 0, 80.5, 33);
        titleBtn.tag=i;
        if (i==0) {
            titleBtn.selected=YES;
        }
        [titleBtn setTitle:[titileArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitle:[titileArray objectAtIndex:i] forState:UIControlStateHighlighted];
        [titleBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:13]];
        [titleBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        [titleBtn setTitleColor:STYLECLOLR forState:UIControlStateSelected];

        [titleBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [titleBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(titleAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:titleBtn];
        [BtnArray addObject:titleBtn];
        [[titleBtn layer]setBorderWidth:0.5];
        [[titleBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    }
    
    //导航栏
    SearchBar = [[UISearchBar alloc] init];
    SearchBar.frame = CGRectMake(0, 0, 200, 44);
    SearchBar.placeholder = @"寻找商铺、商品";
    SearchBar.delegate = self;
    SearchBar.backgroundColor=[UIColor clearColor];
    [SearchBar setTintColor:[UIColor clearColor]];
    
    for (UIView* view  in SearchBar.subviews) {
        for (UIView* view1  in view.subviews) {
            
            if ([view1 isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [view1 removeFromSuperview];
                
            }
            if ([view1 isKindOfClass:[UITextField class]]) {
                [DLIDEKeyboardView attachToTextView:(UITextField* )view1];
            }
        }
    }
    SearchBar.keyboardType = UIKeyboardTypeDefault;
    [self.navigationItem setTitleView:SearchBar];
    
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HIGHE-98)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    
    [self SearchOrder:NowType];
   
    
    // Do any additional setup after loading the view.
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    KeyWord=searchBar.text;
    [self SearchOrder:NowType];
}

-(void)SearchOrder:(int)nowType
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/search.jhtml?city=C0007&keyword=%@&order=%d&page=1&size=10&x=120.17948490192&y=30.331132261917",KeyWord,nowType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
                          Type=[[[ReturnDict objectForKey:@"data"] objectForKey:@"type"] intValue];
                          [ListArray addObjectsFromArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"itemList"]];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [TableView reloadData];
                          });
                      }
                      NetError:^(int error) {
                      }
     ];
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
    
    if (Type==1) {
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

    }else
    {
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
        
        UILabel* evaluateLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, 85,100, 20)];
        evaluateLabel.text=[NSString stringWithFormat:@"%@人点评",[[ListArray ObjectAtIndex:row] ObjectForKey:@"evaluateCount"]];
        evaluateLabel.textColor=UIColorFromRGB(0x999999);
        evaluateLabel.backgroundColor=[UIColor clearColor];
        evaluateLabel.font=[UIFont systemFontOfSize:12];
        evaluateLabel.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:evaluateLabel];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (Type==1) {
        B_ShopDetailViewController *B_ShopDetailView=[[B_ShopDetailViewController alloc] init];
        B_ShopDetailView.Dict=[ListArray objectAtIndex:[indexPath row]];
        B_ShopDetailView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:B_ShopDetailView animated:YES];
    }else{
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[ListArray ObjectAtIndex:[indexPath row]]];
        [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
        [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
        
        B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
        B_GoodsDetailView.Dict=dict;
        B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
    }
    

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil)// 是否是正在使用的视图
        
    {
       // self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
    // Dispose of any resources that can be recreated.
}

@end
