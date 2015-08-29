//
//  TBMirrorCameraOpenGLView.m
//  TBMirror
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "TBMirrorCameraOpenGLView.h"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NSString *const kImageVertexShaderString = SHADER_STRING
(
 attribute vec4 aPosition;
 attribute vec2 aTexCoord;
 
 uniform mat4 uMatrixMVP;
 
 varying vec2 vTexCoord;
 
 void main(){
     gl_Position = uMatrixMVP * aPosition;
     vTexCoord = aTexCoord;
 }
 );

NSString *const kyuvFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 const vec2 uvDelta = vec2(0.5 , 0.5);
 const mat3 convertMatrix = mat3(1.0 , 1.0 , 1.0 , 0 , -0.39465 , 2.03211 , 1.13983 , -0.58060 , 0);//列矩阵
 
 uniform sampler2D uYTextureSampler;
 uniform sampler2D uUVTextureSampler;
 varying vec2 vTexCoord;
 
 void main ()
{
    vec3 yuv = vec3(texture2D(uYTextureSampler, vTexCoord).r , texture2D(uUVTextureSampler, vTexCoord).ra -uvDelta);
    vec3 rgb = convertMatrix * yuv;
    gl_FragColor = vec4(rgb, 1.0);
}
);

@interface TBMirrorCameraOpenGLView() {
    GLuint          program;
    GLuint          vshader;
    GLuint          fshader;
    GLint           uYTextureSampler;
    GLint           uUVTextureSampler;
    GLint           uMatrixMVP;
    GLint           aPosition;
    GLint           aTexCoord;
    GLuint          mYTextureHandle;
    GLuint          mUVTextureHandle;
    float *mPosBuffer;
    float *mTexBuffer;
    void *mYBuffer;
    void *mUVBuffer;
    BOOL _isFrontCamera;
    
    GLKMatrix4 matrixPvm;
    GLKMatrix4 matrixBackPvm;

    CGFloat width;
    CGFloat height;
}

@end

@implementation TBMirrorCameraOpenGLView

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context cameraSize:(CGSize)cameraSize {
    if ((self = [super initWithFrame:frame context:context])) {
        width = cameraSize.width;
        height = cameraSize.height;
        
        [self initOpenGL];
    }
    
    return self;
}

- (void)initOpenGL {
    program = glCreateProgram();
    
    const GLchar *vshSource = (GLchar *)[kImageVertexShaderString UTF8String];
    vshader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vshader, 1, &vshSource, NULL);
    glCompileShader(vshader);
    
#ifdef DEBUG
    [self testShader:vshader];
#endif
	GLint status;
    glGetShaderiv(vshader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE) {
        glDeleteShader(vshader);
        NSLog(@"Failed to compile shader:\n");
        return;
    }
    
    const GLchar *fshSource = (GLchar *)[kyuvFragmentShaderString UTF8String];
    fshader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fshader, 1, &fshSource, NULL);
    glCompileShader(fshader);
#ifdef DEBUG
    [self testShader:fshader];
#endif
	GLint fshStatus;
    glGetShaderiv(fshader, GL_COMPILE_STATUS, &fshStatus);
    if (fshStatus == GL_FALSE) {
        glDeleteShader(fshader);
        NSLog(@"Failed to compile shader:\n");
        return;
    }
    
	glAttachShader(program, vshader);
	glAttachShader(program, fshader);
    
	glLinkProgram(program);
#ifdef DEBUG
    GLint programLogLength;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &programLogLength);
    if (programLogLength > 0)
    {
        GLchar *programLog = (GLchar *)malloc(programLogLength);
        glGetProgramInfoLog(program, programLogLength, &programLogLength, programLog);
        NSLog(@"Program validate log:\n%s", programLog);
        free(programLog);
    }
