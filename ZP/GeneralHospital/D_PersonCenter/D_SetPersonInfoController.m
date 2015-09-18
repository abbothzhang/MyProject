//
//  D_SetPersonInfoController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14/12/21.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_SetPersonInfoController.h"
#import "D_ManageInfoViewController.h"
#import "D_AddressListViewController.h"
#import "D_PasswordViewController.h"
@interface D_SetPersonInfoController ()

@end

@implementation D_SetPersonInfoController
@synthesize ReturnDict;
@synthesize UseImage;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    LabelArray=[[NSMutableArray alloc] init];
    self.view.backgroundColor=UIColorFromRGB(0xeeeeee);
    NSString *string=([ReturnDict objectForKey:@"description"]==nil||[[ReturnDict objectForKey:@"description"] length]==0)?@"未设置":@"重新设置";
    NSString *sex=[ReturnDict objectForKey:@"sex"]==nil||[[ReturnDict objectForKey:@"sex"] isEqualToString:@"男"]?@"\ue602  男":@"\ue603   女";
    
    LineArray=[[NSArray alloc] initWithObjects:
                                              @[@"头像",@100,[ReturnDict objectForKey:@"headImage"]],
                                              @[@"昵称",@44,[ReturnDict objectForKey:@"nickName"]],
                                              @[@"手机号",@44,[ReturnDict objectForKey:@"phone"]],
                                              @[@"登录密码",@44,@"修改"],
                                              @[@"收货地址",@44,@"管理"],
                                              @[@"性别",@44,sex],
                                              @[@"个性签名",@44,string], nil];
    int height=15;

    for(int i=0;i<[LineArray count];i++)
    {
        int hei=[[[LineArray objectAtIndex:i] objectAtIndex:1] integerValue];
        if (i==4) {
            UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 0.5)];
            lineImage.backgroundColor=UIColorFromRGB(0xdddddd);
            [self.view addSubview:lineImage];
            height=height+15;
        }
        UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBtn.tag=i;
        changeBtn.frame = CGRectMake(0, height, SCREEN_WIDTH, hei);
        changeBtn.backgroundColor=[UIColor whiteColor];
        [changeBtn addTarget:self action:@selector(changeAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:changeBtn];
        if (i==4) {
            UIImageView *lineImage1=[[UIImageView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 0.5)];
            lineImage1.backgroundColor=UIColorFromRGB(0xdddddd);
            [self.view addSubview:lineImage1];
        }
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 0,SCREEN_WIDTH-20, hei)];
        titleLabel.text=[[LineArray objectAtIndex:i] objectAtIndex:0];
        titleLabel.textColor=UIColorFromRGB(0x000000);
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:15];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [changeBtn addSubview:titleLabel];
        
        UILabel* scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 2,140, hei-4)];
        if(i!=2){
            scoreLabel.text=[NSString stringWithFormat:@"%@  \ue629",i==0?@"":[[LineArray objectAtIndex:i] objectAtIndex:2]];
        }else{
            scoreLabel.text=[NSString stringWithFormat:@"%@",i==0?@"":[[LineArray objectAtIndex:i] objectAtIndex:2]];
        }
        [scoreLabel setFont:[UIFont fontWithName:@"icomoon" size:15]];
        scoreLabel.textColor=UIColorFromRGB(0xcccccc);
        scoreLabel.backgroundColor=[UIColor clearColor];
        scoreLabel.textAlignment=NSTextAlignmentRight;
        [changeBtn addSubview:scoreLabel];
        
        [LabelArray addObject:scoreLabel];
        
        if (i==0) {
            HeadImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 18, 64, 64)];
            if (UseImage==nil) {
                [HeadImage sd_setImageWithURL:[NSURL URLWithString:[ReturnDict ObjectForKey:@"headImage"]] placeholderImage:[UIImage imageNamed:@"d_head_image.png"]];
            }else{
                HeadImage.image=UseImage;
            }
            [changeBtn addSubview:HeadImage];
            [[HeadImage layer] setMasksToBounds:YES];
            [[HeadImage layer] setCornerRadius:32];
            
            UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 0.5)];
            lineImage.backgroundColor=UIColorFromRGB(0xdddddd);
            [self.view addSubview:lineImage];
        }else if(i!=4){
            UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, height, SCREEN_WIDTH-20, 0.5)];
            lineImage.backgroundColor=UIColorFromRGB(0xdddddd);
            [self.view addSubview:lineImage];
        }
        height=height+hei;
    }
    UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 1)];
    lineImage.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.view addSubview:lineImage];
    
    // Do any additional setup after loading the view.
}


