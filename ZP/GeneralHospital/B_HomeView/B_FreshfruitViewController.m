
//
//  B_SuperDealViewController.m
//  zhipin
//
//  Created by 佳李 on 15/7/12.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_FreshfruitViewController.h"
#import "FruitTableViewCell.h"
#import "B_GoodsDetailViewController.h"
#import "MJRefresh.h"
#import "B_ShoppingListViewController.h"
@interface B_FreshfruitViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *leftView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, assign)BOOL Ishow;

@end
#define HEIGHT 116
#define HEIGHTN 164

@implementation B_FreshfruitViewController
@synthesize ShopId;
@synthesize Type;
@synthesize CatId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        IsLine=YES;
        SelectIndex=1;
        PageIndex=1;
        
        BtnArray=[NSMutableArray new];
        // Custom initialization
    }
    return self;
}

-(void)titleAct:(UIButton *)sender
{
    for (UIButton *btn in BtnArray) {
        btn.selected=NO;
    }
    sender.selected=YES;
    SelectIndex=sender.tag+1;
    [self SearchShoppingOrder:[NSString stringWithFormat:@"%ld",SelectIndex]];
}


#pragma mark - ViewController 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[G_ShopCar allKeys] count]];
    NumLabel.hidden=[[G_ShopCar allKeys] count]==0;
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CategoryList = [NSMutableArray array];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    self.Ishow = NO;
    [self TopView];
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-40-60-50)];
    self.myTable.backgroundColor = [UIColor clearColor];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.rowHeight = 100;
    [self.view addSubview:self.myTable];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dictArray = [NSMutableArray array];
    
    SelectIndex = 3;
    [self SearchShoppingOrder:@"3"];
    
    [self initRightButton];

    
    UIView* TitleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    UILabel *lableView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    lableView.text=@"新鲜水果";
    lableView.textColor=[UIColor whiteColor];
    //    lableView.shadowColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
    //    lableView.shadowOffset=CGSizeMake(0, 0.2);
    lableView.textAlignment=NSTextAlignmentCenter;
    lableView.backgroundColor=[UIColor clearColor];
    lableView.font=[UIFont boldSystemFontOfSize:17];
    [TitleView addSubview:lableView];
    [self.navigationItem setTitleView:lableView];
    
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
    [self tomView];
    
    
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/index.jhtml?id=%@",ShopId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
                          if ([[ReturnDict objectForKey:@"categories"] count]>0) {
                              [LeftTable setListArray:[ReturnDict objectForKey:@"categories"]];
                              [LeftTable reloadData];
                              CategoryList=[[NSArray alloc] initWithArray:[ReturnDict objectForKey:@"categories"]];
                          }
                      }
                      NetError:^(int error) {
                          
                      }];
    
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IsLine?HEIGHT:HEIGHTN;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return IsLine?[self.dictArray count]:([self.dictArray count]/3+([self.dictArray count]%3>0?1:0));
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    static NSString *ident = @"cellfrrit";
    //    B_SuperDealCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    //    if (cell ==nil) {
    //        cell = [[B_SuperDealCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    //    }
    //    NSDictionary *dic = self.dictArray [indexPath.row];
    //    [cell showInfo:dic];
    //    NSLog(@"dic     %@", dic);
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
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[[self.dictArray ObjectAtIndex:row] ObjectForKey:@"imageurl" ]]];
        [cell.contentView addSubview:iconImage];
        
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width + 20, iconImage.frame.origin.y, SCREEN_WIDTH - iconImage.frame.size.width - 40, [[[self.dictArray ObjectAtIndex:row] ObjectForKey:@"name" ] length]>12?40:30)];
        titleLabel.text=[[self.dictArray ObjectAtIndex:row] ObjectForKey:@"name"];
        titleLabel.textColor=UIColorFromRGB(0x000000);
        titleLabel.numberOfLines=2;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:titleLabel];
        
        UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y  + titleLabel.frame.size.height, titleLabel.frame.size.width / 2, 20)];
        moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[self.dictArray ObjectAtIndex:row] ObjectForKey:@"price"] floatValue]];
        moneyLabel.textColor=UIColorFromRGB(0xfc4f01);
        //        moneyLabel.backgroundColor=[UIColor redColor];
        moneyLabel.font=[UIFont systemFontOfSize:18];
        moneyLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:moneyLabel];
        
        
        
        NSString *oldPrice = [NSString stringWithFormat:@"¥%.2f",[[[self.dictArray ObjectAtIndex:row] ObjectForKey:@"originalPrice"] floatValue]];
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
        evaluateLabel.text=[NSString stringWithFormat:@"%@人点评",[[self.dictArray ObjectAtIndex:row] ObjectForKey:@"evaluateCount"]];
        evaluateLabel.textColor=UIColorFromRGB(0x999999);
        evaluateLabel.backgroundColor=[UIColor clearColor];
        evaluateLabel.font=[UIFont systemFontOfSize:11];
        evaluateLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:evaluateLabel];
        
        
        UIView *linebottom= [[UIView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, HEIGHT - .5f, cell.frame.size.width - iconImage.frame.size.width, .5)];
        linebottom.backgroundColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:linebottom];
        
        
        
    }else{
        
        for (int i=0; i<3; i++) {
            
            if (row*3+i>=[self.dictArray count]) {
                break;
            }
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
            [iconImage sd_setImageWithURL:[NSURL URLWithString:[[self.dictArray ObjectAtIndex:index] ObjectForKey:@"imageurl" ]]];
            [arrowBtn addSubview:iconImage];
            
            UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(4, 96,90, 30)];
            titleLabel.text=[[self.dictArray ObjectAtIndex:index] ObjectForKey:@"name"];
            titleLabel.textColor=UIColorFromRGB(0x000000);
            titleLabel.numberOfLines=2;
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.font=[UIFont systemFontOfSize:11];
            titleLabel.textAlignment=NSTextAlignmentLeft;
            [arrowBtn addSubview:titleLabel];
            
            UIImageView *BackImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 130, 96, 0.5)];
            BackImage.backgroundColor=UIColorFromRGB(0xeeeeee);
            [arrowBtn addSubview:BackImage];
            
            NSString *str = [NSString stringWithFormat:@"¥%.1f",[[[self.dictArray ObjectAtIndex:index] ObjectForKey:@"price"] floatValue]];
            CGSize s = [str boundingRectWithSize:CGSizeMake(96 - 8, 14) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
            
            UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 134,85, 18)];
            moneyLabel.text= str;
            moneyLabel.textColor=UIColorFromRGB(0xfc4f01);
            
            moneyLabel.backgroundColor=[UIColor clearColor];
            moneyLabel.font=[UIFont systemFontOfSize:14];
            moneyLabel.textAlignment=NSTextAlignmentLeft;
            [arrowBtn addSubview:moneyLabel];
            
        }
        
        
    }
    
    //    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,IsLine? HEIGHT:HEIGHTN -0.5, SCREEN_WIDTH-10, 0.5)];
    //    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    //    [cell.contentView addSubview:lineImage];
    //
    //
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dictArray [indexPath.row];
    B_GoodsDetailViewController *vc = [[B_GoodsDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.Dict = @{@"code" : [dic [@"id"] stringValue], @"title" : dic [@"name"]};
    [self.navigationController pushViewController:vc  animated:YES];
    
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


#pragma mark --topView
-(void)TopView{
    //
    //    float w = [[UIScreen mainScreen]bounds].size.width;
    //
    //    NSArray *array = @[@"促销",@"新品",@"销量",@"价格"];
    //    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, 40)];
    //    topView.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:topView];
    //
    //
    //    for (int i = 0; i < 4; i++) {
    //        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((w/4)*i,0 , w/4 ,topView.frame.size.height)];
    //        button.backgroundColor = [UIColor clearColor];
    //
    //        button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    //        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
    //        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [button setTitleColor:[UIColor colorWithRed:87/255.0 green:204/255.0 blue:203/255.0 alpha:1] forState:UIControlStateSelected];
    //        button.tag = 100+i;
    //        [button addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        [topView addSubview:button];
    //
    //        UIView *linev = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width + 1, 10,0.5, 20)];
    //        linev.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
    //        [topView addSubview:linev];
    //
    //    }
    //
    //    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-1, w, 0.5)];
    //    bottomline.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
    //    [topView addSubview:bottomline];
    //
    //
    NSArray *titileArray=@[@"促销",@"新品",@"销量",@"价格"];
    float w = SCREEN_WIDTH / 4;
    for (int i=0; i<4; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(w * i, 0, w, 40);
        titleBtn.tag=i;
        if (i==2) {
            titleBtn.selected=YES;
        }
        [titleBtn setTitle:[titileArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitle:[titileArray objectAtIndex:i] forState:UIControlStateHighlighted];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [titleBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [titleBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(titleAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:titleBtn];
        [BtnArray addObject:titleBtn];
        [[titleBtn layer]setBorderWidth:0.5];
        [[titleBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    }
    
}
-(void)clickTopBtn:(UIButton *)button{   //100,101,102,103
    int tag = (int)button.tag;
    UIButton *btn0 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:103];
    
    if (tag == 100) {
        
        btn0.selected = YES;
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        
    }else if (tag == 101){
        
        btn0.selected = NO;
        btn1.selected = YES;
        btn2.selected = NO;
        btn3.selected = NO;
        
    }else if (tag == 102){
        btn0.selected = NO;
        btn1.selected = NO;
        btn2.selected = YES;
        btn3.selected = NO;
        
        
    }else if (tag == 103){
        
        btn0.selected = NO;
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = YES;
        
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
    
    
    UIButton *categrateBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 0, 50, 50)];
    [categrateBtn setTitle:@"分类" forState:UIControlStateNormal];
    [categrateBtn setTitleColor:[UIColor colorWithRed:42/255.0 green:134/255.0 blue:193/255.0 alpha:1] forState:UIControlStateNormal];
    [bottomView addSubview:categrateBtn];
    [categrateBtn addTarget:self action:@selector(menuAct) forControlEvents:UIControlEventTouchUpInside];
    //    UIButton *categrateVTpye = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    categrateVTpye.backgroundColor =[UIColor clearColor] ;
    //    [categrateVTpye setTitle:@"方格" forState:UIControlStateNormal];
    //    [categrateVTpye setTitle:@"列表" forState:UIControlStateSelected];
    //    [categrateVTpye setTitleColor:[UIColor colorWithRed:42/255.0 green:134/255.0 blue:193/255.0 alpha:1] forState:UIControlStateNormal];
    //    [categrateVTpye addTarget:self action:@selector(isShowType:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    categrateVTpye.center = CGPointMake(w-(25+20), bottomView.frame.size.height/2);
    //    [bottomView addSubview:categrateVTpye];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(SCREEN_WIDTH - 45, 5, 40, 40);
    [changeBtn setTitle:@"\ue601" forState:UIControlStateNormal];
    [changeBtn setTitle:@"\ue600" forState:UIControlStateSelected];
    [changeBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:35]];
    [changeBtn setTitleColor:UIColorFromRGB(0xe8c682) forState:UIControlStateNormal];
    [changeBtn setTitleColor:UIColorFromRGB(0xe8c682) forState:UIControlStateHighlighted];
    [changeBtn addTarget:self action:@selector(isShowType:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:changeBtn];
    
    
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
-(void)isShowType:(UIButton *)sender{
    self.myTable.backgroundColor=IsLine?UIColorFromRGB(0xeeeeee):UIColorFromRGB(0xffffff);
    IsLine = sender.selected;
    sender.selected=!sender.isSelected;
    [self.myTable reloadData];
}
#pragma mark --leftView
-(void)addleftView{
    //    float w = [[UIScreen mainScreen]bounds].size.width;
    //    float h = [[UIScreen mainScreen]bounds].size.height;
    //    NSArray *array = @[@"所有分类",@"美食",@"购物",@"旅游",@"休闲娱乐",@"亲子",@"酒店",@"健身"];
    //
    //
    //    self.leftView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, h, w/2-20, h-60-50)];
    //    self.leftView.backgroundColor = [UIColor blackColor];
    //    self.leftView.alpha = 0.5;
    //
    //    self.leftView.contentSize = CGSizeMake(self.leftView.frame.size.width, 60*array.count);
    //    [self.view addSubview:self.leftView];
    //
    //    for(int i =0;i<array.count;i++){
    //        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i*60, self.leftView.frame.size.width, 60)];
    //        button.backgroundColor = [UIColor clearColor];
    //        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
    //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [self.leftView addSubview: button];
    //        [button addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    //        button.tag = 200+i;
    //        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.size.height+button.frame.origin.y+1, button.frame.size.width, .5)];
    //        line.backgroundColor = [UIColor whiteColor];
    //        [self.leftView addSubview:line];
    //    }
    
    //    [self getCategory];
    
    
    LeftTable =[[B_LeftTableView alloc] initWithFrame:CGRectMake(-WWW, 0, WWW, SCREEN_HIGHE-110)];
    LeftTable.showsHorizontalScrollIndicator=NO;
    LeftTable.tableFooterView = [[UIView alloc] init];
    LeftTable.showsVerticalScrollIndicator=NO;
    LeftTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    LeftTable.separatorColor=[UIColor whiteColor];
    LeftTable.alpha = .85f;
    LeftTable.backgroundColor = [UIColor blackColor];
    [self.view addSubview:LeftTable];
    LeftTable.hidden=LeftTable.frame.origin.x==-WWW;
    [LeftTable SetClickBlock:^(NSString * string) {
        [self menuAct];
        CatId=string;
        Type=@"3";
        [self SearchShoppingOrder:@"3"];
        
    }];
    [LeftTable setListArray:CategoryList];
    [LeftTable reloadData];
    
}

- (void)getCategory
{
    //    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/shop/index.jhtml?id=%@",[Dict objectForKey:@"code"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //    [NetRequest setASIPostDict:nil
    //                       ApiName:@""
    //                     CanCancel:YES
    //                   SetHttpType:HttpGet
    //                     SetNotice:NoticeType1
    //                    SetNetWork:NetWorkTypeAS
    //                    SetProcess:ProcessType8
    //                    SetEncrypt:Encryption
    //                      SetCache:Cache
    //                      NetBlock:^(NSDictionary *ReturnDict){
    //
    //                          if ([[ReturnDict objectForKey:@"categories"] count]>0) {
    //                              [CategoryList addObjectsFromArray:[ReturnDict objectForKey:@"categories"]];
    //                          }
    //                      }
    //                      NetError:^(int error) {
    //                      }
    //     ];
    
}

- (void)menuAct
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        LeftTable.frame=CGRectMake(LeftTable.frame.origin.x==-WWW?0:-WWW, 0, WWW, SCREEN_HIGHE-114);
        LeftTable.hidden=!LeftTable.isHidden;
    } completion:^(BOOL finished) {
    }];
}

-(void)ArrowAct:(UIButton *)sender
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[self.dictArray ObjectAtIndex:sender.tag]];
    [dict setObject:[dict objectForKey:@"id"] forKey:@"code"];
    [dict setObject:[dict objectForKey:@"name"] forKey:@"title"];
    B_GoodsDetailViewController *B_GoodsDetailView=[[B_GoodsDetailViewController alloc] init];
    B_GoodsDetailView.Dict=dict;
    B_GoodsDetailView.shopID = self.ShopId;
    B_GoodsDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_GoodsDetailView animated:YES];
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

#pragma mark - CustomMethod
-(void)SearchShoppingOrder:(NSString *)string
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
                          if ([[ReturnDict objectForKey:@"data"] count]<10) {
                              [self.myTable removeFooter];
                          }
                          [self.dictArray removeAllObjects];
                          [self.dictArray addObjectsFromArray:[ReturnDict objectForKey: @"data"]];
                          
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.myTable reloadData];
                          });
                      }
                      NetError:^(int error) {
                      }
     ];
    
    
    //     上拉刷新
    __weak UITableView* tableView= self.myTable;
    __weak NSMutableArray *listArray= self.dictArray;
    [self.myTable addLegendFooterWithRefreshingBlock:^{
        
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
                                  [self.myTable removeFooter];
                              }
                              [self.dictArray addObjectsFromArray:[ReturnDict objectForKey:@"data"]];
                              [self.myTable.footer endRefreshing];
                              [self.myTable reloadData];
                          }
                          NetError:^(int error) {
                          }
         ];
    }];
    
}

@end
