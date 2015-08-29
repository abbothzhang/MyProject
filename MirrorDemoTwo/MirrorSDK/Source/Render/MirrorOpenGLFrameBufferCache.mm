//
//  MirrorOpenGLFrameBufferCache.m
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import "MirrorOpenGLFrameBufferCache.h"
#import <UIKit/UIKit.h>
#import "MirrorOpenGLContext.h"
#import "MirrorOpenGLNode.h"

@implementation MirrorOpenGLFrameBufferCache

- (id)init;
{
    if (self = [super init])
    {
        _memoryWarningObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self purgeAllUnassignedFramebuffers];
        }];
        _framebufferCache = [[NSMutableDictionary alloc] init];
        _framebufferTypeCounts = [[NSMutableDictionary alloc] init];
        _activeImageCaptureList = [[NSMutableArray alloc] init];
        _framebufferCacheQueue = dispatch_queue_create("com.MirrorFramebufferCacheQueue", NULL);
    }
    return self;
}

- (NSString *)hashForSize:(CGSize)size textureOptions:(MirrorTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture;
{
    if (onlyTexture)
    {
        return [NSString stringWithFormat:@"%.1fx%.1f-%d:%d:%d:%d:%d:%d:%d-NOFB", size.width, size.height, textureOptions.minFilter, textureOptions.magFilter, textureOptions.wrapS, textureOptions.wrapT, textureOptions.internalFormat, textureOptions.format, textureOptions.type];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fx%.1f-%d:%d:%d:%d:%d:%d:%d", size.width, size.height, textureOptions.minFilter, textureOptions.magFilter, textureOptions.wrapS, textureOptions.wrapT, textureOptions.internalFormat, textureOptions.format, textureOptions.type];
    }
}

- (MirrorOpenGLFrameBuffer *)fetchFramebufferForSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;
{
    MirrorTextureOptions defaultTextureOptions;
    defaultTextureOptions.minFilter = GL_LINEAR;
    defaultTextureOptions.magFilter = GL_LINEAR;
    defaultTextureOptions.wrapS = GL_CLAMP_TO_EDGE;
    defaultTextureOptions.wrapT = GL_CLAMP_TO_EDGE;
    defaultTextureOptions.internalFormat = GL_RGBA;
    defaultTextureOptions.format = GL_BGRA;
    defaultTextureOptions.type = GL_UNSIGNED_BYTE;
    
    return [self fetchFramebufferForSize:framebufferSize textureOptions:defaultTextureOptions onlyTexture:onlyTexture];
}

- (MirrorOpenGLFrameBuffer *)fetchFramebufferForSize:(CGSize)framebufferSize textureOptions:(MirrorTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture
{
    __block MirrorOpenGLFrameBuffer *framebufferFromCache = nil;
    runSynchronousOnContextQueue(^{
        NSString *lookupHash = [self hashForSize:framebufferSize textureOptions:textureOptions onlyTexture:onlyTexture];
        NSNumber *numberOfMatchingTexturesInCache = [_framebufferTypeCounts objectForKey:lookupHash];
        NSInteger numberOfMatchingTextures = [numberOfMatchingTexturesInCache integerValue];
        
        if ([numberOfMatchingTexturesInCache integerValue] < 1)
        {
            // Nothing in the cache, create a new framebuffer to use
            framebufferFromCache = [[MirrorOpenGLFrameBuffer alloc] initWithSize:framebufferSize textureOptions:textureOptions onlyTexture:onlyTexture];
        }
        else
        {
            // Something found, pull the old framebuffer and decrement the count
            NSInteger currentTextureID = (numberOfMatchingTextures - 1);
            while ((framebufferFromCache == nil) && (currentTextureID >= 0))
            {
                NSString *textureHash = [NSString stringWithFormat:@"%@-%ld", lookupHash, (long)currentTextureID];
                framebufferFromCache = [_framebufferCache objectForKey:textureHash];
                // Test the values in the cache first, to see if they got invalidated behind our back
                if (framebufferFromCache != nil)
                {
                    // Withdraw this from the cache while it's in use
                    [_framebufferCache removeObjectForKey:textureHash];
                }
                currentTextureID--;
            }
            
            currentTextureID++;
            
            [_framebufferTypeCounts setObject:[NSNumber numberWithInteger:currentTextureID] forKey:lookupHash];
            
            if (framebufferFromCache == nil)
            {
                framebufferFromCache = [[MirrorOpenGLFrameBuffer alloc] initWithSize:framebufferSize textureOptions:textureOptions onlyTexture:onlyTexture];
            }
        }
    });
    
    [framebufferFromCache lock];
    return framebufferFromCache;
}

- (void)returnFramebufferToCache:(MirrorOpenGLFrameBuffer *)framebuffer
{
    [framebuffer clearAllLocks];
    
    runAsynchronousOnContextQueue(^{
        CGSize framebufferSize = framebuffer.bufferSize;
        MirrorTextureOptions framebufferTextureOptions = framebuffer.textureOptions;
        NSString *lookupHash = [self hashForSize:framebufferSize textureOptions:framebufferTextureOptions onlyTexture:framebuffer.missingFramebuffer];
        NSNumber *numberOfMatchingTexturesInCache = [_framebufferTypeCounts objectForKey:lookupHash];
        NSInteger numberOfMatchingTextures = [numberOfMatchingTexturesInCache integerValue];
        
        NSString *textureHash = [NSString stringWithFormat:@"%@-%ld", lookupHash, (long)numberOfMatchingTextures];
        [_framebufferCache setObject:framebuffer forKey:textureHash];
        [_framebufferTypeCounts setObject:[NSNumber numberWithInteger:(numberOfMatchingTextures + 1)] forKey:lookupHash];
    });
}

- (void)purgeAllUnassignedFramebuffers;
{
    runAsynchronousOnContextQueue(^{
        [_framebufferCache removeAllObjects];
        [_framebufferTypeCounts removeAllObjects];
        CVOpenGLESTextureCacheFlush([[MirrorOpenGLContext sharedContext] videoTextureCache], 0);
    });
}

@end
