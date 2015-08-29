//
//  MirrorNetworkUtil.m
//  Mirror
//
//  Created by albert on 15/4/1.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "MirrorNetworkUtil.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"

//用来判断系统版本的宏
#define SYS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYS_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYS_LESS_THAN_OR_EQUAL_TO(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface MirrorNetworkUtil ()

@property (nonatomic, strong) NSString* networkStatus;

@end

@implementation MirrorNetworkUtil

+ (id)sharedInstance
{
    static MirrorNetworkUtil* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MirrorNetworkUtil alloc] init];
    });
    
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        CTTelephonyNetworkInfo* telephonyInfo = [CTTelephonyNetworkInfo new];
        
        if (SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.networkStatus = telephonyInfo.currentRadioAccessTechnology;
            
            [NSNotificationCenter.defaultCenter addObserverForName:@"CTRadioAccessTechnologyDidChangeNotification"
                                                            object:nil
                                                             queue:nil
                                                        usingBlock:^(NSNotification* note) {
                                                            self.networkStatus = telephonyInfo.currentRadioAccessTechnology;
                                                        }];
        }
    }
    
    return self;
}

- (void)dealloc
{
    if (SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CTRadioAccessTechnologyDidChangeNotification" object:nil];
    }
}


+(BOOL)isWIFI{
//    return [WVCommonUtil isWIFI];
    BOOL isWifi = NO;
    Reachability *reachability = [Reachability reachabilityWithHostname:@"h5.m.taobao.com"];
    //结果说明：0-无连接   1-wifi    2-3G
    NSInteger netStat = [reachability currentReachabilityStatus];
    if (netStat == ReachableViaWiFi) {
        isWifi = YES;
    }
    return isWifi;
}


- (NSMutableDictionary*)getNetworkType
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    if (SYS_VERSION_LESS_THAN(@"7.0")) {
        Reachability *reachability = [Reachability reachabilityWithHostname:@"h5.m.taobao.com"];
        switch ([reachability currentReachabilityStatus]) {
            case NotReachable:
                [result setObject:@"NONE" forKey:@"type"];
                break;
            case ReachableViaWiFi:
                [result setObject:@"WIFI" forKey:@"type"];
                break;
            case ReachableViaWWAN:
                [result setObject:@"WWAN" forKey:@"type"];
                break;
            default:
                break;
        }
        
        return result;
    }
    
    NSString* type;
    NSString* message;
    
    if (!self.networkStatus) {
        type = @"NONE";
    } else if ([self.networkStatus isEqualToString:@"CTRadioAccessTechnologyEdge"] || [self.networkStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        type = @"2G";
    } else if ([self.networkStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"] ||
               [self.networkStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"] ||
               [self.networkStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"] ||
               [self.networkStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"] ||
               [self.networkStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"] ||
               [self.networkStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"] ||
               [self.networkStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"] ||
               [self.networkStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
        type = @"3G";
    } else if ([self.networkStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
        type = @"4G";
    } else {
        type = @"UNKNOWN";
    }
    
    if (self.networkStatus.length > 23) {
        message = [self.networkStatus substringFromIndex:23];
    }
    
    [result setObject:type forKey:@"type"];
    if (message) {
        [result setObject:message forKey:@"message"];
    }
    
    return result;
}



@end
