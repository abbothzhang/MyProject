//
//  MirrorGLKTextureInfo.h
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface MirrorGLKTextureInfo : GLKTextureInfo

@property (assign) GLuint                     name;
@property (assign) GLenum                     target;
@property (assign) GLuint                     width;
@property (assign) GLuint                     height;
@property (assign) GLKTextureInfoAlphaState   alphaState;
@property (assign) GLKTextureInfoOrigin       textureOrigin;
@property (assign) BOOL                       containsMipmaps;

- (id)initWithName:(GLuint)name target:(GLenum)target width:(GLuint)width height:(GLuint)height;

@end
