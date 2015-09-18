//
//  B_GoodsDetailViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-15.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "B_GoodsDetailViewController.h"
#import "B_ShopDetailViewController.h"
#import "B_GoodUrlViewController.h"
#import "B_CommentListViewController.h"
#import "GlobalHead.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "AESCrypt.h"
#import "D_LoginViewController.h"
#define COLOR UIColorFromRGB(0xcccccc)
#define TEXTCOLOR UIColorFromRGB(0x666666)


@interface B_GoodsDetailViewController ()

@end

@implementation B_GoodsDetailViewController
@synthesize Dict;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        BtnArray=[[NSMutableArray alloc] init];
        CommentImageArray=[[NSMutableArray alloc] init];
        selectIndex=0;
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
//    NumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[G_ShopCar allKeys] count]];
//    NumLabel.hidden=[[G_ShopCar allKeys] count]==0;
//    ShopListBtn.selected=[G_ShopCar objectForKey:[Dict objectForKey:@"code"]]!=nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=NO;

    NumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[G_ShopCar allKeys] count]];
    NumLabel.hidden=[[G_ShopCar allKeys] count]==0;
 
}

-(void)RightAct
{
    [self.navigationController pushViewController:[NSClassFromString(@"B_ShoppingListViewController") new] animated:YES];
}

-(void)LeftAct
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=[Dict objectForKey:@"title"];

    self.view.backgroundColor=[UIColor whiteColor];
    ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HIGHE+20 - 50)];
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    ScrollView.contentSize=CGSizeMake(0, 900);
    ScrollView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self.view addSubview:ScrollView];
    UIButton *leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(15, 20, 33, 33)];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
