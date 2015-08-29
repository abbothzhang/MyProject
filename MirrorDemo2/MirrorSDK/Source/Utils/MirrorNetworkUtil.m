//
//  MirrorNetworkUtil.m
//  Mirror
//
//  Created by albert on 15/4/1.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "MirrorNetworkUtil.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

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
    return [WVCommonUtil isWIFI];
}

- (NSString *)getNetworkType{
    
    if ([WVCommonUtil isWIFI]) {
        return @"WIFI";
    } else {
        return [[self getCellularType] objectForKey:@"type"];
    }
    
}

- (NSMutableDictionary*)getCellularType
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    if (SYS_VERSION_LESS_THAN(@"7.0")) {
        if ([WVCommonUtil checkNetConnection] == -1) {
            [result setObject:@"NONE" forKey:@"type"];
        } else {
            [result setObject:@"CELL" forKey:@"type"];
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
