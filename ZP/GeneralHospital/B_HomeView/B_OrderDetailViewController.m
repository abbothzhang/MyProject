//
//  B_OrderDetailViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/2/1.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_OrderDetailViewController.h"
#import "B_CheckstandViewController.h"
#import "B_CheckLogisticsController.h"
#import "B_CommentViewController.h"
@interface B_OrderDetailViewController ()

@end

@implementation B_OrderDetailViewController
@synthesize OrderId;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单详情";
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE)];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.contentSize=CGSizeMake(0, 800);
    [self.view addSubview:scrollView];
    
    UIView *downBack=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHE-50-64, SCREEN_WIDTH, 50)];
    downBack.backgroundColor=UIColorFromRGB(0xf8f8f8);
    [self.view addSubview:downBack];
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/order/detail.jhtml?orderId=%@",OrderId]]];
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
                          ResultDict=[[NSDictionary alloc] initWithDictionary:ReturnDict];
                          NSArray *listArray=[[NSArray alloc] initWithArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"itemList"]];
                          scrollView.contentSize=CGSizeMake(0, 650+[listArray count]*85);
                          
                          UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 124)];
                          topView.backgroundColor=[UIColor whiteColor];
                          [scrollView addSubview:topView];
                          
                          UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
                          lineImage.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [topView addSubview:lineImage];
                          
                          UIImageView *lineImage1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH-20, 1)];
                          lineImage1.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [topView addSubview:lineImage1];
                          
                          UIImageView *lineImage2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 123, SCREEN_WIDTH, 1)];
                          lineImage2.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [topView addSubview:lineImage2];
                          
                        
                          UILabel* orderTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,100, 35)];
                          orderTitle.text=@"订单号：";
                          orderTitle.textColor=UIColorFromRGB(0x666666);
                          orderTitle.backgroundColor=[UIColor clearColor];
                          orderTitle.font=[UIFont systemFontOfSize:14];
                          orderTitle.textAlignment=NSTextAlignmentLeft;
                          [topView addSubview:orderTitle];
                          
                          UILabel* orderNum=[[UILabel alloc] initWithFrame:CGRectMake(80, 0,200, 35)];
                          orderNum.text=[[ReturnDict objectForKey:@"data"] objectForKey:@"orderId"];
                          orderNum.textColor=UIColorFromRGB(0x666666);
                          orderNum.backgroundColor=[UIColor clearColor];
                          orderNum.font=[UIFont systemFontOfSize:14];
                          orderNum.textAlignment=NSTextAlignmentLeft;
                          [topView addSubview:orderNum];
                          
                          UILabel* orderStateTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 35,200, 22)];
                          orderStateTitle.text=@"订单状态：";
                          orderStateTitle.textColor=UIColorFromRGB(0x666666);
                          orderStateTitle.backgroundColor=[UIColor clearColor];
                          orderStateTitle.font=[UIFont systemFontOfSize:14];
                          orderStateTitle.textAlignment=NSTextAlignmentLeft;
                          [topView addSubview:orderStateTitle];
                          
                          //订单状态，1-待付款，2-待发货，3-已发货，4-已完成，5-已取消
                          UILabel* orderState=[[UILabel alloc] initWithFrame:CGRectMake(10, 35,300, 22)];
                          switch ([[[ReturnDict objectForKey:@"data"] objectForKey:@"orderStatus"] intValue]) {
                              case 1:
                              {
                                  orderState.text=@"待付款";
                              }
                                  break;
                              case 2:
                              {
                                  orderState.text=@"待发货";
                              }
                                  break;
                              case 3:
                              {
                                  orderState.text=@"已发货";
                              }
                                  break;
                              case 4:
                              {
                                  orderState.text=@"已完成";
                              }
                                  break;
                              case 5:
                              {
                                  orderState.text=@"已取消";
                              }
                                  break;
                              default:
                                  break;
                          }
                          orderState.textColor=UIColorFromRGB(0xFF9900);
                          orderState.backgroundColor=[UIColor clearColor];
                          orderState.font=[UIFont systemFontOfSize:14];
                          orderState.textAlignment=NSTextAlignmentRight;
                          [topView addSubview:orderState];
                          
                          
                          UILabel* orderFeeTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 57,200, 22)];
                          orderFeeTitle.text=@"订单金额（含运费）：";
                          orderFeeTitle.textColor=UIColorFromRGB(0x666666);
                          orderFeeTitle.backgroundColor=[UIColor clearColor];
                          orderFeeTitle.font=[UIFont systemFontOfSize:14];
                          orderFeeTitle.textAlignment=NSTextAlignmentLeft;
                          [topView addSubview:orderFeeTitle];
                    
                          UILabel* orderFee=[[UILabel alloc] initWithFrame:CGRectMake(10, 57,300, 22)];
                          orderFee.text=[NSString stringWithFormat:@"¥%.2f",[[[ReturnDict objectForKey:@"data"] objectForKey:@"amount"] floatValue]];
                          orderFee.textColor=UIColorFromRGB(0xFF9900);
                          orderFee.backgroundColor=[UIColor clearColor];
                          orderFee.font=[UIFont systemFontOfSize:14];
                          orderFee.textAlignment=NSTextAlignmentRight;
                          [topView addSubview:orderFee];
                          
                          UILabel* orderFreightTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 79,200, 22)];
                          orderFreightTitle.text=@"运费：";
                          orderFreightTitle.textColor=UIColorFromRGB(0x666666);
                          orderFreightTitle.backgroundColor=[UIColor clearColor];
                          orderFreightTitle.font=[UIFont systemFontOfSize:14];
                          orderFreightTitle.textAlignment=NSTextAlignmentLeft;
                          [topView addSubview:orderFreightTitle];
                          
                          UILabel* orderFreight=[[UILabel alloc] initWithFrame:CGRectMake(10, 79,300, 22)];
                          orderFreight.text=[NSString stringWithFormat:@"¥%.2f",[[[ReturnDict objectForKey:@"data"] objectForKey:@"freight"] floatValue]];
                          orderFreight.textColor=UIColorFromRGB(0x000000);
                          orderFreight.backgroundColor=[UIColor clearColor];
                          orderFreight.font=[UIFont systemFontOfSize:14];
                          orderFreight.textAlignment=NSTextAlignmentRight;
                          [topView addSubview:orderFreight];
                          
                          UILabel* orderScoreTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 101,200, 22)];
                          orderScoreTitle.text=@"赠送积分：";
                          orderScoreTitle.textColor=UIColorFromRGB(0x666666);
                          orderScoreTitle.backgroundColor=[UIColor clearColor];
                          orderScoreTitle.font=[UIFont systemFontOfSize:14];
                          orderScoreTitle.textAlignment=NSTextAlignmentLeft;
                          [topView addSubview:orderScoreTitle];
                          
                          UILabel* orderScore=[[UILabel alloc] initWithFrame:CGRectMake(10, 101,300, 22)];
                          orderScore.text=[NSString stringWithFormat:@"%@",[[ReturnDict objectForKey:@"data"] objectForKey:@"point"]];
                          orderScore.textColor=UIColorFromRGB(0x000000);
                          orderScore.backgroundColor=[UIColor clearColor];
                          orderScore.font=[UIFont systemFontOfSize:14];
                          orderScore.textAlignment=NSTextAlignmentRight;
                          [topView addSubview:orderScore];
                          
                          
                          UIView *middleView=[[UIView alloc]initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 105)];
                          middleView.backgroundColor=[UIColor whiteColor];
                          [scrollView addSubview:middleView];
                          
                          UIImageView *lineImage3=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
                          lineImage3.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [middleView addSubview:lineImage3];
                          
                          UIImageView *lineImage4=[[UIImageView alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH-20, 1)];
                          lineImage4.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [middleView addSubview:lineImage4];
                          
                          UIImageView *lineImage5=[[UIImageView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 1)];
                          lineImage5.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [middleView addSubview:lineImage5];
                          
                          UILabel* locLabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 35,45, 70)];
                          locLabel.text=@"\ue60e";
                          [locLabel setFont:[UIFont fontWithName:@"icomoon" size:30]];
                          locLabel.textColor=STYLECLOLR;
                          locLabel.backgroundColor=[UIColor clearColor];
                          locLabel.textAlignment=NSTextAlignmentCenter;
                          [middleView addSubview:locLabel];
                          
                          
                          UILabel* addressTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,100, 35)];
                          addressTitle.text=@"收货地址：";
                          addressTitle.textColor=UIColorFromRGB(0x666666);
                          addressTitle.backgroundColor=[UIColor clearColor];
                          addressTitle.font=[UIFont systemFontOfSize:14];
                          addressTitle.textAlignment=NSTextAlignmentLeft;
                          [middleView addSubview:addressTitle];
                          
                          UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(45, 35,100, 35)];
                          nameLabel.text=[NSString stringWithFormat:@"%@",[[ReturnDict objectForKey:@"data"] objectForKey:@"consignee"]];
                          nameLabel.textColor=UIColorFromRGB(0x666666);
                          nameLabel.backgroundColor=[UIColor clearColor];
                          nameLabel.font=[UIFont systemFontOfSize:14];
                          nameLabel.textAlignment=NSTextAlignmentLeft;
                          [middleView addSubview:nameLabel];
                          
                          UILabel* phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 35,300, 35)];
                          phoneLabel.text=[NSString stringWithFormat:@"%@",[[ReturnDict objectForKey:@"data"] objectForKey:@"phone"]];
                          phoneLabel.textColor=UIColorFromRGB(0x666666);
                          phoneLabel.backgroundColor=[UIColor clearColor];
                          phoneLabel.font=[UIFont systemFontOfSize:14];
                          phoneLabel.textAlignment=NSTextAlignmentRight;
                          [middleView addSubview:phoneLabel];
                          
                          UILabel* addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(45, 70,255, 35)];
                          addressLabel.text=[NSString stringWithFormat:@"%@",[[ReturnDict objectForKey:@"data"] objectForKey:@"address"]];
                          addressLabel.numberOfLines = 2;
                          addressLabel.textColor=UIColorFromRGB(0x666666);
                          addressLabel.backgroundColor=[UIColor clearColor];
                          addressLabel.font=[UIFont systemFontOfSize:14];
                          addressLabel.textAlignment=NSTextAlignmentLeft;
                          [middleView addSubview:addressLabel];
                          
                          
                          UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, 260, SCREEN_WIDTH, 90)];
                          downView.backgroundColor=[UIColor whiteColor];
                          [scrollView addSubview:downView];
                          
                          UIImageView *lineImage6=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
                          lineImage6.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [downView addSubview:lineImage6];
                          
                          UIImageView *lineImage7=[[UIImageView alloc] initWithFrame:CGRectMake(10, 45, SCREEN_WIDTH-20, 1)];
                          lineImage7.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [downView addSubview:lineImage7];
                          
                          UIImageView *lineImage8=[[UIImageView alloc] initWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, 1)];
                          lineImage8.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [downView addSubview:lineImage8];
                          
                          UILabel* distributType=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,255, 45)];
                          distributType.text=@"配送方式：";
                          distributType.numberOfLines = 2;
                          distributType.textColor=UIColorFromRGB(0x666666);
                          distributType.backgroundColor=[UIColor clearColor];
                          distributType.font=[UIFont systemFontOfSize:14];
                          distributType.textAlignment=NSTextAlignmentLeft;
                          [downView addSubview:distributType];
                          
                          UILabel* payType=[[UILabel alloc] initWithFrame:CGRectMake(10, 45,255, 45)];
                          payType.text=@"支付方式：";
                          payType.numberOfLines = 2;
                          payType.textColor=UIColorFromRGB(0x666666);
                          payType.backgroundColor=[UIColor clearColor];
                          payType.font=[UIFont systemFontOfSize:14];
                          payType.textAlignment=NSTextAlignmentLeft;
                          [downView addSubview:payType];
                          
                          UILabel* distributTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 45)];
                          distributTypeLabel.text=@"普通快递";
                          distributTypeLabel.numberOfLines = 2;
                          distributTypeLabel.textColor=UIColorFromRGB(0x666666);
                          distributTypeLabel.backgroundColor=[UIColor clearColor];
                          distributTypeLabel.font=[UIFont systemFontOfSize:14];
                          distributTypeLabel.textAlignment=NSTextAlignmentRight;
                          [downView addSubview:distributTypeLabel];
                          
                          UILabel* payTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 45,300, 45)];
                          payTypeLabel.text=@"在线支付";
                          payTypeLabel.numberOfLines = 2;
                          payTypeLabel.textColor=UIColorFromRGB(0x666666);
                          payTypeLabel.backgroundColor=[UIColor clearColor];
                          payTypeLabel.font=[UIFont systemFontOfSize:14];
                          payTypeLabel.textAlignment=NSTextAlignmentRight;
                          [downView addSubview:payTypeLabel];
                          
                          UIView *belowView=[[UIView alloc]initWithFrame:CGRectMake(0, 370, SCREEN_WIDTH, 160+[listArray count]*85)];
                          belowView.backgroundColor=[UIColor whiteColor];
                          [scrollView addSubview:belowView];
                          
                          UIImageView *lineImage9=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
                          lineImage9.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [belowView addSubview:lineImage9];
                          
                          UIImageView *lineImage10=[[UIImageView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
                          lineImage10.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [belowView addSubview:lineImage10];
                          
                          UIImageView *lineImage11=[[UIImageView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, 1)];
                          lineImage11.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [belowView addSubview:lineImage11];
                          
                          UIImageView *lineImage12=[[UIImageView alloc] initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 1)];
                          lineImage12.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [belowView addSubview:lineImage12];
                          

                          
                          UIImageView *lineImage14=[[UIImageView alloc] initWithFrame:CGRectMake(0, belowView.frame.size.height-1, SCREEN_WIDTH, 1)];
                          lineImage14.backgroundColor=UIColorFromRGB(0xeeeeee);
                          [belowView addSubview:lineImage14];
                          
                          UILabel* listInfo=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,255, 45)];
                          listInfo.text=@"清单信息";
                          listInfo.numberOfLines = 2;
                          listInfo.textColor=UIColorFromRGB(0x666666);
                          listInfo.backgroundColor=[UIColor clearColor];
                          listInfo.font=[UIFont systemFontOfSize:14];
                          listInfo.textAlignment=NSTextAlignmentLeft;
                          [belowView addSubview:listInfo];
                          
                          UILabel* listInfoDetail=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 45)];
                          listInfoDetail.text=[NSString stringWithFormat:@"共%lu项    合计：¥%.02f",(unsigned long)[listArray count],[[[ReturnDict objectForKey:@"data"] objectForKey:@"amount"] floatValue]];
                          listInfoDetail.numberOfLines = 2;
                          listInfoDetail.textColor=UIColorFromRGB(0x666666);
                          listInfoDetail.backgroundColor=[UIColor clearColor];
                          listInfoDetail.font=[UIFont systemFontOfSize:14];
                          listInfoDetail.textAlignment=NSTextAlignmentRight;
                          [belowView addSubview:listInfoDetail];
                          
                          UILabel* shopName=[[UILabel alloc] initWithFrame:CGRectMake(10, 45,300, 40)];
                          shopName.text=[NSString stringWithFormat:@"商铺：%@",[[ReturnDict objectForKey:@"data"] objectForKey:@"shopName"]];
                          shopName.numberOfLines = 2;
                          shopName.textColor=UIColorFromRGB(0x666666);
                          shopName.backgroundColor=[UIColor clearColor];
                          shopName.font=[UIFont systemFontOfSize:14];
                          shopName.textAlignment=NSTextAlignmentLeft;
                          [belowView addSubview:shopName];
                          
                          UILabel* shopPhone=[[UILabel alloc] initWithFrame:CGRectMake(10, 85,300, 40)];
                          shopPhone.text=[NSString stringWithFormat:@"电话：%@",[[ReturnDict objectForKey:@"data"] objectForKey:@"shopPhone"]];
                          shopPhone.textColor=UIColorFromRGB(0x666666);
                          shopPhone.backgroundColor=[UIColor clearColor];
                          shopPhone.font=[UIFont systemFontOfSize:14];
                          shopPhone.textAlignment=NSTextAlignmentLeft;
                          [belowView addSubview:shopPhone];
                          
                          
                          for (int i=0; i<[listArray count]; i++) {
                              UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(12.5, 135+i*85, 60, 60)];
                              [iconImage sd_setImageWithURL:[NSURL URLWithString:[[listArray ObjectAtIndex:i] ObjectForKey:@"image"]]];
                              [belowView addSubview:iconImage];
                              [[iconImage layer] setMasksToBounds:YES];
                              [[iconImage layer] setCornerRadius:2];
                              
                              UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(82.5,   135+i*85,180, 30)];
                              titleLabel.text=[[listArray ObjectAtIndex:i] ObjectForKey:@"name"];
                              titleLabel.textColor=UIColorFromRGB(0x333333);
                              titleLabel.numberOfLines=5;
                              titleLabel.backgroundColor=[UIColor clearColor];
                              titleLabel.font=[UIFont systemFontOfSize:12];
                              titleLabel.textAlignment=NSTextAlignmentLeft;
                              [belowView addSubview:titleLabel];
                              
                              UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(250,  135+i*85,57,20)];
                              priceLabel.text=[NSString stringWithFormat:@"¥%@",[[listArray ObjectAtIndex:i] ObjectForKey:@"price"]];
                              priceLabel.textColor=UIColorFromRGB(0x333333);
                              priceLabel.numberOfLines=5;
                              priceLabel.backgroundColor=[UIColor clearColor];
                              priceLabel.font=[UIFont systemFontOfSize:12];
                              priceLabel.textAlignment=NSTextAlignmentRight;
                              [belowView addSubview:priceLabel];
                              
                              NSMutableString *mString=[[NSMutableString alloc] init];
                              for(NSString *string in [[listArray ObjectAtIndex:i] ObjectForKey:@"specificationList"])
                              {
                                  [mString appendFormat:@"%@\n",string];
                              }
                              UILabel* areaLabel=[[UILabel alloc] initWithFrame:CGRectMake(82.5,  165+i*85,120, 50)];
                              areaLabel.text=mString;
                              areaLabel.numberOfLines=10;
                              areaLabel.textColor=UIColorFromRGB(0xaeaeae);
                              areaLabel.backgroundColor=[UIColor clearColor];
                              areaLabel.font=[UIFont systemFontOfSize:11];
                              areaLabel.textAlignment=NSTextAlignmentLeft;
                              [belowView addSubview:areaLabel];
                              
                              UILabel *CodeLabel=[[UILabel alloc] initWithFrame:CGRectMake(250,  155+i*85, 57, 28)];
                              CodeLabel.text=[NSString stringWithFormat:@"x%@",[[listArray ObjectAtIndex:i] ObjectForKey:@"quantity"]];
                              CodeLabel.textColor=UIColorFromRGB(0x666666);
                              CodeLabel.backgroundColor=[UIColor clearColor];
                              CodeLabel.font=[UIFont systemFontOfSize:12];
                              CodeLabel.textAlignment=NSTextAlignmentRight;
                              [belowView addSubview:CodeLabel];
                              
                              UIImageView *lineImage13=[[UIImageView alloc] initWithFrame:CGRectMake(10,210+85*i, SCREEN_WIDTH-20, 1)];
                              lineImage13.backgroundColor=UIColorFromRGB(0xeeeeee);
                              [belowView addSubview:lineImage13];
                          }

                          
                          switch ([[[ReturnDict objectForKey:@"data"] ObjectForKey:@"orderStatus"] intValue]) {
                              case 1:
                              {
                                  UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                  payBtn.frame = CGRectMake(80, 10, 70, 35);
                                  [payBtn setTitle:@"付款" forState:UIControlStateNormal];
                                  [payBtn setTitle:@"付款" forState:UIControlStateHighlighted];
                                  payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                                  [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                  [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                                  [payBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                                                    forState:UIControlStateNormal];
                                  [payBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                                                    forState:UIControlStateSelected];
                                  [payBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
                                  [downBack addSubview:payBtn];
                                  [[payBtn layer] setMasksToBounds:YES];
                                  [[payBtn layer] setCornerRadius:4];
                                  [[payBtn layer]setBorderWidth:1];
                                  [[payBtn layer]setBorderColor:[STYLECLOLR CGColor]];
                                  
                                  UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                  cancelBtn.frame = CGRectMake(170, 10, 70, 35);
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
                                  [downBack addSubview:cancelBtn];
                                  [[cancelBtn layer] setMasksToBounds:YES];
                                  [[cancelBtn layer] setCornerRadius:4];
                                  [[cancelBtn layer]setBorderWidth:1];
                                  [[cancelBtn layer]setBorderColor:[STYLECLOLR CGColor]];
                              }
                                  break;
                              case 2:
                              {
                                  downBack.hidden=YES;
                              }
                                  break;
                              case 3:
                              {
                                  UIButton *logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                  logisticsBtn.frame = CGRectMake(80, 10,80, 35);
                                  [logisticsBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                                  [logisticsBtn setTitle:@"查看物流" forState:UIControlStateHighlighted];
                                  logisticsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                                  [logisticsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                  [logisticsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                                  [logisticsBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                                                          forState:UIControlStateNormal];
                                  [logisticsBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                                                          forState:UIControlStateSelected];
                                  [logisticsBtn addTarget:self action:@selector(logisticsAct:) forControlEvents:UIControlEventTouchUpInside];
                                  [downBack addSubview:logisticsBtn];
                                  [[logisticsBtn layer] setMasksToBounds:YES];
                                  [[logisticsBtn layer] setCornerRadius:4];
                                  [[logisticsBtn layer]setBorderWidth:1];
                                  [[logisticsBtn layer]setBorderColor:[STYLECLOLR CGColor]];
                                  
                                  UIButton *reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                  reviewBtn.frame = CGRectMake(170, 10, 70, 35);
                                  [reviewBtn setTitle:@"点评" forState:UIControlStateNormal];
                                  [reviewBtn setTitle:@"点评" forState:UIControlStateHighlighted];
                                  reviewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                                  [reviewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                  [reviewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                                  [reviewBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                                                       forState:UIControlStateNormal];
                                  [reviewBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                                                       forState:UIControlStateSelected];
                                  [reviewBtn addTarget:self action:@selector(cancelAct:) forControlEvents:UIControlEventTouchUpInside];
                                  [downBack addSubview:reviewBtn];
                                  [[reviewBtn layer] setMasksToBounds:YES];
                                  [[reviewBtn layer] setCornerRadius:4];
                                  [[reviewBtn layer]setBorderWidth:1];
                                  [[reviewBtn layer]setBorderColor:[STYLECLOLR CGColor]];
                              }
                                  break;
                              case 4:
                              {
//                                  UIButton * afterSalesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                                  afterSalesBtn.frame = CGRectMake(80,10,80, 35);
//                                  [afterSalesBtn setTitle:@"申请售后" forState:UIControlStateNormal];
//                                  [afterSalesBtn setTitle:@"申请售后" forState:UIControlStateHighlighted];
//                                  afterSalesBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//                                  [afterSalesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                                  [afterSalesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//                                  [afterSalesBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
//                                                           forState:UIControlStateNormal];
//                                  [afterSalesBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
//                                                           forState:UIControlStateSelected];
//                                  [afterSalesBtn addTarget:self action:@selector(logisticsAct:) forControlEvents:UIControlEventTouchUpInside];
//                                  [downBack addSubview:afterSalesBtn];
//                                  [[afterSalesBtn layer] setMasksToBounds:YES];
//                                  [[afterSalesBtn layer] setCornerRadius:2];
//                                  [[afterSalesBtn layer]setBorderWidth:1];
//                                  [[afterSalesBtn layer]setBorderColor:[STYLECLOLR CGColor]];
                                  
                                  UIButton *reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                  reviewBtn.frame = CGRectMake((SCREEN_WIDTH-70)/2, 10, 70, 35);
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
                                  [downBack addSubview:reviewBtn];
                                  [[reviewBtn layer] setMasksToBounds:YES];
                                  [[reviewBtn layer] setCornerRadius:4];
                                  [[reviewBtn layer]setBorderWidth:1];
                                  [[reviewBtn layer]setBorderColor:[STYLECLOLR CGColor]];
                              }
                                  break;
                                  
                              default:
                              {
                                  downBack.hidden=YES;
                              }
                                  break;
                          }
                      }
                      NetError:^(int error) {
                      }
     ];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)payAct:(UIButton *)sender
{
    B_CheckstandViewController *B_Checkstand=[[B_CheckstandViewController alloc] init];
    B_Checkstand.SellDict=[ResultDict objectForKey:@"data"];
    B_Checkstand.AllPrice=[NSString stringWithFormat:@"¥%.2f",[[[ResultDict objectForKey:@"data"]objectForKey:@"amount"] floatValue]];
    [self.navigationController pushViewController:B_Checkstand animated:YES];
}

-(void)cancelAct:(UIButton *)sender
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/order/cancel.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:OrderId,@"orderId", nil]
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
                          
                      }
                      NetError:^(int error) {
                      }
     ];
    
}

-(void)logisticsAct:(UIButton *)sender
{
    B_CheckLogisticsController *B_CheckLogistics=[[B_CheckLogisticsController alloc] init];
    B_CheckLogistics.UrlString=[ResultDict objectForKey:@"deliveryURL"];
    [self.navigationController pushViewController:B_CheckLogistics animated:YES];
}

-(void)reviewAct:(UIButton *)sender
{
    B_CommentViewController *B_CommentView=[[B_CommentViewController alloc] init];
    B_CommentView.UseDict=[NSDictionary dictionaryWithObjectsAndKeys:[[ResultDict objectForKey:@"data"] objectForKey:@"id"],@"orderId", nil];
    NSLog(@"ResultDict =%@",[ResultDict objectForKey:@"data"]);
    [self.navigationController pushViewController:B_CommentView animated:YES];
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