//    [leftBtn setTitle:@"\ue626" forState:UIControlStateNormal];
//    [leftBtn setTitle:@"\ue626" forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"商品详情_03.png"] forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    leftBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.55];
    [leftBtn addTarget:self action:@selector(LeftAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    leftBtn.alpha = .5;
    
    [[leftBtn layer] setMasksToBounds:YES];
    [[leftBtn layer] setCornerRadius:16.5];
    [[leftBtn layer]setBorderWidth:1];
    [[leftBtn layer]setBorderColor:[[UIColor clearColor] CGColor]];
    
    RightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [RightBtn setFrame:CGRectMake(SCREEN_WIDTH-48,20, 33, 33)];
//    [RightBtn setTitle:@"\ue60b" forState:UIControlStateNormal];
//    [RightBtn setTitle:@"\ue60b" forState:UIControlStateHighlighted];
    [RightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [RightBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:18]];
    RightBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.55];
    [RightBtn addTarget:self action:@selector(RightAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RightBtn];
    [RightBtn setImage:[UIImage imageNamed:@"商品详情_06.png"] forState:UIControlStateNormal];
    [[RightBtn layer] setMasksToBounds:YES];
    [[RightBtn layer] setCornerRadius:16.5];
    [[RightBtn layer]setBorderWidth:1];
    RightBtn.alpha = .5f;
    [[RightBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
 

    NumLabel=[[UILabel alloc] initWithFrame:CGRectMake(18, -5,10, 10)];
    NumLabel.textColor=UIColorFromRGB(0xffffff);
    NumLabel.backgroundColor=[UIColor redColor];
    NumLabel.font=[UIFont systemFontOfSize:8];
    NumLabel.textAlignment=NSTextAlignmentCenter;
    [RightBtn addSubview:NumLabel];
    [[NumLabel layer] setMasksToBounds:YES];
    [[NumLabel layer] setCornerRadius:5];

    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/product/index.jhtml?id=%@",[Dict objectForKey:@"code"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
                          GoodDict =[[NSDictionary alloc] initWithDictionary:[ReturnDict objectForKey:@"data"]];
                          NSLog(@"GOODDICT      %@",GoodDict);
                          imageList=[[GoodDict objectForKey:@"imageList"] copy];
                          UIScrollView *sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 296)];
                          sc.showsHorizontalScrollIndicator=NO;
                          sc.showsVerticalScrollIndicator=NO;
                          sc.pagingEnabled=YES;
                          sc.contentSize=CGSizeMake(SCREEN_WIDTH*[imageList count], 0);
                          [ScrollView addSubview:sc];
                          for (int i=0; i<[imageList count]; i++) {
                              UIImageView *storeImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 296)];
                              storeImage.contentMode = UIViewContentModeScaleAspectFit;
                              [storeImage sd_setImageWithURL:[NSURL URLWithString:[imageList objectAtIndex:i]]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              storeImage.frame=CGRectMake(SCREEN_WIDTH*i, (296-SCREEN_WIDTH/image.size.width *image.size.height)/2, SCREEN_WIDTH, SCREEN_WIDTH/image.size.width*image.size.height);
                            
                          }];
                              [sc addSubview:storeImage];
                          }
                          
                          if (imageList.count > 1) {
                              aryPots = [NSMutableArray array];
                              float wpot = 10;
                              float space = 5;
                              float sumPosts = (wpot+space)*[imageList count];
                              
                              float xFrom = (SCREEN_WIDTH-sumPosts)/2;
                              for (int i=0; i<[imageList count]; i++) {
                                  UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(xFrom+i*(wpot+space), sc.frame.size.height - 15, 8, 8)];
                                  imgv.layer.cornerRadius = 4;
                                  imgv.layer.borderWidth = .5f;
                                  imgv.layer.borderColor = [UIColor colorWithWhite:.88f alpha:1].CGColor;
                                  imgv.tag = i;
                                  if (i==0) {
                                      imgv.backgroundColor = [UIColor whiteColor];
                                      
                                  }else{
                                      imgv.backgroundColor = UIColorFromRGB(0x5cd6d6);
                                  }
                                  imgv.userInteractionEnabled = NO;
                                  [ScrollView addSubview:imgv];
                                  [aryPots addObject:imgv];
                              }
                              
                              indexPot = 0;
                              [self performSelector:@selector(turnPage:) withObject:sc afterDelay:3];
                              
                              
                          }

                          
                          UIView *titileView=[[UIView alloc] initWithFrame:CGRectMake(0, 296,SCREEN_WIDTH, 45)];
                          titileView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:titileView];
 
                          [[titileView layer]setBorderWidth:0.5];
                          [[titileView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
                          UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,150, 41)];
                          nameLabel.text=[GoodDict objectForKey:@"title"];
                          nameLabel.textColor=UIColorFromRGB(0x000000);
                          nameLabel.numberOfLines=5;
                          nameLabel.textColor=UIColorFromRGB(0x333333);
                          nameLabel.backgroundColor=[UIColor clearColor];
                          nameLabel.font=[UIFont systemFontOfSize:14];
                          nameLabel.textAlignment=NSTextAlignmentLeft;
                          [titileView addSubview:nameLabel];
                          
                          UILabel * gapLabel = [[UILabel alloc] initWithFrame:CGRectMake(239.5, 7.5, .5, 30)];
                          gapLabel.backgroundColor = UIColorFromRGB(0x999999);
                          [titileView addSubview:gapLabel];
                          
                          
                          
                          int tag=[[GoodDict ObjectForKey:@"collectFlag"] intValue];
                          NSString *string=[NSString stringWithFormat:tag==1?@" \ue61d\n已收藏":@" \ue61d\n收藏"];
                          
                          UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          collectBtn.frame = CGRectMake(240, 0, 90, 41);
                          collectBtn.tag=tag;
                          collectBtn.titleLabel.numberOfLines = 4;
                          [collectBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
                          [collectBtn setTitle:string forState:UIControlStateNormal];
                          [collectBtn setTitle:string forState:UIControlStateHighlighted];
                          [collectBtn setTitleColor:tag==1 ? UIColorFromRGB(0xfed230) : UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                          [collectBtn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
                          [collectBtn.titleLabel setFont:[UIFont fontWithName:@"zipn" size:10]];
                          [collectBtn addTarget:self
                                         action:@selector(collectAct:)
                               forControlEvents:UIControlEventTouchUpInside];
                          [titileView addSubview:collectBtn];
                          
                          UIView *priceView=[[UIView alloc] initWithFrame:CGRectMake(0, 296 + 45, SCREEN_WIDTH, 58)];
                          priceView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:priceView];
                          [[titileView layer]setBorderWidth:0.5];
                          [[titileView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
 
                          UILabel *rtLabel=[[UILabel alloc] initWithFrame:CGRectMake(90 + 10, 20, 100, 20)];
                          rtLabel.text=[NSString stringWithFormat:@"¥%@",[GoodDict objectForKey:@"originalPrice"]];
                          rtLabel.textColor=UIColorFromRGB(0x666666);
                          rtLabel.backgroundColor=[UIColor clearColor];
                          rtLabel.font=[UIFont systemFontOfSize:11];
                          [priceView addSubview:rtLabel];
                          
                          UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(90 + 10, 29.5, 30, 1)];
                          lineImage.backgroundColor=UIColorFromRGB(0x666666);
                          [priceView addSubview:lineImage];
                          
                          UILabel *pLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 18, 100, 20)];
                          pLabel.text=[NSString stringWithFormat:@"¥%@",[GoodDict objectForKey:@"price"]];
                          pLabel.textColor=UIColorFromRGB(0xFE5000);
                          pLabel.backgroundColor=[UIColor clearColor];
                          pLabel.font=[UIFont systemFontOfSize:23];
                          [priceView addSubview:pLabel];
                          

                          CGRect sDesc = CGRectZero;
                          NSLog(@"详情    %@", [GoodDict objectForKey: @"desc"]);
                          CGSize actualsize;
                          
                          if ([GoodDict objectForKey:@"desc"]) {
                              NSString *string = [GoodDict objectForKey:@"desc"];
//                              sDesc = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize: 12]} context:nil];
//                                CGSize sizeToFit = [string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
                              
                              CGSize size =CGSizeMake(SCREEN_WIDTH - 100,MAXFLOAT);
                              NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
                              actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
                              
                              NSLog(@"height    %.1f", sDesc.size.height);
                          }
                          
                          UILabel* comLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 48,300, actualsize.height)];
                          comLabel.text=[GoodDict objectForKey:@"desc"]==nil?@"暂无信息":[GoodDict objectForKey:@"desc"];
