//
//  TBMirrorViewController_Private.h
//  TBMirror
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TBMirrorViewController() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, weak) id<TBMirrorViewControllerDelegate> delegate;
@property (nonatomic, assign) TBMirrorMakeUpType type;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

@property (nonatomic, assign) BOOL isFrontCamera;

- (void)setupView;

- (void)releaseCamera;

@end
