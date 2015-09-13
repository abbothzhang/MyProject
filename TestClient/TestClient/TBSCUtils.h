//
//  TBSCUtils.h
//  SocializeSDK
//
//  Created by Wan Wentao on 14/11/24.

//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSCDataTypes.h"

@interface TBSCUtils : NSObject

+ (float)iphoneScaleAdapt;



#define SAFE_STRING(obj) ([TBSCUtils getSafeString:obj])
#define SAFE_OBJECT(obj) ([TBSCUtils getSafeObject:obj])
#define IS_NULL(obj) ([TBSCUtils isEmpty:obj]) // 是否未空，请参照isEmpty

// 是否为空，如果是集合，则判断是否集合中有元素，没有则为空。如果是字符串则判断是否为空串，是则为空
+(BOOL)isEmpty:(NSObject*)obj;
+(BOOL)isNotEmpty:(NSObject*)obj;
+(NSString*)intToString:(NSInteger)intValue;
+(NSString*)longToString:(long)longValue;
+(NSString*)unsignedLongLongToString:(unsigned long long)numberValue;
// number缩写
+(NSString*)longAbbreviation:(long)longValue;
// number缩写
+(NSString*)intAbbreviation:(int)intValue;

// 数字超过999显示为“999+”
+(NSString*)longNumberAbbreviation:(LongIdType)longValue;
// 数字超过num位数，如num为3，则显示为“999+”
+(NSString*)longNumberAbbreviation:(LongIdType)longValue number:(NSUInteger)num;

+(NSString*)getSafeString:(NSObject*)obj;
+(NSObject*)getSafeObject:(NSObject*)obj;

+(NSString*)errorMessage:(NSError*)error;

+(BOOL)isStringUrlNative:(NSString*)url;
+(NSString*)stringUrltoImage:(NSString*)url;

// ios在中文状态时候输入拼音后不选择中文字符输入，输入英文字母这个时候输出的字符会带一个小的utf8空格 \xe2\x80\x86 (SIX-PER-EM SPACE ) 这个空格需要干掉它
+(NSString*)stringRemoveUtf8Space:(NSString*)str;
@end