//                          comLabel.numberOfLines=5;
                          comLabel.numberOfLines = 0;
                          comLabel.textColor=UIColorFromRGB(0x333333);
                          comLabel.backgroundColor=[UIColor clearColor];
                          comLabel.font=[UIFont systemFontOfSize:12];
                          comLabel.textAlignment=NSTextAlignmentLeft;
                          [priceView addSubview:comLabel];
                          priceView.frame = CGRectMake(0, 296 + 45 + 20, SCREEN_WIDTH, 38 + actualsize.height + 10 + 20);
//                          UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                          downBtn.frame = CGRectMake(270, 30, 40, 30);
//                          [downBtn setTitle:@"\ue627" forState:UIControlStateNormal];
//                          [downBtn setTitle:@"\ue627" forState:UIControlStateHighlighted];
//                          [downBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
//                          downBtn.titleLabel.font = [UIFont fontWithName:@"icomoon" size:15];
//                          [downBtn addTarget:self action:@selector(downAct) forControlEvents:UIControlEventTouchUpInside];
//                          [comView addSubview:downBtn];
                          
//                          
//                          UIView *comView=[[UIView alloc] initWithFrame:CGRectMake(0, 296 + 45 + 58 + 10,SCREEN_WIDTH, 56)];
//                          comView.backgroundColor=[UIColor whiteColor];
//                          [ScrollView addSubview:comView];
//                          [[comView layer]setBorderWidth:0.5];
//                          [[comView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
//                          
//                          
                          
                          
                          //点评
                          UIView *starView=[[UIView alloc] initWithFrame:CGRectMake(0, priceView.frame.origin.y + 10 + 38 + actualsize.height + 10 + 20, SCREEN_WIDTH, 61)];
                          starView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:starView];
                          [[starView layer]setBorderWidth:0.5];
                          [[starView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
                          UILabel* commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10,40, 40)];
                          commentLabel.text=@"\ue609";
                          commentLabel.textColor=STYLECLOLR;
                          commentLabel.backgroundColor=[UIColor clearColor];
                          commentLabel.font=[UIFont fontWithName:@"zipn" size:24];
                          commentLabel.textAlignment=NSTextAlignmentCenter;
                          [starView addSubview:commentLabel];
                          
                          UILabel* comTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 10,100, 40)];
                          comTextLabel.text=[NSString stringWithFormat:@"点评（%@）",[GoodDict objectForKey:@"evaluateNumber"]];
                          comTextLabel.textColor=[UIColor blackColor];
                          comTextLabel.backgroundColor=[UIColor clearColor];
                          comTextLabel.font=[UIFont boldSystemFontOfSize:14];
                          comTextLabel.textAlignment=NSTextAlignmentLeft;
                          [starView addSubview:comTextLabel];
                          NSMutableString *starString=[NSMutableString new];
                          for (int i=0; i<[[GoodDict objectForKey:@"score"] intValue]; i++){
                              [starString appendString:@"\ue61f"];
                          }
                          [starString appendFormat:@" %.1f",[[GoodDict objectForKey:@"score"] floatValue]];
                          UILabel* starLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 10,150, 40)];
                          starLabel.text=starString;
                          starLabel.textColor=UIColorFromRGB(0xfed230);
                          starLabel.backgroundColor=[UIColor clearColor];
                          starLabel.font=[UIFont fontWithName:@"zipn" size:18];
                          starLabel.textAlignment=NSTextAlignmentLeft;
                          [starView addSubview:starLabel];
                          
                          NSArray *evaluateArray;
                          if([GoodDict objectForKey:@"evaluate"]==nil||[[GoodDict objectForKey:@"evaluate"] count]==0)
                          {
                              evaluateArray=[[NSArray alloc] init];
                          }else
                          {
                              evaluateArray=[[NSArray alloc] initWithArray:[GoodDict objectForKey:@"evaluate"]];
                          }
                          
                          
                          UIView *commentView=[[UIView alloc] initWithFrame:CGRectMake(0,  starView.frame.size.height + starView.frame.origin.y, SCREEN_WIDTH, 130*[evaluateArray count])];
                          commentView.backgroundColor=UIColorFromRGB(0xf5f5f2);
                          [ScrollView addSubview:commentView];
                          [[commentView layer]setBorderWidth:0.5];
                          [[commentView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
                          int myCount = [evaluateArray count];
                          
                          for (int j=0; j<[evaluateArray count]; j++) {
                              UIImageView *headImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10+j*130, 30, 30)];
                              [headImage sd_setImageWithURL:[NSURL URLWithString:[[evaluateArray objectAtIndex:j] objectForKey:@"headImage"]]];
                              [commentView addSubview:headImage];
                              [[headImage layer] setMasksToBounds:YES];
                              [[headImage layer] setCornerRadius:15];
                              
                              UILabel* nLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 10+j*130,300, 20)];
                              nLabel.text=[[evaluateArray objectAtIndex:j] objectForKey:@"name"];
                              nLabel.textColor=UIColorFromRGB(0x000000);
                              nLabel.backgroundColor=[UIColor clearColor];
                              nLabel.font=[UIFont systemFontOfSize:13];
                              nLabel.textAlignment=NSTextAlignmentLeft;
                              [commentView addSubview:nLabel];
                              
                              UILabel* timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 28+j*130,300, 20)];
                              timeLabel.text=[[evaluateArray objectAtIndex:j] objectForKey:@"time"];
                              timeLabel.textColor=UIColorFromRGB(0x999999);
                              timeLabel.backgroundColor=[UIColor clearColor];
                              timeLabel.font=[UIFont systemFontOfSize:11];
                              timeLabel.textAlignment=NSTextAlignmentLeft;
                              [commentView addSubview:timeLabel];
                              
                              NSMutableString *starString=[NSMutableString new];
                              for (int i=0; i<[[[evaluateArray objectAtIndex:j] objectForKey:@"score"] intValue]; i++){
                                  [starString appendString:@"\ue61f"];
                              }
                              
                              UILabel* sLabel=[[UILabel alloc] initWithFrame:CGRectMake(200, j*130,150, 40)];
                              sLabel.text=starString;
                              sLabel.textColor=UIColorFromRGB(0xfed230);
                              sLabel.backgroundColor=[UIColor clearColor];
                              sLabel.font=[UIFont fontWithName:@"zipn" size:18];
                              sLabel.textAlignment=NSTextAlignmentLeft;
                              [commentView addSubview:sLabel];
                              
                              UILabel* contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 45+j*130,300, 20)];
                              contentLabel.text=[[evaluateArray objectAtIndex:j] objectForKey:@"desc"];
                              contentLabel.textColor=UIColorFromRGB(0x000000);
                              contentLabel.backgroundColor=[UIColor clearColor];
                              contentLabel.font=[UIFont systemFontOfSize:12.5];
                              contentLabel.textAlignment=NSTextAlignmentLeft;
                              [commentView addSubview:contentLabel];
  
                              
                              //图片
                              if ([evaluateArray count]!=0) {
                                  for (int i=0; i<5; i++) {
                                      if ([[evaluateArray objectAtIndex:j] objectForKey:[NSString stringWithFormat:@"image%d",i+1]]==nil||[[[evaluateArray objectAtIndex:j] objectForKey:[NSString stringWithFormat:@"image%d",i+1]] length]==0) {
                                          continue;
                                      }
                                      UIButton *conmmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                      conmmentBtn.tag=i;
                                      //conmmentBtn.frame = CGRectMake(10+65*i, 440+65+j*130, 60, 60);
                                      conmmentBtn.frame = CGRectMake(10+65*i, CGRectGetMaxY(contentLabel.frame), 60, 60);
                                      [conmmentBtn sd_setImageWithURL:[NSURL URLWithString:[[evaluateArray objectAtIndex:j] objectForKey:[NSString stringWithFormat:@"image%d",i+1]]] forState:UIControlStateNormal];
                                      [conmmentBtn addTarget:self action:@selector(tapImage:) forControlEvents:UIControlEventTouchUpInside];
                                      [commentView addSubview:conmmentBtn];
                                      [CommentImageArray addObject:conmmentBtn];
                                  }
                                  
                              }
                              
                          }
                          

                          

                          UIView *seeAllView=[[UIView alloc] initWithFrame:CGRectMake(0, commentView.frame.size.height + commentView.frame.origin.y,SCREEN_WIDTH, 61)];
                          seeAllView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:seeAllView];
                          [[seeAllView layer]setBorderWidth:0.5];
                          [[seeAllView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
                          UIButton *seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          seeBtn.frame =CGRectMake(0, 0,SCREEN_WIDTH, 60);
                          [seeBtn addTarget:self action:@selector(seeAct) forControlEvents:UIControlEventTouchUpInside];
                          [seeAllView addSubview:seeBtn];
                          
                          UILabel* ttLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 60)];
                          ttLabel.text=@"查看全部评论";
                          ttLabel.textColor=UIColorFromRGB(0x6ad4d3);
                          ttLabel.backgroundColor=[UIColor clearColor];
                          ttLabel.font=[UIFont boldSystemFontOfSize:14];
                          ttLabel.textAlignment=NSTextAlignmentLeft;
                          [seeBtn addSubview:ttLabel];
                          
                          UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 60)];
                          arrowLabel.text=@"\ue629";
                          arrowLabel.textColor=UIColorFromRGB(0x888888);
                          arrowLabel.backgroundColor=[UIColor clearColor];
                          arrowLabel.font=[UIFont fontWithName:@"icomoon" size:18];
                          arrowLabel.textAlignment=NSTextAlignmentRight;
                          [seeBtn addSubview:arrowLabel];
                          
                          UIView *seePicView=[[UIView alloc] initWithFrame:CGRectMake(0,  commentView.frame.size.height + commentView.frame.origin.y + 71,SCREEN_WIDTH, 51)];
                          seePicView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:seePicView];
                          [[seePicView layer]setBorderWidth:0.5];
                          [[seePicView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
                          UIButton *tttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          tttBtn.frame =CGRectMake(0, 0,SCREEN_WIDTH, 50);
                          [tttBtn addTarget:self action:@selector(tttAct) forControlEvents:UIControlEventTouchUpInside];
                          [seePicView addSubview:tttBtn];
                          
                          UILabel* tttLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 50)];
                          tttLabel.text=@"图文详情";
                          tttLabel.textColor=UIColorFromRGB(0x333333);
                          tttLabel.backgroundColor=[UIColor clearColor];
                          tttLabel.font=[UIFont boldSystemFontOfSize:14];
                          tttLabel.textAlignment=NSTextAlignmentLeft;
                          [tttBtn addSubview:tttLabel];
                          
                          UILabel* arrow1Label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 50)];
                          arrow1Label.text=@"\ue629";
                          arrow1Label.textColor=UIColorFromRGB(0x888888);
                          arrow1Label.backgroundColor=[UIColor clearColor];
                          arrow1Label.font=[UIFont fontWithName:@"icomoon" size:18];
                          arrow1Label.textAlignment=NSTextAlignmentRight;
                          [tttBtn addSubview:arrow1Label];
                          
                          UIView *shopListView=[[UIView alloc] initWithFrame:CGRectMake(0,  commentView.frame.size.height + commentView.frame.origin.y + 41 + 41 + 50, SCREEN_WIDTH, 70)];
                          shopListView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:shopListView];
                          [[shopListView layer]setBorderWidth:0.5];
                          [[shopListView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
                          UIImageView *shopHeadImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
                          [shopHeadImage sd_setImageWithURL:[NSURL URLWithString:[GoodDict objectForKey:@"storeImageUrl"]]];
                          [shopListView addSubview:shopHeadImage];
                          [[shopHeadImage layer] setMasksToBounds:YES];
                          [[shopHeadImage layer] setCornerRadius:25];
                          
                          UILabel* shopArrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 70)];
                          shopArrowLabel.text=@"\ue629";
                          shopArrowLabel.textColor=UIColorFromRGB(0x888888);
                          shopArrowLabel.backgroundColor=[UIColor clearColor];
                          shopArrowLabel.font=[UIFont fontWithName:@"icomoon" size:18];
                          shopArrowLabel.textAlignment=NSTextAlignmentRight;
                          [shopListView addSubview:shopArrowLabel];
                          
