//
//  TBSCUtils.m
//  SocializeSDK
//

//  Created by Wan Wentao on 14/11/24.
//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import "TBSCUtils.h"
#import <UIKit/UIKit.h>

@implementation TBSCUtils

+ (float)iphoneScaleAdapt
{
    static float scale = 1.0;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if ([[UIScreen mainScreen]bounds].size.width == 375.f) {
            scale = 1.171875;
        } else if ([[UIScreen mainScreen]bounds].size.width == 414.f) {
            scale = 1.29375;
        } else {
            scale = 1;
        }
    });
    return scale;
}



//+(BOOL)isEmpty:(NSObject *)obj {
//    if (SAFE_OBJECT(obj) == nil) {
//        return YES;
//    }
//    
//    if ([obj isKindOfClass:[NSString class]]) {
//        return [obj performSelector:@selector(length)] <= 0;
//    }
//    
//    if ([[TBSCUtils collectionClassArray] containsObject:[obj superclass]]) {
//        return [(NSArray *)obj count] <= 0;
//    }
//    
//    return NO;
//}

+(BOOL)isNotEmpty:(NSObject *)obj {
    return ![TBSCUtils isEmpty:obj];
}

//+(NSArray*)collectionClassArray {
//    static NSArray *s2cMap = nil;
//    if (!s2cMap) {
//        s2cMap = [NSArray arrayWithObjects:[NSArray class],[NSDictionary class],[TBItemList class],[TBSCItemList class], nil];
//    }
//    return s2cMap;
//}

+(NSString *)longToString:(long)longValue {
    return [NSString stringWithFormat:@"%ld",longValue];
}

+(NSString *)intToString:(NSInteger)intValue {
    return [NSString stringWithFormat:@"%ld",intValue];
}

+(NSString *)unsignedLongLongToString:(unsigned long long)numberValue {
    return [NSString stringWithFormat:@"%llu",numberValue];
}

+(NSString *)intAbbreviation:(int)intValue {
    
    NSString *intStr = [TBSCUtils intToString:intValue];
    
    return [TBSCUtils abbreviationWithString:intStr];
}

+(NSString *)longAbbreviation:(long)longValue {
    NSString *longStr = [TBSCUtils longToString:longValue];
    
    return [TBSCUtils abbreviationWithString:longStr];
}

// 数字超过999显示为“999+”
+(NSString*)longNumberAbbreviation:(LongIdType)longValue {
    NSString * numStr = nil;
    
    if(longValue <= 0) {
        numStr = @"";
    } else if (longValue > 999) {
        numStr = @"999+";
    } else {
        numStr = [NSString stringWithFormat:@"%llu", longValue];
    }
    
    return numStr;
}

// 数字超过num显示为num个9+，如num为5，显示为“99999+”
+(NSString*)longNumberAbbreviation:(LongIdType)longValue number:(NSUInteger)num {
    NSString * numStr = nil;
    
    LongIdType showNumber = 0;
    NSUInteger numCount = num;
    for (; numCount > 0; numCount--) {
        showNumber = showNumber * 10 + 9;
    }
    
    if(longValue <= 0) {
        numStr = @"";
    } else if (longValue > showNumber) {
        numStr = [NSString stringWithFormat:@"%llu+",showNumber];
    } else {
        numStr = [NSString stringWithFormat:@"%llu", longValue];
    }
    
    return numStr;
}

//0~9999：原数字
//10000~9999999：x万/x.x万，小数点后最多一位
//10000000~99999999：x万，无小数点
//100000000及以上：x亿
+(NSString *)abbreviationWithString:(NSString*)str {
    if (str.length <= 4) {
        return str;
    }
    
    NSRange rangeYi = NSMakeRange(0, str.length - 8);
    NSRange rangeWan = NSMakeRange(0, str.length - 4);
    NSRange rangeQian = NSMakeRange(str.length - 4, 1);
    
    if (str.length < 8 && ![[str substringWithRange:rangeQian] isEqualToString:@"0"]) {
        NSLog(@"%@",[str substringWithRange:rangeWan]);
        NSLog(@"%@",[str substringWithRange:rangeQian]);
        
        return [NSString stringWithFormat:@"%@.%@万",[str substringWithRange:rangeWan],[str substringWithRange:rangeQian]];
    }else if(str.length < 9){
        return [NSString stringWithFormat:@"%@万",[str substringWithRange:rangeWan]];
    }
    
    
    return [NSString stringWithFormat:@"%@亿",[str substringWithRange:rangeYi]];
}

+(NSString *)getSafeString:(NSObject *)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return (NSString*)obj;
}

+(NSObject *)getSafeObject:(NSObject *)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return obj;
}

//+(NSString *)errorMessage:(NSError *)error {
//    if (error == nil || ![error isKindOfClass:[TBErrorResponse class]]) {
//        return @"";
//    }
//    
//    return [(TBErrorResponse*)error msg];
//}

+(BOOL)isStringUrlNative:(NSString*)url{
    return ([url rangeOfString:@"bundle://"].location != NSNotFound);
}

+(NSString*)stringUrltoImage:(NSString*)url{
    int location = [url rangeOfString:@"bundle://"].location;
    return [url substringFromIndex: location+9];
}

+(NSString*)stringRemoveUtf8Space:(NSString *)str {
    char* utf8Replace = "\xe2\x80\x86\0";
    NSData* data = [NSData dataWithBytes:utf8Replace length:strlen(utf8Replace)];
    NSString* utf8_str_format = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString* mutableStr = [NSMutableString stringWithString:str];
    NSString* result =  [mutableStr stringByReplacingOccurrencesOfString:utf8_str_format withString:@""];
    return result;
}


@end
