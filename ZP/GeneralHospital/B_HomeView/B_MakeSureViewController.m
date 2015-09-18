//
//  B_MakeSureViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/4.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_MakeSureViewController.h"
#import "D_AddAddressViewController.h"
#import "D_AddressListViewController.h"
#import "B_DeliveryListViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "B_CheckstandViewController.h"
@interface B_MakeSureViewController ()

@end

@implementation B_MakeSureViewController

-(void)changeAddressAct
{
    D_AddressListViewController *D_AddressList=[[D_AddressListViewController alloc] init];
    [self.navigationController pushViewController:D_AddressList animated:YES];
    [D_AddressList setAddressDict:^(NSDictionary *dict) {
        [DetailDict setObject:[dict objectForKey:@"id"] forKey:@"receiverId"];
        [DetailDict setObject:[dict objectForKey:@"consignee"] forKey:@"receiverUserName"];
        [DetailDict setObject:[dict objectForKey:@"phone"] forKey:@"receiverPhone"];
        [DetailDict setObject:[dict objectForKey:@"address"] forKey:@"receiverAddress"];
        NameLabel.text=[NSString stringWithFormat:@"%@       %@",[DetailDict objectForKey:@"receiverUserName"],[DetailDict objectForKey:@"receiverPhone"]];
        AddressLabel.text=[[dict objectForKey:@"areaName"]  stringByAppendingString:  [NSString stringWithFormat:@"%@",[DetailDict objectForKey:@"receiverAddress"]]];
        

    }];
}

-(void)addressAct
{
    D_AddAddressViewController *D_AddAddress=[[D_AddAddressViewController alloc] init];
    [self.navigationController pushViewController:D_AddAddress animated:YES];
 
}


