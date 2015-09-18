

//
//  B_LimitedDealViewController.m
//  zhipin
//
//  Created by 佳李 on 15/7/8.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_LimitedDealViewController.h"
#import "B_LimitDealCell.h"
#import "B_GoodsDetailViewController.h"
#import "B_ShoppingListViewController.h"
#import "MJRefresh.h"

@interface B_LimitedDealViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate, LimitDealCellDelegate>
{
    UIButton *rightButton;
    NSString *countDownTime;
    NSInteger myTag;
    NSInteger PageIndex;
}
@property (nonatomic, strong) UIScrollView *leftView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, assign)BOOL Ishow;
@end

@implementation B_LimitedDealViewController
@synthesize countDownTime;
#pragma mark - ViewController 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)initProInfo:(NSInteger)promotionid
{
        PageIndex=1;
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/promotion/productlist.jhtml?page=%ld&promotionId=%ld",  PageIndex++,(long)promotionid]]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType8
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict) {
                                                NSLog(@"returnDic---> %@", ReturnDict);
                          
                          [self.productListArray removeAllObjects];
                          [self.productListArray addObjectsFromArray: [[ReturnDict objectForKey:@"data"] objectForKey:@"productList"]];
                          [self.myTable reloadData];
                      }
                      NetError:^(int error) {
                          
                      }
     ];
    
        //     上拉刷新


    [self.myTable addLegendFooterWithRefreshingBlock:^{
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/promotion/productlist.jhtml?page=%ld&promotionId=%ld",  PageIndex++,(long)promotionid]]];
        [NetRequest setASIPostDict:nil
                           ApiName:@""
                         CanCancel:YES
                       SetHttpType:HttpGet
                         SetNotice:NoticeType1
                        SetNetWork:NetWorkTypeAS
                        SetProcess:ProcessType8
                        SetEncrypt:Encryption
                          SetCache:Cache
                          NetBlock:^(NSDictionary *ReturnDict) {
                              NSLog(@"returnDic---> %@", ReturnDict);
                              
                              if ([[ReturnDict objectForKey:@"data"] count]<10) {
                                  [self.myTable removeFooter];
                              }
                              [self.productListArray addObjectsFromArray: [[ReturnDict objectForKey:@"data"] objectForKey:@"productList"]];
                              [self.myTable.footer endRefreshing];
                              [self.myTable reloadData];
                              
                          }
                          NetError:^(int error) {
                              
                          }
         ];
    }];


    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.productListArray = [[NSMutableArray alloc] init];

    myTag = 1;

    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];

    NSLog(@"ARRAY       %@",self.productListArray);
    UIView* TitleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    lableView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    lableView.text=@"限时抢购";
    lableView.textColor=[UIColor whiteColor];
    //    lableView.shadowColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
    //    lableView.shadowOffset=CGSizeMake(0, 0.2);
    lableView.textAlignment=NSTextAlignmentCenter;
    lableView.backgroundColor=[UIColor clearColor];
    lableView.font=[UIFont boldSystemFontOfSize:17];
    [TitleView addSubview:lableView];
    [self.navigationItem setTitleView:lableView];
    
    [self initRightButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.Ishow = NO;
    [self TopView];
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-40-60)];
    self.myTable.backgroundColor = [UIColor clearColor];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    flowLayout.headerReferenceSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, 60);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, self.myTable.frame.size.width, self.myTable.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor redColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"iwDisCell"];
    //    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    
    self.collectionView.hidden = YES;
    [self addleftView];
//    [self tomView];
    
    
    
    PageIndex=1;
    [self initProInfo:self.currentPromotionId];
    
    
 }




- (void)initRightButton
{
    
    rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 30, 40)];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    iv.image = [UIImage imageNamed:@"shopcart1"];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [rightButton addSubview:iv];
    iv.center = CGPointMake(15, 20);
    
    [rightButton addTarget:self action:@selector(rightAct) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    [self.navigationItem setRightBarButtonItem:titleButton];
}

