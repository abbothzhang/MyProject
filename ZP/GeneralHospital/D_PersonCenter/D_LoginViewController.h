//
//  D_LoginViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/3.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "UcmedViewStyle.h"
#import "UXTextField.h"
typedef void(^LoginBlock)(void);
@interface D_LoginViewController : UcmedViewStyle<UITextFieldDelegate,UIAlertViewDelegate>
{
    UXTextField *UserName;
    UXTextField *Password;
    LoginBlock  LoginB;
}
-(void)setLoginBlock:(LoginBlock)loginBlock;

@property (nonatomic, assign) BOOL isBack;
@end