-(void)viewLoad
{

    __block int height=10;
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/order/prepare.jhtml"]];
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
                          NSLog(@"%@",ReturnDict);
                          [DetailDict removeAllObjects];
                          [DetailDict setDictionary:[ReturnDict objectForKey:@"data"]];

                          NSArray *listArray=[DetailDict objectForKey:@"cartItemList"];
                          if([DetailDict objectForKey:@"receiverAddress"]!=nil)
                          {
                              UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                              addressBtn.frame =CGRectMake(0, height, SCREEN_WIDTH, 95);
                              addressBtn.backgroundColor=[UIColor whiteColor];
                              [addressBtn addTarget:self action:@selector(changeAddressAct) forControlEvents:UIControlEventTouchUpInside];
                              [ScrollView addSubview:addressBtn];
                              
                              UILabel* localLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,30, 95)];
                              localLabel.text=@"\ue60e";
                              localLabel.textColor=STYLECLOLR;
                              localLabel.backgroundColor=[UIColor clearColor];
                              localLabel.font=[UIFont fontWithName:@"icomoon" size:25];
                              localLabel.textAlignment=NSTextAlignmentCenter;
                              [addressBtn addSubview:localLabel];
                              
                              NameLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 23,200, 20)];
                              NameLabel.text=[NSString stringWithFormat:@"%@       %@",[DetailDict objectForKey:@"receiverUserName"],[DetailDict objectForKey:@"receiverPhone"]];
                              NameLabel.textColor=UIColorFromRGB(0x666666);
                              NameLabel.backgroundColor=[UIColor clearColor];
                              NameLabel.font=[UIFont systemFontOfSize:16];
                              NameLabel.textAlignment=NSTextAlignmentLeft;
                              [addressBtn addSubview:NameLabel];
                              
                              AddressLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 45,200, 40)];
                              AddressLabel.numberOfLines=2;
                              AddressLabel.text=[NSString stringWithFormat:@"%@",[DetailDict objectForKey:@"receiverAddress"]];
                              AddressLabel.textColor=UIColorFromRGB(0x666666);
                              AddressLabel.backgroundColor=[UIColor clearColor];
                              AddressLabel.font=[UIFont systemFontOfSize:12];
                              AddressLabel.textAlignment=NSTextAlignmentLeft;
                              [addressBtn addSubview:AddressLabel];
                              
                              UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0,30, 95)];
                              arrowLabel.text=@"\ue621";
                              arrowLabel.textColor=UIColorFromRGB(0x888888);
                              arrowLabel.backgroundColor=[UIColor clearColor];
                              arrowLabel.font=[UIFont fontWithName:@"icomoon" size:25];
                              arrowLabel.textAlignment=NSTextAlignmentCenter;
                              [addressBtn addSubview:arrowLabel];
                              
                              UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 0.5)];
                              lineView.backgroundColor=UIColorFromRGB(0xaaaaaa);
                              [ScrollView addSubview:lineView];
                              
                              height+=95;
                              
                              UIImageView *lineView1=[[UIImageView alloc] initWithFrame:CGRectMake(0,height, SCREEN_WIDTH, 0.5)];
                              lineView1.backgroundColor=UIColorFromRGB(0xaaaaaa);
                              [ScrollView addSubview:lineView1];
                              
                          }else{
                              
                              UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                              addressBtn.frame =CGRectMake(0, height, SCREEN_WIDTH, 40);
                              addressBtn.backgroundColor=[UIColor whiteColor];
                              [addressBtn addTarget:self action:@selector(addressAct) forControlEvents:UIControlEventTouchUpInside];
                              [ScrollView addSubview:addressBtn];
                              
                              UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,200, 40)];
                              nameLabel.text=@"新增收获地址";
                              nameLabel.textColor=UIColorFromRGB(0x666666);
                              nameLabel.backgroundColor=[UIColor clearColor];
                              nameLabel.font=[UIFont systemFontOfSize:16];
                              nameLabel.textAlignment=NSTextAlignmentLeft;
                              [addressBtn addSubview:nameLabel];
                              
                              UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0,30, 40)];
                              arrowLabel.text=@"\ue621";
                              arrowLabel.textColor=UIColorFromRGB(0x888888);
                              arrowLabel.backgroundColor=[UIColor clearColor];
                              arrowLabel.font=[UIFont fontWithName:@"icomoon" size:25];
                              arrowLabel.textAlignment=NSTextAlignmentCenter;
                              [addressBtn addSubview:arrowLabel];
                              
                              UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 0.5)];
                              lineView.backgroundColor=UIColorFromRGB(0xaaaaaa);
                              [ScrollView addSubview:lineView];
                              
                              height+=40;
                              
                              UIImageView *lineView1=[[UIImageView alloc] initWithFrame:CGRectMake(0,height, SCREEN_WIDTH, 0.5)];
                              lineView1.backgroundColor=UIColorFromRGB(0xaaaaaa);
                              [ScrollView addSubview:lineView1];
                              
                          }
                          height+=10;
                          
                          UIButton *sendTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          sendTypeBtn.frame =CGRectMake(0, height, SCREEN_WIDTH, 45);
                          sendTypeBtn.backgroundColor=[UIColor whiteColor];
                          [sendTypeBtn addTarget:self action:@selector(sendTypeAct) forControlEvents:UIControlEventTouchUpInside];
                          [ScrollView addSubview:sendTypeBtn];
                          
                          UILabel* sendLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,200, 45)];
                          sendLabel.text=@"配送方式";
                          sendLabel.textColor=UIColorFromRGB(0x666666);
                          sendLabel.backgroundColor=[UIColor clearColor];
                          sendLabel.font=[UIFont systemFontOfSize:16];
                          sendLabel.textAlignment=NSTextAlignmentLeft;
                          [sendTypeBtn addSubview:sendLabel];
                          
                          UILabel* sendArrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0,100, 40)];
                          sendArrowLabel.text=[NSString stringWithFormat:@"运费:%@元",[DetailDict objectForKey:@"freight"]];
                          sendArrowLabel.textColor=UIColorFromRGB(0x888888);
                          sendArrowLabel.backgroundColor=[UIColor clearColor];
                          sendArrowLabel.font=[UIFont fontWithName:@"icomoon" size:16];
                          sendArrowLabel.textAlignment=NSTextAlignmentCenter;
                          [sendTypeBtn addSubview:sendArrowLabel];
                          
                          height+=45;
                          UIImageView *lineView2=[[UIImageView alloc] initWithFrame:CGRectMake(0,height-0.5, SCREEN_WIDTH, 0.5)];
                          lineView2.backgroundColor=UIColorFromRGB(0xaaaaaa);
                          [ScrollView addSubview:lineView2];
                          
                          UIButton *payTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          payTypeBtn.frame =CGRectMake(0, height, SCREEN_WIDTH, 45);
                          payTypeBtn.backgroundColor=[UIColor whiteColor];
                          [payTypeBtn addTarget:self action:@selector(payTypeAct) forControlEvents:UIControlEventTouchUpInside];
                          [ScrollView addSubview:payTypeBtn];
                          
                          UILabel* payLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,200, 45)];
                          payLabel.text=@"支付方式";
                          payLabel.textColor=UIColorFromRGB(0x666666);
                          payLabel.backgroundColor=[UIColor clearColor];
                          payLabel.font=[UIFont systemFontOfSize:16];
                          payLabel.textAlignment=NSTextAlignmentLeft;
                          [payTypeBtn addSubview:payLabel];
                          
                          UILabel* payArrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0,100, 40)];
                          payArrowLabel.text=@"在线支付";
                          payArrowLabel.textColor=UIColorFromRGB(0x888888);
                          payArrowLabel.backgroundColor=[UIColor clearColor];
                          payArrowLabel.font=[UIFont fontWithName:@"icomoon" size:16];
                          payArrowLabel.textAlignment=NSTextAlignmentCenter;
                          [payTypeBtn addSubview:payArrowLabel];
                          
                          height+=45;
                          UIImageView *lineView3=[[UIImageView alloc] initWithFrame:CGRectMake(0,height-0.5, SCREEN_WIDTH, 0.5)];
                          lineView3.backgroundColor=UIColorFromRGB(0xaaaaaa);
                          [ScrollView addSubview:lineView3];
                          
                          height+=20;
                          
                          UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          infoBtn.frame =CGRectMake(0, height, SCREEN_WIDTH, 45);
                          infoBtn.backgroundColor=[UIColor whiteColor];
                          //[infoBtn addTarget:self action:@selector(infoAct) forControlEvents:UIControlEventTouchUpInside];
                          [ScrollView addSubview:infoBtn];
                          
                          height+=45;
                          
                          UIImageView *lineView4=[[UIImageView alloc] initWithFrame:CGRectMake(0,height-0.5, SCREEN_WIDTH, 0.5)];
                          lineView4.backgroundColor=UIColorFromRGB(0xaaaaaa);
                          [ScrollView addSubview:lineView4];
                          
                          
                          UILabel* listLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,200, 45)];
                          listLabel.text=@"清单信息";
                          listLabel.textColor=UIColorFromRGB(0x666666);
                          listLabel.backgroundColor=[UIColor clearColor];
                          listLabel.font=[UIFont systemFontOfSize:15];
                          listLabel.textAlignment=NSTextAlignmentLeft;
                          [infoBtn addSubview:listLabel];
                          
                          UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(110, 0,200, 45)];
                          moneyLabel.text=[NSString stringWithFormat:@"共%lu项  合计：¥%.2f",(unsigned long)[listArray count],[[DetailDict objectForKey:@"totalPrice"] floatValue]];
                          moneyLabel.textColor=UIColorFromRGB(0x666666);
                          moneyLabel.backgroundColor=[UIColor clearColor];
                          moneyLabel.font=[UIFont systemFontOfSize:12];
                          moneyLabel.textAlignment=NSTextAlignmentRight;
                          [infoBtn addSubview:moneyLabel];
                          
                          UIView *belowView=[[UIView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 91+85*[listArray count])];
                          belowView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:belowView];
                          
                          UILabel* shopName=[[UILabel alloc] initWithFrame:CGRectMake(20,0, SCREEN_WIDTH-40, 30)];
                          shopName.text=[NSString stringWithFormat:@"商铺：%@",[DetailDict objectForKey:@"shopName"]];
                          shopName.textColor=UIColorFromRGB(0x000000);
                          shopName.backgroundColor=[UIColor clearColor];
                          shopName.font=[UIFont systemFontOfSize:12];
                          shopName.textAlignment=NSTextAlignmentLeft;
                          [belowView addSubview:shopName];
                          
                          UIImageView *lineView5=[[UIImageView alloc] initWithFrame:CGRectMake(10,-0.5+30, SCREEN_WIDTH-20, 0.5)];
                          lineView5.backgroundColor=UIColorFromRGB(0xaaaaaa);
                          [belowView addSubview:lineView5];
                          
                          UIImageView *lineView6=[[UIImageView alloc] initWithFrame:CGRectMake(10,-0.5+91, SCREEN_WIDTH-20, 0.5)];
                          lineView6.backgroundColor=UIColorFromRGB(0xaaaaaa);
                          [belowView addSubview:lineView6];
                          
                          TextField=[[UXTextField alloc] initWithFrame:CGRectMake(20,40, SCREEN_WIDTH-40,40)];
                          TextField.placeholder=@"给商家留言：";
                          TextField.delegate=self;
                          TextField.returnKeyType=UIReturnKeyDone;
                          TextField.backgroundColor=UIColorFromRGB(0xf8f8f8);
                          [belowView addSubview:TextField];
                          [[TextField layer] setMasksToBounds:YES];
                          [[TextField layer] setCornerRadius:4];
                          [[TextField layer]setBorderWidth:0];
                          [[TextField layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
                          for (int i=0; i<[listArray count]; i++) {
                              
                              UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10+i*85+91, 60, 60)];
                              [iconImage sd_setImageWithURL:[NSURL URLWithString:[[listArray ObjectAtIndex:i] ObjectForKey:@"imageUrl"]]];
                              [belowView addSubview:iconImage];
                              [[iconImage layer] setMasksToBounds:YES];
                              [[iconImage layer] setCornerRadius:2];
                              
                              UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(80,  20+i*85+91,120, 30)];
                              titleLabel.text=[[listArray ObjectAtIndex:i] ObjectForKey:@"name"];
                              titleLabel.textColor=UIColorFromRGB(0x333333);
                              titleLabel.numberOfLines=5;
                              titleLabel.backgroundColor=[UIColor clearColor];
                              titleLabel.font=[UIFont systemFontOfSize:12];
                              titleLabel.textAlignment=NSTextAlignmentLeft;
                              [belowView addSubview:titleLabel];
                              
                              UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(180,  20+i*85+91,120, 20)];
                              priceLabel.text=[NSString stringWithFormat:@"¥%@",[[listArray ObjectAtIndex:i] ObjectForKey:@"price"]];
                              priceLabel.textColor=UIColorFromRGB(0x333333);
                              priceLabel.numberOfLines=5;
                              priceLabel.backgroundColor=[UIColor clearColor];
                              priceLabel.font=[UIFont systemFontOfSize:12];
                              priceLabel.textAlignment=NSTextAlignmentRight;
                              [belowView addSubview:priceLabel];
                              
                              UILabel* quantityLabel=[[UILabel alloc] initWithFrame:CGRectMake(180,  40+i*85+91,120, 20)];
                              quantityLabel.text=[NSString stringWithFormat:@"x%@",[[listArray ObjectAtIndex:i] ObjectForKey:@"quantity"]];
                              quantityLabel.textColor=UIColorFromRGB(0x333333);
                              quantityLabel.numberOfLines=5;
                              quantityLabel.backgroundColor=[UIColor clearColor];
                              quantityLabel.font=[UIFont systemFontOfSize:12];
                              quantityLabel.textAlignment=NSTextAlignmentRight;
                              [belowView addSubview:quantityLabel];
                              
                              NSMutableString *mString=[[NSMutableString alloc] init];
                              for(NSString *string in [[listArray ObjectAtIndex:i] ObjectForKey:@"specificationList"])
                              {
                                  [mString appendFormat:@"%@\n",string];
                              }
                              UILabel* areaLabel=[[UILabel alloc] initWithFrame:CGRectMake(80, 50+i*85+91,120, 50)];
                              areaLabel.text=mString;
                              areaLabel.numberOfLines=10;
                              areaLabel.textColor=UIColorFromRGB(0xaeaeae);
                              areaLabel.backgroundColor=[UIColor clearColor];
                              areaLabel.font=[UIFont systemFontOfSize:11];
                              areaLabel.textAlignment=NSTextAlignmentLeft;
                              [belowView addSubview:areaLabel];
                              
                              
                              
                              
                              UIImageView *lineView7=[[UIImageView alloc] initWithFrame:CGRectMake(10,(i+1)*85+91-0.5, SCREEN_WIDTH-20, 0.5)];
                              lineView7.backgroundColor=UIColorFromRGB(0xaaaaaa);
                              [belowView addSubview:lineView7];
                              
                          }
                          
                          UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HIGHE-64-50,100, 50)];
                          titleLabel.text=@"合计：";
                          titleLabel.textColor=UIColorFromRGB(0x666666);
                          titleLabel.backgroundColor=[UIColor clearColor];
                          titleLabel.font=[UIFont systemFontOfSize:12];
                          titleLabel.textAlignment=NSTextAlignmentLeft;
                          [self.view addSubview:titleLabel];
                          
                          UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HIGHE-64-50,100, 50)];
                          priceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[DetailDict objectForKey:@"totalPrice"] floatValue]];
                          priceLabel.textColor=UIColorFromRGB(0xe85829);
                          priceLabel.backgroundColor=[UIColor clearColor];
                          priceLabel.font=[UIFont systemFontOfSize:18];
                          priceLabel.textAlignment=NSTextAlignmentLeft;
                          [self.view addSubview:priceLabel];
                          
                          UILabel* percLabel=[[UILabel alloc] initWithFrame:CGRectMake(140, SCREEN_HIGHE-64-50,100, 50)];
                          percLabel.text=@"积分：";
                          percLabel.textColor=UIColorFromRGB(0x666666);
                          percLabel.backgroundColor=[UIColor clearColor];
                          percLabel.font=[UIFont systemFontOfSize:12];
                          percLabel.textAlignment=NSTextAlignmentLeft;
                          [self.view addSubview:percLabel];
                          
                          UILabel* scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(175, SCREEN_HIGHE-64-50,100, 50)];
                          scoreLabel.text=[NSString stringWithFormat:@"%@",[DetailDict objectForKey:@"points"]];
                          scoreLabel.textColor=UIColorFromRGB(0xe85829);
                          scoreLabel.backgroundColor=[UIColor clearColor];
                          scoreLabel.font=[UIFont systemFontOfSize:18];
                          scoreLabel.textAlignment=NSTextAlignmentLeft;
                          [self.view addSubview:scoreLabel];
                          
                          UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          sureBtn.frame = CGRectMake(SCREEN_WIDTH-82,  SCREEN_HIGHE-64-45, 71, 40);
                          [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
                          [sureBtn setTitle:@"确认" forState:UIControlStateHighlighted];
                          sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
                          [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateNormal];
                          [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
                          [sureBtn addTarget:self action:@selector(sureAct) forControlEvents:UIControlEventTouchUpInside];
                          [self.view addSubview:sureBtn];
                          [[sureBtn layer] setMasksToBounds:YES];
                          [[sureBtn layer] setCornerRadius:2];
                          
                          ScrollView.contentSize=CGSizeMake(0,height + belowView.frame.size.height+200);
                      }
                      NetError:^(int error) {
                      }
     ];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    DetailDict=[[NSMutableDictionary alloc] init];
    ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64-50)];
    ScrollView.backgroundColor=UIColorFromRGB(0xf0f0f3);
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:ScrollView];
    [self viewLoad];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    ScrollView.contentOffset=CGPointMake(0, 100);
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    ScrollView.contentOffset=CGPointMake(0, 0);
    return YES;
}

