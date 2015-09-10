//
//  staticFrameWorkDemo.m
//  staticFrameWorkDemo
//
//  Created by albert on 15/9/7.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "staticFrameWorkDemo.h"
#import <UIKit/UIKit.h>

@implementation staticFrameWorkDemo

- (NSString *)getResourcePath{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"img1" ofType:@"png"];
    return path;
}

- (void)getResource{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"img1" ofType:@"png"];
    NSLog(path);
    
}

@end
