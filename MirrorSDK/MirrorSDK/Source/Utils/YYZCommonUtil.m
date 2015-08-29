/*!
 * @FILE: YYZCommonUtil.h
 * @PROJECT: YYZPlugin
 * @DESCRIPTION:
 * Hybrid模块通用工具
 *

 */

#import "YYZCommonUtil.h"
#import "Reachability.h"
//#import "YYZGlobalContext.h"
//#import "WVUserConfig.h"

static NetworkStatus wvNetworkStatus = ReachableViaWiFi;
static NSLock * wvNetworkStatuslingLock = nil;
static Reachability* _staticReachability = nil;

@implementation YYZCommonUtil

+ (NSString *) getToday:(NSString *) datepattern {
    return [YYZCommonUtil getDateString:[NSDate date] withFormat:datepattern];
}

+ (NSString *) getDateString:(NSDate *) date withFormat:(NSString *) datepattern {
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    
    dateFormate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormate.dateFormat = datepattern;
    
    return [dateFormate stringFromDate:date];
}

+ (NSString *) urlWithoutHash:(NSString *) requestURL {
    if (requestURL) {
        NSArray * parts = [requestURL componentsSeparatedByString:@"#"];
        
        if (parts && 0 < [parts count]) {
            requestURL = [parts objectAtIndex:0];
        }
    }
    
    return requestURL;
}

+ (int) checkNetConnection {
    if (wvNetworkStatus) {
        switch (wvNetworkStatus) {
            case NotReachable:
                return 0;
            case ReachableViaWiFi:
                return 1;
            case ReachableViaWWAN:
                return 2;
            default:
                return -1;
        }
    }
    
    return -1;
}

+ (BOOL) isWIFI {
    return 1 == [YYZCommonUtil checkNetConnection];
}

+ (void)registerForNetworkReachabilityNotifications {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticReachability = [Reachability reachabilityWithHostname:@"www.taobao.com"] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:_staticReachability];
        [_staticReachability startNotifier];
    });
}

+ (void)unsubscribeFromNetworkReachabilityNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

+ (void)reachabilityChanged:(NSNotification *) note {
    if (_staticReachability != note.object) {
        return;
    }
    
    if (!wvNetworkStatuslingLock) {
        wvNetworkStatuslingLock = [[NSLock alloc] init];
    }
    
    [wvNetworkStatuslingLock lock];
    wvNetworkStatus = [_staticReachability currentReachabilityStatus];
    [wvNetworkStatuslingLock unlock];
}

+ (NSDate *) getNowDate {
    return [NSDate date];
}

+ (double) getCurrentTime {
    return [[YYZCommonUtil getNowDate] timeIntervalSince1970];
}

+ (NSString *) getNowTimeString {
    return [NSString stringWithFormat:@"%f", [YYZCommonUtil getCurrentTime]];
}

+ (BOOL) checkTime:(NSString*) targetTime withStaticTime:(int) staticTime {
    if (nil == targetTime) {
        return YES;
    }
    
    double between = [targetTime doubleValue] - [YYZCommonUtil getCurrentTime];

    between = between < 0 ? between * -1 : between;
    
    return staticTime <= between;
}

+ (NSString *) autoFixRandomParam:(NSString *) url withParamAndValue:(NSString *) paramAndValue {
    if (paramAndValue) {
        if (0 < [url rangeOfString:paramAndValue].length) {
            url = [YYZCommonUtil urlByDeleteParamAndValue:url withParamAndValue:paramAndValue];
        } else {
            url = [YYZCommonUtil urlByAppendParamAndValue:url withParamAndValue:paramAndValue];
        }
    }
    
    return url;
}

+ (NSString *) urlByDeleteParamAndValue:(NSString *) url withParamAndValue:(NSString *) paramAndValue {
    if (paramAndValue) {
        url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&%@", paramAndValue] withString:@""];
        url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@&", paramAndValue] withString:@""];
        url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"?%@", paramAndValue] withString:@""];
        
        if ([url hasSuffix:@"&"] || [url hasSuffix:@"?"]) {
            url = [url substringToIndex:(url.length -1)];
        }
    }
    
    return url;
}

