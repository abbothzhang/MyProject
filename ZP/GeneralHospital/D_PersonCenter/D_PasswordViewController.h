//
//  D_PasswordViewController.h
//  zhipin
//
//  Created by 夏科杰 on 15/2/17.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXTextField.h"
@interface D_PasswordViewController : UcmedViewStyle<UITextFieldDelegate>
{
    UXTextField *OldPassword;
    UXTextField *NewPassword;
    UXTextField *AgainPassword;
}


@end
