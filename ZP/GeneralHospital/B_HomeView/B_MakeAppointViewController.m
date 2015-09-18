//
//  B_MakeAppointViewController.m
//  zhipin
//
//  Created by 夏科杰 on 15/3/1.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_MakeAppointViewController.h"
#import "B_CheckstandViewController.h"
@interface B_MakeAppointViewController ()

@end

@implementation B_MakeAppointViewController
-(void)timeAct:(UIButton*)sender
{
 
    if (SelectPicker.isHidden) {
        [UIView animateWithDuration:0.6 animations:^{
            SelectPicker.hidden=NO;
        }];
    }else{
        [UIView animateWithDuration:0.6 animations:^{
            SelectPicker.hidden=YES;
        }];
    }

    
    
    
//    NSMutableArray *timeArray=[[NSMutableArray alloc] init];
//    for (NSDictionary *dict in [AppointDict objectForKey:@"timeList"]) {
//        [timeArray addObject:[NSString stringWithFormat:@"%@~%@",[dict objectForKey:@"begin"],[dict objectForKey:@"until"]]];
//    }
//    UXActionSheet *actionSheet=[[UXActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"请选择预约时间"]
//                                                  cancelButtonTitle:@"取消"
//                                                               show:^(long index) {
//                                                                   TimeIndex=index;
//                                                                   NSString *string=[NSString stringWithFormat:@"%@~%@",[[[AppointDict objectForKey:@"timeList"] objectAtIndex:index] objectForKey:@"begin"],[[[AppointDict objectForKey:@"timeList"] objectAtIndex:index] objectForKey:@"until"]];
//                                                                   [TimeBtn setTitle:string
//                                                                            forState:UIControlStateNormal];
//                                                                   [TimeBtn setTitle:string
//                                                                            forState:UIControlStateSelected];
//                                                               }
//                                                             cancel:^{
//                                                                 
//                                                             }
//                                                        selectArray:timeArray
//                                                  otherButtonTitles:nil];
}

