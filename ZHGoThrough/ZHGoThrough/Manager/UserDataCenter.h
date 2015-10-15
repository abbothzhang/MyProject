//
//  UserDataCenter.h
//  ZHGoThrough
//
//  Created by albert on 15/10/14.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataCenter : NSObject



+ (instancetype)sharedInstance;

- (NSInteger)gameLevel;
- (void)setGameLevel:(NSInteger)level;

- (NSInteger)userTopLevel;
- (void)setUserTopLevel:(NSInteger)level;

@end
