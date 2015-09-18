//
//  B_FirstViewController.m
//  zhipin
//
//  Created by 佳李 on 15/7/1.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_FirstViewController.h"
#import "DLIDEKeyboardView.h"
#import "B_ShopSearchViewController.h"
#import "B_LocationViewController.h"
#import "B_AdDetailViewController.h"
#import "B_LimitedDealViewController.h"
#import "B_GoodsListViewController.h"
#import "B_SuperDealViewController.h"
#import "B_GoodsDetailViewController.h"
#import "B_FreshfruitViewController.h"
#import "MJRefresh.h"
#import "B_GoodUrlViewController.h"
#import "B_ShoppingListViewController.h"

@interface B_FirstViewController ()<UIGestureRecognizerDelegate>
{
    UIView *countView;
    NSMutableArray *productListArray;
    NSDictionary *returnInfo;
    UIScrollView *vi;
    
    UILabel *hourLabel;
    UILabel *minuteLabel;
    UILabel *secLabel;
    
    NSMutableArray *aryPots;
    NSInteger indexPot ;
    UIScrollView *scMain;
    NSMutableArray *adArray;
    CGFloat w;
    NSTimer *countTimer;
    NSInteger time;
    UIImageView *catIV;
    UIButton *rightButton;
    
    CLLocation *location;
    
    NSInteger promotionId;
    NSInteger currentPromotionId;
    NSInteger nextPromotionId;
    BOOL isStarted;
    UILabel *lastLabel;
}
@end

@implementation B_FirstViewController

#pragma mark - ViewController LifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self initSearchBar];
    
 
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    [SearchBar removeFromSuperview];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    LocString = @"杭州";
//    [self initSearchBar];
    productListArray = [NSMutableArray array];
    self.cityCode = @"C0007";
    [self handleLocationManager];
    [self initLeftButton];
    [self initRightButton];
    [self initScrollView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCity:) name:@"updateCity" object:nil];
    adArray = [NSMutableArray array];
    //[self initLimitedTimeDeal];

}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    B_ShopSearchViewController *B_ShopSearch=[[B_ShopSearchViewController alloc] init];
    B_ShopSearch.KeyWord=searchBar.text;
    B_ShopSearch.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_ShopSearch animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier ];
        cell.backgroundColor = [UIColor colorWithWhite:.88f alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
     return cell;
}

#pragma mark - CustomMethod


- (void)initScrollView
{
    vi = [[UIScrollView alloc] initWithFrame:CGRectZero];
    vi.bounces = YES;
    vi.showsHorizontalScrollIndicator = NO;

    vi.delegate = self;
    vi.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE);
    //vi.backgroundColor = [UIColor colorWithWhite:.88f alpha:1];
    vi.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.view addSubview: vi];
    vi.scrollEnabled = YES;
    
    __weak __typeof(self)weakSelf = self;
    [vi addLegendHeaderWithRefreshingBlock:^{
        [weakSelf initLimitedTimeDeal];
    
    }];
    
    
    float h = 0;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
//    imageView.backgroundColor = [UIColor orangeColor];

