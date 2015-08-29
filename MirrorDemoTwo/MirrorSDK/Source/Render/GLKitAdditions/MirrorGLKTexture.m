//
//  MirrorGLKTexture.m
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import "MirrorGLKTexture.h"
#import "MirrorGLKTextureInfo.h"
@import OpenGLES;

@implementation MirrorGLKTexture

@synthesize textureInfo = _textureInfo;
@synthesize wrapSMode = _wrapSMode;
@synthesize wrapTMode = _wrapTMode;
@synthesize minFilter = _minFilter;
@synthesize magFilter = _magFilter;

- (id)initWithTextureInfo:(GLKTextureInfo *)textureInfo
{
    self = [super init];
    if (self) {
        _textureInfo = [textureInfo copy];
        [self setDefaults];
    }
    return self;
}

- (id)initWithContentsOfFile:(NSString *)path options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:error];
    
    if (textureInfo == nil) {
        self = nil;
        return nil;
    }
    
    return [self initWithTextureInfo:textureInfo];
}

- (id)initWithWidth:(GLsizei)width height:(GLsizei)height data:(GLvoid *)data
{
    self = [super init];
    if (self) {
        GLuint name;
        glGenTextures(1, &name);
        glBindTexture(GL_TEXTURE_2D, name);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);
        _textureInfo = [[MirrorGLKTextureInfo alloc] initWithName:name target:GL_TEXTURE_2D width:width height:height];
        [self setDefaults];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:error];
    
    if (textureInfo == nil) {
        self = nil;
        return nil;
    }
    
    return [self initWithTextureInfo:textureInfo];
}


- (void)dealloc
{
    GLuint name = self.textureInfo.name;
    glDeleteTextures(1, &name);
}

#pragma mark - Properties

- (void)setWrapSMode:(MirrorGLKTextureWrapMode)wrapSMode
{
    if (wrapSMode == _wrapSMode) {
        return;
    }
    
    _wrapSMode = wrapSMode;
    glBindTexture(self.textureInfo.target, self.textureInfo.name);
    glTexParameteri(self.textureInfo.target, GL_TEXTURE_WRAP_S, [self convertWrapMode:_wrapSMode]);
}

- (void)setWrapTMode:(MirrorGLKTextureWrapMode)wrapTMode
{
    if (wrapTMode == _wrapTMode) {
        return;
    }
    
    _wrapTMode = wrapTMode;
    glBindTexture(self.textureInfo.target, self.textureInfo.name);
    glTexParameteri(self.textureInfo.target, GL_TEXTURE_WRAP_T, [self convertWrapMode:_wrapSMode]);
}

- (void)setMinFilter:(MirrorGLKTextureMinFilter)minFilter
{
    if (minFilter == _minFilter) {
        return;
    }
    
    _minFilter = minFilter;
    glBindTexture(self.textureInfo.target, self.textureInfo.name);
    glTexParameteri(self.textureInfo.target, GL_TEXTURE_MIN_FILTER, [self convertMinFilter:_minFilter]);
}

- (void)setMagFilter:(MirrorGLKTextureMagFilter)magFilter
{
    if (magFilter == _magFilter) {
        return;
    }
    
    _magFilter = magFilter;
    glBindTexture(self.textureInfo.target, self.textureInfo.name);
    glTexParameteri(self.textureInfo.target, GL_TEXTURE_MAG_FILTER, [self convertMagFilter:_magFilter]);
}

#pragma mark - Methods

- (GLint)convertWrapMode:(MirrorGLKTextureWrapMode)wrapMode
{
    switch (wrapMode) {
        case MirrorGLKTextureWrapModeRepeat:
            return GL_REPEAT;
            
        case MirrorGLKTextureWrapModeClamp:
            return GL_CLAMP_TO_EDGE;
            
        case MirrorGLKTextureWrapModeMirroredRepeat:
            return GL_MIRRORED_REPEAT;
    }
}

- (GLint)convertMinFilter:(MirrorGLKTextureMinFilter)minFilter
{
    switch (minFilter) {
        case MirrorGLKTextureMinFilterLinear:
            return GL_LINEAR;
            
        case MirrorGLKTextureMinFilterNearestMipmapLinear:
            return GL_NEAREST_MIPMAP_LINEAR;
            
        case MirrorGLKTextureMinFilterNearest:
            return GL_NEAREST;
            
        case MirrorGLKTextureMinFilterLinearMipmapLinear:
            return GL_LINEAR_MIPMAP_LINEAR;
            
        case MirrorGLKTextureMinFilterLinearMipmapNearest:
            return GL_LINEAR_MIPMAP_NEAREST;
            
        case MirrorGLKTextureMinFilterNearestMipmapNearest:
            return GL_NEAREST_MIPMAP_NEAREST;
    }
}

- (GLint)convertMagFilter:(MirrorGLKTextureMagFilter)magFilter
{
    switch (magFilter) {
        case MirrorGLKTextureMagFilterLinear:
            return GL_LINEAR;

        case MirrorGLKTextureMagFilterNearest:
            return GL_NEAREST;
    }
}

- (void)setDefaults
{
    _wrapSMode = MirrorGLKTextureWrapModeRepeat;
    _wrapTMode = MirrorGLKTextureWrapModeRepeat;
    _minFilter = MirrorGLKTextureMinFilterNearestMipmapLinear;
    _magFilter = MirrorGLKTextureMagFilterLinear;
}

@end
