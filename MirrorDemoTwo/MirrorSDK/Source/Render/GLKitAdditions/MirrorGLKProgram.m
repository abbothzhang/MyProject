//
//  MirrorGLKProgram.m
//  MirrorSDK
//
//  Created by 龙冥 on 3/4/15.
//  Copyright (c) 2015 Taobao.com. All rights reserved.
//

#import "MirrorGLKProgram.h"

// 定义渲染管道程序字符串宏
#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @STRINGIZE2(text)

// Hardcode the vertex shader for standard filters, but this can be overridden
//顶点着色器
NSString *const kMirrorImageVertexShaderString = SHADER_STRING
(
 attribute vec4 position;//位置，vec4说明有4个点组成，attribute表示属性，由程序提供输入值
 attribute vec4 inputTextureCoordinate;//源颜色，RGBA
 
 varying vec2 textureCoordinate;// 2D素材纹理坐标
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
 }
 );

NSString *const kMirrorImagePassthroughFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
 }
 );

// Hardcode the vertex shader for standard filters, but this can be overridden
NSString *const kMirrorYUVImageVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
 }
 );

NSString *const kMirrorYUVFullRangeConversionForLAFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
     mediump vec3 yuv;
     lowp vec3 rgb;
     
     yuv.x = texture2D(luminanceTexture, textureCoordinate).r;
     yuv.yz = texture2D(chrominanceTexture, textureCoordinate).ra - vec2(0.5, 0.5);
     rgb = colorConversionMatrix * yuv;
     
     gl_FragColor = vec4(rgb, 1);
 }
 );

NSString *const MirrorGLKProgramErrorDomain = @"GLKProgramErrorDomain";

@interface MirrorGLKProgram ()

@property (readonly, copy, nonatomic) NSDictionary *uniforms;
@property (strong, nonatomic) NSMutableDictionary *dirtyUniforms;
@property (strong, nonatomic) NSMutableDictionary *samplerBindings;
@property (strong, nonatomic) NSMutableDictionary *samplerXBBindings;

- (GLuint)createShaderWithSource:(NSString *)sourceCode type:(GLenum)type error:(NSError *__autoreleasing *)error;
- (GLuint)createProgramWithVertexShaderSource:(NSString *)vertexShaderSource fragmentShaderSource:(NSString *)fragmentShaderSource error:(NSError *__autoreleasing *)error;
- (NSMutableDictionary *)uniformsForProgram:(GLuint)program;
- (NSMutableDictionary *)attributesForProgram:(GLuint)program;

- (void)flushUniform:(MirrorGLKUniform *)uniform;

@end

@implementation MirrorGLKProgram

@synthesize uniforms = _uniforms;
@synthesize attributes = _attributes;
@synthesize dirtyUniforms = _dirtyUniforms;
@synthesize program = _program;
@synthesize samplerBindings = _samplerBindings;
@synthesize samplerXBBindings = _samplerXBBindings;

- (id)initWithVertexShaderFromFile:(NSString *)vertexShaderPath fragmentShaderFromFile:(NSString *)fragmentShaderPath error:(NSError *__autoreleasing *)error
{
    NSString *vertexShaderSource = [[NSString alloc] initWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:error];
    
    if (vertexShaderSource == nil) {
        return nil;
    }
    
    NSString *fragmentShaderSource = [[NSString alloc] initWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:error];
    
    if (fragmentShaderSource == nil) {
        return nil;
    }
    
    return [self initWithVertexShaderSource:vertexShaderSource fragmentShaderSource:fragmentShaderSource error:error];
}