//    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [imageButton setBackgroundColor:[UIColor clearColor]];
//    [imageButton setFrame:imageView.bounds];
//    [vi addSubview:imageButton];
//    [imageButton addTarget:self action:@selector(adVC) forControlEvents:UIControlEventTouchUpInside];

    scMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    scMain.showsHorizontalScrollIndicator = NO;
    scMain.delegate = self;
    
    [vi addSubview:scMain];
    h += scMain.frame.size.height;
    
    UIView *logoView = [[UIView alloc] init];
    logoView.backgroundColor = [UIColor whiteColor];
    
    CGFloat edge = 30;
    CGFloat radius = (SCREEN_WIDTH - (30 * 2)) /3;
    NSArray *imageArray = @[@"未标题-1_05.png", @"未标题-1_03.png", @"未标题-1_07.png"];
    NSArray *titleArray = @[@"商铺推荐", @"超值好货", @"新鲜水果"];
    NSArray *colorArray = @[[UIColor orangeColor], STYLECLOLR, [UIColor blueColor]];
    
    for (int i = 0 ; i < 3; i++) {
        UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[logoButton setFrame:CGRectMake(edge + i * radius - 30*i, 0, radius, radius + 20)];
        [logoButton setFrame:CGRectMake( 5+ i * radius - 20*i, 0, radius, radius + 20)];
        logoButton.tag = i;
    
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, radius - 40, radius - 40)];
        iv.backgroundColor = [UIColor whiteColor];
        UIColor *color = colorArray[i];
        iv.layer.borderColor = color.CGColor;
        [logoButton addSubview:iv];
        iv.layer.cornerRadius = radius / 2 - 20;
        iv.image = [UIImage imageNamed:imageArray [i]];

        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, radius - 15 , radius - 10, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        [logoButton addSubview:label];
        
        [logoView addSubview:logoButton];
        [logoButton addTarget:self action:@selector(logoMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    logoView.frame = CGRectMake(0, 130 + 10, SCREEN_WIDTH, radius + 20);
    [vi addSubview:logoView];
    
    h+=  20 + radius  + 10;
    
    int kHeight = 140;
    if (IS_IPHONE_6) {
        kHeight = 180;
    } else if(IS_IPHONE_6P)
    {
        kHeight = 200;
    }
    countView = [[UIView alloc] initWithFrame:CGRectMake(5, h + 10, SCREEN_WIDTH - 10, kHeight)];
    countView.backgroundColor = [UIColor whiteColor];
    [vi addSubview:countView ];
    
    UILabel *dealLabel = [[UILabel alloc] init];
    NSString *string = @"限时抢购";
    CGRect s = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes : @{ NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    dealLabel.frame = CGRectMake(12, 12, s.size.width, s.size.height);
    dealLabel.font = [UIFont systemFontOfSize:14];
    dealLabel.text = string;
    dealLabel.tag = 0;
    dealLabel.textColor = UIColorFromRGB(0xdd662b);
    [countView addSubview:dealLabel];
    

    NSString *lastString = @"距开始";
    lastLabel = [[UILabel alloc] init];
    CGRect lastS = [lastString boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:  NSStringDrawingUsesFontLeading attributes : @{ NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    lastLabel.frame = CGRectMake(SCREEN_WIDTH - 110 - lastS.size.width, 12, 40, s.size.height);
    lastLabel.text = lastString;
    lastLabel.font = [UIFont systemFontOfSize:12];
    lastLabel.textColor =UIColorFromRGB(0x666666);
    lastLabel.tag = 0;
    [countView addSubview:lastLabel];
    
    CGFloat origin = lastLabel.frame.origin.x + lastLabel.frame.size.width ;
    CGFloat width = SCREEN_WIDTH - lastLabel.frame.origin.x - lastLabel.frame.size.width;
    CGFloat viewWidth = width - 15 - 40 - 14;
    w = viewWidth / 3;
    
    hourLabel = [[UILabel alloc] init];
//    hourLabel.frame = CGRectMake(origin + i *(w + 10), 12, w, 16);
    hourLabel.frame = CGRectMake(origin, 12, w, 16);
    hourLabel.backgroundColor = [UIColor blackColor];
    hourLabel.textColor = [UIColor whiteColor];
    hourLabel.font = [UIFont systemFontOfSize:10];
    hourLabel.textAlignment = NSTextAlignmentCenter;
    hourLabel.text = @"11";
    [countView addSubview:hourLabel];
    
    UILabel *symbol1 = [[UILabel alloc] init];
    symbol1.frame = CGRectMake(0, 0, 7, 16);
    symbol1.text = @":";
    symbol1.center = CGPointMake(hourLabel.center.x + w /2  + 5, 8 + 12);
    symbol1.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:symbol1];
    
    
    minuteLabel = [[UILabel alloc] init];
    minuteLabel.frame = CGRectMake(origin + (w + 10), 12, w, 16);
    minuteLabel.backgroundColor = [UIColor blackColor];
    minuteLabel.textColor = [UIColor whiteColor];
    minuteLabel.font = [UIFont systemFontOfSize:10];
    minuteLabel.textAlignment = NSTextAlignmentCenter;
    minuteLabel.text = @"11";
    [countView addSubview:minuteLabel];

    UILabel *symbol2 = [[UILabel alloc] init];
    symbol2.frame = CGRectMake(0, 0, 7, 16);
    symbol2.text = @":";
    symbol2.center = CGPointMake(minuteLabel.center.x + w /2  + 5, 8 + 12);
    symbol2.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:symbol2];

    
    secLabel = [[UILabel alloc] init];
    secLabel.frame = CGRectMake(origin + (w + 10) * 2, 12, w, 16);
    secLabel.backgroundColor = [UIColor blackColor];
    secLabel.textColor = [UIColor whiteColor];
    secLabel.font = [UIFont systemFontOfSize:10];
    secLabel.textAlignment = NSTextAlignmentCenter;
    secLabel.text = @"11";
    [countView addSubview:secLabel];

    UILabel *labelBig = [[UILabel alloc] init];
    labelBig.frame = CGRectMake(origin + 2 * (w + 10) + w + 5, 12, 10, 10);
    labelBig.text = @">";
    labelBig.font = [UIFont systemFontOfSize:14];
    labelBig.textColor = [UIColor colorWithWhite:.2f alpha:1];
    labelBig.tag = 0;
    [countView addSubview:labelBig];
    
    
    CGFloat picOriginX = 25;
    CGFloat picOriginY = dealLabel.frame.origin.x + dealLabel.frame.size.height + 15;
    CGFloat gap = 28;
    CGFloat wid = (SCREEN_WIDTH - 10 -30 * 2- 28 * 2 ) / 3;
    
    
    for (int i = 0 ; i < 3; i++) {
        UIImageView *dealimageView= [[UIImageView alloc] init];
        dealimageView.frame = CGRectMake(picOriginX + i * (wid + gap), picOriginY, wid, wid);
        dealimageView.backgroundColor = [UIColor colorWithWhite:.68f alpha:1];
        [countView addSubview:dealimageView];
        dealimageView.hidden = YES;
        //dealimageView.layer.borderWidth = .5f;
        dealimageView.layer.borderColor = [UIColor orangeColor].CGColor;
        dealimageView.tag = i;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.frame = CGRectMake(picOriginX + i * (wid + gap), picOriginY + wid + 10, 50, 16);
        priceLabel.text = [NSString stringWithFormat:@"3%d元", i];
        priceLabel.textColor = UIColorFromRGB(0xff6633);
        priceLabel.font = [UIFont systemFontOfSize:12];
        [countView addSubview:priceLabel];
        priceLabel.hidden = YES;
        priceLabel.tag = i + 1;
        
        UILabel *oldPrice = [[UILabel alloc] init];
        oldPrice.frame = CGRectMake(picOriginX + 40 + i * (wid + gap) + 10, picOriginY + wid + 12, 50, 16);
        oldPrice.text = [NSString stringWithFormat:@"3%d元", i];
        oldPrice.textColor = UIColorFromRGB(0x6ad3d4);
        oldPrice.font = [UIFont systemFontOfSize:8];
        [countView addSubview:oldPrice];
        oldPrice.hidden = YES;
        oldPrice.tag = i + 5;
        
 
        
    }
    
    
    
     h += countView.frame.size.height;
    
//    vi.frame = CGRectMake(0, 0, SCREEN_WIDTH, h + 15 + 40);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setFrame:countView.bounds];
    [countView addSubview:button];
    [button addTarget:self action:@selector(showLimitedDeal) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark bottomView
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(countView.frame) + 12, SCREEN_WIDTH, 160)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [vi addSubview:bottomView];
    
}


#pragma mark 跳转
- (void)showLimitedDeal
{
    B_LimitedDealViewController *vc = [[B_LimitedDealViewController alloc] init];
    //vc.productListArray = productListArray;
    //vc.promotionId = promotionId;
    vc.currentPromotionId = currentPromotionId;
    vc.nextPromotionId = nextPromotionId;
    vc.countDownTime = [NSString stringWithFormat:@"%ld", (long)time];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initSearchBar {
    //导航栏
    SearchBar = [[UISearchBar alloc] init];
    SearchBar.frame = CGRectMake(0, 0, 160, 44);
    SearchBar.center = CGPointMake(SCREEN_WIDTH / 2, 22);
    SearchBar.placeholder = @"查找商铺、商品";
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
    [self.navigationController.navigationBar addSubview:SearchBar];
}

- (void)initLeftButton {

    leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 60, 40)];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 25, 30)];
    iv.image = [UIImage imageNamed:@"location"];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [leftButton addSubview:iv];
    
    citylabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 40, 40)];
    citylabel.text = LocString;
    citylabel.font = [UIFont systemFontOfSize:15];
    citylabel.textColor = [UIColor whiteColor];
    [leftButton addSubview:citylabel];
    
    [leftButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAct) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    [self.navigationItem setLeftBarButtonItem:titleButton];
}

