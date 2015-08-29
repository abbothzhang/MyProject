//
//  MirrorMakeUpInput.m
//  MirrorSDK
//
//  Created by 龙冥 on 7/6/15.
//  Copyright (c) 2015 Taobao. All rights reserved.
//

#import "MirrorMakeUpInput.h"
#import "MirrorMakeUpCenter.h"

@implementation MirrorMakeUpInput

@synthesize enabled = _enabled;

- (id)init {
    if (self = [super init]) {
        self.enabled = YES;
    }
    return self;
}





#pragma mark - MirrorOpenGLProtocol
- (void)inputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    [[MirrorMakeUpCenter sharedCenter] inputSampleBuffer:sampleBuffer];
    
}
- (void)setInputFramebuffer:(MirrorOpenGLFrameBuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex{}
- (void)setInputRotation:(MirrorImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex{}
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex{}

- (BOOL)wantsMonochromeInput{
    return NO;
}
- (void)setCurrentMonochromeInput:(BOOL)newValue{}
- (void)inputFramebufferAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex{}

- (NSInteger)nextAvailableTextureIndex{
    return 0;
}
- (BOOL)shouldIgnoreUpdatesToThisTarget{
    return YES;
}
- (BOOL)shouldUpdatesSimpleBufferToThisTarget{
    return YES;
}
//- (BOOL)enabled{return <#expression#>}
- (void)didEndProcessing{}

@end