- (id)initWithVertexShaderSource:(NSString *)vertexShaderSource fragmentShaderSource:(NSString *)fragmentShaderSource error:(NSError *__autoreleasing *)error
{
    self = [super init];
    if (self) {
        _program = [self createProgramWithVertexShaderSource:vertexShaderSource fragmentShaderSource:fragmentShaderSource error:error];
        
        if (self.program == 0) {
            return nil;
        }
        
        _uniforms = [[self uniformsForProgram:self.program] copy];
        _attributes = [[self attributesForProgram:self.program] copy];
        self.samplerBindings = [[NSMutableDictionary alloc] init];
        self.samplerXBBindings = [[NSMutableDictionary alloc] init];
        self.dirtyUniforms = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    glDeleteProgram(self.program);
}

+ (MirrorGLKProgram *)defaultProgram
{
    NSError *error = nil;
    MirrorGLKProgram *program = [[MirrorGLKProgram alloc] initWithVertexShaderSource:kMirrorImageVertexShaderString fragmentShaderSource:kMirrorImagePassthroughFragmentShaderString error:&error];
    if (program == nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    return program;
}

+ (MirrorGLKProgram *)defaultYUVProgram {
    NSError *error = nil;
    MirrorGLKProgram *program = [[MirrorGLKProgram alloc] initWithVertexShaderSource:kMirrorYUVImageVertexShaderString fragmentShaderSource:kMirrorYUVFullRangeConversionForLAFragmentShaderString error:&error];
    if (program == nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    return program;
}

#pragma mark - Methods

- (void)setValue:(void *)value forUniformNamed:(NSString *)uniformName
{
    MirrorGLKUniform *uniform = [self.uniforms objectForKey:uniformName];
    if (uniform) {
        uniform.value = value;
        [self.dirtyUniforms setObject:uniform forKey:uniform.name];
    }
}

- (void)bindSamplerNamed:(NSString *)samplerName toXBTexture:(MirrorGLKTexture *)texture unit:(GLint)unit
{
    if ([self.uniforms objectForKey:samplerName] == nil) {
        return;
    }
    
    [self setValue:&unit forUniformNamed:samplerName];
    
    if (texture != nil) {
        [self.samplerXBBindings setObject:texture forKey:samplerName];
    }
    else {
        [self.samplerXBBindings removeObjectForKey:samplerName];
    }
}

- (GLuint)uniformIndex:(NSString *)uniformName {
    MirrorGLKUniform *uniform = [self.uniforms objectForKey:uniformName];
    return uniform.location;
}

// 获取程序里attributeName对应的绑定GLuint参数值
- (GLuint)attributeIndex:(NSString *)attributeName {
    MirrorGLKAttribute *attr = [self.attributes objectForKey:attributeName];
    return attr.location;
}

- (void)bindSamplerNamed:(NSString *)samplerName toTexture:(GLuint)texture unit:(GLint)unit
{
    if ([self.uniforms objectForKey:samplerName] == nil) {
        return;
    }
    
    [self setValue:&unit forUniformNamed:samplerName];
    
    if (texture != 0) {
        [self.samplerBindings setObject:[NSNumber numberWithUnsignedInt:texture] forKey:samplerName];
    }
    else {
        [self.samplerBindings removeObjectForKey:samplerName];
    }
}

//创建着色器
- (GLuint)createShaderWithSource:(NSString *)sourceCode type:(GLenum)type error:(NSError *__autoreleasing *)error
{
    GLuint shader = glCreateShader(type);//创建一个空的着色器
    
    if (shader == 0) {
        if (error != NULL) {
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"glCreateShader failed.", NSLocalizedDescriptionKey, nil];
            *error = [[NSError alloc] initWithDomain:MirrorGLKProgramErrorDomain code:MirrorGLKProgramErrorFailedToCreateShader userInfo:userInfo];
        }
        return 0;
    }
    
    const GLchar *shaderSource = [sourceCode cStringUsingEncoding:NSUTF8StringEncoding];
    
    glShaderSource(shader, 1, &shaderSource, NULL);//指定着色器源代码，glShaderSource(shaderHandle, 1, &source, 0);source代表要执行的源代码字符串数组，1表示源代码字符串数组的字符串个数是一个，0表示源代码字符串长度数组的个数为0个
    glCompileShader(shader);//编译着色器
    
    GLint success = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);//查看编译着色器是否成功，可选的查询状态有L_DELETE_STATUS,GL_COMPILE_STATUS, GL_INFO_LOG_LENGTH, GL_SHADER_SOURCE_LENGTH
    
    if (success == 0) {
        if (error != NULL) {
            char errorMsg[2048];
            glGetShaderInfoLog(shader, sizeof(errorMsg), NULL, errorMsg);
            NSString *errorString = [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding];
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, nil];
            *error = [[NSError alloc] initWithDomain:MirrorGLKProgramErrorDomain code:MirrorGLKProgramErrorCompilationFailed userInfo:userInfo];
        }
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}

- (GLuint)createProgramWithVertexShaderSource:(NSString *)vertexShaderSource fragmentShaderSource:(NSString *)fragmentShaderSource error:(NSError *__autoreleasing *)error
{
    //创建顶点着色器
    GLuint vertexShader = [self createShaderWithSource:vertexShaderSource type:GL_VERTEX_SHADER error:error];
    
    if (vertexShader == 0) {
        return 0;
    }
    
    //创建片元着色器
    GLuint fragmentShader = [self createShaderWithSource:fragmentShaderSource type:GL_FRAGMENT_SHADER error:error];
    
    if (fragmentShader == 0) {
        return 0;
    }
    
    GLuint program = glCreateProgram();//创建一个渲染程序
    glAttachShader(program, vertexShader);//将着色器添加到程序中
    glAttachShader(program, fragmentShader);//将着色器添加到程序中
    glLinkProgram(program);//你可能添加了多个着色器，链接程序
    
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    //查看连接是否成功
    GLint linked = 0;
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    if (linked == 0) {
        if (error != NULL) {
            char errorMsg[2048];
            glGetProgramInfoLog(program, sizeof(errorMsg), NULL, errorMsg);
            NSString *errorString = [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding];
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, nil];
            *error = [[NSError alloc] initWithDomain:MirrorGLKProgramErrorDomain code:MirrorGLKProgramErrorLinkFailed userInfo:userInfo];
        }
        glDeleteProgram(program);
        return 0;
    }
    
    return program;
}