- (void)initRightButton
{
    
    rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 30, 40)];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
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
    B_ShoppingListViewController *B_ShoppingList=[[B_ShoppingListViewController alloc] init];
    B_ShoppingList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_ShoppingList animated:YES];
}


#pragma mark 获取数据
- (void)initLimitedTimeDeal
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/index.jhtml?city=%@",self.cityCode  ]]];
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
                          [vi.header endRefreshing];
                          NSLog(@"returnDic test01---> %@", ReturnDict);
                          if (returnInfo && [returnInfo isEqual:ReturnDict]) {
                              return ;
                          }
                          returnInfo = ReturnDict ;
                          [productListArray removeAllObjects];
                          [productListArray addObjectsFromArray: [[ReturnDict objectForKey:@"data"] objectForKey:@"productList"]];
                          
                          //promotionId = [[[ReturnDict objectForKey:@"data"] objectForKey:@"promotionId"] integerValue];
                          currentPromotionId = [[[ReturnDict objectForKey:@"data"] objectForKey:@"currentPromotionId"] integerValue];
                          nextPromotionId = [[[ReturnDict objectForKey:@"data"] objectForKey:@"nextPromotionId"] integerValue];
                          
                          if ([[[ReturnDict objectForKey:@"data"] objectForKey:@"isPromotionStarted"] integerValue] == 0) {
                              lastLabel.text = @"距开始";
                          } else {
                              lastLabel.text = @"剩余";
                          }
                          
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self refreshView:ReturnDict];
                          });
                          
                      }
                      NetError:^(int error) {
                          //[vi removeHeader];
                          [vi.header endRefreshing];
                      }
     ];

    
}

