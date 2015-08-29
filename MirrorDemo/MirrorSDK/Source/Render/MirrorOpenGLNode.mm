//
//  MirrorOpenGLNode.m
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import "MirrorOpenGLNode.h"
#import "MirrorOpenGLContext.h"

@interface MirrorOpenGLNode ()

@property (nonatomic, assign) CGSize cachedMaximumOutputSize;

@end

@implementation MirrorOpenGLNode

@synthesize outputTextureOptions = _outputTextureOptions;
@synthesize outputFramebuffer = _outputFramebuffer;
@synthesize targetTextureIndices = _targetTextureIndices;
@synthesize targetToIgnoreForUpdates = _targetToIgnoreForUpdates;
@synthesize cachedMaximumOutputSize = _cachedMaximumOutputSize;

- (id)init
{
    if (self = [super init]) {
        _targets = [[NSMutableArray alloc] init];
        _targetTextureIndices = [[NSMutableArray alloc] init];
        // set default texture options
        _outputTextureOptions.minFilter = GL_LINEAR;
        _outputTextureOptions.magFilter = GL_LINEAR;
        _outputTextureOptions.wrapS = GL_CLAMP_TO_EDGE;
        _outputTextureOptions.wrapT = GL_CLAMP_TO_EDGE;
        _outputTextureOptions.internalFormat = GL_RGBA;
        _outputTextureOptions.format = GL_BGRA;
        _outputTextureOptions.type = GL_UNSIGNED_BYTE;
        _dataLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (NSArray *)targets
{
    [_dataLock lock];
    NSArray *targets = [NSArray arrayWithArray:_targets];
    [_dataLock unlock];
    return targets;
}

- (MirrorOpenGLFrameBuffer *)framebufferForOutput
{
    return self.outputFramebuffer;
}

- (void)removeOutputFramebuffer
{
    self.outputFramebuffer = nil;
}

- (void)setInputFramebufferForTarget:(id<MirrorOpenGLProtocol>)target atIndex:(NSInteger)inputTextureIndex
{
    [target setInputFramebuffer:[self framebufferForOutput] atIndex:inputTextureIndex];
}

- (void)addTarget:(id<MirrorOpenGLProtocol>)newTarget
{
    [_dataLock lock];
    NSInteger nextAvailableTextureIndex = [newTarget nextAvailableTextureIndex];
    [self addTarget:newTarget atTextureLocation:nextAvailableTextureIndex];    
    if ([newTarget shouldIgnoreUpdatesToThisTarget]) {
        _targetToIgnoreForUpdates = newTarget;
    }
    [_dataLock unlock];
}

- (void)addTarget:(id<MirrorOpenGLProtocol>)newTarget atTextureLocation:(NSInteger)textureLocation
{
    if([_targets containsObject:newTarget]) {
        return;
    }
    
    self.cachedMaximumOutputSize = CGSizeZero;
    runSynchronousOnContextQueue(^{
        [self setInputFramebufferForTarget:newTarget atIndex:textureLocation];
        [_targets addObject:newTarget];
        [_targetTextureIndices addObject:[NSNumber numberWithInteger:textureLocation]];
        _allTargetsWantMonochromeData = _allTargetsWantMonochromeData && [newTarget wantsMonochromeInput];
    });
}

- (void)removeTarget:(id<MirrorOpenGLProtocol>)targetToRemove;
{
    if(![_targets containsObject:targetToRemove]) {
        return;
    }
    
    if (_targetToIgnoreForUpdates == targetToRemove)
    {
        _targetToIgnoreForUpdates = nil;
    }
    
    self.cachedMaximumOutputSize = CGSizeZero;
    
    NSInteger indexOfObject = [_targets indexOfObject:targetToRemove];
    NSInteger textureIndexOfTarget = [[_targetTextureIndices objectAtIndex:indexOfObject] integerValue];
    
    runSynchronousOnContextQueue(^{
        [targetToRemove setInputSize:CGSizeZero atIndex:textureIndexOfTarget];
        [targetToRemove setInputRotation:kMirrorImageNoRotation atIndex:textureIndexOfTarget];
        
        [_targetTextureIndices removeObjectAtIndex:indexOfObject];
        [_targets removeObject:targetToRemove];
        [targetToRemove didEndProcessing];
    });
}

- (void)removeAllTargets;
{
    self.cachedMaximumOutputSize = CGSizeZero;
    runSynchronousOnContextQueue(^{
        for (id<MirrorOpenGLProtocol> targetToRemove in _targets)
        {
            NSInteger indexOfObject = [_targets indexOfObject:targetToRemove];
            NSInteger textureIndexOfTarget = [[_targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            [targetToRemove setInputSize:CGSizeZero atIndex:textureIndexOfTarget];
            [targetToRemove setInputRotation:kMirrorImageNoRotation atIndex:textureIndexOfTarget];
        }
        [_targets removeAllObjects];
        [_targetTextureIndices removeAllObjects];
        
        _allTargetsWantMonochromeData = YES;
    });
}

- (void)dealloc
{
    [self removeAllTargets];
}

@end

void runSynchronousOnContextQueue(void (^block)(void))
{
    dispatch_queue_t contextQueue = [MirrorOpenGLContext sharedContext].contextQueue;
    if (dispatch_get_current_queue() == contextQueue) {
        block();
    }
    else {
        dispatch_sync(contextQueue, block);
    }
}

void runAsynchronousOnContextQueue(void (^block)(void)) {
    dispatch_queue_t contextQueue = [MirrorOpenGLContext sharedContext].contextQueue;
    if (dispatch_get_current_queue() == contextQueue) {
        block();
    }
    else {
        dispatch_async(contextQueue, block);
    }
}

void runAsynchronousOnMainQueue(void (^block)(void)) {
    dispatch_queue_t contextQueue = dispatch_get_main_queue();
    if (dispatch_get_current_queue() == contextQueue) {
        block();
    }
    else {
        dispatch_async(contextQueue, block);
    }
}
