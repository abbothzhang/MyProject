//
//  B_CheckLogisticsController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 15/2/5.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_CheckLogisticsController : UcmedViewStyle<UIWebViewDelegate>
{
    UIActivityIndicatorView*   ActivityIndicator;
}
@property(nonatomic,strong)NSString *UrlString;
@end