+ (NSString *) getParamValueFromUrl:(NSString *) url withParamName:(NSString *) paramName {
    NSString * v = @"";
    
    if (url && paramName) {
        if (0 < [url rangeOfString:@"?"].length) {
            NSArray * parts = [url componentsSeparatedByString:@"?"];
            
            if (parts && 1 < [parts count]) {
                NSString * pvstr = [parts objectAtIndex:1];
                NSArray * pvs = [pvstr componentsSeparatedByString:@"&"];
                
                for (int i=0; i<[pvs count]; i++) {
                    NSString * pv = [pvs objectAtIndex:i];
                    
                    if ([pv hasPrefix:[NSString stringWithFormat:@"%@=", paramName]]) {
                        NSArray * pandv = [pv componentsSeparatedByString:@"="];
                        
                        if (pandv && 1 < [pandv count]) {
                            NSString * value = [pandv objectAtIndex:1];
                            
                            if (value && 0 < [value rangeOfString:@"#"].length) {
                                NSArray * rv = [value componentsSeparatedByString:@"#"];
                                
                                if (rv && 0 < [rv count]) {
                                    v = [rv objectAtIndex:0];
                                }
                            } else {
                                v = value;
                            }
                        }
                    }
                }
            }
        }
    }
    
    return v;
}

+ (NSString *) urlByDeleteParam:(NSString *)url withParam:(NSString *)paramName {
    if (paramName) {
        if (0 < [url rangeOfString:@"?"].length) {
            NSArray * parts = [url componentsSeparatedByString:@"?"];
            
            if (parts && 1 < [parts count]) {
                url = [parts objectAtIndex:0];
                NSString * pvstr = [parts objectAtIndex:1];
                NSString * md = nil;
                NSArray * mdandpv = [pvstr componentsSeparatedByString:@"#"];
                
                if (1 < [mdandpv count]) {
                    md = [mdandpv objectAtIndex:1];
                    pvstr = [mdandpv objectAtIndex:0];
                }
                
                NSArray * pvs = [pvstr componentsSeparatedByString:@"&"];
                BOOL isfirstp = YES;
                
                for (int i=0; i<[pvs count]; i++) {
                    NSString * pv = [pvs objectAtIndex:i];
                    
                    if ([pv hasPrefix:[NSString stringWithFormat:@"%@=", paramName]]) {
                        continue;
                    }
                    
                    if (isfirstp) {
                        url = [NSString stringWithFormat:@"%@?%@", url, pv];
                        isfirstp = NO;
                        continue;
                    }
                    
                    url = [NSString stringWithFormat:@"%@&%@", url, pv];
                }
                
                url = md ? [NSString stringWithFormat:@"%@#%@", url, md]:url;
            }
        }
    }
    
    return url;
}

+ (NSString *) urlByReplaceParamAndValue:(NSString *)url withParam:(NSString *)paramName withParamAndValue:(NSString *) newpv {
    if (paramName && newpv && 0 < newpv.length) {
        if (0 < [url rangeOfString:@"?"].length) {
            NSArray * parts = [url componentsSeparatedByString:@"?"];
            
            if (parts && 1 < [parts count]) {
                url = [parts objectAtIndex:0];
                NSString * pvstr = [parts objectAtIndex:1];
                NSString * md = nil;
                NSArray * mdandpv = [pvstr componentsSeparatedByString:@"#"];
                
                if (1 < [mdandpv count]) {
                    md = [mdandpv objectAtIndex:1];
                    pvstr = [mdandpv objectAtIndex:0];
                }
                
                NSArray * pvs = [pvstr componentsSeparatedByString:@"&"];
                BOOL isfirstp = YES;
                
                for (int i=0; i<[pvs count]; i++) {
                    NSString * pv = [pvs objectAtIndex:i];
                    
                    if ([pv hasPrefix:[NSString stringWithFormat:@"%@=", paramName]]) {
                        pv = newpv;
                    }
                    
                    if (isfirstp) {
                        url = [NSString stringWithFormat:@"%@?%@", url, pv];
                        isfirstp = NO;
                        continue;
                    }
                    
                    url = [NSString stringWithFormat:@"%@&%@", url, pv];
                }
                
                url = md ? [NSString stringWithFormat:@"%@#%@", url, md]:url;
            }
        }
    }
    
    return url;
}

