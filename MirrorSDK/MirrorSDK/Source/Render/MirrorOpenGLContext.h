//
//  MirrorOpenGLContext.h
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@class MirrorOpenGLFrameBufferCache;
@class MirrorOpenGLFrameBuffer;
@class MirrorGLKProgram;

#define MirrorImageRotationSwapsWidthAndHeight(rotation) ((rotation) == kMirrorImageRotateLeft || (rotation) == kMirrorImageRotateRight || (rotation) == kMirrorImageRotateRightFlipVertical || (rotation) == kMirrorImageRotateRightFlipHorizontal)

typedef enum {
    kMirrorImageNoRotation,
    kMirrorImageRotateLeft,
    kMirrorImageRotateRight,
    kMirrorImageFlipVertical,
    kMirrorImageFlipHorizonal,
    kMirrorImageRotateRightFlipVertical,
    kMirrorImageRotateRightFlipHorizontal,
    kMirrorImageRotate180
}MirrorImageRotationMode;

@protocol MirrorOpenGLProtocol <NSObject>

@optional

- (void)inputSampleBuffer:(CMSampleBufferRef)sampleBuffer;//
- (void)setInputFramebuffer:(MirrorOpenGLFrameBuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
- (void)setInputRotation:(MirrorImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
- (BOOL)wantsMonochromeInput;
- (void)setCurrentMonochromeInput:(BOOL)newValue;
- (void)inputFramebufferAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
- (NSInteger)nextAvailableTextureIndex;
- (BOOL)shouldIgnoreUpdatesToThisTarget;
- (BOOL)shouldUpdatesSimpleBufferToThisTarget;
- (BOOL)enabled;
- (void)didEndProcessing;

@end

@interface MirrorOpenGLContext : NSObject {
@private
    dispatch_queue_t _contextQueue;
    EAGLContext *_context;
    CVOpenGLESTextureCacheRef _videoTextureCache;
    MirrorOpenGLFrameBufferCache *_framebufferCache;
}

@property (readonly, nonatomic) dispatch_queue_t contextQueue;
@property (readonly, retain, nonatomic) EAGLContext *context;
@property (readonly, nonatomic) CVOpenGLESTextureCacheRef videoTextureCache;
@property (readonly, retain, nonatomic) MirrorOpenGLFrameBufferCache *framebufferCache;
@property (readwrite, retain, nonatomic) MirrorGLKProgram *currentProgram;

+ (MirrorOpenGLContext *)sharedContext;
- (void)setCurrentContext;
+ (BOOL)supportsFastTextureUpload;
+ (void)setActiveProgram:(MirrorGLKProgram *)program;
+ (BOOL)deviceSupportsRedTextures;
+ (const GLfloat *)textureCoordinatesForRotation:(MirrorImageRotationMode)rotationMode;
- (void)clearResource;

@end
