//
//  GeneralClass.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-5-16.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralClass : NSObject
+ (UIImage *)CreateImageWithColor: (UIColor *) color;
+(void)Assert:(NSString*)noticeString;
+ (NSString *)StringIsNotNULL:(NSString *) string;
+ (id)ObjectIsNotNULL:(id)object ClassName:(id)name;
+(void)ShowNotice:(NSString *)title
       setContent:(NSString *)content
        setResult:(NZAlertStyle)result
          setType:(NoticeType)type;
+ (void)ShowMBP:(NSString *)title
        message:(NSString *)content
        setType:(NZAlertStyle)type;
@end
