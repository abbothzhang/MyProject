//
//  MirrorOpenGLView.mm
//  MirrorSDK
//
//  Created by 龙冥 on 5/27/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "MirrorOpenGLView.h"
#import "MirrorOpenGLNode.h"
#import "MirrorGLKProgram.h"

@interface MirrorOpenGLView ()

@property (nonatomic, strong) MirrorGLKProgram *displayProgram;
@property (nonatomic, assign) GLuint framebuffer;
@property (nonatomic, assign) GLuint colorRenderbuffer;
@property (nonatomic, assign) CGSize boundsSizeAtFrameBuffer;
@property (nonatomic, assign) CGSize inputSize;
@property (nonatomic, strong) MirrorOpenGLFrameBuffer *inputFrameBuffer;
@property (copy, atomic) void (^takeAPhotoCompletion)(UIImage *image);

- (void)initializer;
- (void)createDisplayFramebuffer;
- (void)recalculateViewGeometry;

@end

@implementation MirrorOpenGLView

@synthesize sizeInPixels = _sizeInPixels;
@synthesize fillMode = _fillMode;
@synthesize enabled = _enabled;
@synthesize displayProgram = _displayProgram;
@synthesize framebuffer = _framebuffer;
@synthesize colorRenderbuffer = _colorRenderbuffer;
@synthesize boundsSizeAtFrameBuffer = _boundsSizeAtFrameBuffer;
@synthesize inputSize = _inputSize;
@synthesize inputFrameBuffer = _inputFrameBuffer;

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
        [self initializer];
    }
    return self;
}

- (void)initializer
{
    // Set scaling to account for Retina display
    if ([self respondsToSelector:@selector(setContentScaleFactor:)]) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
    }
    _inputRotation = kMirrorImageNoRotation;
    self.layer.opaque = YES;
    ((CAEAGLLayer *)self.layer).drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];

    self.enabled = YES;
    runSynchronousOnContextQueue(^{
        // set context
        [[MirrorOpenGLContext sharedContext] setCurrentContext];
        self.displayProgram = [MirrorGLKProgram defaultProgram];
        assert(self.displayProgram);
        [MirrorOpenGLContext setActiveProgram:self.displayProgram];
        glEnableVertexAttribArray([self.displayProgram attributeIndex:@"position"]);//开启顶点属性数组
        glEnableVertexAttribArray([self.displayProgram attributeIndex:@"inputTextureCoordinate"]);
        _fillMode = kMirrorImageFillModePreserveAspectRatio;
        [self createDisplayFramebuffer];
    });
}

- (void)destroyDisplayFramebuffer
{
    glDeleteFramebuffers(1, &_framebuffer);
    self.framebuffer = 0;
    
    glDeleteRenderbuffers(1, &_colorRenderbuffer);
    self.colorRenderbuffer = 0;
}

- (void)createDisplayFramebuffer
{
    [[MirrorOpenGLContext sharedContext] setCurrentContext];
    
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, self.framebuffer);
    
    glGenRenderbuffers(1, &_colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, self.colorRenderbuffer);
    
    [[MirrorOpenGLContext sharedContext].context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
    GLint backingWidth, backingHeight;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    if ((backingWidth == 0) || (backingHeight == 0)) {
        [self destroyDisplayFramebuffer];
        return;
    }
    
    _sizeInPixels.width = (CGFloat)backingWidth;
    _sizeInPixels.height = (CGFloat)backingHeight;
    
    //    NSLog(@"Backing width: %d, height: %d", backingWidth, backingHeight);
    //将创建的渲染缓冲区绑定到帧缓冲区上，并使用颜色填充
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.colorRenderbuffer);
    
    //GLuint framebufferCreationStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    //NSAssert(framebufferCreationStatus == GL_FRAMEBUFFER_COMPLETE, @"Failure with display framebuffer generation for display of size: %f, %f", self.bounds.size.width, self.bounds.size.height);
    self.boundsSizeAtFrameBuffer = self.bounds.size;
}