+ (NSString *) urlByAppendParamAndValue:(NSString *) url withParamAndValue:(NSString *) paramAndValue {
    if (paramAndValue && 0 < paramAndValue.length) {
        if ([url hasSuffix:@"/"]) {
            url = [url substringToIndex:(url.length-1)];
        }
        
        NSString* headString = nil;
		NSString* queryString = nil;
		//有问号
        if (0 < [url rangeOfString:@"?"].length) {
			headString = [url substringToIndex:[url rangeOfString:@"?"].location+1];
			if (url.length > headString.length) {
				queryString = [url substringFromIndex:[url rangeOfString:@"?"].location+1];
			}
			
			if (0 < [queryString rangeOfString:@"#"].length) {
				NSArray * parts = [queryString componentsSeparatedByString:@"#"];
				
				if (parts && 0 < parts) {
					queryString = [NSString stringWithFormat:@"%@&%@", [parts objectAtIndex:0], paramAndValue];
					
					for (int i=1; i<[parts count]; i++) {
						queryString = [NSString stringWithFormat:@"%@#%@", queryString, [parts objectAtIndex:i]];
					}
				}
			}else{
				queryString = [NSString stringWithFormat:@"%@&%@", queryString, paramAndValue];
			}
			
			url = [NSString stringWithFormat:@"%@%@",headString,queryString];
			
        }//没问号
		else{
			if (0 < [url rangeOfString:@"#"].length) {
				
				NSArray * parts = [url componentsSeparatedByString:@"#"];
				
				if (parts && 0 < parts) {
					url = [NSString stringWithFormat:@"%@?%@", [parts objectAtIndex:0], paramAndValue];
					
					for (int i=1; i<[parts count]; i++) {
						url = [NSString stringWithFormat:@"%@#%@", url, [parts objectAtIndex:i]];
					}
				}
			} else {
				url = [NSString stringWithFormat:@"%@?%@", url, paramAndValue];
			}

		}
		
	}
    
    return url;
}

+ (BOOL) checkIshveParam:(NSString *) url withParamValue:(NSString *) param {
    return 0 < [url rangeOfString:[NSString stringWithFormat:@"&%@=", param]].length
    || 0 < [url rangeOfString:[NSString stringWithFormat:@"?%@=", param]].length;
}

+ (void) initResourceDic {
    [YYZCommonUtil initResourceDicWithName:YYZ_RESOURCE_FILES_DIC];
}

+ (void) updateResourceDic:(NSString *) u {
    [YYZCommonUtil updateResourceDicWithName:u withName:YYZ_RESOURCE_FILES_DIC];
}

+ (void) initResourceDicWithName:(NSString *) name {
    NSMutableSet * resourceDic = [YYZGlobalContext getContextValue:name];
    
    @synchronized(resourceDic) {
        if (resourceDic) {
            [resourceDic removeAllObjects];
        } else {
            resourceDic = [[NSMutableSet alloc] initWithCapacity:10];
        }
    
        [YYZGlobalContext putContext:name setResource:resourceDic];
    }
}

+ (void) updateResourceDicWithName:(NSString *) u withName:(NSString *) name {
    NSMutableSet * resourceDic = [YYZGlobalContext getContextValue:name];
    
    @synchronized(resourceDic) {
        if (!resourceDic) {
            resourceDic = [[NSMutableSet alloc] initWithCapacity:10];
        }
    
        [resourceDic addObject:u];
    }
    
    [YYZGlobalContext putContext:name setResource:resourceDic];
}

+ (NSString *) getResourcePathWithoutParam:(NSString *) url {
    if (0 >= [url rangeOfString:@"?"].length) {
        return url;
    }
    
    BOOL hvCom = 0 < [url rangeOfString:@"??"].length;
    url = hvCom ? [url stringByReplacingOccurrencesOfString:@"??" withString:@"-:-:"]:url;
    
    NSArray * parts = [url componentsSeparatedByString:@"?"];
    NSString * u = parts && 0 < [parts count] ? [parts objectAtIndex:0]:url;
    
    return hvCom ? [u stringByReplacingOccurrencesOfString:@"-:-:" withString:@"??"]:u;
}

+ (BOOL) isLock {
    NSString * lock = [YYZGlobalContext getContextValue:YYZ_LOCK];
    return lock && [lock isEqualToString:YYZ_IS_LOCK];
}

+ (BOOL) isFromCDN {
    NSString* cdn = [YYZGlobalContext getContextValue:YYZ_CDN_FETCH_RULE];
    //只有cdn的值返回0的时候才走mtop
    return !(cdn && [cdn isEqualToString:@"0"]);
}

