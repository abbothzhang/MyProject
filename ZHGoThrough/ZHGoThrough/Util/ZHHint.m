//
//  ZHHint.m
//  TrainTicketBooking
//
//  Created by albert on 15-1-25.
//  Copyright (c) 2015年 albert. All rights reserved.
//

#import "ZHHint.h"
#import "MBProgressHUD.h"

@implementation ZHHint

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(void)showToast:(NSString*)str
{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText = str;
    hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

@end
