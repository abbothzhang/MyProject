//
//  MirrorGLKUniform.h
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MirrorGLKShaderVariable.h"

@interface MirrorGLKUniform : MirrorGLKShaderVariable

@property (assign, nonatomic) void *value;

@end
