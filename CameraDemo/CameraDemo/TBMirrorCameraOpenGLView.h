//
//  TBMirrorCameraOpenGLView.h
//  TBMirror
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <GLKit/GLKit.h>


@interface TBMirrorCameraOpenGLView : GLKView

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context cameraSize:(CGSize)cameraSize;

- (void)updateData:(unsigned char*)pYuvRet isFrontCamera:(BOOL)isFrontCamera;

@end