-(void)changeAct:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"选择照片"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"图片",@"拍照",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
        }
            break;
        case 1:
        {
            D_ManageInfoViewController *D_ManageInfoView=[[D_ManageInfoViewController alloc] init];
            D_ManageInfoView.Index=sender.tag;
            D_ManageInfoView.TitleString=[[LineArray objectAtIndex:sender.tag] objectAtIndex:2];
            D_ManageInfoView.title=[NSString stringWithFormat:@"修改%@",[[LineArray objectAtIndex:sender.tag] objectAtIndex:0]];
            [D_ManageInfoView setNameInfo:^(NSString *title) {
                if (PersonString) {
                    PersonString(title);
                }
                ((UILabel *)[LabelArray objectAtIndex:sender.tag]).text=title;
            }];
            [self.navigationController pushViewController:D_ManageInfoView animated:YES];
        }
            break;
        case 2:
        {
            break;
        }
        case 3:
        {
            D_PasswordViewController *D_Password=[[D_PasswordViewController alloc] init];
            [self.navigationController pushViewController:D_Password animated:YES];
        }
            break;
        case 4:
        {
            D_AddressListViewController *D_AddressList=[[D_AddressListViewController alloc] init];
            [self.navigationController pushViewController:D_AddressList animated:YES];
        }
            break;
        case 5:
        {
            //1：男性，0：女性
            NSLog(@"%@",ReturnDict);
            int  sex=([[ReturnDict objectForKey:@"sex"] isEqualToString:@"男"])?1:0;
            ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/modify_userinfo.jhtml"]];
            [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:sex==1?@"0":@"1",@"sex", nil]
                               ApiName:@""
                             CanCancel:YES
                           SetHttpType:HttpPost
                             SetNotice:NoticeType1
                            SetNetWork:NetWorkTypeAS
                            SetProcess:ProcessType1
                            SetEncrypt:Encryption
                              SetCache:Cache
                              NetBlock:^(NSDictionary *returnDict){
                                  NSLog(@"%@",returnDict);
                                  if(sex==1)
                                  {
                                    ((UILabel *)[LabelArray objectAtIndex:sender.tag]).text=@"\ue603   女  \ue629";
                                    [ReturnDict setObject:@"女" forKey:@"sex"];
                                      if (PersonSex) {
                                          PersonSex(@"女");
                                      }
                                  }else
                                  {
                                    ((UILabel *)[LabelArray objectAtIndex:sender.tag]).text=@"\ue602  男  \ue629";
                                    [ReturnDict setObject:@"男" forKey:@"sex"];
                                    if (PersonSex) {
                                          PersonSex(@"男");
                                    }
                                  }

                                  
                                  
                              }
                              NetError:^(int error) {
                              }
             ];
        }
            break;
        case 6:
        {
            D_ManageInfoViewController *D_ManageInfoView=[[D_ManageInfoViewController alloc] init];
            D_ManageInfoView.Index=sender.tag;
            D_ManageInfoView.TitleString=[ReturnDict objectForKey:@"description"];
            D_ManageInfoView.title=[NSString stringWithFormat:@"修改%@",[[LineArray objectAtIndex:sender.tag] objectAtIndex:0]];
            [D_ManageInfoView setNameInfo:^(NSString *title) {
                if (PersonDes) {
                    PersonDes(title);
                }
            }];
            [D_ManageInfoView setSignatureInfo:^(NSString *signature) {
                if (PersonDes) {
                    PersonDes(signature);
                }
            }];
            [self.navigationController pushViewController:D_ManageInfoView animated:YES];
        }
            break;
        default:
        {
            D_ManageInfoViewController *D_ManageInfoView=[[D_ManageInfoViewController alloc] init];
            D_ManageInfoView.Index=sender.tag;
            D_ManageInfoView.TitleString=[[LineArray objectAtIndex:sender.tag] objectAtIndex:2];
            D_ManageInfoView.title=[NSString stringWithFormat:@"修改%@",[[LineArray objectAtIndex:sender.tag] objectAtIndex:0]];
            [D_ManageInfoView setNameInfo:^(NSString *info) {
                if (PersonDes) {
                    PersonDes(info);
                }
            }];
            [self.navigationController pushViewController:D_ManageInfoView animated:YES];
        }
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/modify_userinfo.jhtml"]];
        [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"nickName", nil]
                           ApiName:@""
                         CanCancel:YES
                       SetHttpType:HttpPost
                         SetNotice:NoticeType1
                        SetNetWork:NetWorkTypeAS
                        SetProcess:ProcessType1
                        SetEncrypt:Encryption
                          SetCache:Cache
                          NetBlock:^(NSDictionary *returnDict){
                              NSLog(@"%@",returnDict);
                              NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                                                title:@"提示"
                                                                              message:@"修改成功"
                                                                             delegate:self];
                              [alert showWithCompletion:^{
                                  [self.navigationController popViewControllerAnimated:YES];
                              }];
                          }
                          NetError:^(int error) {
                          }
         ];
    }
}

-(void)setPersonInfo:(SPersonInfo)personInfo
{
    PersonInfo=personInfo;
}

-(void)setPersonString:(SPersonString)personString
{
    PersonString=personString;
}

-(void)setPersonDes:(SPersonDes)personDes
{
    PersonDes=personDes;
}

-(void)setPersonSex:(SPersonDes)personSex
{
    PersonSex=personSex;
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
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/change_headimage.jhtml"]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                       KeyName:@"file"
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
                         
                          if(PersonInfo)
                          PersonInfo(image);
                          HeadImage.image=image;
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