- (void)rightAct
{
    B_ShoppingListViewController *vc = [[B_ShoppingListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (myTag == 1) {
        static NSString *ident = @"dealCell";
        B_LimitDealCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
        if (cell ==nil) {
            cell = [[B_LimitDealCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        NSDictionary *dic = [self.productListArray objectAtIndex:indexPath.row];
        NSLog(@"%@", self.productListArray);
        [cell showInfo:dic];
        [cell refreshTimeWithTime: [dic objectForKey:@"remainTime"]];
        cell.delegate = self;
        return cell;
    } else
    {
        static NSString *ident = @"dealCell1";
        B_LimitDealCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ident];
        if (cell ==nil) {
            cell = [[B_LimitDealCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        NSDictionary *dic = [self.productListArray objectAtIndex:indexPath.row];
        NSLog(@"%@", self.productListArray);
        [cell showInfo:dic];
        [cell refreshTimeWithTime: [dic objectForKey:@"remainTime"]];
        cell.delegate = self;
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.productListArray objectAtIndex:indexPath.row];
    B_GoodsDetailViewController *vc = [[B_GoodsDetailViewController alloc] init ];
    vc.hidesBottomBarWhenPushed=YES;
    vc.Dict = @{@"code" : [dic [@"productId"] stringValue], @"title" : dic [@"productName"]};
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"iwDisCell" ;
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width/3, [[UIScreen mainScreen]bounds].size.width/3)];
        cell.backgroundColor = [UIColor grayColor];
    }
    
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    float w = [[UIScreen mainScreen]bounds].size.width/3;
    return CGSizeMake(w-10,w-10);
}
//
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,0,0, 0);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
/*
 //  headerView
 -(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
 
 //    UICollectionReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
 //    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, 40)];
 //
 //    NSString *text ;
 //    if (indexPath.section == 0) {
 //        text = @"    企业悬赏";
 //    }else if (indexPath.section ==1){
 //        text = @"    生活优惠";
 //    }
 //
 //    headLabel.text = text;
 //    headLabel.font = [UIFont systemFontOfSize:12.f];
 //    headLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
 //    [headerV addSubview:headLabel];
 //
 //    return headerV;
 return nil;
 
 }
 */

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}

#pragma mark LimitedDelegate
- (void)pushToDetailWithItemID:(NSInteger)itemid andName:(NSString *)name
{
    B_GoodsDetailViewController *vc = [[B_GoodsDetailViewController alloc] init ];
    vc.hidesBottomBarWhenPushed=YES;
    vc.Dict = @{@"code" : @(itemid).stringValue, @"title" : name};
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --topView
-(void)TopView{
    
    float w = [[UIScreen mainScreen]bounds].size.width;
    
    NSArray *array = @[@"10点场", @"下期预告"];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, 40)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((w/2)*i, 0, w/2 ,topView.frame.size.height)];
        button.backgroundColor = [UIColor clearColor];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitleColor : ZPSystemColor forState:UIControlStateSelected];
        button.tag = 100+i;
        [button addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [topView addSubview:button];
        
        UIView *linev = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width + 1, 12.5, 0.5, 15)];
        linev.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
        [topView addSubview:linev];

    }
    
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-1, w, 0.5)];
    bottomline.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
    [topView addSubview:bottomline];
    
    
    
}
-(void)clickTopBtn:(UIButton *)button{   //100,101,102,103
    int tag = (int)button.tag;
    UIButton *btn0 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
   
    
    if (tag == 100) {
        
        btn0.selected = YES;
        btn0.tintColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
        btn1.selected = NO;
        btn1.tintColor = [UIColor whiteColor];
        lableView.text  = @"限时抢购";
        [self initProInfo:self.currentPromotionId];
        myTag = 1;
    }else if (tag == 101){
        
        btn0.selected = NO;
        btn1.selected = YES;
        btn1.tintColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
        btn0.tintColor = [UIColor whiteColor];

         lableView.text=@"下期预告";
        [self initProInfo:self.nextPromotionId];
        myTag = 2;
 

    }
    
    
}
#pragma mark --bottomView
-(void)tomView{
    
    float w = [[UIScreen mainScreen]bounds].size.width;
    float h = [[UIScreen mainScreen]bounds].size.height;
    
    
    UIView *bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, h-50-60, w, 50)];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.tag = 300;
    [self.view addSubview:bottomView];
    
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, 1, w, 0.5)];
    bottomline.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
    [bottomView addSubview:bottomline];
    
    
    UIButton *categrateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [categrateBtn setTitle:@"分类" forState:UIControlStateNormal];
    [categrateBtn setTitleColor:[UIColor colorWithRed:42/255.0 green:134/255.0 blue:193/255.0 alpha:1] forState:UIControlStateNormal];
    categrateBtn.center = CGPointMake(25+10, bottomView.frame.size.height/2);
    [bottomView addSubview:categrateBtn];
    [categrateBtn addTarget:self action:@selector(isShowLeftView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *categrateVTpye = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    categrateVTpye.backgroundColor =[UIColor clearColor] ;
    [categrateVTpye setTitle:@"方格" forState:UIControlStateNormal];
    [categrateVTpye setTitle:@"列表" forState:UIControlStateSelected];
    [categrateVTpye setTitleColor:[UIColor colorWithRed:42/255.0 green:134/255.0 blue:193/255.0 alpha:1] forState:UIControlStateNormal];
    [categrateVTpye addTarget:self action:@selector(isShowType:) forControlEvents:UIControlEventTouchUpInside];
    
    categrateVTpye.center = CGPointMake(w-(25+20), bottomView.frame.size.height/2);
    [bottomView addSubview:categrateVTpye];
    
    [self.view bringSubviewToFront:bottomView];
    
}
-(void)isShowLeftView:(UIButton *)button{
    
    
    float w = [[UIScreen mainScreen]bounds].size.width;
    float h = [[UIScreen mainScreen]bounds].size.height;
    self.Ishow = !self.Ishow;
    if (self.Ishow) {
        [UIView animateWithDuration:0.5 animations:^{
            self.leftView.frame = CGRectMake(0, 0, w/2-20, h-60-50);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.leftView.frame = CGRectMake(0,h, w/2-20, h-60-50);
        }];
    }
    
}
-(void)isShowType:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.myTable.hidden = YES;
        self.collectionView.hidden = NO;
    }else{
        self.myTable.hidden = NO;
        self.collectionView.hidden = YES;
    }
}
#pragma mark --leftView
-(void)addleftView{
    float w = [[UIScreen mainScreen]bounds].size.width;
    float h = [[UIScreen mainScreen]bounds].size.height;
    NSArray *array = @[@"所有分类",@"美食",@"购物",@"旅游",@"休闲娱乐",@"亲子",@"酒店",@"健身"];
    
    
    self.leftView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, h, w/2-20, h-60-50)];
    self.leftView.backgroundColor = [UIColor blackColor];
    self.leftView.alpha = 0.5;
    
    self.leftView.contentSize = CGSizeMake(self.leftView.frame.size.width, 60*array.count);
    [self.view addSubview:self.leftView];
    
    for(int i =0;i<array.count;i++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i*60, self.leftView.frame.size.width, 60)];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftView addSubview: button];
        [button addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 200+i;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.size.height+button.frame.origin.y+1, button.frame.size.width, .5)];
        line.backgroundColor = [UIColor whiteColor];
        [self.leftView addSubview:line];
    }
    
}
-(void)clickLeftButton:(UIButton *)button{
    float w = [[UIScreen mainScreen]bounds].size.width;
    float h = [[UIScreen mainScreen]bounds].size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.leftView.frame = CGRectMake(-w/2-20,0, w/2-20, h-60-50);
        
    } completion:^(BOOL finished) {
        self.leftView.frame = CGRectMake(0, h, w/2-20, h-60-50);
        
    }];
    self.Ishow = NO;
    
    
}
@end

