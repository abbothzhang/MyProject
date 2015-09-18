//
//  D_SignInViewController.m
//  zhipin
//
//  Created by kjx on 15/3/15.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "D_SignInViewController.h"

@interface D_SignInViewController ()

@end

@implementation D_SignInViewController
@synthesize ShopId;
-(void)SureAct
{
    /*
     入参：
     
     参数名称	数据类型	是否必须	说明
     data	string	是	json字符串参数
     data详情：
     
     参数名称	数据类型	是否必须	说明
     shopId	long	是	店铺ID
     content	string	是	留言内容
     imageList	array	否	图片URL字符串数组
     */
    
    if ([TextView.text length]<1) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"温馨提示"
                              message:@"亲，签到不能为空哦！"
                              delegate:nil
                              cancelButtonTitle:@"确认"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%@",ShopId] forKey:@"shopId"];
    [dict setObject:TextView.text forKey:@"content"];
    if ([ListArray count]>0) {
     [dict setObject:ListArray forKey:@"imageList"];
    }
    
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/sign/submit.jhtml"]];
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
                          
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle:@"提示"
                                                message:@"签到成功！"
                                                delegate:self
                                                cancelButtonTitle:@"确认"
                                                otherButtonTitles:nil];
                          [alert show];
                      }
                      NetError:^(int error) {
                      }
     ];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"签到";
    ListArray=[[NSMutableArray alloc] init];
    ImageArray=[[NSMutableArray alloc] init];
    
    UIButton *SureBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [SureBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [SureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SureBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [SureBtn addTarget:self action:@selector(SureAct) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:SureBtn]];
    
    TextView=[[UITextView alloc] initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, 150)];
    TextView.backgroundColor=[UIColor whiteColor];
    TextView.font=[UIFont systemFontOfSize:13];
    TextView.delegate=self;
    TextView.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:TextView];
    [[TextView layer] setMasksToBounds:YES];
    [[TextView layer] setCornerRadius:2];
    [[TextView layer] setBorderWidth:1];
    [[TextView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    
    ImageView=[[UIView alloc] initWithFrame:CGRectMake(0, 165, SCREEN_WIDTH, 70)];
    ImageView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:ImageView];
    

    [self drawView];
}

-(void)drawView
{
    for (UIView *view in ImageView.subviews) {
        [view removeFromSuperview];
    }

    ImageView.frame=CGRectMake(0, 165, SCREEN_WIDTH,(([ImageArray count]+1)/5+(([ImageArray count]+1)%5>0?1:0))*62+6);
 
    for ( int i=0; i<[ImageArray count]; i++) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(8+62*(i%5),6+(i/5)*62,56, 56);
        [addBtn.titleLabel setFont:[UIFont fontWithName:@"zhipin1" size:25]];
        [addBtn setImage:[ImageArray objectAtIndex:i] forState:UIControlStateNormal];
        [addBtn setImage:[ImageArray objectAtIndex:i] forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(addAct:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.backgroundColor=UIColorFromRGB(0xf4f4f4);
        [ImageView addSubview:addBtn];
        [[addBtn layer] setMasksToBounds:YES];
        [[addBtn layer] setCornerRadius:2];

    }
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake([ImageArray count]%5*62+8,([ImageArray count]/5)*62+6,56, 56);
    [addBtn.titleLabel setFont:[UIFont fontWithName:@"zhipin1" size:25]];
    [addBtn setTitle:@"\uf05d" forState:UIControlStateNormal];
    [addBtn setTitle:@"\uf05d" forState:UIControlStateHighlighted];
    [addBtn setTitleColor:UIColorFromRGB(0xc9c9c9) forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0xc9c9c9) forState:UIControlStateSelected];
    [addBtn addTarget:self action:@selector(addAct:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor=UIColorFromRGB(0xf4f4f4);
    [ImageView addSubview:addBtn];
    [[addBtn layer] setMasksToBounds:YES];
    [[addBtn layer] setCornerRadius:2];
    [[addBtn layer] setBorderWidth:1];
    [[addBtn layer] setBorderColor:[UIColorFromRGB(0x999999) CGColor]];
}

-(void)addAct:(UIButton *)sender
{
    if ([ImageArray count]>8) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"温馨提示"
                              message:@"亲，最多只能添加9张图片！"
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择照片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"图片",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
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
                         
                          [ImageArray addObject:image];
                          [ListArray addObject:[returnDict objectForKey:@"data"]];
                          [self drawView];
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
