//
//  UserDataCenter.m
//  ZHGoThrough
//
//  Created by albert on 15/10/14.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "UserDataCenter.h"


#define USERDEFAULT_CURRENT_LEVEL   @"USERDEFAULT_CURRENT_LEVEL"
#define USERDEFAULT_USER_TOP_LEVEL  @"USERDEFAULT_USER_TOP_LEVEL"

@interface UserDataCenter()


@end

@implementation UserDataCenter


+ (instancetype)sharedInstance{
    static UserDataCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserDataCenter alloc] init];
    });
    
    return instance;
}


//
- (NSInteger)gameLevel{
    
    NSString *levelStr = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_CURRENT_LEVEL];
    NSInteger currentLevel = [levelStr integerValue];
    if (currentLevel == 0) {
        currentLevel = 1;
    }
    
    return currentLevel;
}


- (void)setGameLevel:(NSInteger)level{
    [[NSUserDefaults standardUserDefaults] setObject:@(level) forKey:USERDEFAULT_CURRENT_LEVEL];
    NSInteger userTopLevel = [self userTopLevel];
    if (userTopLevel < level) {
        [self setUserTopLevel:level];
    }
}


- (NSInteger)userTopLevel{
    NSString *userTopLevelStr = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_USER_TOP_LEVEL];
    NSInteger userTopLevel = [userTopLevelStr integerValue];
    return userTopLevel == 0? 1:userTopLevel;
}

- (void)setUserTopLevel:(NSInteger)level{
    [[NSUserDefaults standardUserDefaults] setObject:@(level) forKey:USERDEFAULT_USER_TOP_LEVEL];
}



@end
