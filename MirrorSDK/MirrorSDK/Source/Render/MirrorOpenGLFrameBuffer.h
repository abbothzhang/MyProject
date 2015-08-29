//
//  MirrorOpenGLFrameBuffer.h
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#else
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#endif

#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>

// FrameBuffer texture pixels format

typedef struct MirrorTextureOptions {
    
    GLenum minFilter;//???
    GLenum magFilter;//???
    GLenum wrapS;//???
    GLenum wrapT;//???
    GLenum internalFormat;//???
    GLenum format;//???
    GLenum type;//???
    
} MirrorTextureOptions;//???

@interface MirrorOpenGLFrameBuffer : NSObject {
@private
    GLuint _framebuffer;
    CVPixelBufferRef _renderTarget;
    CVOpenGLESTextureRef _renderTexture;
    //NSUInteger _lockCount;
    NSUInteger _referenceCount;
    BOOL _referenceCountingDisabled;
}

@property (nonatomic, readonly) CGSize bufferSize;
@property (nonatomic, readonly) MirrorTextureOptions textureOptions;
@property (nonatomic, readonly) GLuint texture;
@property (nonatomic, readonly) BOOL missingFramebuffer;

// Initialization and teardown
- (id)initWithSize:(CGSize)bufferSize textureOptions:(MirrorTextureOptions)textureOptions onlyTexture:(BOOL)onlyGenerateTexture;
- (void)activateFramebuffer;
- (void)enableReferenceCounting;
- (void)disableReferenceCounting;
- (void)clearAllLocks;
- (void)lock;
- (void)unlock;

@end
