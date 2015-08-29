//
//  MirrorGLKProgram.h
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MirrorGLKUniform.h"
#import "MirrorGLKAttribute.h"
#import "MirrorGLKTexture.h"

/**
 * Error domain.
 */
extern NSString *const MirrorGLKProgramErrorDomain;

/**
 * Error codes.
 */
enum {
    MirrorGLKProgramErrorFailedToCreateShader = 0,
    MirrorGLKProgramErrorCompilationFailed = 1,
    MirrorGLKProgramErrorLinkFailed = 2
};

/**
 * The class that is missing in GLKit.
 * Encapsulates a GPU program.封装
 * Its interface is based on the GLKBaseEffect class.
 */
@interface MirrorGLKProgram : NSObject

@property (readonly, copy, nonatomic) NSDictionary *attributes;
@property (readonly, nonatomic) GLuint program;

+ (MirrorGLKProgram *)defaultProgram;
+ (MirrorGLKProgram *)defaultYUVProgram;
- (id)initWithVertexShaderFromFile:(NSString *)vertexShaderPath fragmentShaderFromFile:(NSString *)fragmentShaderPath error:(NSError *__autoreleasing *)error;
- (id)initWithVertexShaderSource:(NSString *)vertexShaderSource fragmentShaderSource:(NSString *)fragmentShaderSource error:(NSError *__autoreleasing *)error;
- (void)setValue:(void *)value forUniformNamed:(NSString *)uniform;
- (void)bindSamplerNamed:(NSString *)samplerName toXBTexture:(MirrorGLKTexture *)texture unit:(GLint)unit;
- (void)bindSamplerNamed:(NSString *)samplerName toTexture:(GLuint)texture unit:(GLint)unit;
- (void)prepareToDraw;
- (void)active;
- (GLuint)uniformIndex:(NSString *)uniformName;
- (GLuint)attributeIndex:(NSString *)attributeName;

@end
