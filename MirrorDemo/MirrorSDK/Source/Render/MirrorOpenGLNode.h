//
//  MirrorOpenGLNode.h
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MirrorOpenGLFrameBuffer.h"
#import "MirrorOpenGLContext.h"

void runSynchronousOnContextQueue(void (^block)(void));
void runAsynchronousOnContextQueue(void (^block)(void));
void runAsynchronousOnMainQueue(void (^block)(void));

@interface MirrorOpenGLNode : NSObject {
@private
    NSMutableArray *_targets;
    NSMutableArray *_targetTextureIndices;
    MirrorOpenGLFrameBuffer *_outputFramebuffer;
    BOOL _allTargetsWantMonochromeData;
    NSRecursiveLock *_dataLock;
}

@property (readwrite, nonatomic) MirrorTextureOptions outputTextureOptions;
@property (nonatomic,strong) MirrorOpenGLFrameBuffer *outputFramebuffer;
@property (nonatomic,readonly) NSMutableArray *targetTextureIndices;
@property (readwrite, nonatomic, unsafe_unretained) id<MirrorOpenGLProtocol> targetToIgnoreForUpdates;

/** Returns an array of the current targets.
 */
- (NSArray *)targets;
- (void)addTarget:(id<MirrorOpenGLProtocol>)newTarget;

@end