- (void)refreshView: (NSDictionary *)dic
{
    dic = dic [@"data"];
    NSArray *productArray  = [dic ObjectForKey:@"productList"];
         for (UIView *subView in countView.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                if (subView.tag > productArray.count) {
                    return;
                }
                NSDictionary *dic = [productArray objectAtIndex:subView.tag];

                subView.hidden = NO;
                NSString *str = [dic ObjectForKey:@"imageUrl"];
                UIImageView *imageView = (UIImageView *)subView;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                

                
            }else if ([subView isKindOfClass:[UILabel class]] && subView.tag && (subView.tag - 4) < 0){
                NSDictionary *dic = [productArray objectAtIndex:subView.tag - 1];
                subView.hidden = NO;
                double price = [[dic objectForKey:@"price"] doubleValue];
                UILabel *label = (UILabel *)subView;
                label.text = [NSString stringWithFormat:@"%.2f元", price];
            
            }else if([subView isKindOfClass:[UILabel class]] && (subView.tag - 4) > 0){
                NSDictionary *dic = [productArray objectAtIndex:subView.tag - 5 ];
                subView.hidden = NO;
                double oldprice = [[dic objectForKey:@"orginalPrice"] doubleValue];
                UILabel *label = (UILabel *)subView;
                label.text = [NSString stringWithFormat:@"%.2f元", oldprice];
                
                CGSize s = [[NSString stringWithFormat:@"%.2f元", oldprice] boundingRectWithSize:CGSizeMake(MAXFLOAT, 10) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} context:nil].size;

                
                UILabel *linelabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x , label.frame.origin.y + label.frame.size.height / 2, s.width -4, .5f)];
                linelabel.backgroundColor = UIColorFromRGB(0x6ad3d4);
                [countView addSubview: linelabel];
                
                
            }
        }
