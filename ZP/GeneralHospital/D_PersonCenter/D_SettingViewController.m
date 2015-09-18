//
//  D_SettingViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/2/2.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "D_SettingViewController.h"
#import "D_PrivacyStatementViewController.h"
#import "D_LoginViewController.h"
#import "AESCrypt.h"
#import "GlobalHead.h"
@interface D_SettingViewController ()

@end

@implementation D_SettingViewController

-(void)downAct
{
    
}
-(void)upAct
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/common/version/check.jhtml?id=1&version_num=%@",app_build]]];
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
                          if ([ReturnDict objectForKey:@"message"]!=nil ) {
                              UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[ReturnDict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                              [AlertView show];
                          }
                          if ([[ReturnDict objectForKey:@"edition"] length] != 0){
                              if ([[ReturnDict objectForKey:@"is_update"] integerValue] == 1) {
                                  //强制升级
                                  UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本:%@",[ReturnDict objectForKey:@"edition"]] message:[ReturnDict objectForKey:@"content"] delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"退出软件",nil];
                                  AlertView.tag = 11;
                                  AlertView.accessibilityLabel=[ReturnDict objectForKey:@"link"];
                                  [AlertView show];
                                  
                              }else if([[ReturnDict objectForKey:@"is_update"] integerValue] == 0 && [ReturnDict objectForKey:@"is_update"] != nil) {
                                  //建议升级
                                  UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本:%@",[ReturnDict objectForKey:@"edition"]] message:[ReturnDict objectForKey:@"content"] delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"以后再说",nil];
                                  AlertView.tag = 22;
                                  AlertView.accessibilityLabel=[ReturnDict objectForKey:@"link"];
                                  [AlertView show];
                                  
                              }
                          }
                          
                      }
                      NetError:^(int error) {
                          
                      }
     ];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 11) {
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.accessibilityLabel]];
            exit(0);
        }else{
            exit(0);
        }
        //跳到网址更新
        
    }else if(alertView.tag == 22){
        if (buttonIndex == 0) {
            //跳到网址更新
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.accessibilityLabel]];
        }else{
            //不强退
        }
    }
}
-(void)midAct
{
    D_PrivacyStatementViewController *D_PrivacyStatement=[[D_PrivacyStatementViewController alloc] init];
    D_PrivacyStatement.Url=@"http://app.zipn.cn/privacy_state.html";
    D_PrivacyStatement.title=@"隐私声明";
    [self.navigationController pushViewController:D_PrivacyStatement animated:YES];
}


-(void)aboutAct
{
    [self.navigationController pushViewController:[NSClassFromString(@"D_AboutUsViewController") new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    
    UIView *upView=[[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 88)];
    upView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:upView];
    
    UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=UIColorFromRGB(0xeeeeee);
    [upView addSubview:lineView];
    
//    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    upBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
//    [upBtn addTarget:self action:@selector(upAct) forControlEvents:UIControlEventTouchUpInside];
//    [upView addSubview:upBtn];
//    
//    UILabel* upLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 44)];
//    upLabel.text=@"检查更新";
//    upLabel.textColor=UIColorFromRGB(0x000000);
//    upLabel.backgroundColor=[UIColor clearColor];
//    upLabel.font=[UIFont systemFontOfSize:18];
//    upLabel.textAlignment=NSTextAlignmentLeft;
//    [upBtn addSubview:upLabel];
//    
//    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 0,200, 44)];
//    arrowLabel.text=@"\ue629";
//    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:18]];
//    arrowLabel.textColor=UIColorFromRGB(0x666666);
//    arrowLabel.backgroundColor=[UIColor clearColor];
//    arrowLabel.textAlignment=NSTextAlignmentRight;
//    [upBtn addSubview:arrowLabel];
    
    UIButton *midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    midBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [midBtn addTarget:self action:@selector(midAct) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:midBtn];
    
    UILabel* midLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 44)];
    midLabel.text=@"隐私声明";
    midLabel.textColor=UIColorFromRGB(0x000000);
    midLabel.backgroundColor=[UIColor clearColor];
    midLabel.font=[UIFont systemFontOfSize:18];
    midLabel.textAlignment=NSTextAlignmentLeft;
    [midBtn addSubview:midLabel];
    
    UILabel* arrowLabel1=[[UILabel alloc] initWithFrame:CGRectMake(100, 0,200, 44)];
    arrowLabel1.text=@"\ue629";
    [arrowLabel1 setFont:[UIFont fontWithName:@"icomoon" size:18]];
    arrowLabel1.textColor=UIColorFromRGB(0x666666);
    arrowLabel1.backgroundColor=[UIColor clearColor];
    arrowLabel1.textAlignment=NSTextAlignmentRight;
    [midBtn addSubview:arrowLabel1];
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(0, 44, SCREEN_WIDTH, 44);
    [downBtn addTarget:self action:@selector(downAct) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:downBtn];
    