- (NSMutableDictionary *)uniformsForProgram:(GLuint)program
{
    GLint count;
    glGetProgramiv(program, GL_ACTIVE_UNIFORMS, &count);
    GLint maxLength;
    glGetProgramiv(program, GL_ACTIVE_UNIFORM_MAX_LENGTH, &maxLength);
    GLchar *nameBuffer = (GLchar *)malloc(maxLength * sizeof(GLchar));
    NSMutableDictionary *uniforms = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; ++i) {
        GLint size;
        GLenum type;
        glGetActiveUniform(program, i, maxLength, NULL, &size, &type, nameBuffer);
        GLint location = glGetUniformLocation(program, nameBuffer);
        NSString *name = [[NSString alloc] initWithCString:nameBuffer encoding:NSUTF8StringEncoding];
        MirrorGLKUniform *uniform = [[MirrorGLKUniform alloc] initWithName:name location:location size:size type:type];
        [uniforms setObject:uniform forKey:name];
    }
    
    free(nameBuffer);
    
    return uniforms;
}

- (NSMutableDictionary *)attributesForProgram:(GLuint)program
{
    GLint count;
    glGetProgramiv(program, GL_ACTIVE_ATTRIBUTES, &count);
    GLint maxLength;
    glGetProgramiv(program, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &maxLength);
    GLchar *nameBuffer = (GLchar *)malloc(maxLength * sizeof(GLchar));
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; ++i) {
        GLint size;
        GLenum type;
        glGetActiveAttrib(program, i, maxLength, NULL, &size, &type, nameBuffer);
        GLint location = glGetAttribLocation(program, nameBuffer);//从着色器源程序中的顶点着色器中获取属性
        NSString *name = [[NSString alloc] initWithCString:nameBuffer encoding:NSUTF8StringEncoding];
        MirrorGLKAttribute *attribute = [[MirrorGLKAttribute alloc] initWithName:name location:location size:size type:type];
        [attributes setObject:attribute forKey:name];
    }
    
    free(nameBuffer);
    
    return attributes;
}

- (void)flushUniform:(MirrorGLKUniform *)uniform
{
    switch (uniform.type) {
        case GL_FLOAT:
            glUniform1fv(uniform.location, uniform.size, uniform.value);
            break;
            
        case GL_FLOAT_VEC2:
            glUniform2fv(uniform.location, uniform.size, uniform.value);
            break;
            
        case GL_FLOAT_VEC3:
            glUniform3fv(uniform.location, uniform.size, uniform.value);
            break;
            
        case GL_FLOAT_VEC4:
            glUniform4fv(uniform.location, uniform.size, uniform.value);
            break;
            
        case GL_INT:
        case GL_BOOL:
            glUniform1iv(uniform.location, uniform.size, uniform.value);
            break;
            
        case GL_INT_VEC2:
        case GL_BOOL_VEC2:
            glUniform2iv(uniform.location, uniform.size, uniform.value);
            break;
            
        case GL_INT_VEC3:
        case GL_BOOL_VEC3:
            glUniform3iv(uniform.location, uniform.size, uniform.value);
            break;
            
        case GL_INT_VEC4:
        case GL_BOOL_VEC4:
            glUniform4iv(uniform.location, uniform.size, uniform.value);
            break;
            
        case GL_FLOAT_MAT2:
            glUniformMatrix2fv(uniform.location, uniform.size, GL_FALSE, uniform.value);
            break;
            
        case GL_FLOAT_MAT3:
            glUniformMatrix3fv(uniform.location, uniform.size, GL_FALSE, uniform.value);
            break;
            
        case GL_FLOAT_MAT4:
            glUniformMatrix4fv(uniform.location, uniform.size, GL_FALSE, uniform.value);
            break;
            
        case GL_SAMPLER_2D:
        case GL_SAMPLER_CUBE:
            glUniform1iv(uniform.location, uniform.size, uniform.value);
            break;
            
        default:
            break;
    }
}

- (void)active {
    glUseProgram(self.program);
}

- (void)prepareToDraw
{
    glUseProgram(self.program);
    
    // Flush dirty uniforms
    for (NSString *name in [self.dirtyUniforms allKeys]) {
        MirrorGLKUniform *uniform = [self.dirtyUniforms objectForKey:name];
        [self flushUniform:uniform];
    }
    
    [self.dirtyUniforms removeAllObjects];
    
    // Set textures
    for (NSString *name in [self.uniforms allKeys]) {
        MirrorGLKUniform *uniform = [self.uniforms objectForKey:name];
        
        if (uniform.type == GL_SAMPLER_2D || uniform.type == GL_SAMPLER_CUBE) {
            MirrorGLKTexture *texture = [self.samplerXBBindings objectForKey:uniform.name];
            
            if (texture != nil) {
                glActiveTexture(GL_TEXTURE0 + *(GLint *)uniform.value);
                glBindTexture(GL_TEXTURE_2D, texture.textureInfo.name);
            }
            
            NSNumber *textureNumber = [self.samplerBindings objectForKey:uniform.name];
            
            if (textureNumber != nil) {
                glActiveTexture(GL_TEXTURE0 + *(GLint *)uniform.value);
                glBindTexture(GL_TEXTURE_2D, textureNumber.unsignedIntValue);
            }
        }
    }
}

@end