- (void)recalculateViewGeometry
{
    runSynchronousOnContextQueue(^{
        CGFloat heightScaling, widthScaling;
        CGSize currentViewSize = self.bounds.size;
        CGRect insetRect = AVMakeRectWithAspectRatioInsideRect(self.inputSize, self.bounds);
        
        switch(_fillMode)
        {
            case kMirrorImageFillModeStretch:
            {
                widthScaling = 1.0;
                heightScaling = 1.0;
                break;
            }
            case kMirrorImageFillModePreserveAspectRatio:
            {
                widthScaling = insetRect.size.width / currentViewSize.width;
                heightScaling = insetRect.size.height / currentViewSize.height;
                break;
            }
            case kMirrorImageFillModePreserveAspectRatioAndFill:
            {
                widthScaling = currentViewSize.height / insetRect.size.height;
                heightScaling = currentViewSize.width / insetRect.size.width;
                break;
            }
        }
        _imageVertices[0] = -widthScaling;
        _imageVertices[1] = -heightScaling;
        _imageVertices[2] = widthScaling;
        _imageVertices[3] = -heightScaling;
        _imageVertices[4] = -widthScaling;
        _imageVertices[5] = heightScaling;
        _imageVertices[6] = widthScaling;
        _imageVertices[7] = heightScaling;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // The frame buffer needs to be trashed and re-created when the view size changes.
    if (!CGSizeEqualToSize(self.bounds.size, self.boundsSizeAtFrameBuffer) &&
        !CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        runSynchronousOnContextQueue(^{
            [self destroyDisplayFramebuffer];
            [self createDisplayFramebuffer];
            [self recalculateViewGeometry];
        });
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    runSynchronousOnContextQueue(^{
        [self destroyDisplayFramebuffer];
    });
}

- (void)activeFramebuffer
{
    if (!self.framebuffer) {
        [self createDisplayFramebuffer];
    }
    glBindFramebuffer(GL_FRAMEBUFFER, self.framebuffer);
    glViewport(0, 0, (GLint)_sizeInPixels.width, (GLint)_sizeInPixels.height);
}

- (void)presentFramebuffer
{
    glBindRenderbuffer(GL_RENDERBUFFER, self.colorRenderbuffer);
    [[MirrorOpenGLContext sharedContext].context presentRenderbuffer:GL_RENDERBUFFER];//把缓冲区（render buffer和color buffer）的颜色呈现到UIView上
}

+ (const GLfloat *)textureCoordinatesForRotation:(MirrorImageRotationMode)rotationMode
{
    static const GLfloat noRotationTextureCoordinates[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f,
    };
    
    static const GLfloat rotateRightTextureCoordinates[] = {
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
    };
    
    static const GLfloat rotateLeftTextureCoordinates[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
    };
    
    static const GLfloat verticalFlipTextureCoordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    static const GLfloat horizontalFlipTextureCoordinates[] = {
        1.0f, 1.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
    };
    
    static const GLfloat rotateRightVerticalFlipTextureCoordinates[] = {
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
    };
    
    static const GLfloat rotateRightHorizontalFlipTextureCoordinates[] = {
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
    };
    
    static const GLfloat rotate180TextureCoordinates[] = {
        1.0f, 0.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
    };
    
    switch(rotationMode)
    {
        case kMirrorImageNoRotation: return noRotationTextureCoordinates;
        case kMirrorImageRotateLeft: return rotateLeftTextureCoordinates;
        case kMirrorImageRotateRight: return rotateRightTextureCoordinates;
        case kMirrorImageFlipVertical: return verticalFlipTextureCoordinates;
        case kMirrorImageFlipHorizonal: return horizontalFlipTextureCoordinates;
        case kMirrorImageRotateRightFlipVertical: return rotateRightVerticalFlipTextureCoordinates;
        case kMirrorImageRotateRightFlipHorizontal: return rotateRightHorizontalFlipTextureCoordinates;
        case kMirrorImageRotate180: return rotate180TextureCoordinates;
    }
}

- (UIImage *)snapshot
{
    GLint backingWidth, backingHeight;
    
    // Bind the color renderbuffer used to render the OpenGL ES view
    
    // If your application only creates a single color renderbuffer which is already bound at this point,
    
    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
    
    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    
    // Get the size of the backing CAEAGLLayer
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);    
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    // Read pixel data from the framebuffer
    
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels((int)x, (int)y, (int)width, (int)height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    // Create a CGImage with the pixel data
    
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    
    // otherwise, use kCGImageAlphaPremultipliedLast
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();    
    CGImageRef iref = CGImageCreate((int)width, (int)height, 8, 32, (int)width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,ref, NULL, true, kCGRenderingIntentDefault);
    
    // OpenGL ES measures data in PIXELS
    
    // Create a graphics context with the target size measured in POINTS
    
    NSInteger widthInPoints, heightInPoints;
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    
    // Set the scale parameter to your OpenGL ES view's contentScaleFactor
    
    // so that you get a high-resolution snapshot when its value is greater than 1.0
    
    CGFloat scale = self.contentScaleFactor;
    widthInPoints = width / scale;
    heightInPoints = height / scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    
    // Flip the CGImage by rendering it to the flipped bitmap context
    
    // The size of the destination area is measured in POINTS
    
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
    // Retrieve the UIImage from the current context
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Clean up
    
    free(data);    
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
    
    return image;
}

- (CGSize)maximumOutputSize
{
    if ([self respondsToSelector:@selector(setContentScaleFactor:)]) {
        CGSize pointSize = self.bounds.size;
        return CGSizeMake(self.contentScaleFactor * pointSize.width, self.contentScaleFactor * pointSize.height);
    }
    else
    {
        return self.bounds.size;
    }
}

//这个方法没有用到
- (CGSize)sizeInPixels
{
    if (CGSizeEqualToSize(_sizeInPixels, CGSizeZero))
    {
        return [self maximumOutputSize];
    }
    else
    {
        return _sizeInPixels;
    }
}

- (void)takeAPhotoWithCompletion:(void (^)(UIImage *))completion
{
    self.takeAPhotoCompletion = completion;
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    runSynchronousOnContextQueue(^{        
        glFinish();
    });
}

//- (void)inputSampleBuffer:(CMSampleBufferRef)sampleBuffer{}
//- (void)setInputFramebuffer:(MirrorOpenGLFrameBuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex{}
//- (void)setInputRotation:(MirrorImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex{}
//- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex{}
//- (BOOL)wantsMonochromeInput{}
//- (void)setCurrentMonochromeInput:(BOOL)newValue{}
//- (void)inputFramebufferAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex{}
//- (NSInteger)nextAvailableTextureIndex{}
//- (BOOL)shouldIgnoreUpdatesToThisTarget{}
//- (BOOL)shouldUpdatesSimpleBufferToThisTarget{}
//- (BOOL)enabled{}
//- (void)didEndProcessing{}

#pragma mark - MirrorOpenGLProtocol
- (void)inputSampleBuffer:(CMSampleBufferRef)sampleBuffer{}

- (void)setInputFramebuffer:(MirrorOpenGLFrameBuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex
{
    self.inputFrameBuffer = newInputFramebuffer;
    [newInputFramebuffer lock];
}

- (void)setInputRotation:(MirrorImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex
{
    _inputRotation = newInputRotation;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex
{
    runSynchronousOnContextQueue(^{
        CGSize rotatedSize = newSize;
        
        if (MirrorImageRotationSwapsWidthAndHeight(_inputRotation)) {
            rotatedSize.width = newSize.height;
            rotatedSize.height = newSize.width;
        }
        if (!CGSizeEqualToSize(_inputSize, rotatedSize))
        {
            self.inputSize = rotatedSize;
            [self recalculateViewGeometry];
        }
    });
}

- (BOOL)wantsMonochromeInput;
{
    return NO;
}

- (void)setCurrentMonochromeInput:(BOOL)newValue {
    
}

- (void)inputFramebufferAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex
{
    runSynchronousOnContextQueue(^{
        [MirrorOpenGLContext setActiveProgram:self.displayProgram];
        [self activeFramebuffer];
        assert(!glGetError());
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);//背景颜色为黑
        glClear(GL_COLOR_BUFFER_BIT);
        glActiveTexture(GL_TEXTURE4);
        assert(!glGetError());
        glBindTexture(GL_TEXTURE_2D,  [self.inputFrameBuffer texture]);
        glUniform1i([self.displayProgram uniformIndex:@"inputImageTexture"], 4);
        assert(!glGetError());
        glVertexAttribPointer([self.displayProgram attributeIndex:@"position"], 2, GL_FLOAT, 0, 0, _imageVertices);
        glVertexAttribPointer([self.displayProgram attributeIndex:@"inputTextureCoordinate"], 2, GL_FLOAT, 0, 0, [MirrorOpenGLView textureCoordinatesForRotation:_inputRotation]);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        assert(!glGetError());
        if (self.takeAPhotoCompletion) {
            UIImage *image = [self snapshot];
            runAsynchronousOnMainQueue (^ {
                self.takeAPhotoCompletion(image);
                self.takeAPhotoCompletion = nil;
            });
        }
        [self presentFramebuffer];
        [self.inputFrameBuffer unlock];
        self.inputFrameBuffer = nil;
    });
}

- (NSInteger)nextAvailableTextureIndex
{
    return 0;
}

- (BOOL)shouldIgnoreUpdatesToThisTarget
{
    return NO;
}

- (BOOL)shouldUpdatesSimpleBufferToThisTarget {
    return NO;
}

//- (BOOL)enabled;

- (void)didEndProcessing {
    
}

@end
