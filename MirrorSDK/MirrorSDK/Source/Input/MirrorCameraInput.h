//
//  MirrorCameraInput.h
//  MirrorSDK
//
//  Created by 龙冥 on 5/26/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <mach/host_info.h>
#import <mach/mach.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "MirrorOpenGLContext.h"
#import "MirrorOpenGLNode.h"

@class MirrorCameraInput;

@protocol MirrorCameraInputDelegate <NSObject>

@optional

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)videoCamera:(MirrorCameraInput *)camera didUpdateSecondsPerFrame:(NSTimeInterval)secondsPerFrame;//
- (void)videoCameraDidBeginAdjustingFocus:(MirrorCameraInput *)camera;
- (void)videoCameraDidFinishAdjustingFocus:(MirrorCameraInput *)camera;
- (void)videoCameraDidBeginAdjustingExposure:(MirrorCameraInput *)camera;
- (void)videoCameraDidFinishAdjustingExposure:(MirrorCameraInput *)camera;
- (void)videoCameraDidBeginAdjustingWhiteBalance:(MirrorCameraInput *)camera;
- (void)videoCameraDidFinishAdjustingWhiteBalance:(MirrorCameraInput *)camera;

@end

@interface MirrorCameraInput : MirrorOpenGLNode <AVCaptureVideoDataOutputSampleBufferDelegate> {
@private
    dispatch_queue_t _cameraQueue;
    dispatch_semaphore_t _frameRenderingSemaphore;
    const GLfloat *_preferConver;
    __weak id<MirrorCameraInputDelegate> _delegate;
    GLuint _luminanceTexture, _chrominanceTexture;
    MirrorImageRotationMode _outputRotation,_internalRotation;
    BOOL _captureAsYUV;
}

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (assign, nonatomic) size_t videoWidth, videoHeight;
@property (nonatomic, assign) BOOL waitForFocus; // only takes a photo after the camera stops adjusting focus in takeAPhotoWithCompletion:
@property (nonatomic, assign) AVCaptureFlashMode flashMode;
@property (nonatomic, assign, getter = isRendering) BOOL rendering;
@property (nonatomic, assign, getter = isCapturing) BOOL capturing;
@property (nonatomic, readonly) BOOL hasTorch;
@property (nonatomic, readonly) BOOL focusPointSupported;
@property (nonatomic, readonly) BOOL exposurePointSupported;
@property (nonatomic, readonly) BOOL lowLightBoostSupported;
@property (nonatomic, readonly) BOOL lowLightBoostEnabled;
@property (nonatomic, readonly) NSTimeInterval secondsPerFrame;//spf
@property (nonatomic, assign) BOOL updateSecondsPerFrame;
@property (nonatomic, weak) id<MirrorCameraInputDelegate> delegate;
/// This determines the rotation applied to the output image, based on the source material
@property (readwrite, nonatomic) UIInterfaceOrientation cameraOrientation;
/// These properties determine whether or not the two camera orientations should be mirrored. By default, both are NO.
@property (readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera;
@property (nonatomic,assign) AVCaptureDevicePosition cameraPosition;

//这个方法暂时还没用到
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition;
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition captureAsYUV:(BOOL)captureAsYUV;
- (void)startCapturing;
- (void)stopCapturing;
- (void)setFocusPoint:(CGPoint)focusPoint;
- (void)takeAPhotoWithCompletion:(void (^)(UIImage *))completion;

@end