-(void)numAct:(UIButton *)sender
{
    
    NSMutableArray *timeArray=[[NSMutableArray alloc] init];
    for (id string in [AppointDict objectForKey:@"personList"]) {
        [timeArray addObject:[NSString stringWithFormat:@"%@人",string]];
    }
    UXActionSheet *actionSheet=[[UXActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"请选择预约人数"]
                                                  cancelButtonTitle:@"取消"
                                                               show:^(long index) {
                                                                   NumIndex=index;
                                                                   NSString *string=[NSString stringWithFormat:@"%@人",[[AppointDict objectForKey:@"personList"] objectAtIndex:index]];
                                                                   
                                                                   [PeopleBtn setTitle:string forState:UIControlStateNormal];
                                                                   [PeopleBtn setTitle:string forState:UIControlStateSelected];
                        
                                                               }
                                                             cancel:^{
                                                                 
                                                             }
                                                        selectArray:timeArray
                                                  otherButtonTitles:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"确认预约";
    DateIndex=0;
    TimeIndex=0;
    NumIndex =-1;
    
    ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64-50)];
    ScrollView.backgroundColor=UIColorFromRGB(0xf0f0f3);
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:ScrollView];
    
    TimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    TimeBtn.frame = CGRectMake(10,16, SCREEN_WIDTH-20, 38);
    [TimeBtn setTitle:@"请选择到店时间" forState:UIControlStateNormal];
    [TimeBtn setTitle:@"请选择到店时间" forState:UIControlStateSelected];
    TimeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [TimeBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    [TimeBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateSelected];
    [TimeBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                       forState:UIControlStateSelected];
    [TimeBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                       forState:UIControlStateNormal];
    [TimeBtn addTarget:self
                action:@selector(timeAct:)
      forControlEvents:UIControlEventTouchUpInside];
    [ScrollView addSubview:TimeBtn];
    [[TimeBtn layer] setMasksToBounds:YES];
    [[TimeBtn layer] setCornerRadius:2];
    [[TimeBtn layer]setBorderWidth:1];
    [[TimeBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,100, 38)];
    nameLabel.text=@"时间";
    nameLabel.textColor=UIColorFromRGB(0x666666);
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.font=[UIFont boldSystemFontOfSize:14];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [TimeBtn addSubview:nameLabel];
    
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, 0,100, 38)];
    arrowLabel.text=@"\ue627";
    arrowLabel.textColor=UIColorFromRGB(0x666666);
    arrowLabel.backgroundColor=[UIColor clearColor];
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel.textAlignment=NSTextAlignmentRight;
    [TimeBtn addSubview:arrowLabel];
    
    UILabel* noticeLabel=[[UILabel alloc] initWithFrame:CGRectMake(20,54,280, 35)];
    noticeLabel.text=@"修改预约请提早一小时联系商家";
    noticeLabel.textColor=UIColorFromRGB(0x999999);
    noticeLabel.backgroundColor=[UIColor clearColor];
    noticeLabel.font=[UIFont boldSystemFontOfSize:14];
    noticeLabel.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:noticeLabel];
    
    PeopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PeopleBtn.frame = CGRectMake(10,89, SCREEN_WIDTH-20, 38);
    [PeopleBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [PeopleBtn setTitle:@"请选择" forState:UIControlStateSelected];
    PeopleBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [PeopleBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    [PeopleBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateSelected];
    [PeopleBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                       forState:UIControlStateSelected];
    [PeopleBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                       forState:UIControlStateNormal];
    [PeopleBtn addTarget:self
                action:@selector(numAct:)
      forControlEvents:UIControlEventTouchUpInside];
    [ScrollView addSubview:PeopleBtn];
    [[PeopleBtn layer] setMasksToBounds:YES];
    [[PeopleBtn layer] setCornerRadius:2];
    [[PeopleBtn layer]setBorderWidth:1];
    [[PeopleBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    UILabel* peopleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,100, 38)];
    peopleLabel.text=@"人数";
    peopleLabel.textColor=UIColorFromRGB(0x666666);
    peopleLabel.backgroundColor=[UIColor clearColor];
    peopleLabel.font=[UIFont boldSystemFontOfSize:14];
    peopleLabel.textAlignment=NSTextAlignmentLeft;
    [PeopleBtn addSubview:peopleLabel];
    
    UILabel* arrowLabel1=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, 0,100, 38)];
    arrowLabel1.text=@"\ue627";
    arrowLabel1.textColor=UIColorFromRGB(0x666666);
    arrowLabel1.backgroundColor=[UIColor clearColor];
    [arrowLabel1 setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel1.textAlignment=NSTextAlignmentRight;
    [PeopleBtn addSubview:arrowLabel1];
    
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20,127,100, 40)];
    titleLabel.text=@"联系人信息";
    titleLabel.textColor=UIColorFromRGB(0x999999);
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [ScrollView addSubview:titleLabel];
    
    UserName=[[UITextField alloc] initWithFrame:CGRectMake(10, 167, 110, 37.5)];
    UserName.placeholder=@"请输入姓名";
    UserName.delegate=self;
    UserName.font=[UIFont systemFontOfSize:14];
    UserName.textAlignment=NSTextAlignmentCenter;
    UserName.backgroundColor=[UIColor whiteColor];
    [ScrollView addSubview:UserName];
    [[UserName layer] setMasksToBounds:YES];
    [[UserName layer] setCornerRadius:2];
    [[UserName layer]setBorderWidth:1];
    [[UserName layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    ManBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ManBtn.frame = CGRectMake(140,167, 60, 38);
    [ManBtn setTitle:@"先生" forState:UIControlStateNormal];
    [ManBtn setTitle:@"先生" forState:UIControlStateSelected];
    ManBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [ManBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    [ManBtn setTitleColor:STYLECLOLR forState:UIControlStateSelected];
    [ManBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                         forState:UIControlStateSelected];
    [ManBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                         forState:UIControlStateNormal];
    [ManBtn addTarget:self
                  action:@selector(SexAct)
        forControlEvents:UIControlEventTouchUpInside];
    [ScrollView addSubview:ManBtn];
    [[ManBtn layer] setMasksToBounds:YES];
    [[ManBtn layer] setCornerRadius:2];
    [[ManBtn layer]setBorderWidth:1];
    [[ManBtn layer]setBorderColor:[STYLECLOLR CGColor]];
    ManBtn.selected=YES;
    
    WomenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    WomenBtn.frame = CGRectMake(220,167, 60, 38);
    WomenBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [WomenBtn setTitle:@"女士" forState:UIControlStateNormal];
    [WomenBtn setTitle:@"女士" forState:UIControlStateSelected];
    [WomenBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    [WomenBtn setTitleColor:STYLECLOLR forState:UIControlStateSelected];
    [WomenBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                      forState:UIControlStateSelected];
    [WomenBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                      forState:UIControlStateNormal];
    [WomenBtn addTarget:self
               action:@selector(SexAct)
     forControlEvents:UIControlEventTouchUpInside];
    [ScrollView addSubview:WomenBtn];
    [[WomenBtn layer] setMasksToBounds:YES];
    [[WomenBtn layer] setCornerRadius:2];
    [[WomenBtn layer]setBorderWidth:1];
    [[WomenBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    
    PhoneName=[[UITextField alloc] initWithFrame:CGRectMake(10, 214.5, 190, 37.5)];
    PhoneName.placeholder=@"请输入联系号码";
    PhoneName.delegate=self;
    PhoneName.font=[UIFont systemFontOfSize:14];
    PhoneName.textAlignment=NSTextAlignmentCenter;
    PhoneName.backgroundColor=[UIColor whiteColor];
    [ScrollView addSubview:PhoneName];
    [[PhoneName layer] setMasksToBounds:YES];
    [[PhoneName layer] setCornerRadius:2];
    [[PhoneName layer]setBorderWidth:1];
    [[PhoneName layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    UIButton *payTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payTypeBtn.frame =CGRectMake(0, 266, SCREEN_WIDTH, 45);
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
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/preorder/prepare.jhtml"]]];
    [NetRequest setASIPostDict:nil
                       ApiName:@"submit"
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"%@",ReturnDict);
                          AppointDict=[[NSDictionary alloc] initWithDictionary:[ReturnDict objectForKey:@"data"]];
                          int height=320;
                          
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
                          listLabel.font=[UIFont systemFontOfSize:14];
                          listLabel.textAlignment=NSTextAlignmentLeft;
                          [infoBtn addSubview:listLabel];
                          
                          NSArray *listArray=[[NSArray alloc] initWithArray:[AppointDict objectForKey:@"cartItemList"]];
                          NSLog(@"listArray=%@==%@",listArray,AppointDict);
                          UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(110, 0,200, 45)];
                          moneyLabel.text=[NSString stringWithFormat:@"共%lu项  合计：¥%.2f",(unsigned long)[listArray count],[[AppointDict objectForKey:@"totalPrice"] floatValue]];
                          moneyLabel.textColor=UIColorFromRGB(0x666666);
                          moneyLabel.backgroundColor=[UIColor clearColor];
                          moneyLabel.font=[UIFont systemFontOfSize:12];
                          moneyLabel.textAlignment=NSTextAlignmentRight;
                          [infoBtn addSubview:moneyLabel];
                          
                          UIView *belowView=[[UIView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 91+85*[listArray count])];
                          belowView.backgroundColor=[UIColor whiteColor];
                          [ScrollView addSubview:belowView];
                          
                          UILabel* shopName=[[UILabel alloc] initWithFrame:CGRectMake(20,0, SCREEN_WIDTH-40, 30)];
                          shopName.text=[NSString stringWithFormat:@"商铺：%@",[AppointDict objectForKey:@"shopName"]];
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
                          
                          TextField=[[UITextField alloc] initWithFrame:CGRectMake(20,40, SCREEN_WIDTH-40,40)];
                          TextField.tag=11;
                          TextField.placeholder=@"给商家留言：";
                          TextField.delegate=self;
                          TextField.font=[UIFont systemFontOfSize:13];
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
                          ScrollView.contentSize=CGSizeMake(0, height+91+85*[listArray count]);
                          ScoreLabel.text=[NSString stringWithFormat:@"%@",[AppointDict objectForKey:@"points"]];
                          PriceLabel.text=[NSString stringWithFormat:@"¥%.2f",[[AppointDict objectForKey:@"totalPrice"] floatValue]];
                          DateArray=[[NSArray alloc] initWithArray:[AppointDict objectForKey:@"dateList"]];
                          TimeArray=[[NSArray alloc] initWithArray:[AppointDict objectForKey:@"timeList"]];
                          SelectPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHE-64-180, SCREEN_WIDTH, 180)];
                          SelectPicker.delegate=self;
                          SelectPicker.dataSource=self;
                          SelectPicker.hidden=YES;
                          SelectPicker.backgroundColor=[UIColor whiteColor];
                          [self.view addSubview:SelectPicker];
                          [[SelectPicker layer]setBorderWidth:1];
                          [[SelectPicker layer]setBorderColor:[STYLECLOLR CGColor]];
                          [TimeBtn setTitle:[NSString stringWithFormat:@"%@(%@) %@~%@",[[DateArray objectAtIndex:DateIndex] objectForKey:@"date"],[[DateArray objectAtIndex:DateIndex] objectForKey:@"week"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"begin"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"until"]]
                                   forState:UIControlStateNormal];
                          [TimeBtn setTitle:[NSString stringWithFormat:@"%@(%@) %@~%@",[[DateArray objectAtIndex:DateIndex] objectForKey:@"date"],[[DateArray objectAtIndex:DateIndex] objectForKey:@"week"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"begin"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"until"]]
                                   forState:UIControlStateSelected];
                      }
                      NetError:^(int error) {
                      }
     ];

    UILabel* allLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HIGHE-64-50,100, 50)];
    allLabel.text=@"合计：";
    allLabel.textColor=UIColorFromRGB(0x666666);
    allLabel.backgroundColor=[UIColor clearColor];
    allLabel.font=[UIFont systemFontOfSize:12];
    allLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:allLabel];
    
    PriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HIGHE-64-50,100, 50)];

    PriceLabel.textColor=UIColorFromRGB(0xe85829);
    PriceLabel.backgroundColor=[UIColor clearColor];
    PriceLabel.font=[UIFont systemFontOfSize:18];
    PriceLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:PriceLabel];
    
    UILabel* percLabel=[[UILabel alloc] initWithFrame:CGRectMake(140, SCREEN_HIGHE-64-50,100, 50)];
    percLabel.text=@"积分：";
    percLabel.textColor=UIColorFromRGB(0x666666);
    percLabel.backgroundColor=[UIColor clearColor];
    percLabel.font=[UIFont systemFontOfSize:12];
    percLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:percLabel];
    
    ScoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(175, SCREEN_HIGHE-64-50,100, 50)];

    ScoreLabel.textColor=UIColorFromRGB(0xe85829);
    ScoreLabel.backgroundColor=[UIColor clearColor];
    ScoreLabel.font=[UIFont systemFontOfSize:18];
    ScoreLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:ScoreLabel];
    
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
    

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [DateArray count];
            break;
        case 1:
            return [TimeArray count];
            break;
        default:
            return [DateArray count];
            break;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *fontView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2,40)];
    
    UILabel* allLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/2,40)];
    allLabel.textColor=UIColorFromRGB(0x666666);
    allLabel.backgroundColor=[UIColor clearColor];
    allLabel.font=[UIFont systemFontOfSize:16];
    allLabel.textAlignment=NSTextAlignmentCenter;
    [fontView addSubview:allLabel];
    switch (component) {
        case 0:
            allLabel.text= [NSString stringWithFormat:@"%@(%@)",[[DateArray objectAtIndex:row] objectForKey:@"date"],[[DateArray objectAtIndex:row] objectForKey:@"week"]];
            break;
        case 1:
        default:
            allLabel.text= [NSString stringWithFormat:@"%@~%@",[[TimeArray objectAtIndex:row] objectForKey:@"begin"],[[TimeArray objectAtIndex:row] objectForKey:@"until"]];
            break;
    }
    return fontView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return  40;
}

 - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    switch (component) {
        case 0:
            DateIndex=row;
            break;
        case 1:
            TimeIndex=row;
            break;
        default:
            
            break;
    }
    
    [TimeBtn setTitle:[NSString stringWithFormat:@"%@(%@) %@~%@",[[DateArray objectAtIndex:DateIndex] objectForKey:@"date"],[[DateArray objectAtIndex:DateIndex] objectForKey:@"week"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"begin"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"until"]]
             forState:UIControlStateNormal];
    [TimeBtn setTitle:[NSString stringWithFormat:@"%@(%@) %@~%@",[[DateArray objectAtIndex:DateIndex] objectForKey:@"date"],[[DateArray objectAtIndex:DateIndex] objectForKey:@"week"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"begin"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"until"]]
             forState:UIControlStateSelected];
}