//    time = [dic [@"remainTime"] integerValue] / 1000000;
//    NSInteger hour = time / 3600;
//    NSInteger min = (time - hour * 3600) / 60;
//    NSInteger sec = time - hour * 3600 - min * 60 ;
    time = [dic [@"remainTime"] integerValue] /1000;
    NSInteger hour = time / 3600;
    NSInteger min = (time/ 60)%60;
    NSInteger sec = time%60 ;
    
    [countTimer invalidate];
    
    hourLabel.text = [NSString stringWithFormat:@"%.2ld", (long)hour];
    minuteLabel.text = [NSString stringWithFormat:@"%.2d", (int)min];
    secLabel.text = [NSString stringWithFormat:@"%.2d", (int)sec];
    
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(minusSecond:) userInfo:nil repeats:YES];
    
    adArray = [dic objectForKey:@"advertises"];
    if (adArray && adArray.count > 0) {
        for (int i = 0; i < adArray.count; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH , 0, SCREEN_WIDTH, 130)];
            NSDictionary *dic = [adArray objectAtIndex:i];
            NSString *imageString = [dic objectForKey:@"imageurl"];
            NSLog(@"imageString %@", imageString);
            [iv sd_setImageWithURL:[NSURL URLWithString:imageString] ];
            iv.contentMode = UIViewContentModeScaleAspectFill;
            [scMain addSubview:iv];

             
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = iv.bounds;
            button.backgroundColor = [UIColor clearColor];
            [iv addSubview:button];
            iv.userInteractionEnabled = YES;
            button.tag = i;
            [button addTarget:self action:@selector(showAdDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
        scMain.pagingEnabled = YES;
        [scMain setContentSize:CGSizeMake(SCREEN_WIDTH * [adArray count], 130)];
        aryPots = [NSMutableArray array];
        float wpot = 10;
        float space = 5;
        float sumPosts = (wpot+space)*[adArray count];
        
        NSLog(@"%ld", (unsigned long)[adArray count]);
        
        float xFrom = (SCREEN_WIDTH-sumPosts)/2;
        for (int i=0; i<[adArray count]; i++) {
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(xFrom+i*(wpot+space), 130-15, 8, 8)];
            imgv.tag = i;
            imgv.layer.cornerRadius = 4;
            imgv.layer.borderColor = [UIColor colorWithWhite:.88F alpha:1].CGColor;
            imgv.layer.borderWidth = .5f;
            if (i==0) {
                imgv.backgroundColor = [UIColor whiteColor];

            }else{
                imgv.backgroundColor = UIColorFromRGB(0x5cd6d6);

             }
            imgv.userInteractionEnabled = NO;
            //[vi addSubview:imgv];
            //[aryPots removeAllObjects];
            [aryPots addObject:imgv];
        }
        
        indexPot = 0;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(turnPage:) object:scMain];
        [self performSelector:@selector(turnPage:) withObject:scMain afterDelay:3];
        
    }
    
}

- (void)minusSecond: (NSTimer *)timer
{
    
    int second = [secLabel.text intValue];
    int minute = [minuteLabel.text intValue];
    int hour = [hourLabel.text intValue];

    if (hour == 0) {
        if (minute == 0) {
            if (second == 0) {
                countTimer = nil;
                [countTimer invalidate   ];
            }else{
                second--;
            }
        }else{
  
                if (second == 0) {
                    minute--;
                    second = 60;
                    second--;
                }else{
                    second--;
                }
         }
    }else{
        if (minute == 0) {
            if (second == 0) {
                hour--;
                minute = 59;
                second = 60;
                second--;
            }else{
                if (second < 0) {
                    second = 60;
                }
                second--;
            }
        }else{
            if (second == 0) {
                second = 60;
                minute--;
                second--;
            }else{

                second--;
            }
        }
    }
    

    secLabel.text = [NSString stringWithFormat:@"%.2d", second];
    minuteLabel.text = [NSString stringWithFormat:@"%.2d", minute];
    hourLabel.text = [NSString stringWithFormat:@"%.2d", hour];
    time  = hour * 3600 + minute * 60 + second;
}


- (void)turnPage:(UIScrollView *)sc{
    
    if (indexPot<[adArray count]) {
        [sc setContentOffset:CGPointMake(indexPot*SCREEN_WIDTH, 0) animated:YES];
    }else{
        indexPot = 0;
        [sc setContentOffset:CGPointMake(indexPot*SCREEN_WIDTH, 0) animated:NO];
    }
    
    //    float x = sc.contentOffset.x;
    //    int page = x/DEVICE_WIDTH;
    
    for (int i=0; i<[aryPots count]; i++) {
        UIImageView *imgvPot = [aryPots objectAtIndex:i];
        if (i==indexPot) {
            imgvPot.backgroundColor = [UIColor whiteColor];
        }else{
            imgvPot.backgroundColor = UIColorFromRGB(0x5cd6d6);

         }
    }
    
    indexPot++;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(turnPage:) object:sc];
    [self performSelector:@selector(turnPage:) withObject:sc afterDelay:3];
}



