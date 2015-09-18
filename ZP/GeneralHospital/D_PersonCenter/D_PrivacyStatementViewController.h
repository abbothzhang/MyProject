//
//  D_PrivacyStatementViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 15/2/2.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D_PrivacyStatementViewController : UcmedViewStyle<UIWebViewDelegate>
{
    UIActivityIndicatorView*   ActivityIndicator;
}
@property(nonatomic,retain)NSString *Url;

@end
