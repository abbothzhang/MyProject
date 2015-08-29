//
//  TBMirrorViewControllerFactory.h
//  TBMirror
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBMirrorViewController.h"

@interface TBMirrorViewControllerFactory : NSObject

+ (TBMirrorViewController *)viewControllerWithType:(TBMirrorMakeUpType)type delegate:(id<TBMirrorViewControllerDelegate>)delegate;

@end