//    UILabel* downLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 44)];
//    downLabel.text=@"意见反馈";
//    downLabel.textColor=UIColorFromRGB(0x000000);
//    downLabel.backgroundColor=[UIColor clearColor];
//    downLabel.font=[UIFont systemFontOfSize:18];
//    downLabel.textAlignment=NSTextAlignmentLeft;
//    [downBtn addSubview:downLabel];
//    
//    UILabel* arrowLabel2=[[UILabel alloc] initWithFrame:CGRectMake(100, 0,200, 44)];
//    arrowLabel2.text=@"\ue629";
//    [arrowLabel2 setFont:[UIFont fontWithName:@"icomoon" size:18]];
//    arrowLabel2.textColor=UIColorFromRGB(0x666666);
//    arrowLabel2.backgroundColor=[UIColor clearColor];
//    arrowLabel2.textAlignment=NSTextAlignmentRight;
//    [downBtn addSubview:arrowLabel2];
    
    UIImageView *lineView1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 44, SCREEN_WIDTH-20, 1)];
    lineView1.backgroundColor=UIColorFromRGB(0xeeeeee);
    [upView addSubview:lineView1];
    
    UIImageView *lineView2=[[UIImageView alloc] initWithFrame:CGRectMake(10, 88, SCREEN_WIDTH-20, 1)];
    lineView2.backgroundColor=UIColorFromRGB(0xeeeeee);
    [upView addSubview:lineView2];
    
//    UIImageView *lineView3=[[UIImageView alloc] initWithFrame:CGRectMake(0, 131, SCREEN_WIDTH, 1)];
//    lineView3.backgroundColor=UIColorFromRGB(0xeeeeee);
//    [upView addSubview:lineView3];
    
    UIView *downView=[[UIView alloc] initWithFrame:CGRectMake(0, 44+15, SCREEN_WIDTH, 44)];
    downView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:downView];
    [[downView layer]setBorderWidth:1];
    [[downView layer]setBorderColor:[UIColorFromRGB(0xeeeeee) CGColor]];
    
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [aboutBtn addTarget:self action:@selector(aboutAct) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:aboutBtn];
    
    UILabel* aboutLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,300, 44)];
    aboutLabel.text=@"关于至品";
    aboutLabel.textColor=UIColorFromRGB(0x000000);
    aboutLabel.backgroundColor=[UIColor clearColor];
    aboutLabel.font=[UIFont systemFontOfSize:18];
    aboutLabel.textAlignment=NSTextAlignmentLeft;
    [aboutBtn addSubview:aboutLabel];
    
    UILabel* arrowAboutLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 0,200, 44)];
    arrowAboutLabel.text=@"\ue629";
    [arrowAboutLabel setFont:[UIFont fontWithName:@"icomoon" size:18]];
    arrowAboutLabel.textColor=UIColorFromRGB(0x666666);
    arrowAboutLabel.backgroundColor=[UIColor clearColor];
    arrowAboutLabel.textAlignment=NSTextAlignmentRight;
    [aboutBtn addSubview:arrowAboutLabel];
 

    
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(10, 240, SCREEN_WIDTH-20, 45);
    [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOut setTitle:@"退出登录" forState:UIControlStateHighlighted];
    loginOut.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [loginOut setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateNormal];
    [loginOut setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
    [loginOut addTarget:self action:@selector(loginOutAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOut];
    
    
    // Do any additional setup after loading the view.
}

-(void)loginOutAct
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/logout.jhtml"]];
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
                          [G_UseDict removeAllObjects];
                          [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[AESCrypt encrypt:@"user_model" password:@"zhipin123"]];
                          [G_PersonDetail removeAllObjects];
                          
                          D_LoginViewController *D_LoginView=[[D_LoginViewController alloc] init];
                          [D_LoginView setLoginBlock:^{
                              [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                          }];
                          [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:D_LoginView] animated:YES completion:nil];
                      }
                      NetError:^(int error) {
                      }
     ];
 

}

//http://app.zipn.cn/app/setting/declare.jhtml
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
