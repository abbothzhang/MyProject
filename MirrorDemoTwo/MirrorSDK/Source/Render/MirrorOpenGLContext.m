//
//  MirrorOpenGLContext.m
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import "MirrorOpenGLContext.h"
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/glext.h>
#import "MirrorGLKProgram.h"
#import "SynthesizeSingleton.h"
#import "MirrorOpenGLFrameBufferCache.h"

@implementation MirrorOpenGLContext

SYNTHESIZE_SINGLETON_FOR_CLASS (MirrorOpenGLContext)

@synthesize context = _context;
@synthesize contextQueue = _contextQueue;
@synthesize videoTextureCache = _videoTextureCache;
@synthesize currentProgram = _currentProgram;
@synthesize framebufferCache = _framebufferCache;

- (id)init {
    if (self = [super init]) {
        _contextQueue = dispatch_queue_create("com.MirrorOpenGLESContextQueue", NULL);
    }
    return self;
}

+ (EAGLContext *)newContext
{
    static EAGLSharegroup *sharegroup = nil;//EAGLSharegroup???
    if (sharegroup == nil) {
        EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        sharegroup = context.sharegroup;
        return context;
    }
    else {
        return [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:sharegroup];
    }
}

- (EAGLContext *)context;
{
    if (_context == nil)
    {
        _context = [MirrorOpenGLContext newContext];
        [EAGLContext setCurrentContext:_context];
        // Set up a few global settings for the image processing pipeline
        glDisable(GL_DEPTH_TEST);
    }
    return _context;
}

+ (MirrorOpenGLContext *)sharedContext {
    return [MirrorOpenGLContext sharedMirrorOpenGLContext];
}

- (void)setCurrentContext {
    EAGLContext *glContext = [self context];
    if ([EAGLContext currentContext] != glContext)
    {
        [EAGLContext setCurrentContext:glContext];
    }
}

- (CVOpenGLESTextureCacheRef)videoTextureCache;
{
    if (_videoTextureCache == NULL)
    {
#if defined(__IPHONE_6_0)
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [self context], NULL, &_videoTextureCache);
#else
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, (__bridge void *)[self context], NULL, &_videoTextureCache);
#endif
        if (err)
        {
            NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreate %d", err);
        }
    }
    return _videoTextureCache;
}

+ (BOOL)supportsFastTextureUpload;
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
    return (CVOpenGLESTextureCacheCreate != NULL);
#pragma clang diagnostic pop
    
#endif
}

- (void)setContextProgram:(MirrorGLKProgram *)program {
    EAGLContext *glContext = [self context];
    if ([EAGLContext currentContext] != glContext) {
        [EAGLContext setCurrentContext:glContext];
    }    
    if (self.currentProgram != program)
    {
        self.currentProgram = program;
        [self.currentProgram active];
    }
}

+ (void)setActiveProgram:(MirrorGLKProgram *)program
{
    [[MirrorOpenGLContext sharedContext] setContextProgram:program];
}

+ (BOOL)deviceSupportsOpenGLESExtension:(NSString *)extension
{
    static dispatch_once_t pred;
    static NSArray *extensionNames = nil;
    
    // Cache extensions for later quick reference, since this won't change for a given device
    dispatch_once(&pred, ^{
        [[MirrorOpenGLContext sharedContext] setCurrentContext];
        NSString *extensionsString = [NSString stringWithCString:(const char *)glGetString(GL_EXTENSIONS) encoding:NSASCIIStringEncoding];
        extensionNames = [extensionsString componentsSeparatedByString:@" "];
    });
    return [extensionNames containsObject:extension];
}

//???
+ (BOOL)deviceSupportsRedTextures
{
    static dispatch_once_t pred;
    static BOOL supportsRedTextures = NO;
    dispatch_once(&pred, ^{
        supportsRedTextures = [MirrorOpenGLContext deviceSupportsOpenGLESExtension:@"GL_EXT_texture_rg"];
    });
    
    return supportsRedTextures;
}

- (MirrorOpenGLFrameBufferCache *)framebufferCache;
{
    if (_framebufferCache == nil) {
        _framebufferCache = [[MirrorOpenGLFrameBufferCache alloc] init];
    }
    return _framebufferCache;
}

- (void)clearResource {
    [_framebufferCache purgeAllUnassignedFramebuffers];
    [_framebufferCache release];
    _framebufferCache = nil;
    self.currentProgram = nil;
}

+ (const GLfloat *)textureCoordinatesForRotation:(MirrorImageRotationMode)rotationMode
{
    static const GLfloat noRotationTextureCoordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    static const GLfloat rotateLeftTextureCoordinates[] = {
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
    };
    
    static const GLfloat rotateRightTextureCoordinates[] = {
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
    };
    
    static const GLfloat verticalFlipTextureCoordinates[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };
    
    static const GLfloat horizontalFlipTextureCoordinates[] = {
        1.0f, 0.0f,
        0.0f, 0.0f,
        1.0f,  1.0f,
        0.0f,  1.0f,
    };
    
    static const GLfloat rotateRightVerticalFlipTextureCoordinates[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
    };
    
    static const GLfloat rotateRightHorizontalFlipTextureCoordinates[] = {
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
    };
    
    static const GLfloat rotate180TextureCoordinates[] = {
        1.0f, 1.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
    };
    
    switch(rotationMode)
    {
        case kMirrorImageNoRotation: return noRotationTextureCoordinates;
        case kMirrorImageRotateLeft: return rotateLeftTextureCoordinates;
        case kMirrorImageRotateRight: return rotateRightTextureCoordinates;
        case kMirrorImageFlipVertical: return verticalFlipTextureCoordinates;
        case kMirrorImageFlipHorizonal: return horizontalFlipTextureCoordinates;
        case kMirrorImageRotateRightFlipVertical: return rotateRightVerticalFlipTextureCoordinates;
        case kMirrorImageRotateRightFlipHorizontal: return rotateRightHorizontalFlipTextureCoordinates;
        case kMirrorImageRotate180: return rotate180TextureCoordinates;
    }
}

@end