+ (BOOL) isBlank:(NSString *) s {
    return nil == s || 0 == s.length;
}

+ (BOOL) checkIsBlankUrl:(NSString *) url {
    return nil == url || 0 == url.length || [url isEqualToString:@"about:blank"];
}

+ (NSString *) checkIsYYZRequest: (NSString *) url {
    if (nil == url) {
        return nil;
    }
    
    NSArray* ruleArray = [YYZGlobalContext getContextValue:YYZ_URL_RULE];
    
    if (ruleArray) {
        NSError * error;
        int length = [url length];
        
        for (NSString * rule in ruleArray) {
            NSRegularExpression * pattern = [NSRegularExpression regularExpressionWithPattern:rule options:NSRegularExpressionCaseInsensitive error:&error];
            NSUInteger num = pattern ? [pattern numberOfMatchesInString:url options:NSMatchingReportProgress range:NSMakeRange(0, length)] : 0;
            
            if (num > 0) {
                return rule;
            }
        }
    }
    
    return nil;
}

+ (NSString *) getCameraStr:(NSString *) str {
    str = [str lowercaseString];
    return [str stringByReplacingOccurrencesOfString:@"_" withString:@""];
}

/************** [2.4 删除，接入运维系统] **************
+ (NSString *) getConfigUpdateUrl {
    NSString * updateUrl = [YYZGlobalContext getContextValue:YYZ_CHECK_UPDATE_URL];
    updateUrl = (nil != updateUrl ? updateUrl:DEFAULT_UPDATE_URL);
    
    updateUrl = [YYZCommonUtil urlByAppendParamAndValue:updateUrl withParamAndValue:[self getTTID]];
    
    return updateUrl;
}
*****************************************************/

/************** [2.4 删除，接入运维系统] **************
+ (NSString *) getRuleUpdateUrl {
    NSString * ruleUpdateUrl = TBWV_DF_UPDATE;
    
    ruleUpdateUrl = [YYZCommonUtil urlByAppendParamAndValue:ruleUpdateUrl withParamAndValue:[self getTTID]];
    
    return ruleUpdateUrl;
}
*****************************************************/

+ (NSString *) getTTID {
    return [YYZCommonUtil isBlank:[WVUserConfig ttid]] ? [NSString stringWithFormat:@"ttid=%@", YYZ_DEFAULT_TTID] : [NSString stringWithFormat:@"ttid=%@", [WVUserConfig ttid]] ;
}

+ (NSString *) getCleanUrl:(NSString *) url {
    if (url) {
        url = [YYZCommonUtil urlByDeleteParam:url withParam:YYZ_SID_KEY];
    }
    
    return url;
}

+ (NSString *)getBaseURL:(NSString *)url
{
    NSURL* originURL = [NSURL URLWithString:url];
    if(originURL && originURL.scheme && originURL.host && originURL.path) {
        NSString* path = originURL.path.length == 0 ? @"/" : originURL.path;
        NSString* newURL = [NSString stringWithFormat:@"%@://%@%@", originURL.scheme, originURL.host, path];
        return newURL;
    }
    return nil;
}

+ (NSMutableDictionary *) getParamFromRequestQuery:(NSString *) query withStopWord:(NSString *) stopPre {
    if (query && 0 < query.length) {
        NSArray * pv = [query componentsSeparatedByString:@"&"];
        
        if (pv && 0 < [pv count]) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            
            for (NSString * pvitem in pv) {
                if (pvitem && 0 < pvitem.length) {
                    NSArray * pva = [pvitem componentsSeparatedByString:@"="];
                    
                    if (pva && 2 == [pva count]) {
                        NSString * key = [pva objectAtIndex:0];
                        
                        // 原始KEY
                        [dic setObject:[pva objectAtIndex:1] forKey:key];
                        
                        // 驼峰法则兼容处理
                        if (key && (nil == stopPre || ![key hasPrefix:stopPre])) {
                            key = [YYZCommonUtil getCameraStr:key];
                            [dic setObject:[pva objectAtIndex:1] forKey:key];
                        }
                    } else if (pva && 1 == [pva count]) {
                        NSString * key = [pva objectAtIndex:0];
                        // 原始KEY
                        [dic setObject:@"" forKey:key];
                        
                        // 驼峰法则兼容处理
                        if (key && (nil == stopPre || ![key hasPrefix:stopPre])) {
                            key = [YYZCommonUtil getCameraStr:key];
                            [dic setObject:@"" forKey:key];
                        }
                    }
                }
            }
            
            return dic;
        }
    }
    
    return [[NSMutableDictionary alloc] init];
}