- (void)showAdDetail: (UIButton *)sender
{
    int tag = (int)sender.tag;
    NSDictionary *dic = [adArray objectAtIndex:tag];
    NSInteger type = [[dic objectForKey:@"adType"] integerValue];
    switch (type) {
        case 1:
        {
            B_GoodsDetailViewController *vc = [[B_GoodsDetailViewController alloc] init];
            vc.Dict = @{@"code" : [dic [@"productId"] stringValue], @"title" : @""};
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        
        
        }
            break;
        case 2:
        {

            B_GoodUrlViewController *vc = [[B_GoodUrlViewController alloc] init];
            vc.HtmlString = [dic objectForKey:@"content"];
            vc.title = @"图文详情";            vc.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}


- (void)handleLocationManager {
    LocationManager=[[CLLocationManager alloc]init];
    LocationManager.delegate=self;
    [LocationManager startUpdatingLocation];
    
    if ([LocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [LocationManager requestAlwaysAuthorization];
    }
    if ([LocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [LocationManager requestWhenInUseAuthorization];
    }
    
}

- (void)logoMethod: (UIButton*)sender
{
    NSInteger tag = sender.tag;
    switch (tag) {
        case 0:
        {
            B_HomeViewController *vc = [[B_HomeViewController alloc] init];
            vc.cityCode = self.cityCode;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            B_SuperDealViewController*vc = [[B_SuperDealViewController alloc] init];
            vc.ShopId = [[returnInfo ObjectForKey:@"data"] ObjectForKey:@"superValueShopId"];
        
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 2:
        {
            B_FreshfruitViewController *vc = [[B_FreshfruitViewController alloc] init];
            vc.ShopId = [[returnInfo ObjectForKey:@"data"] ObjectForKey:@"fruitShopId"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

    }
}

- (void)adVC
{
    B_AdDetailViewController *vc = [[B_AdDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([LocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [LocationManager requestWhenInUseAuthorization];
                
                }
            break;
            case kCLAuthorizationStatusDenied:
            
            break;
        default:
            break;
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations firstObject];

    Location=loc.coordinate;
    NSLog(@"首页检测的       纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    [self reversedLocation];
    [LocationManager stopUpdatingLocation];
}

- (void)reversedLocation
{
    //根据经纬度解析成位置
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    CLLocation *cl = [[CLLocation alloc]initWithLatitude:Location.latitude longitude:Location.longitude];
    [geocoder reverseGeocodeLocation:cl completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *mark=[placemark objectAtIndex:0];
         NSLog(@"city --    %@", [mark.addressDictionary objectForKey:@"City"]);
         NSLog(@"mark---    %@", mark.addressDictionary);
         NSString *currentCity = [mark.addressDictionary objectForKey:@"City"];
         
//         if (![currentCity isEqualToString:@"杭州市"] && ![currentCity isEqualToString:@"深圳市"] && ![currentCity isEqualToString:@"绍兴市"]) {
//             B_LocationViewController *vc = [[B_LocationViewController alloc] init];
//             vc.hidesBottomBarWhenPushed = YES;
//             vc.Location = Location;
//             [self.navigationController pushViewController:vc animated:YES];
//         }
         
         if ([currentCity isEqualToString:@"杭州市"]) {
             citylabel.text = @"杭州";
             self.cityCode = @"C0007";
             [self initLimitedTimeDeal];
         } else if ([currentCity isEqualToString:@"深圳市"]) {
             citylabel.text = @"深圳";
             self.cityCode = @"C0006";
             [self initLimitedTimeDeal];
         } else if ([currentCity isEqualToString:@"绍兴市"]) {
             citylabel.text = @"绍兴";
             self.cityCode = @"C0035";
             [self initLimitedTimeDeal];
         } else {
             citylabel.text = @"杭州";
             self.cityCode = @"C0007";
             [self initLimitedTimeDeal];
         }
         
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
         [defaults setObject:self.cityCode forKey:@"cityCode"];
         [defaults synchronize];
         

         
     } ];
    
}

#pragma mark 定位
- (void)leftAct
{
    B_LocationViewController *vc = [[B_LocationViewController alloc] init];
    vc.cityName = LocString;
    vc.Location = Location;
    vc.hidesBottomBarWhenPushed = YES;
    

    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通知 Notification
- (void)updateCity: (NSNotification *)noti
{
    NSDictionary *dic = [noti object];
    citylabel.text = [dic objectForKey:@"city"];
    self.cityCode = [dic objectForKey:@"code"];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.cityCode forKey:@"cityCode"];
    [defaults synchronize];
    
    [self initLimitedTimeDeal];
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