-(void)SexAct
{
    if (ManBtn.isSelected) {

        [[WomenBtn layer]setBorderColor:[STYLECLOLR CGColor]];
        [[ManBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    }else{
        [[ManBtn layer]setBorderColor:[STYLECLOLR CGColor]];
        [[WomenBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    }
    ManBtn.selected=!ManBtn.isSelected;
    WomenBtn.selected=!WomenBtn.isSelected;
}

-(void)sureAct
{
    /*
     
     memo	string	否	给商家留言
     contactUserName	string	是	联系人姓名
     contactPhone	string	是	联系电话
     persons	int	否	预约人数
     beginTime	string	是	预约时间段的起始时间，格式：2014-01-01 12:00
     untilTime	string	是	预约时间段的截止时间，格式：2014-01-01 13:00
     
     */
    if (TimeIndex<0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择预约时间！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if (NumIndex<0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择预约人数！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if (UserName.text==nil||[UserName.text length]==0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入姓名！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if (PhoneName.text==nil||[PhoneName.text length]==0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入手机号！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    /*
     memo	string	否	给商家留言
     contactUserName	string	是	联系人姓名
     contactPhone	string	是	联系电话
     persons	int	否	预约人数
     beginTime	string	是	预约时间段的起始时间，格式：2014-01-01 12:00
     untilTime	string	是	预约时间段的截止时间，格式：2014-01-01 13:00
     
     */
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/preorder/create.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                TextField.text==nil?@"":TextField.text,@"memo",
                                UserName.text,@"contactUserName",
                                PhoneName.text,@"contactPhone",
                                [[AppointDict objectForKey:@"personList"] objectAtIndex:NumIndex],@"persons",
                                [NSString stringWithFormat:@"%@ %@",[[DateArray objectAtIndex:DateIndex] objectForKey:@"date"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"begin"]],@"beginTime",
                                [NSString stringWithFormat:@"%@ %@",[[DateArray objectAtIndex:DateIndex] objectForKey:@"date"],[[TimeArray objectAtIndex:TimeIndex] objectForKey:@"until"]],@"untilTime",
                                nil]
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
                          B_CheckstandViewController *B_Checkstand=[[B_CheckstandViewController alloc] init];
                          B_Checkstand.Tag=2;
                          B_Checkstand.SellDict=[ReturnDict objectForKey:@"data"];
                          B_Checkstand.AllPrice=[NSString stringWithFormat:@"¥%.2f",[[AppointDict objectForKey:@"totalPrice"] floatValue]];
                          [self.navigationController pushViewController:B_Checkstand animated:YES];
                          

                      }
                      NetError:^(int error) {
                      }
     ];
}

-(void)payTypeAct
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
        [UIView animateWithDuration:0.5 animations:^{

            ScrollView.contentOffset=CGPointMake(0, 0);
        }];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    [UIView animateWithDuration:0.5 animations:^{
        if (textField.tag==11) {
            ScrollView.contentOffset=CGPointMake(0, 305+textField.frame.origin.y);
        }else{
            ScrollView.contentOffset=CGPointMake(0, textField.frame.origin.y-80);
        }
       
    }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