#endif
	GLint programStatus;
    glGetProgramiv(program, GL_LINK_STATUS, &programStatus);
    if (programStatus == GL_FALSE) {
		NSLog(@"Failed to link program %d", program);
        return;
    }
    
    uYTextureSampler = glGetUniformLocation(program, "uYTextureSampler");
    uUVTextureSampler = glGetUniformLocation(program, "uUVTextureSampler");
    uMatrixMVP = glGetUniformLocation(program, "uMatrixMVP");
    if (uYTextureSampler == -1 || uUVTextureSampler == -1 || uMatrixMVP == -1) {
        NSLog(@"can't find location");
        return;
    }
    
    aPosition = glGetAttribLocation(program, "aPosition");
    glEnableVertexAttribArray(aPosition);
    aTexCoord = glGetAttribLocation(program, "aTexCoord");
    glEnableVertexAttribArray(aTexCoord);

    if (aPosition == -1 || aTexCoord == -1) {
        NSLog(@"can't find location");
        return;
    }
    
    // 前置摄像头成像View
    GLKMatrix4 matrixView = GLKMatrix4MakeLookAt(0, 0, 0, 0, 0, 1, 0, 1, 0);
    // 后置摄像头成像View
    GLKMatrix4 matrixBackView = GLKMatrix4MakeLookAt(0, 0, 0, 0, 0, -1, 0, 1, 0);
    // 摄像头成像Project
    float radio = height / width;
    GLKMatrix4 matrixProject = GLKMatrix4MakeOrtho(-(float) width / height * radio, (float) width / height * radio, -radio, radio, 1, 10);
    // 前置摄像头成像Model
    GLKMatrix4 matrixModel = GLKMatrix4Translate(GLKMatrix4Rotate(GLKMatrix4Identity, -M_PI/2, 0, 0, 1) , 0, 0, 3);
    // 后置摄像头成像Model
    GLKMatrix4 matrixBackModel = GLKMatrix4Translate(GLKMatrix4Rotate(GLKMatrix4Identity, -M_PI/2, 0, 0, 1) , 0, 0, -3);
    
    matrixPvm = GLKMatrix4Multiply(matrixProject, GLKMatrix4Multiply(matrixView, matrixModel));
    matrixBackPvm = GLKMatrix4Multiply(matrixProject, GLKMatrix4Multiply(matrixBackView, matrixBackModel));
    
    CGFloat previewWidth = height;
    CGFloat previewHeight = width;

    mPosBuffer = (float*)malloc(sizeof(float) * 24);
    float position[] = {//
        - previewWidth / previewHeight, 1.0f, 0, 1,// Position 0
        - previewWidth / previewHeight, -1.0f, 0, 1,// Position 1
         previewWidth / previewHeight, -1.0f, 0, 1,// Position 2
         previewWidth / previewHeight, -1.0f, 0, 1,// Position 2
         previewWidth / previewHeight, 1.0f, 0, 1,// Position 3
        - previewWidth / previewHeight, 1.0f, 0, 1,// Position 0
    };
    for (int i = 0; i < 24; i++) {
        mPosBuffer[i] = position[i];
    }
    
    mTexBuffer = (float*)malloc(sizeof(float) * 12);
    float texture[] = { 0.0f, 0.0f, // TexCoord 0
        0.0f, 1.0f, // TexCoord 1
        1.0f, 1.0f, // TexCoord 2
        1.0f, 1.0f, // TexCoord 2
        1.0f, 0.0f,// TexCoord 3
        0.0f, 0.0f, // TexCoord 0
    };
    for (int i = 0; i < 12; i++) {
        mTexBuffer[i] = texture[i];
    }
    
    GLuint textures[2];
    glGenTextures(2, textures);
    mYTextureHandle = textures[0];
    mUVTextureHandle = textures[1];
    
    glBindTexture(GL_TEXTURE_2D, mYTextureHandle);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glBindTexture(GL_TEXTURE_2D, mUVTextureHandle);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

- (void)testShader:(GLuint)shader {
	GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
	if (status != GL_TRUE)
	{
		GLint logLength;
		glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
		if (logLength > 0)
		{
			GLchar *log = (GLchar *)malloc(logLength);
			glGetShaderInfoLog(shader, logLength, &logLength, log);
            NSLog(@"shader compile log:\n%s", log);
			free(log);
		}
	}
}

- (void)drawRect:(CGRect)rect{
    if (mYBuffer == NULL || mUVBuffer == NULL) {
        return;
    }
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(program);
    glVertexAttribPointer(aPosition, 4, GL_FLOAT, 0, 0, mPosBuffer);
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, 0, 0, mTexBuffer);
    
    if (_isFrontCamera) {
        glUniformMatrix4fv(uMatrixMVP, 1, 0, matrixPvm.m);
    } else {
        glUniformMatrix4fv(uMatrixMVP, 1, 0, matrixBackPvm.m);
    }
    
    glActiveTexture(GL_TEXTURE0);
    glUniform1i(uYTextureSampler, 0);
    glBindTexture(GL_TEXTURE_2D, mYTextureHandle);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, (int)width, (int)height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, mYBuffer);
    
    glActiveTexture(GL_TEXTURE1);
    glUniform1i(uUVTextureSampler, 1);
    glBindTexture(GL_TEXTURE_2D, mUVTextureHandle);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE_ALPHA, ((int)width) / 2, ((int)height) / 2, 0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, mUVBuffer);
    glDrawArrays(GL_TRIANGLES, 0, 6);
//    glFlush();
}

- (void)updateData:(unsigned char*)pYuvRet isFrontCamera:(BOOL)isFrontCamera{
    int cameraWidth = (int)width;
    int cameraHeight = (int)height;
    if (mYBuffer == NULL) {
        mYBuffer = (unsigned char *)malloc(cameraWidth*cameraHeight);
    }
    if (mUVBuffer == NULL) {
        mUVBuffer = (unsigned char *)malloc(cameraWidth*cameraHeight/2);
    }
    memcpy(mYBuffer, pYuvRet, cameraWidth*cameraHeight);
    memcpy(mUVBuffer, pYuvRet+cameraWidth*cameraHeight, cameraWidth*cameraHeight/2);
    _isFrontCamera = isFrontCamera;
}

- (void)dealloc {
    if (vshader) {
        glDeleteShader(vshader);
    }
    if (fshader) {
        glDeleteShader(fshader);
    }
    if (program) {
        glDeleteProgram(program);
    }
    if (mYTextureHandle) {
        glDeleteTextures(1, &mYTextureHandle);
        mYTextureHandle = 0;
    }
    if (mUVTextureHandle) {
        glDeleteTextures(1, &mUVTextureHandle);
        mUVTextureHandle = 0;
    }
    if (mPosBuffer != NULL) {
        free(mPosBuffer);
    }
    if (mTexBuffer != NULL) {
        free(mTexBuffer);
    }
    if (mYBuffer != NULL) {
        free(mYBuffer);
    }
    if (mUVBuffer != NULL) {
        free(mUVBuffer);
    }
}

@end