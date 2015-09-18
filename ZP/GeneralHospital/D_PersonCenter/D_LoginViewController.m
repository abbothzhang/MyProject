//
//  D_LoginViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/3.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_LoginViewController.h"
#import "AESCrypt.h"
#pragma mark - Utilities
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "BDRSACryptor.h"
#import "BDRSACryptorKeyPair.h"
#import "BDError.h"
#import "BDLog.h"
#import "GlobalHead.h"
#import "RSAESCryptor.h"
@interface D_LoginViewController ()

@end

@implementation D_LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"登录";
        // Custom initialization
    }
    return self;
}

-(void)setLoginBlock:(LoginBlock)loginBlock
{
    LoginB=loginBlock;
}

- (void)generateKeysExample
{
    BDError *error = [[BDError alloc] init];
    BDRSACryptor *RSACryptor = [[BDRSACryptor alloc] init];
    
    BDRSACryptorKeyPair *RSAKeyPair = [RSACryptor generateKeyPairWithKeyIdentifier:@"key_pair_tag"
                                   error:error];
    
    BDDebugLog(@"Private Key:\n%@\n\nPublic Key:\n%@", RSAKeyPair.privateKey, RSAKeyPair.publicKey);
//    
//    [self encryptionCycleWithRSACryptor:RSACryptor
//                                keyPair:RSAKeyPair
//                                  error:error];
}

- (NSString *)GetKeyEncryption:(NSString *)string
{
    BDError *error = [[BDError alloc] init];
    BDRSACryptor *RSACryptor = [[BDRSACryptor alloc] init];
    
    NSString *privateKey=@"-----BEGIN RSA PRIVATE KEY-----\
    MIICXgIBAAKBgQC9fSJ1l962Qdq7rMqCx2Wr7CxMe2H07nOogxt379kyAUZeESWu\
    dbSIXnMQU22nRJGHwitkETPeTkpswY1jGk9TBECbBmyzTJRbKSq08rDEI3yxXd6R\
    qtniK47I24y80Gnx8ptYUeAdypNdcLJ/vKTCLQnoA07TfMeZl7XqnAaJ9QIDAQAB\
    AoGBAJU5ZZjL2AUaCYLAyd6B3wysehplFDiKTKUJUul6Bka+AEd2I4GnilvWXbEe\
    sn0Gn8EU5YzxizJn326UYp8ICizN85EI/jiKDk+gyt6BttDgX3Xf3v0nu15JmjTS\
    D5Fo0m6hphuLEq7/fNDetQ1UgBeKi8jo6aLu9ySn1WTRTwWhAkEA+MbXeZSaVptz\
    xW/B83h9c56/Pscg6FlQ9WsS0w0+7/FKluvAkQU2we5NwK6zJzRC38rlBMHconkN\
    cU3pkUHtbQJBAML9mwhZ9l388Wng4NRyUnx/ZgT6FL1mioKq7vhFdc9FKjACAVmL\
    E/FCKI4pd3MLHu/mGmXiJ/r6qu2WTdyk4akCQQCufkoE7UaUGNVLVugjbhAQWPir\
    f+CFGKDAgyng/xl2EzjOQu3+yjluLUg8Lk1a4j1F23pnq9Kl42KaZpu9VxDBAkEA\
    occTp5wsQdKo4TWIk/q94Tk6BYsPRg0bgkobtrS6h9tUozwmroorY5GGYFybFEH3\
    ywZYhItcrGjpA/Iea6AI8QJAbNRVCO2ImdT/fngoFKK40PLZSooFu0njRYcNUWGr\
    7GkUxeS7gC3GNYWcZG+f8zbXaXsjyD0pSNeaHFDRmJCcTA==\
    -----END RSA PRIVATE KEY-----";
    
    NSString *publicKey=@"-----BEGIN PUBLIC KEY-----\
    MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9fSJ1l962Qdq7rMqCx2Wr7CxM\
    e2H07nOogxt379kyAUZeESWudbSIXnMQU22nRJGHwitkETPeTkpswY1jGk9TBECb\
    BmyzTJRbKSq08rDEI3yxXd6RqtniK47I24y80Gnx8ptYUeAdypNdcLJ/vKTCLQno\
    A07TfMeZl7XqnAaJ9QIDAQAB\
    -----END PUBLIC KEY-----";
    
    privateKey = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rsa_private_key" ofType:@"txt"]
                                                         encoding:NSUTF8StringEncoding
                                                           error:nil];
    
    publicKey = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rsa_public_key" ofType:@"txt"]
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
    
    BDRSACryptorKeyPair *RSAKeyPair = [[BDRSACryptorKeyPair alloc] initWithPublicKey:publicKey
                                                                          privateKey:privateKey];
    
    return [self encryptionCycleWithRSACryptor:RSACryptor
                                       keyPair:RSAKeyPair
                                    encryption:string
                                         error:error];
}