-(void)sureAct
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/order/create.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:[DetailDict objectForKey:@"receiverId"],@"receiverId",TextField.text==nil?@"":TextField.text,@"memo", nil]
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
                          B_CheckstandViewController *B_Checkstand=[[B_CheckstandViewController alloc] init];
                          B_Checkstand.Tag=1;
                          B_Checkstand.SellDict=[ReturnDict objectForKey:@"data"];
                          B_Checkstand.AllPrice=[NSString stringWithFormat:@"¥%.2f",[[DetailDict objectForKey:@"totalPrice"] floatValue]];
                          [self.navigationController pushViewController:B_Checkstand animated:YES];
                      }
                      NetError:^(int error) {
                      }
     ];
}
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"=======%ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 2:
        {
            B_DeliveryListViewController *B_DeliveryList=[[B_DeliveryListViewController alloc] init];
            [self.navigationController pushViewController:B_DeliveryList animated:YES];
        }
            break;
            
        case 0:
        {
            
        }
            break;
            
        case 1:
        {
            NSLog(@"%@====",[SellDict objectForKey:@"alipayParam"]);
            [[AlipaySDK defaultService] payOrder:[SellDict objectForKey:@"alipayParam"]
                                      fromScheme:@"zhipin"
                                        callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)sendTypeAct
{
    
}

-(void)payTypeAct
{
    
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
