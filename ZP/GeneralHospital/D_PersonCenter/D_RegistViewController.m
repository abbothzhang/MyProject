//
//  D_RegistViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/3.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_RegistViewController.h"

#import "BDRSACryptor.h"
#import "BDRSACryptorKeyPair.h"
#import "BDError.h"
#import "BDLog.h"
@interface D_RegistViewController ()

@end

@implementation D_RegistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"注册";
        // Custom initialization
    }
    return self;
}

//- (void)generateKeysExample
//{
//    BDError *error = [[BDError alloc] init];
//    BDRSACryptor *RSACryptor = [[BDRSACryptor alloc] init];
//    
//    BDRSACryptorKeyPair *RSAKeyPair = [RSACryptor generateKeyPairWithKeyIdentifier:@"key_pair_tag"
//                                                                             error:error];
//    
//    BDDebugLog(@"Private Key:\n%@\n\nPublic Key:\n%@", RSAKeyPair.privateKey, RSAKeyPair.publicKey);
//    
//    [self encryptionCycleWithRSACryptor:RSACryptor
//                                keyPair:RSAKeyPair
//                                  error:error];
//}


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
    
    BDRSACryptorKeyPair *RSAKeyPair = [[BDRSACryptorKeyPair alloc] initWithPublicKey:publicKey
                                                                          privateKey:privateKey];
    
   return [self encryptionCycleWithRSACryptor:RSACryptor
                                keyPair:RSAKeyPair
                                  error:error
                                encorde:string];
}


- (NSString *)encryptionCycleWithRSACryptor:(BDRSACryptor *)RSACryptor
                                    keyPair:(BDRSACryptorKeyPair *)RSAKeyPair
                                      error:(BDError *)error
                                    encorde:(NSString *)string
{
    NSString *cipherText =
    [RSACryptor encrypt:string
                    key:RSAKeyPair.publicKey
                  error:error];
    
    BDDebugLog(@"Cipher Text:\n%@", cipherText);

    NSString *recoveredText =
    [RSACryptor decrypt:cipherText
                    key:RSAKeyPair.privateKey
                  error:error];
    
    BDDebugLog(@"Recovered Text:\n%@", recoveredText);
    
    return cipherText;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==AreaCode) {
        [self.view endEditing:YES];
    }
    [[textField layer]setBorderWidth:0.5];
    [[textField layer]setBorderColor:[STYLECLOLR CGColor]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[textField layer]setBorderWidth:0.5];
    [[textField layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"注册";
 
    NSMutableDictionary *dictText = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor], UITextAttributeTextColor,
                                     [UIFont systemFontOfSize:20],UITextAttributeFont,
                                     [UIColor colorWithWhite:1.0f alpha:1.0f],UITextAttributeTextShadowColor,
                                     nil] ;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8) {
        [dictText setObject:[NSValue valueWithCGSize:CGSizeMake(0, 0.5)] forKey:UITextAttributeTextShadowOffset];
    }else
    {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(0, 2.0);
        [dictText setObject:shadow forKey:NSShadowAttributeName];
    }
