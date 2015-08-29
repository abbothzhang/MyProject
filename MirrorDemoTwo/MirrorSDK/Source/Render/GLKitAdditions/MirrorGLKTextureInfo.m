//
//  MirrorGLKTextureInfo.m
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import "MirrorGLKTextureInfo.h"

@implementation MirrorGLKTextureInfo

@synthesize name = _name, target = _target, width = _width, height = _height, alphaState = _alphaState, textureOrigin = _textureOrigin, containsMipmaps = _containsMipmaps;

- (id)initWithName:(GLuint)name target:(GLenum)target width:(GLuint)width height:(GLuint)height
{
    self = [super init];
    if (self) {
        _name = name;
        _target = target;
        _width = width;
        _height = height;
    }
    return self;
}

@end
