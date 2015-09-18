//
//  D_ManageInfoViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14/12/23.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_ManageInfoViewController.h"

@interface D_ManageInfoViewController ()

@end

@implementation D_ManageInfoViewController
@synthesize Index;
@synthesize TitleString;
-(void)manWomenAct
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if (Index==6) {
        TextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 200)]; //初始化大小并自动释放
        TextView.delegate=self;
        TextView.returnKeyType=UIReturnKeyGo;
        TextView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
        TextView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
        TextView.text=TitleString;
        TextView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        [self.view addSubview:TextView];
        [[TextView layer] setMasksToBounds:YES];
        [[TextView layer] setCornerRadius:2];
        [[TextView layer] setBorderWidth:0.5];
        [[TextView layer] setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    }else
    {
        TextField = [[UXTextField alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 45)]; //初始化大小并自动释放
        TextField.textColor = [UIColor blackColor];//设置textview里面的字体颜色
        TextField.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
        TextField.text=TitleString;
        TextField.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        [self.view addSubview:TextField];
        [[TextField layer] setMasksToBounds:YES];
        [[TextField layer] setCornerRadius:2];
        [[TextField layer] setBorderWidth:0.5];
        [[TextField layer] setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    }

    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, Index==6?270:70, SCREEN_WIDTH-20, 45);
    [sureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认修改" forState:UIControlStateHighlighted];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xf39900)] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:UIColorFromRGB(0xf39900)] forState:UIControlStateSelected];
    [sureBtn addTarget:self action:@selector(sureAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
 
}

-(void)setNameInfo:(SNameInfo)nameInfo
{
    NameInfo=nameInfo;
}

-(void)setSignatureInfo:(SignatureInfo)signInfo
{
    SignInfo=signInfo;
}

-(void)sureAct
{
 
    switch (Index) {
        case 1:
        {
            if ([[TextField.text stringByReplacingOccurrencesOfString:@"" withString:@" "] length]==0) {
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称不能为空！" delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/modify_userinfo.jhtml"]];
            [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:TextField.text,@"nickName", nil]
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
                                  if(NameInfo){
                                      NameInfo(TextField.text);
                                  }
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
            break;
        case 6:
        {
            if ([[TextView.text stringByReplacingOccurrencesOfString:@"" withString:@" "] length]==0) {
                
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"个性签名不能为空！" delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/modify_userinfo.jhtml"]];
            [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:TextView.text,@"description", nil]
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
                                  if (SignInfo) {
                                     SignInfo(TextView.text);
                                  }
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