//    [self.navigationController.navigationBar setTitleTextAttributes:dictText];
    
    
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

    ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    ScrollView.contentSize=CGSizeMake(0, 600);
    [self.view addSubview:ScrollView];
    
    
    PhoneNum=[[UXTextField alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 45)];
    PhoneNum.delegate=self;
    PhoneNum.returnKeyType=UIReturnKeyDone;
    PhoneNum.placeholder=@"请输入手机号";
    [ScrollView addSubview:PhoneNum];
    [[PhoneNum layer]setBorderWidth:0.5];
    [[PhoneNum layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    NumCode=[[UXTextField alloc] initWithFrame:CGRectMake(10, 65, SCREEN_WIDTH-20-120, 45)];
    NumCode.delegate=self;
    NumCode.returnKeyType=UIReturnKeyDone;
    NumCode.placeholder=@"请输入验证码";
    [ScrollView addSubview:NumCode];
    [[NumCode layer]setBorderWidth:0.5];
    [[NumCode layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    
    GetCode = [UIButton buttonWithType:UIButtonTypeCustom];
    GetCode.frame = CGRectMake(SCREEN_WIDTH-120, 65, 110, 45);
    [GetCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    [GetCode setTitle:@"发送验证码" forState:UIControlStateHighlighted];
    GetCode.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [GetCode setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                       forState:UIControlStateNormal];
    [GetCode setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                       forState:UIControlStateSelected];
    [GetCode addTarget:self action:@selector(getCodeAct:)
      forControlEvents:UIControlEventTouchUpInside];
    [ScrollView addSubview:GetCode];
    [[GetCode layer] setMasksToBounds:YES];
    [[GetCode layer] setCornerRadius:2];
 
    Password=[[UXTextField alloc] initWithFrame:CGRectMake(10, 120, SCREEN_WIDTH-20, 45)];
    Password.delegate=self;
    Password.secureTextEntry=YES;
    Password.returnKeyType=UIReturnKeyDone;
    Password.placeholder=@"密码";
    [ScrollView addSubview:Password];
    [[Password layer]setBorderWidth:0.5];
    [[Password layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
    RegistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    RegistBtn.frame = CGRectMake(10, 175, SCREEN_WIDTH-20, 45);
    [RegistBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [RegistBtn setTitle:@"立即注册" forState:UIControlStateHighlighted];
    RegistBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [RegistBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                       forState:UIControlStateNormal];
    [RegistBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR]
                       forState:UIControlStateSelected];
    [RegistBtn addTarget:self action:@selector(NextStep)
      forControlEvents:UIControlEventTouchUpInside];
    [ScrollView addSubview:RegistBtn];
    [[RegistBtn layer] setMasksToBounds:YES];
    [[RegistBtn layer] setCornerRadius:2];
    
    //设置本地区号
    
}
 
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        ScrollView.contentOffset=CGPointMake(0, 0);
    }];
    [textField resignFirstResponder];
    return NO;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        ScrollView.contentOffset=CGPointMake(0, textField.frame.origin.y-10);
    }];
    return YES;
}


-(void)NextStep
{
    if ([[PhoneNum.text stringByReplacingOccurrencesOfString:@"" withString:@" "] length]!=11||![PhoneNum.text hasPrefix:@"1"]) {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil)  otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([[Password.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([[NumCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    NSString *cipherText =[self GetKeyEncryption:Password.text];
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/register.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:PhoneNum.text,@"phone",cipherText,@"enpassword",NumCode.text,@"code", nil]
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
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                      NetError:^(int error) {
                      }
     ];


}

-(void)getCodeAct:(UIButton *)sender{
    if ([[PhoneNum.text stringByReplacingOccurrencesOfString:@"" withString:@" "] length]!=11||![PhoneNum.text hasPrefix:@"1"]) {

        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil)  otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *cipherText =[self GetKeyEncryption:PhoneNum.text];
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/common/send_code.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:cipherText,@"enphone", nil]
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
                          __block int timeout=30; //倒计时时间
                          dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                          dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                          dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                          dispatch_source_set_event_handler(_timer, ^{
                              if(timeout<=0){ //倒计时结束，关闭
                                  dispatch_source_cancel(_timer);
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      //设置界面的按钮显示 根据自己需求设置
                                      [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                                      sender.userInteractionEnabled = YES;
                                  });
                              }else{
                                  //            int minutes = timeout / 60;
                                  int seconds = timeout % 60;
                                  NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      //设置界面的按钮显示 根据自己需求设置
                                      NSLog(@"____%@",strTime);
                                      [sender setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                                      sender.userInteractionEnabled = NO;
                                      
                                  });
                                  timeout--;
                                  
                              }
                          });
                          dispatch_resume(_timer);
                          
                      }
                      NetError:^(int error) {
                      }
     ];

    
  
    
}



-(void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