//                          [shopListView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)]];
                          

                          ScrollView.contentSize = CGSizeMake(0, 900+myCount*130);
                      }
                      NetError:^(int error) {
                      }
     ];
    
    UIView *seeShopView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHE-50,SCREEN_WIDTH, 50)];
    seeShopView.backgroundColor=UIColorFromRGBA(0xf5f5f5,0.9);
    [self.view addSubview:seeShopView];
    

    
    
    ShopListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ShopListBtn.frame = CGRectMake(190,  SCREEN_HIGHE-45, 123, 33);
    ShopListBtn.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HIGHE - 25);
    [ShopListBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [ShopListBtn setTitle:@"继续添加" forState:UIControlStateSelected];
    ShopListBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [ShopListBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0x5cd7d7)] forState:UIControlStateNormal];
    [ShopListBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0x5cd7d7)] forState:UIControlStateSelected];
    [ShopListBtn addTarget:self action:@selector(addListAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ShopListBtn];
    [[ShopListBtn layer] setMasksToBounds:YES];
    [[ShopListBtn layer] setCornerRadius:6];

    // Do any additional setup after loading the view.
}

- (void)turnPage:(UIScrollView *)sc{
    
    if (indexPot<[imageList count]) {
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
            imgvPot.backgroundColor = UIColorFromRGB(0x5cd6d6);
        }else{
            imgvPot.backgroundColor = [UIColor whiteColor];
        }
    }
    
    indexPot++;
    [self performSelector:@selector(turnPage:) withObject:sc afterDelay:3];
}


