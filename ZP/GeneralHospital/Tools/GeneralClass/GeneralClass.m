//
//  GeneralClass.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-5-16.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "GeneralClass.h"

@implementation GeneralClass
+ (UIImage *) CreateImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(void)Assert:(NSString*)noticeString
{
#ifdef DEBUG
    NSAssert(DEBUGTYPE,([NSString stringWithFormat:@"\n\n----------------------------------------------------------------------\n\n%@\n\n----------------------------------------------------------------------\n\n",noticeString]));
#endif
}

+ (id)ObjectIsNotNULL:(id)object ClassName:(id)name
{
    if (object==nil) {
        [GeneralClass Assert:[NSString stringWithFormat:@"%@:数据为空，请检查！！！",name]];
        return @"";
    }
    
    if ([object isEqual:[NSNull null]]) {
        [GeneralClass Assert:[NSString stringWithFormat:@"%@:二逼后台又给<null>了！！！",name]];
        return @"";
    }
    
    if (![object isKindOfClass:[NSString class]]){
        return object;
    }else{
        return [NSString stringWithFormat:@"%@",object];
    }
}

//现实提示
+(void)ShowNotice:(NSString *)title
       setContent:(NSString *)content
        setResult:(NZAlertStyle)result
          setType:(NoticeType)type
{
    switch (type) {
        case NoticeType0:
        {
            NZAlertView *alert = [[NZAlertView alloc] initWithStyle:result
                                  //statusBarColor:[UIColor purpleColor]
                                                              title:title
                                                            message:content
                                                           delegate:self];
            [alert show];
        }
            break;
        case NoticeType1:
        {
            [self ShowMBP:title message:content setType:result];
        }
            break;
        case NoticeType2:
        {
            
        }
            break;
        case NoticeType3:
        {
            
        }
            break;
        case NoticeType4:
        {
            
        }
            break;
            
        default:
            break;
    }
}


+ (void)ShowMBP:(NSString *)title message:(NSString *)content setType:(NZAlertStyle)type
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = title;
    hud.detailsLabelText=content;
    NSString *path = @"NZAlertView-Icons.bundle/";
    
    switch (type) {
        case NZAlertStyleError:
        {
            path = [path stringByAppendingString:@"AlertViewErrorIcon"];
            
            // hud.labelColor=[UIColor errorColor];
            // hud.detailsLabelColor=[UIColor errorColor];
        }
            break;
            
        case NZAlertStyleInfo:
        {
            path = [path stringByAppendingString:@"AlertViewInfoIcon"];
            
            // hud.labelColor=[UIColor infoColor];
            // hud.detailsLabelColor=[UIColor infoColor];
        }
            break;
            
        case NZAlertStyleSuccess:
        {
            path = [path stringByAppendingString:@"AlertViewSucessIcon"];
            
            // hud.labelColor=[UIColor successColor];
            // hud.detailsLabelColor=[UIColor successColor];
        }
            break;
        default:
            break;
    }
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:path]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:2.0];
}


+ (NSString *)StringIsNotNULL:(NSString *)string
{
    if (string==nil) {
        [GeneralClass Assert:@"GeneralClass:数据为空，请检查！！！"];
        return @"";
    }
    if ([string isEqual:[NSNull null]]) {
        [GeneralClass Assert:@"GeneralClass:二逼后台又给<null>了！！！"];
        return @"";
    }

    return [NSString stringWithFormat:@"%@",string];
}
@end