- (NSString *)encryptionCycleWithRSACryptor:(BDRSACryptor *)RSACryptor
                                    keyPair:(BDRSACryptorKeyPair *)RSAKeyPair
                                 encryption:(NSString *)string
                                      error:(BDError *)error
{
    NSString *cipherText =
    [RSACryptor encrypt:string
                    key:RSAKeyPair.publicKey
                  error:error];
    NSLog(@"\n%@\n", cipherText);
    
    //BDDebugLog(@"Cipher Text:\n%@", cipherText);

    
    NSString *recoveredText =
    [RSACryptor decrypt:cipherText
                    key:RSAKeyPair.privateKey
                  error:error];
    NSLog(@"\n%@\n", recoveredText);
    
    //BDDebugLog(@"Recovered Text:\n%@", recoveredText);
    return cipherText;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    //修改导航字体格式
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObject:STYLECLOLR forKey:NSForegroundColorAttributeName]];
    
    self.navigationController.navigationBarHidden=NO;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/common/version/check.jhtml?id=1&version_num=%@",app_build]]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessUnType
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict) {
                          
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

 
//    
//    NSMutableDictionary *dictText = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                     [UIColor whiteColor], UITextAttributeTextColor,
//                                     [UIFont systemFontOfSize:20],UITextAttributeFont,
//                                     [UIColor colorWithWhite:1.0f alpha:1.0f],c,
//                                     nil] ;
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8) {
//        [dictText setObject:[NSValue valueWithCGSize:CGSizeMake(0, 0.5)] forKey:UITextAttributeTextShadowOffset];
//    }else
//    {
//        NSShadow *shadow = [[NSShadow alloc] init];
//        shadow.shadowOffset = CGSizeMake(0, 2.0);
//        [dictText setObject:shadow forKey:NSShadowAttributeName];
//    }
//    [self.navigationController.navigationBar setTitleTextAttributes:dictText];
//    
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(0, 0, 25, 25)];
//    [btn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
//    [btn setTitle:@"\ue626" forState:UIControlStateNormal];
//    [btn setTitle:@"\ue626" forState:UIControlStateHighlighted];
//    [btn setTitleColor:STYLECLOLR forState:UIControlStateNormal];
//    [btn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    UIImage *image = [UIImage imageNamed:@"back"];
    [btn setImage:image  forState:UIControlStateNormal];
    //[_backButton setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10, 0)];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
//    [self.navigationController.navigationBar setTitleTextAttributes:dictText];
    
    if (_isBack) {
        [btn setHidden:YES];
    }
    
    UserName=[[UXTextField alloc] initWithFrame:CGRectMake(10, 16, SCREEN_WIDTH-20, 45)];
    UserName.delegate=self;
    UserName.text=[[NSUserDefaults  standardUserDefaults] objectForKey:@"----swkt----"];
    UserName.returnKeyType=UIReturnKeyDone;
    UserName.placeholder=@"请输入手机号";
    [self.view addSubview:UserName];
    [[UserName layer]setBorderWidth:0.5];
    [[UserName layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];

    Password=[[UXTextField alloc] initWithFrame:CGRectMake(10, 71, SCREEN_WIDTH-20, 45)];
    Password.delegate=self;
    Password.text=[[NSUserDefaults  standardUserDefaults] objectForKey:@"----pqsw----"];
    Password.secureTextEntry=YES;
    Password.returnKeyType=UIReturnKeyDone;
    Password.placeholder=@"密码";
    [self.view addSubview:Password];
    [[Password layer]setBorderWidth:0.5];
    [[Password layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    UserName.text=@"";
    Password.text=@"";
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, 130, SCREEN_WIDTH-20, 45);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [loginBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
    [loginBtn addTarget:self action:@selector(loginAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(10, 190, 100, 30);
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registBtn setTitle:@"立即注册" forState:UIControlStateHighlighted];
    [registBtn setTitleColor:STYLECLOLR forState:UIControlStateNormal];
    [registBtn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
    registBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [registBtn addTarget:self action:@selector(registAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(210, 190, 100, 30);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateHighlighted];
    [forgetBtn setTitleColor:STYLECLOLR forState:UIControlStateNormal];
    [forgetBtn setTitleColor:STYLECLOLR forState:UIControlStateHighlighted];
    forgetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [forgetBtn addTarget:self action:@selector(forgetAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    // Do any additional setup after loading the view.
}

-(void)registAct
{
    [self.navigationController pushViewController:[NSClassFromString(@"D_RegistViewController") new] animated:YES];
}

-(void)forgetAct
{
    [self.navigationController pushViewController:[NSClassFromString(@"D_ForgetViewController") new] animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[textField layer]setBorderWidth:0.5];
    [[textField layer]setBorderColor:[STYLECLOLR CGColor]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[textField layer]setBorderWidth:0.5];
    [[textField layer]setBorderColor:[UIColorFromRGB(0xccccccc) CGColor]];
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
-(void)loginAct
{
    NSLog(@"----%@",Password.text);
    NSString *passW=[self GetKeyEncryption:Password.text];
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/login.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:UserName.text,@"phone",passW,@"enpassword", nil]
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
                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                          [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];

                          [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"time"];
                          
                          [[NSUserDefaults standardUserDefaults] setObject:[AESCrypt encrypt:[NSString stringWithFormat:@"%@",ReturnDict] password:@"zhipin123"] forKey:[AESCrypt encrypt:@"user_model" password:@"zhipin123"]];
                          [G_UseDict setDictionary:ReturnDict];
                          LoginB();
                      }
                      NetError:^(int error) {
                      }
     ];
}

-(void)backAction:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    if (_isBack) {
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
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
