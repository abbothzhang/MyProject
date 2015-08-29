/*!
 * @FILE: YYZCommonUtil.h
 * @PROJECT: YYZPlugin
 * @DESCRIPTION:
 * Hybrid模块通用工具
 *
 *  Created by 颜 垣 on 12-10-22.
 *  Copyright (c) 2012年 一淘网. All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef enum {
    NET_LOW_OR_NO = 0,
    NET_HIGH = 1
} NET_TYPE;

@interface YYZCommonUtil : NSObject

/*!
 * 获取今天的格式化字符串
 */
+ (NSString *) getToday:(NSString *) datepattern;

/*!
 * 获取时间的格式化字符串
 */
+ (NSString *) getDateString:(NSDate *) date withFormat:(NSString *) datepattern;

/*!
 * 去掉URL中的HASH
 */
+ (NSString *) urlWithoutHash:(NSString *) requestURL;

/**
 * 获取不含任何参数和端口号的URL
 */
+ (NSString *) getBaseURL:(NSString*)url;

/*!
 * 检查网络情况
 * 返回值：
 *  0\-1:无网络
 *  1:WIFI
 *  2:3G/WLAN
 */
+ (int) checkNetConnection;

/*!
 * 获取当前时间数值
 */
+ (double) getCurrentTime;

/*!
 * 获取当前时间
 */
+ (NSDate *) getNowDate;

/*!
 * 获取当前时间字符串表示
 */
+ (NSString *) getNowTimeString;

/*!
 * 检查时间间隔是否超过预计时间
 */
+ (BOOL) checkTime:(NSString*) targetTime withStaticTime:(int) staticTime;

/*!
 * 自动完成URL中标记参数的补充和删除
 */
+ (NSString *) autoFixRandomParam:(NSString *) url withParamAndValue:(NSString *) paramAndValue;

/*!
 * 从URL读取参数值
 */
+ (NSString *) getParamValueFromUrl:(NSString *) url withParamName:(NSString *) paramName;

/*!
 * 从URL删除参数
 */
+ (NSString *) urlByDeleteParamAndValue:(NSString *) url withParamAndValue:(NSString *) paramAndValue;

/*!
 * 从URL替换参数值
 */
+ (NSString *) urlByReplaceParamAndValue:(NSString *)url withParam:(NSString *)paramName withParamAndValue:(NSString *) newpv;

/*!
 * 补充参数给URL
 */
+ (NSString *) urlByAppendParamAndValue:(NSString *) url withParamAndValue:(NSString *) paramAndValue;

/*!
 * 从URL删除某个参数
 */
+ (NSString *) urlByDeleteParam:(NSString *)url withParam:(NSString *)paramName;

/*!
 * 是否包含有参数
 */
+ (BOOL) checkIshveParam:(NSString *) url withParamValue:(NSString *) param;

/*!
 * 初始化资源字典对象
 */
+ (void) initResourceDic;

/*!
 * 更新资源字典
 */
+ (void) updateResourceDic:(NSString *) u;

/*!
 * 获取不带版本号的路径
 */
+ (NSString *) getResourcePathWithoutParam:(NSString *) url;

/*!
 * 检查URL是否是空地址
 */
+ (BOOL) checkIsBlankUrl:(NSString *) url;

/*!
 * 检查URL是否命中规则配置
 */
+ (NSString *) checkIsYYZRequest: (NSString *) url;

/*!
 * 判空
 */
+ (BOOL) isBlank:(NSString *) s;

/*!
 * 获取骆驼法则的小写串
 */
+ (NSString *) getCameraStr:(NSString *) str;

/************* [v2.4 删除，接入运维系统]*************
//获取配置更新地址
+ (NSString *) getConfigUpdateUrl;

//获取规则更新地址
+ (NSString *) getRuleUpdateUrl;
****************************************************/

/*!
 * 是否关闭
 */
+ (BOOL) isLock;

/*!
 * 是否从CDN获取配置
 */
+ (BOOL) isFromCDN;
/*!
 * 获取不带任何参数的地址
 */
+ (NSString *) getCleanUrl:(NSString *) url;

/*!
 * 从QUERY中获取参数DIC，支持骆驼法则
 */
+ (NSMutableDictionary *) getParamFromRequestQuery:(NSString *) query;

/*!
 * 从QUERY中获取参数DIC，支持骆驼法则，但是带有停用前缀串
 */
+ (NSMutableDictionary *) getParamFromRequestQuery:(NSString *) query withStopWord:(NSString *) stopPre;

/*!
 * 从QUERY中获取参数DIC, 不使用骆驼法则
 */
+ (NSMutableDictionary*) getOriginalParamFromRequestQuery:(NSString *)query;
/*!
 * 封装默认的参数到URL
 */
+ (NSString *) addDefaultParamForURL:(NSString *) loadUrl;

/*!
 * 从URL删除sid
 */
+ (NSString *) removeSidFromURL:(NSString *) loadUrl;

/*!
 * 检查是否是ALIBABA域名
 */
+ (BOOL) checkIsAliDomain: (NSString *) url;

/*!
 * 检查版本
 * 0：oldVersion < newVersion 新
 * 1：oldVersion = newVersion 同
 * 2：oldVersion > newVersion 老
 */
+ (int) checkVersion:(NSString *) oldVersion withNewVersoin:(NSString *) newVersion;

+ (void) WindVaneLog:(NSString *) format,...;

+ (void) registerForNetworkReachabilityNotifications;

+ (BOOL) isWIFI;

/**
 *  利用时间戳、计数器、硬件地址产生的全局唯一标示
 */
+ (NSString*)UUIDString;

@end
