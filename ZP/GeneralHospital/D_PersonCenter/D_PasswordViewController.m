//
//  D_PasswordViewController.m
//  zhipin
//
//  Created by 夏科杰 on 15/2/17.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "D_PasswordViewController.h"
#import "BDRSACryptor.h"
#import "BDRSACryptorKeyPair.h"
#import "BDError.h"
#import "BDLog.h"
#import "GlobalHead.h"
#import "RSAESCryptor.h"
@interface D_PasswordViewController ()

@end

@implementation D_PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改密码";
    OldPassword=[[UXTextField alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 45)];
    OldPassword.delegate=self;
    OldPassword.secureTextEntry=YES;
    OldPassword.clearButtonMode=UITextFieldViewModeWhileEditing;
    OldPassword.returnKeyType=UIReturnKeyDone;
    OldPassword.placeholder=@"原密码";
    [self.view addSubview:OldPassword];
    [[OldPassword layer]setBorderWidth:0.5];
    [[OldPassword layer]setBorderColor:[STYLECLOLR CGColor]];
    
    NewPassword=[[UXTextField alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH-20, 45)];
    NewPassword.delegate=self;
    NewPassword.clearButtonMode=UITextFieldViewModeWhileEditing;
    NewPassword.secureTextEntry=YES;
    NewPassword.returnKeyType=UIReturnKeyDone;
    NewPassword.placeholder=@"新密码";
    [self.view addSubview:NewPassword];
    [[NewPassword layer]setBorderWidth:0.5];
    [[NewPassword layer]setBorderColor:[STYLECLOLR CGColor]];
    
    
    AgainPassword=[[UXTextField alloc] initWithFrame:CGRectMake(10, 110, SCREEN_WIDTH-20, 45)];
    AgainPassword.delegate=self;
    AgainPassword.clearButtonMode=UITextFieldViewModeWhileEditing;
    AgainPassword.secureTextEntry=YES;
    AgainPassword.returnKeyType=UIReturnKeyDone;
    AgainPassword.placeholder=@"确认密码";
    [self.view addSubview:AgainPassword];
    [[AgainPassword layer]setBorderWidth:0.5];
    [[AgainPassword layer]setBorderColor:[STYLECLOLR CGColor]];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 180, SCREEN_WIDTH-20, 45);
    [sureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认修改" forState:UIControlStateHighlighted];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
    [sureBtn addTarget:self action:@selector(sureSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    // Do any additional setup after loading the view.
}

-(void)sureSetting
{
    int lengthO=[[OldPassword.text stringByReplacingOccurrencesOfString:@" " withString:@""] length];
    int lengthN=[[NewPassword.text stringByReplacingOccurrencesOfString:@" " withString:@""] length];
    int lengthA=[[AgainPassword.text stringByReplacingOccurrencesOfString:@" " withString:@""] length];
    if (lengthO<6||lengthO>16) {
        UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"原密码长度必须为6～16！" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",nil];
        
        [AlertView show];
        return;
    }
    if (lengthN<6||lengthN>16) {
        UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"新密码长度必须为6～16！" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",nil];
        
        [AlertView show];
        return;
    }
    if (lengthA<6||lengthA>16) {
        UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"确认密码长度必须为6～16！" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",nil];
        
        [AlertView show];
        return;
    }
    if (![NewPassword.text isEqualToString:AgainPassword.text]) {
        UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"两次密码不一致！" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",nil];
        
        [AlertView show];
        return;
    }
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/user/change_password.jhtml"]];
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:[self GetKeyEncryption:OldPassword.text],@"oldpassword",[self GetKeyEncryption:NewPassword.text],@"newpassword", nil]
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
