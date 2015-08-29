//
//  TBMirrorViewControllerFactory.m
//  TBMirror
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "TBMirrorViewControllerFactory.h"
#import "TBMirrorPhotoViewController.h"
#import "TBMirrorVideoViewController.h"
#import "TBMirrorUtils.h"

@implementation TBMirrorViewControllerFactory

+ (TBMirrorViewController *)viewControllerWithType:(TBMirrorMakeUpType)type delegate:(id<TBMirrorViewControllerDelegate>)delegate{
    //如果设备在黑名单里，那么提示设备不支持
    NSString *blackDeviceListPath = [[NSBundle mainBundle] pathForResource:@"tbmirror_black_device_list" ofType:@"plist"];
    NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:blackDeviceListPath];
    NSArray *blackDeviceList = [plistDic objectForKey:@"black_device_list"];
    NSString *platform = [TBMirrorUtils getCurrentPlatForm];
    if ([blackDeviceList containsObject:platform]) {
        return nil;
    }
    if ([TBMirrorUtils getIOSVersion] < 7.0f) {
        return nil;
    }
    //暂时不支持静态
//    if (type == TBMirrorMakeUpTypePhoto) {
//        return [[TBMirrorPhotoViewController alloc] initWithType:type delegate:delegate];
//    }
    return [[TBMirrorVideoViewController alloc] initWithType:type delegate:delegate];
}


@end
