//
//  MirrorGLKShaderVariable.m
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import "MirrorGLKShaderVariable.h"
@import OpenGLES;

GLint MirrorTypeSizeForType(GLenum type);

@implementation MirrorGLKShaderVariable

@synthesize name = _name;
@synthesize size = _size;
@synthesize type = _type;
@synthesize typeSize = _typeSize;
@synthesize location = _location;

- (id)initWithName:(NSString *)name location:(GLint)location size:(GLint)size type:(GLenum)type
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _location = location;
        _size = size;
        _type = type;
        _typeSize = MirrorTypeSizeForType(self.type);
    }
    return self;
}

@end

GLint MirrorTypeSizeForType(GLenum type)
{
    GLint size = 0;
    
    switch (type) {
        case GL_FLOAT:
            size = GL_FLOAT_SIZE;
            break;
            
        case GL_FLOAT_VEC2:
            size = GL_FLOAT_VEC2_SIZE;
            break;
            
        case GL_FLOAT_VEC3:
            size = GL_FLOAT_VEC3_SIZE;
            break;
            
        case GL_FLOAT_VEC4:
            size = GL_FLOAT_VEC4_SIZE;
            break;
            
        case GL_INT:
            size = GL_INT_SIZE;
            break;
            
        case GL_INT_VEC2:
            size = GL_INT_VEC2_SIZE;
            break;
            
        case GL_INT_VEC3:
            size = GL_INT_VEC3_SIZE;
            break;
            
        case GL_INT_VEC4:
            size = GL_INT_VEC4_SIZE;
            break;
            
        case GL_BOOL:
            size = GL_BOOL_SIZE;
            break;
            
        case GL_BOOL_VEC2:
            size = GL_BOOL_VEC2_SIZE;
            break;
            
        case GL_BOOL_VEC3:
            size = GL_BOOL_VEC3_SIZE;
            break;
            
        case GL_BOOL_VEC4:
            size = GL_BOOL_VEC4_SIZE;
            break;
            
        case GL_FLOAT_MAT2:
            size = GL_FLOAT_MAT2_SIZE;
            break;
            
        case GL_FLOAT_MAT3:
            size = GL_FLOAT_MAT3_SIZE;
            break;
            
        case GL_FLOAT_MAT4:
            size = GL_FLOAT_MAT4_SIZE;
            break;
            
        case GL_SAMPLER_2D:
            size = GL_SAMPLER_2D_SIZE;
            break;
            
        case GL_SAMPLER_CUBE:
            size = GL_SAMPLER_CUBE_SIZE;
            break;
            
        default:
            break;
    }
    
    return size;
}
