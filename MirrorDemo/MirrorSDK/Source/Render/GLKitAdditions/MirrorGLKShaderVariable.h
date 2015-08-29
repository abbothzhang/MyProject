//
//  MirrorGLKShaderVariable.h
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#else
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#endif
/**
 * OpenGL data type sizes
 */
#define GL_FLOAT_SIZE           sizeof(GLfloat)
#define GL_FLOAT_VEC2_SIZE      2*sizeof(GLfloat)
#define GL_FLOAT_VEC3_SIZE      3*sizeof(GLfloat)
#define GL_FLOAT_VEC4_SIZE      4*sizeof(GLfloat)
#define GL_INT_SIZE             sizeof(GLint)
#define GL_INT_VEC2_SIZE        2*sizeof(GLint)
#define GL_INT_VEC3_SIZE        3*sizeof(GLint)
#define GL_INT_VEC4_SIZE        4*sizeof(GLint)
#define GL_BOOL_SIZE        	sizeof(GLint)
#define GL_BOOL_VEC2_SIZE   	2*sizeof(GLint)
#define GL_BOOL_VEC3_SIZE       3*sizeof(GLint)
#define GL_BOOL_VEC4_SIZE       4*sizeof(GLint)
#define GL_FLOAT_MAT2_SIZE      4*sizeof(GLfloat)
#define GL_FLOAT_MAT3_SIZE      9*sizeof(GLfloat)
#define GL_FLOAT_MAT4_SIZE      16*sizeof(GLfloat)
#define GL_SAMPLER_2D_SIZE      sizeof(GLint)
#define GL_SAMPLER_CUBE_SIZE    sizeof(GLint)

@interface MirrorGLKShaderVariable : NSObject

@property (readonly, copy, nonatomic) NSString *name;
@property (readonly, nonatomic) GLint location; //变量对应程序里的GLint ID标识值
@property (readonly, nonatomic) GLint size;
@property (readonly, nonatomic) GLenum type;
@property (readonly, nonatomic) GLint typeSize;

- (id)initWithName:(NSString *)name location:(GLint)location size:(GLint)size type:(GLenum)type;

@end