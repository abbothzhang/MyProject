//
//  B_CommentViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/29.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_CommentViewController.h"

@interface B_CommentViewController ()

@end

@implementation B_CommentViewController
@synthesize UseDict;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"点评";
    
    NSLog(@"orderId===%@",[UseDict objectForKey:@"orderId"]);
    // orderId===201501312833
    ScoreArray=[[NSMutableArray alloc] init];
    ComArray  =[[NSMutableArray alloc] init];
    ImageArray=[[NSMutableArray alloc] init];
    StatuArray=[[NSMutableArray alloc] init];
    UploadDict=[[NSMutableDictionary alloc] init];
    
    
    
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    TableView.backgroundColor=UIColorFromRGBA(0xf5f5f5,0.9);
    TableView.delegate=self;
    TableView.allowsSelection=NO;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/review/info.jhtml?orderId=%@",[UseDict objectForKey:@"orderId"]]]];
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
                          CommentDict=[[NSDictionary alloc] initWithDictionary:[ReturnDict objectForKey:@"data"]];
//                          [UploadDict setObject:[CommentDict objectForKey:@"orderId"] forKey:@"orderId"];
                          
                          ListArray = [[NSMutableArray alloc] initWithArray:[CommentDict objectForKey:@"itemInfoList"]];
                          [TableView reloadData];
                          UIView *belowView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHE-64-50, SCREEN_WIDTH, 50)];
                          belowView.backgroundColor=UIColorFromRGB(0xf8f8f8);
                          [self.view addSubview:belowView];
                          [[belowView layer]setBorderWidth:0.5];
                          [[belowView layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
                          
                          
                          
                          UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                          sureBtn.frame = CGRectMake((SCREEN_WIDTH-70)/2, 5, 70, 40);
                          [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
                          [sureBtn setTitle:@"确认" forState:UIControlStateHighlighted];
                          sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
                          [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                          [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
                          [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xffffff)]
                                             forState:UIControlStateSelected];
                          [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                                             forState:UIControlStateNormal];
                          [sureBtn addTarget:self action:@selector(sureAct:) forControlEvents:UIControlEventTouchUpInside];
                          [belowView addSubview:sureBtn];
                          [[sureBtn layer] setMasksToBounds:YES];
                          [[sureBtn layer] setCornerRadius:4];
                      }
                      NetError:^(int error) {
                      }
     ];
    

 
}