-(void)addListAct
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
        [self intoShopCart];
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


- (void)intoShopCart
{
    if ([[GoodDict objectForKey:@"specifications"] count]==0) {
        [self sureAct:nil];
        return;
    }
    if (BackView==nil) {
        BackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE)];
        BackView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        BackView.alpha=0;
        UIView *upView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-322)];
        upView.backgroundColor=[UIColor clearColor];
        [BackView addSubview:upView];
        UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [upView addGestureRecognizer:TapGesture];
        
        
        BelowView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHE, SCREEN_WIDTH, 322)];
        BelowView.backgroundColor=[UIColor whiteColor];
        [BackView addSubview:BelowView];
        
        UIImageView *headImage=[[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 60, 60)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[GoodDict objectForKey:@"storeImageUrl"]]];
        [BelowView addSubview:headImage];
        
        
        UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 82, SCREEN_WIDTH, 0.5)];
        lineImage.backgroundColor=UIColorFromRGB(0x888888);
        [BelowView addSubview:lineImage];
        
        UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 11,150, 20)];
        nameLabel.text=[GoodDict objectForKey:@"title"];
        nameLabel.textColor=UIColorFromRGB(0x000000);
        nameLabel.numberOfLines=5;
        nameLabel.textColor=UIColorFromRGB(0x333333);
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:14];
        nameLabel.textAlignment=NSTextAlignmentLeft;
        [BelowView addSubview:nameLabel];
        
        PriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 35, 100, 20)];
        PriceLabel.text=[NSString stringWithFormat:@"¥%@",[GoodDict objectForKey:@"price"]];
        PriceLabel.textColor=UIColorFromRGB(0xFE5000);
        PriceLabel.backgroundColor=[UIColor clearColor];
        PriceLabel.font=[UIFont systemFontOfSize:18];
        [BelowView addSubview:PriceLabel];
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 45,100, 20)];
        titleLabel.text=@"数量";
        titleLabel.textColor=UIColorFromRGB(0x000000);
        titleLabel.numberOfLines=5;
        titleLabel.textColor=UIColorFromRGB(0x333333);
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [BelowView addSubview:titleLabel];
        
        UIView *addBtn=[[UIView alloc]initWithFrame:CGRectMake(220, 40, 85, 28)];
        [BelowView addSubview:addBtn];
        [[addBtn layer]setBorderWidth:1];
        [[addBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
        
        UIButton *minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        minBtn.frame = CGRectMake(0, 0, 28, 28);
        [minBtn setTitle:@"—" forState:UIControlStateNormal];
        [minBtn setTitle:@"—" forState:UIControlStateHighlighted];
        [minBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [minBtn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
        [minBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [minBtn addTarget:self action:@selector(minAct:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addSubview:minBtn];
        
        CodeLabel=[[UILabel alloc] initWithFrame:CGRectMake(28, 0, 29, 28)];
        CodeLabel.text=@"1";
        CodeLabel.textColor=UIColorFromRGB(0x666666);
        CodeLabel.backgroundColor=[UIColor clearColor];
        CodeLabel.font=[UIFont systemFontOfSize:12];
        CodeLabel.textAlignment=NSTextAlignmentCenter;
        [addBtn addSubview:CodeLabel];
        [[CodeLabel layer]setBorderWidth:1];
        [[CodeLabel layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
        
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusBtn.frame = CGRectMake(57, 0, 28, 28);
        [plusBtn setTitle:@"＋" forState:UIControlStateNormal];
        [plusBtn setTitle:@"＋" forState:UIControlStateHighlighted];
        [plusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [plusBtn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
        [plusBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [plusBtn addTarget:self action:@selector(addAct:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addSubview:plusBtn];
        
        
        UIImageView *lineImage1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 280, SCREEN_WIDTH, 0.5)];
        lineImage1.backgroundColor=UIColorFromRGB(0x888888);
        [BelowView addSubview:lineImage1];
        
        [BtnArray removeAllObjects];
        
        UILabel* standardLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 95,100, 20)];
        standardLabel.text=@"规格";
        standardLabel.textColor=UIColorFromRGB(0x000000);
        standardLabel.numberOfLines=5;
        standardLabel.textColor=UIColorFromRGB(0x333333);
        standardLabel.backgroundColor=[UIColor clearColor];
        standardLabel.font=[UIFont systemFontOfSize:20];
        standardLabel.textAlignment=NSTextAlignmentLeft;
        [BelowView addSubview:standardLabel];
        
        UIScrollView *typeScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(10, 130, 300, 140)];
        typeScroll.pagingEnabled=NO;
        typeScroll.showsHorizontalScrollIndicator=NO;
        typeScroll.showsVerticalScrollIndicator=NO;
        [BelowView addSubview:typeScroll];
        
        
        NSArray *array=[[GoodDict objectForKey:@"specifications"] copy];
        int x=0;
        int y=0;
        int w=0;
        for(int k=0;k<[array count];k++)
        {
            
            NSString *title=[[array objectAtIndex:k] ObjectForKey:@"specification"];
            w = [title sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(300, 30) lineBreakMode:NSLineBreakByWordWrapping].width+10;
            if (w>=300) {
                w=300;
            }else if(w<=30){
                w=30;
            }
            if (x>=300) {
                x=x-300+w;
                y=y+40;
            }else if(x==0)
            {
                x=w;
            }else if (x+w+10>300) {
                x=w;
                y=y+40;
            }else{
                x=x+10+w;
            }
            
            UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame = CGRectMake(x-w, y,w, 30);
            selectBtn.tag=k;
            selectBtn.highlighted=k==0;
            [selectBtn setTitle:title forState:UIControlStateNormal];
            [selectBtn setTitle:title forState:UIControlStateHighlighted];
            [selectBtn setTitleColor:k==0?STYLECLOLR:TEXTCOLOR forState:UIControlStateNormal];
            [selectBtn setTitleColor:k==0?STYLECLOLR:TEXTCOLOR forState:UIControlStateHighlighted];
            selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [selectBtn addTarget:self action:@selector(selectAct:) forControlEvents:UIControlEventTouchUpInside];
            [typeScroll addSubview:selectBtn];
            [[selectBtn layer] setMasksToBounds:YES];
            [[selectBtn layer] setCornerRadius:2];
            [[selectBtn layer] setBorderWidth:1];
            [[selectBtn layer] setBorderColor:[k==0?STYLECLOLR:COLOR CGColor]];
            
            [BtnArray addObject:selectBtn];
        }
        
        typeScroll.contentSize=CGSizeMake(0, y+40);
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake((SCREEN_WIDTH-90)/2,  285, 90, 33);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateSelected];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0x5cd7d7)] forState:UIControlStateNormal];
        [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0x565656)] forState:UIControlStateSelected];
        [sureBtn addTarget:self action:@selector(sureAct:) forControlEvents:UIControlEventTouchUpInside];
        [BelowView addSubview:sureBtn];
        [[sureBtn layer] setMasksToBounds:YES];
        [[sureBtn layer] setCornerRadius:3];
        
        
    }
    [self.view addSubview:BackView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        BackView.alpha=1;
        BelowView.frame=CGRectMake(0, SCREEN_HIGHE-322, SCREEN_WIDTH, 322);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapImage:(UIButton *)tap
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[CommentImageArray count]];
    for (int i = 0; i<[CommentImageArray count]; i++) {
        // 替换为中等尺寸图片
      
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url=((UIButton *)[CommentImageArray objectAtIndex:i]).sd_currentImageURL;
        photo.srcImageView = [CommentImageArray objectAtIndex:i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}

-(void)sureAct:(UIButton *)sender
{
    [self singleTap:nil];
    NSDictionary *dict;
    if (sender==nil) {
        
        dict=[NSDictionary dictionaryWithObjectsAndKeys:[GoodDict objectForKey:@"code"],@"id",@"1",@"quantity", nil];
    }else{
        dict=[NSDictionary dictionaryWithObjectsAndKeys:[[[GoodDict objectForKey:@"specifications"] objectAtIndex:selectIndex]ObjectForKey:@"code"],@"id",CodeLabel.text,@"quantity", nil];
    }
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/cart/add.jhtml"]];
    [NetRequest setASIPostDict:dict
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
                          

                              [G_ShopCar setObject:Dict forKey:[Dict objectForKey:@"code"]];
                              [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                  ShopListBtn.frame=CGRectMake(RightBtn.frame.origin.x+18, RightBtn.frame.origin.y-5, 0, 0);
                                  ShopListBtn.selected=YES;
                              } completion:^(BOOL finished) {
                                  ShopListBtn.frame=CGRectMake(190,SCREEN_HIGHE-45, 120, 40);
                                  NumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[G_ShopCar allKeys] count]];
                                  NumLabel.hidden=[[G_ShopCar allKeys] count]==0;
                              }];
                          
                          
                      }
                      NetError:^(int error) {
                      }
     ];

    
}

