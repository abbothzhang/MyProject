//
//  D_ManageInfoViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/12/23.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXTextField.h"
typedef void(^SNameInfo)(NSString *);
typedef void(^SignatureInfo)(NSString *);
@interface D_ManageInfoViewController : UcmedViewStyle<UITextViewDelegate>
{
    UXTextField *TextField;
    UITextView  *TextView;
    SNameInfo   NameInfo;
    SignatureInfo SignInfo;
    
}
@property(nonatomic,assign)int Index;
@property(nonatomic,retain)NSString *TitleString;
-(void)setNameInfo:(SNameInfo)nameInfo;

-(void)setSignatureInfo:(SignatureInfo)signInfo;
@end
