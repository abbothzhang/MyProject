//
//  MirrorOpenGLFrameBufferCache.h
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MirrorOpenGLFrameBuffer.h"

@interface MirrorOpenGLFrameBufferCache : NSObject {
@private
    NSMutableDictionary *_framebufferCache;
    NSMutableDictionary *_framebufferTypeCounts;
    NSMutableArray *_activeImageCaptureList; // Where framebuffers that may be lost by a filter, but which are still needed for a UIImage, etc., are stored
    id _memoryWarningObserver;
    
    dispatch_queue_t _framebufferCacheQueue;
}

- (MirrorOpenGLFrameBuffer *)fetchFramebufferForSize:(CGSize)framebufferSize textureOptions:(MirrorTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture;
- (MirrorOpenGLFrameBuffer *)fetchFramebufferForSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;
- (void)returnFramebufferToCache:(MirrorOpenGLFrameBuffer *)framebuffer;
- (void)purgeAllUnassignedFramebuffers;

@end