-(void)sureAct:(UIButton *)sender
{
    NSLog(@"=====%@",UploadDict);
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    /*
     orderId	long	是	订单ID
     reviewList	array	否	商品评论，数组
     */
    
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[UploadDict allValues]];
    for (int i=0; i<[array count]; i++) {
        NSMutableDictionary *dict1=[[NSMutableDictionary alloc] initWithDictionary:[array objectAtIndex:i]];
        NSMutableArray *aList=[[NSMutableArray alloc] initWithArray:[dict1 objectForKey:@"imageUrlList"]];
        for (int k=[aList count]-1; k>=0; k--) {
             NSLog(@"kkk=%d",k);
            if ([aList objectAtIndex:k]==nil||[[aList objectAtIndex:k] length]==0) {
                [aList removeObjectAtIndex:k];
                NSLog(@"delete=%d",k);
            }
        }
        
        [dict1 setObject:aList forKey:@"imageUrlList"];
        [array replaceObjectAtIndex:i withObject:dict1];
    }
    
    [dict setObject:[CommentDict objectForKey:@"orderId"] forKey:@"orderId"];
    [dict setObject:array forKey:@"reviewList"];

    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/review/submit.jhtml"]]];
    [NetRequest setASIPostDict:dict
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
                          [GeneralClass ShowMBP:@"提示" message:@"评论成功！" setType:NZAlertStyleSuccess];
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                      NetError:^(int error) {
                      }
     ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 322;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        UIView *cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 312)];
        cellView.tag=row;
        cellView.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:cellView];
        
        UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(12.5, 12.5, 60, 60)];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"image"]]];
        [cellView addSubview:iconImage];
        [[iconImage layer] setMasksToBounds:YES];
        [[iconImage layer] setCornerRadius:2];
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(82.5,  12.5,180, 30)];
        titleLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"itemName"];
        titleLabel.textColor=UIColorFromRGB(0x333333);
        titleLabel.numberOfLines=5;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:12];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:titleLabel];
        
        UILabel* priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(250, 12.5,57,20)];
        priceLabel.text=[NSString stringWithFormat:@"¥%.2lf",[[[ListArray ObjectAtIndex:row] ObjectForKey:@"price"] doubleValue]];
        priceLabel.textColor=UIColorFromRGB(0x333333);
        priceLabel.numberOfLines=5;
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.font=[UIFont systemFontOfSize:12];
        priceLabel.textAlignment=NSTextAlignmentRight;
        [cellView addSubview:priceLabel];
        
        NSMutableString *mString=[[NSMutableString alloc] init];
        for(NSString *string in [[ListArray ObjectAtIndex:row] ObjectForKey:@"specificationList"])
        {
            [mString appendFormat:@"%@\n",string];
        }
        UILabel* areaLabel=[[UILabel alloc] initWithFrame:CGRectMake(82.5, 42.5,120, 50)];
        areaLabel.text=mString;
        areaLabel.numberOfLines=10;
        areaLabel.textColor=UIColorFromRGB(0xaeaeae);
        areaLabel.backgroundColor=[UIColor clearColor];
        areaLabel.font=[UIFont systemFontOfSize:11];
        areaLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:areaLabel];
        
        if ([[ListArray ObjectAtIndex:row] objectForKey:@"quantity"]!=nil) {
            UILabel *CodeLabel=[[UILabel alloc] initWithFrame:CGRectMake(250, 32.5, 57, 28)];
            CodeLabel.text=[NSString stringWithFormat:@"x%@",[[ListArray ObjectAtIndex:row] ObjectForKey:@"quantity"]];
            CodeLabel.textColor=UIColorFromRGB(0x666666);
            CodeLabel.backgroundColor=[UIColor clearColor];
            CodeLabel.font=[UIFont systemFontOfSize:12];
            CodeLabel.textAlignment=NSTextAlignmentRight;
            [cellView addSubview:CodeLabel];
        }
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,85, SCREEN_WIDTH-20, 0.5)];
        lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
        [cellView addSubview:lineImage];
        
        UILabel* scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,  85,180, 40)];
        scoreLabel.text=@"评分";
        scoreLabel.textColor=UIColorFromRGB(0x999999);
        scoreLabel.numberOfLines=5;
        scoreLabel.backgroundColor=[UIColor clearColor];
        scoreLabel.font=[UIFont systemFontOfSize:13];
        scoreLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:scoreLabel];
        
        UIView *backView=[self showStar:row];
        backView.frame=CGRectMake(70, 85, 200, 40);
        [cellView addSubview:backView];
        [ScoreArray addObject:backView];
        
        

        
        UIImageView *lineImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10,125, SCREEN_WIDTH-20, 0.5)];
        lineImage1.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
        [cellView addSubview:lineImage1];
        
        UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 133, SCREEN_WIDTH-20, 65)];
        textView.delegate=self;
        textView.tag=row;
        textView.backgroundColor=UIColorFromRGB(0xf0f0ed);
        [cellView addSubview:textView];
        [[textView layer] setMasksToBounds:YES];
        [[textView layer] setCornerRadius:2];
        [ComArray addObject:textView];

        
        UIView *btnView=[self addImage:row];
        btnView.frame=CGRectMake(10, 206, SCREEN_WIDTH-20, 55);
        [cellView addSubview:btnView];
        [ImageArray addObject:btnView];
        
        
        UIImageView *lineImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(10,269, SCREEN_WIDTH-20, 0.5)];
        lineImage2.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
        [cellView addSubview:lineImage2];
        
        UILabel* comLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,  269,180, 40)];
        comLabel.text=@"匿名点评";
        comLabel.textColor=UIColorFromRGB(0x999999);
        comLabel.numberOfLines=5;
        comLabel.backgroundColor=[UIColor clearColor];
        comLabel.font=[UIFont systemFontOfSize:13];
        comLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:comLabel];
        
        /*
         orderId	long	是	订单ID
         reviewList	array	否	商品评论，数组
         reviewList详情：
         

         itemId	long	是	商品ID
         score	integer	是
         comment	string	是
         imageUrlList	array	否
         
         */
        
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(90, 279, 20, 20);
        selectBtn.tag=row;
        selectBtn.selected=NO;
        [selectBtn setImage:[UIImage imageNamed:@"b_unselect.png"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"b_select.png"] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(ShopSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:selectBtn];
        [StatuArray addObject:selectBtn];
        [UploadDict setObject:@{@"itemId":[[ListArray ObjectAtIndex:row] ObjectForKey:@"itemId"],
                                @"score":@"5",
                                @"comment":@"",
                                @"imageUrlList":@[@"",@"",@"",@"",@""]
                                }
                       forKey:[NSString stringWithFormat:@"%d",row]];
        }
    return cell;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        TableView.contentOffset=CGPointMake(0, textView.frame.origin.y+322*textView.tag);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
 
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[UploadDict objectForKey:[NSString stringWithFormat:@"%d",textView.tag]]];
    [dict setObject:textView.text forKey:@"comment"];
    [UploadDict setObject:dict forKey:[NSString stringWithFormat:@"%d",textView.tag]];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)ShopSelect:(UIButton *)sender
{
    sender.selected=!sender.isSelected;
}