-(void)singleTap:(UITapGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        BackView.alpha=0;
        BelowView.frame=CGRectMake(0, SCREEN_HIGHE, SCREEN_WIDTH, SCREEN_HIGHE-246);
    } completion:^(BOOL finished) {
        [BackView removeFromSuperview];
    }];
}

- (void)tapMethod
{
    B_ShopDetailViewController *B_ShopDetailView=[[B_ShopDetailViewController alloc] init];
    B_ShopDetailView.Dict= @{@"code" : Dict [@"code"], @"title" : Dict[@"title"]};
    B_ShopDetailView.shopID = self.shopID;
    B_ShopDetailView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:B_ShopDetailView animated:YES];
}

-(void)selectAct:(UIButton *)sender
{

    selectIndex=sender.tag;
    for (int i=0; i<[BtnArray count]; i++) {
        UIButton *btn=[BtnArray objectAtIndex:i];
        if(sender.tag==i)
        {
            [btn setTitleColor:STYLECLOLR forState:UIControlStateNormal];
            [btn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
            [[btn layer] setBorderColor:[STYLECLOLR CGColor]];
        }else
        {
            [btn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
            [btn setTitleColor:TEXTCOLOR forState:UIControlStateHighlighted];
            [[btn layer] setBorderColor:[COLOR CGColor]];
        }
    }
}

-(void)minAct:(UIButton *)sender
{
    int num=[CodeLabel.text integerValue];
    
    float price = [[[[GoodDict objectForKey:@"specifications"] objectAtIndex:selectIndex]ObjectForKey:@"price"] floatValue];
    if (num>1) {
        CodeLabel.text=[NSString stringWithFormat:@"%d",--num];
    }else
    {
        
    }
    PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",num*price];
}

-(void)addAct:(UIButton *)sender
{
    int num=[CodeLabel.text integerValue];
    float price = [[[[GoodDict objectForKey:@"specifications"] objectAtIndex:selectIndex]ObjectForKey:@"price"] floatValue];
    if (num>=1) {
        CodeLabel.text=[NSString stringWithFormat:@"%d",++num];
    }else
    {
        
    }
    PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",num*price];
}

-(void)downAct
{
    
}

-(void)collectAct:(UIButton *)sender
{
    if (sender.tag==1) {
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/product/cancal_collect.jhtml?pid=%@",[Dict objectForKey:@"code"]]]];
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
                              sender.tag=0;
                              NSString *string=[NSString stringWithFormat:sender.tag==1?@" \ue61d\n已收藏":@" \ue61d\n收藏"];
                              [sender setTitle:string forState:UIControlStateNormal];
                              [sender setTitle:string forState:UIControlStateHighlighted];
                              [sender setTitleColor:sender.tag==1?UIColorFromRGB(0xfed230):UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                              [sender setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
                              
                          }
                          NetError:^(int error) {
                          }
         ];
    }else{
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/product/collect.jhtml?pid=%@",[Dict objectForKey:@"code"]]]];
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
                              sender.tag=1;
                               NSString *string=[NSString stringWithFormat:sender.tag==1?@" \ue61d\n已收藏":@" \ue61d\n收藏"];
                              [sender setTitle:string forState:UIControlStateNormal];
                              [sender setTitle:string forState:UIControlStateHighlighted];
                              [sender setTitleColor:sender.tag==1?UIColorFromRGB(0xfed230):UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                              [sender setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
                              
                          }
                          NetError:^(int error) {
                          }
         ];
        
    }
    

}

-(void)tttAct
{
    B_GoodUrlViewController *B_GoodUrl=[[B_GoodUrlViewController alloc] init];
    B_GoodUrl.HtmlString=[GoodDict objectForKey:@"introduction"];
    B_GoodUrl.title=@"图文详情";
    [self.navigationController pushViewController:B_GoodUrl animated:YES];
}

-(void)seeAct
{
    B_CommentListViewController *B_CommentList=[[B_CommentListViewController alloc] init];
    B_CommentList.ItemId=[GoodDict objectForKey:@"code"];
    [self.navigationController pushViewController:B_CommentList animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        //self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
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