+ (NSMutableDictionary *) getParamFromRequestQuery:(NSString *) query {
    return [YYZCommonUtil getParamFromRequestQuery:query withStopWord:nil];
}

//不用驼峰法则的接口
+ (NSMutableDictionary*) getOriginalParamFromRequestQuery:(NSString *)query {
    if (query && 0 < query.length) {
        NSArray * pv = [query componentsSeparatedByString:@"&"];
        
        if (pv && 0 < [pv count]) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            
            for (NSString * pvitem in pv) {
                if (pvitem && 0 < pvitem.length) {
                    NSArray * pva = [pvitem componentsSeparatedByString:@"="];
                    
                    if (pva && 2 == [pva count]) {
                        NSString * key = [pva objectAtIndex:0];
                        // 原始KEY
                        [dic setObject:[pva objectAtIndex:1] forKey:key];
                    } else if (pva && 1 == [pva count]) {
                        NSString * key = [pva objectAtIndex:0];
                        // 原始KEY
                        [dic setObject:@"" forKey:key];
                    }
                }
            }
            
            return dic;
        }
    }
    
    return [[NSMutableDictionary alloc] init];

}


+ (NSString *) addDefaultParamForURL:(NSString *) loadUrl {
    // 带上ttid参数
    if (![YYZCommonUtil checkIshveParam:loadUrl withParamValue:YYZ_TTID_KEY]) {
        loadUrl = [YYZCommonUtil urlByAppendParamAndValue:loadUrl withParamAndValue:[YYZCommonUtil getTTID]];
    }
    
    return loadUrl;
}

+ (NSString *) removeSidFromURL:(NSString *) loadUrl {
    return [YYZCommonUtil urlByDeleteParam:loadUrl withParam:YYZ_SID_KEY];
}

+ (BOOL) checkIsAliDomain: (NSString *) url {
    if ([YYZCommonUtil isBlank:url]) {
        return NO;
    }
    
    if ([url hasPrefix:WAPLUGIN_PROTOCOL_SCHEMA] || [url hasPrefix:PROTOCOL_SCHEME]) {
        return YES;
    }
    
    NSRegularExpression * aliDomainExpression;
    NSError * error;
    NSString * aliDomainPattern = [YYZGlobalContext getContextValue:YYZ_ALIDOMAIN_PATTERN];
    
    if ([YYZCommonUtil isBlank:aliDomainPattern]) {
        aliDomainPattern = ALI_DOMAIN_PATTERN;
    }
    
    aliDomainExpression = [NSRegularExpression regularExpressionWithPattern:aliDomainPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray * matches = [aliDomainExpression matchesInString:url options:NSMatchingReportProgress range:NSMakeRange(0, url.length)];
    
    return !(!matches || 0 == [matches count]);
}

+ (int) checkVersion:(NSString *) oldVersion withNewVersoin:(NSString *) newVersion {
    oldVersion = [oldVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    newVersion = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    int b = [oldVersion length] - [newVersion length];
    
    NSString * n = b > 0 ? newVersion : oldVersion;
    
    int s = 0 > b ? (b * -1) : b;
    
    for (int i=0; i<s; i++) {
        n = [NSString stringWithFormat:@"%@0", n];
    }
    
    if (b > 0) {
        newVersion = n;
    } else {
        oldVersion = n;
    }
    
    if ([oldVersion intValue] < [newVersion intValue]) {
        return 0;
    } else if ([oldVersion intValue] == [newVersion intValue]) {
        return 1;
    } else {
        return 2;
    }
}

+ (void) WindVaneLog:(NSString *) format,... {
    if ([WVUserConfig isOpenWindVaneLog]) {
        if ([YYZCommonUtil isBlank:format]) {
            return;
        }
        
        va_list args;
        va_start(args, format);
        NSString * c = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        NSLog(@"[WindVane]%@", c);
    }
}

+ (NSString *)UUIDString
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString* UUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    return UUID;
}

@end
