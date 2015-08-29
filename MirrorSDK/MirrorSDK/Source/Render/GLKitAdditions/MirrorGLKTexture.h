//
//  MirrorGLKTexture.h
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef enum {
    MirrorGLKTextureWrapModeClamp,
    MirrorGLKTextureWrapModeRepeat,
    MirrorGLKTextureWrapModeMirroredRepeat
    
} MirrorGLKTextureWrapMode;

typedef enum {
    MirrorGLKTextureMinFilterNearest,
    MirrorGLKTextureMinFilterLinear,
    MirrorGLKTextureMinFilterNearestMipmapNearest,
    MirrorGLKTextureMinFilterLinearMipmapNearest,
    MirrorGLKTextureMinFilterNearestMipmapLinear,
    MirrorGLKTextureMinFilterLinearMipmapLinear
    
} MirrorGLKTextureMinFilter;

typedef enum {
    MirrorGLKTextureMagFilterNearest,
    MirrorGLKTextureMagFilterLinear
    
} MirrorGLKTextureMagFilter;

@interface MirrorGLKTexture : NSObject

@property (nonatomic, readonly) GLKTextureInfo *textureInfo;
@property (nonatomic, assign) MirrorGLKTextureWrapMode wrapSMode;
@property (nonatomic, assign) MirrorGLKTextureWrapMode wrapTMode;
@property (nonatomic, assign) MirrorGLKTextureMinFilter minFilter;
@property (nonatomic, assign) MirrorGLKTextureMagFilter magFilter;

- (id)initWithTextureInfo:(GLKTextureInfo *)textureInfo;
- (id)initWithContentsOfFile:(NSString *)path options:(NSDictionary *)options error:(NSError **)error; // samething as -[GLKTextureLoader initWithContentsOfFile:opetions:error:] or +[GLKTextureLoader textureWithContentsOfFile:opetions:error:]
- (id)initWithWidth:(GLsizei)width height:(GLsizei)height data:(GLvoid *)data;
- (id)initWithImage:(UIImage *)image options:(NSDictionary *)options error:(NSError *__autoreleasing *)error;

@end
