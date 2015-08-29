//
//  MainViewController.m
//  CameraDemo
//
//  Created by albert on 15/8/29.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>

#define TBMirror_Default_SessionPreset AVCaptureSessionPreset640x480

@interface MainViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

@property (nonatomic, assign) BOOL isFrontCamera;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    BOOL is = [self checkCamera];
//    [self setupCaptureSession];
    [self setupCamera];
}

// Create and configure a capture session and start it running
- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    

//    if (newDevice == nil) {
//        NSLog(@"TBPSOpenGLAVCamView: Failed to set camera position. No device found in the %@.", AVCaptureDevicePositionFront == AVCaptureDevicePositionFront? @"front": (AVCaptureDevicePositionFront == AVCaptureDevicePositionBack? @"back": @"unknown position"));
//        return;
//    }
    
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
        return;
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
//    dispatch_release(queue);
    
    // Specify the pixel format
    output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    output.minFrameDuration = CMTimeMake(1, 15);
    
    // Start the session running to start the flow of data
    [session startRunning];
    
    // Assign session to an ivar.
//    [self setSession:session];
}

- (void)setupCamera {
    if(![self checkCamera]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"请在iPhone的\"设置\"-\"隐私\"-\"相机\"选项中，允许手机淘宝访问您的相机"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 默认使用前置摄像头
    AVCaptureDevice *device = [self frontFacingCamera];
    self.isFrontCamera = YES;
    
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        // 前置摄像头无法使用尝试使用后置摄像头
        NSError *backCameraError = nil;
        videoInput = [AVCaptureDeviceInput deviceInputWithDevice:[self backFacingCamera] error:&backCameraError];
        self.isFrontCamera = NO;
        if (backCameraError) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"本设备没有支持的摄像头"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    self.session = [[AVCaptureSession alloc] init];
    
    if ( [self.session canAddInput:videoInput] ) {
        [self.session addInput:videoInput];
    }
    self.videoInput = videoInput;
    
    [self.session setSessionPreset:TBMirror_Default_SessionPreset];
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [videoDataOutput setVideoSettings:videoSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    self.videoDataOutputQueue = dispatch_queue_create("TBMirrorVideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    if ([self.session canAddOutput:videoDataOutput]) {
        [self.session addOutput:videoDataOutput];
    }
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    self.videoDataOutput = videoDataOutput;
    
    if ([device lockForConfiguration:&error]) {
        if ([device respondsToSelector:@selector(isLowLightBoostSupported)] && device.lowLightBoostSupported) {
            device.automaticallyEnablesLowLightBoostWhenAvailable = NO;
        }
        if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        }
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        [device unlockForConfiguration];
    }
}

-(BOOL)checkCamera {
    if ([AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count) {
        if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
            NSInteger status = (NSInteger)[[AVCaptureDevice class] performSelector:@selector(authorizationStatusForMediaType:)
                                                                        withObject:AVMediaTypeVideo];
            if(AVAuthorizationStatusAuthorized == status || AVAuthorizationStatusNotDetermined == status) {
                return YES;
            } else {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *) frontFacingCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *) backFacingCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"");
}


@end
