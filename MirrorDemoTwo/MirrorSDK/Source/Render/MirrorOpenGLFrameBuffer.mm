//
//  MirrorOpenGLFrameBuffer.m
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import "MirrorOpenGLFrameBuffer.h"
#import "MirrorOpenGLContext.h"
#import "MirrorOpenGLFrameBufferCache.h"
#import "MirrorOpenGLNode.h"

@interface MirrorOpenGLFrameBuffer ()

- (void)createFramebuffer;
- (void)createTexture;

@end

@implementation MirrorOpenGLFrameBuffer

@synthesize bufferSize = _bufferSize;
@synthesize textureOptions = _textureOptions;
@synthesize texture = _texture;
@synthesize missingFramebuffer = _missingFramebuffer;

- (id)initWithSize:(CGSize)bufferSize textureOptions:(MirrorTextureOptions)textureOptions onlyTexture:(BOOL)onlyGenerateTexture
{
    if (self = [super init])
    {
        _textureOptions = textureOptions;
        _bufferSize = bufferSize;
        _referenceCountingDisabled = NO;
        _missingFramebuffer = onlyGenerateTexture;
        if (_missingFramebuffer)
        {
            runSynchronousOnContextQueue(^{
                [[MirrorOpenGLContext sharedContext] setCurrentContext];
                [self createTexture];
                _framebuffer = 0;
            });
        }
        else
        {
            [self createFramebuffer];
        }
    }
    return self;
}

- (void)createFramebuffer;
{
    runSynchronousOnContextQueue(^{
        [[MirrorOpenGLContext sharedContext] setCurrentContext];
        
        glGenFramebuffers(1, &_framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
        
        // By default, all framebuffers on iOS 5.0+ devices are backed by texture caches, using one shared cache
        if ([MirrorOpenGLContext supportsFastTextureUpload])
        {
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
            CVOpenGLESTextureCacheRef videoTextureCache = [[MirrorOpenGLContext sharedContext] videoTextureCache];
            CFDictionaryRef empty; // empty value for attr value.
            CFMutableDictionaryRef attrs;
            empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks); // our empty IOSurface properties dictionary
            attrs = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
            CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
            
            CVReturn err = CVPixelBufferCreate(kCFAllocatorDefault, (int)_bufferSize.width, (int)_bufferSize.height, kCVPixelFormatType_32BGRA, attrs, &_renderTarget);
            if (err)
            {
                NSLog(@"FBO size: %f, %f", _bufferSize.width, _bufferSize.height);
                //NSAssert(NO, @"Error at CVPixelBufferCreate %d", err);
            }
            err = CVOpenGLESTextureCacheCreateTextureFromImage (kCFAllocatorDefault, videoTextureCache,
                                                                _renderTarget,
                                                                NULL, // texture attributes
                                                                GL_TEXTURE_2D,
                                                                _textureOptions.internalFormat, // opengl format
                                                                (int)_bufferSize.width,
                                                                (int)_bufferSize.height,
                                                                _textureOptions.format, // native iOS format
                                                                _textureOptions.type,
                                                                0,
                                                                &_renderTexture);
            if (err)
            {
                //NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
            }
            
            CFRelease(attrs);
            CFRelease(empty);
            
            glBindTexture(CVOpenGLESTextureGetTarget(_renderTexture), CVOpenGLESTextureGetName(_renderTexture));
            _texture = CVOpenGLESTextureGetName(_renderTexture);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, _textureOptions.wrapS);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, _textureOptions.wrapT);
            
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(_renderTexture), 0);
#endif
        }
        else
        {
            [self createTexture];
            
            glBindTexture(GL_TEXTURE_2D, _texture);
            
            glTexImage2D(GL_TEXTURE_2D, 0, _textureOptions.internalFormat, (int)_bufferSize.width, (int)_bufferSize.height, 0, _textureOptions.format, _textureOptions.type, 0);
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture, 0);
        }
        
#ifndef NS_BLOCK_ASSERTIONS
        GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        //NSAssert(status == GL_FRAMEBUFFER_COMPLETE, @"Incomplete filter FBO: %d", status);
#endif
        
        glBindTexture(GL_TEXTURE_2D, 0);
    });
}

- (void)createTexture;
{
    glActiveTexture(GL_TEXTURE1);
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, _textureOptions.minFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, _textureOptions.magFilter);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, _textureOptions.wrapS);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, _textureOptions.wrapT);
    
    // TODO: Handle mipmaps
}

- (void)activateFramebuffer;
{
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glViewport(0, 0, (int)_bufferSize.width, (int)_bufferSize.height);
}

- (void)destroyFramebuffer;
{
    runSynchronousOnContextQueue(^{
        [[MirrorOpenGLContext sharedContext] setCurrentContext];
        if (_framebuffer) {
            glDeleteFramebuffers(1, &_framebuffer);
            _framebuffer = 0;
        }
        if ([MirrorOpenGLContext supportsFastTextureUpload] && (!_missingFramebuffer)) {
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
            if (_renderTarget) {
                CFRelease(_renderTarget);
                _renderTarget = NULL;
            }
            if (_renderTexture) {
                CFRelease(_renderTexture);
                _renderTexture = NULL;
            }
#endif
        }
        else
        {
            glDeleteTextures(1, &_texture);
        }
    });
}

- (GLuint)texture;
{
    return _texture;
}

- (void)dealloc
{
    [self destroyFramebuffer];
}

#pragma mark -
#pragma mark Reference counting

- (void)lock;
{
    if (_referenceCountingDisabled)
    {
        return;
    }
    _referenceCount++;
}

- (void)unlock;
{
    if (_referenceCountingDisabled)
    {
        return;
    }
    
    NSAssert(_referenceCount > 0, @"Tried to overrelease a framebuffer, did you forget to call -useNextFrameForImageCapture before using -imageFromCurrentFramebuffer?");
    _referenceCount--;
    if (_referenceCount < 1) {
        [[MirrorOpenGLContext sharedContext].framebufferCache returnFramebufferToCache:self];
    }
}

- (void)clearAllLocks;
{
    _referenceCount = 0;
}

- (void)disableReferenceCounting;
{
    _referenceCountingDisabled = YES;
}

- (void)enableReferenceCounting;
{
    _referenceCountingDisabled = NO;
}

@end