-(UIView *)addImage:(int)index
{
    UIView *backView=[[UIView alloc] init];
    
    for (int i=0; i<5; i++) {
        UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        starBtn.frame = CGRectMake((55+7)*i, 0, 55, 55);
        starBtn.tag=i;
        starBtn.accessibilityLanguage=[NSString stringWithFormat:@"%d,%d",index,i];
        [starBtn setImage:[UIImage imageNamed:@"b_add_btn.png"] forState:UIControlStateNormal];
        [starBtn setImage:[UIImage imageNamed:@"b_add_btn.png"] forState:UIControlStateSelected];
        [starBtn addTarget:self action:@selector(imageAct:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:starBtn];
    }
    return backView;
}

-(void)imageAct:(UIButton *)sender
{
    ClickBtn=sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择照片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"图片",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(UIView *)showStar:(int)index
{
    UIView *backView=[[UIView alloc] init];
    for (int i=0; i<5; i++) {
        UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        starBtn.frame = CGRectMake(10+32*i, 0, 30, 40);
        starBtn.tag=i;
        starBtn.accessibilityLanguage=[NSString stringWithFormat:@"%d,%d",index,i];
        [starBtn setTitle:@"\ue61b" forState:UIControlStateNormal];
        [starBtn setTitle:@"\ue61c" forState:UIControlStateSelected];
        [starBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
        [starBtn setTitleColor:UIColorFromRGB(0xffd532) forState:UIControlStateNormal];
        [starBtn setTitleColor:UIColorFromRGB(0xbcbcbc) forState:UIControlStateSelected];
        [starBtn addTarget:self action:@selector(starAct:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:starBtn];
    }
    return backView;
}

-(void)starAct:(UIButton *)sender
{
    NSArray *array=[sender.accessibilityLanguage componentsSeparatedByString:@","];
    int row = [[array objectAtIndex:0] intValue];
    int section = [[array objectAtIndex:1] intValue];
    UIView *view=[ScoreArray objectAtIndex:row];
    for (int i=0; i<[view.subviews count]; i++) {
        UIButton *btn=((UIButton *)[view.subviews objectAtIndex:i]);
        if (btn.tag<=section) {
            btn.selected=NO;
        }else
        {
            btn.selected=YES;
        }
    }
 
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[UploadDict objectForKey:[NSString stringWithFormat:@"%d",row]]];
    [dict setObject:[NSString stringWithFormat:@"%d",section+1] forKey:@"score"];
    [UploadDict setObject:dict forKey:[NSString stringWithFormat:@"%d",row]];
}

//再调用以下委托：
#pragma mark - 发送图片接口
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"%@",editingInfo);
    [picker dismissModalViewControllerAnimated:YES];
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/common/image/upload.jhtml"]];
    [NetRequest setASIPostDict:nil
                       NameKey:@"image"
                     FilesData:image
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *returnDict){
                          NSLog(@"%@",returnDict);
                          
                          [ClickBtn setImage:image forState:UIControlStateNormal];
                          [ClickBtn setImage:image forState:UIControlStateSelected];
                          
                          NSArray *array=[ClickBtn.accessibilityLanguage componentsSeparatedByString:@","];
                          int row = [[array objectAtIndex:0] intValue];
                          int section = [[array objectAtIndex:1] intValue];
                          
                          NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[UploadDict objectForKey:[NSString stringWithFormat:@"%d",row]]];
                          NSMutableArray *urlList;
                          if ([dict objectForKey:@"imageUrlList"]==nil) {
                              urlList=[[NSMutableArray alloc] init];
                          }else
                          {
                              urlList=[[NSMutableArray alloc] initWithArray:[dict objectForKey:@"imageUrlList"]];
                          }
                          [urlList replaceObjectAtIndex:section withObject:[returnDict objectForKey:@"data"]];
                          [dict setObject:urlList forKey:@"imageUrlList"];
                          [UploadDict setObject:dict forKey:[NSString stringWithFormat:@"%d",row]];
                          
                      }
                      NetError:^(int error) {
                      }
     ];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"访问图片库错误"
                                      message:@""
                                      delegate:nil
                                      cancelButtonTitle:@"OK!"
                                      otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 1:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.videoQuality=UIImagePickerControllerQualityType640x480;
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"摄像头不可用！"
                                      message:@""
                                      delegate:nil
                                      cancelButtonTitle:@"OK!"
                                      otherButtonTitles:nil];
                [alert show];
            }
            
            
        }
            break;
        default:
            break;
    }
    
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
