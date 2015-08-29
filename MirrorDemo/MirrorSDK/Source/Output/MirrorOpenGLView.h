//
//  MirrorOpenGLView.h
//  MirrorSDK
//
//  Created by 龙冥 on 5/27/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirrorOpenGLContext.h"
#import <GLKit/GLKit.h>

// 视频缩放填充模式
typedef enum {
    kMirrorImageFillModeStretch,                       // Stretch to fill the full view, which may distort the image outside of its normal aspect ratio
    kMirrorImageFillModePreserveAspectRatio,           // Maintains the aspect ratio of the source image, adding bars of the specified background color
    kMirrorImageFillModePreserveAspectRatioAndFill     // Maintains the aspect ratio of the source image, zooming in on its center to fill the view
} MirrorImageFillModeType;

@interface MirrorOpenGLView : GLKView <MirrorOpenGLProtocol> {
@private
    MirrorImageRotationMode _inputRotation;
    GLfloat _imageVertices[8]; // 顶点矩阵值
}

/** The fill mode dictates how images are fit in the view, with the default being kGPUImageFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) MirrorImageFillModeType fillMode;

/** This calculates the current display size, in pixels, taking into account Retina scaling factors
 */
@property(readonly, nonatomic) CGSize sizeInPixels;//

@property(nonatomic) BOOL enabled; //是否有效

- (void)takeAPhotoWithCompletion:(void (^)(UIImage *))completion;

@end
