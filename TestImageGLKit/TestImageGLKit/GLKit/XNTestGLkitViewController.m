//
//  XNTestGLkitViewController.m
//  TestImageGLKit
//
//  Created by xn on 2021/12/24.
//

#import "XNTestGLkitViewController.h"

#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface XNTestGLkitViewController ()

@property (nonatomic, strong) EAGLContext *context; // 上下文
@property (nonatomic, strong) GLKBaseEffect *effect; // 效果

@end

@implementation XNTestGLkitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConfig];
    
    [self setupVertex];
    
    [self setupTexture];
}

- (void)setupConfig {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!self.context) {
        NSLog(@"创建上下文失败");
        return;
    }
    
    [EAGLContext setCurrentContext:self.context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    view.drawableColorFormat = GLKViewDrawableColorFormatSRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    glClearColor(0.5, 0.5, 0.5, 1.0);
}

- (void)setupVertex {
//     设置(顶点坐标， 纹理坐标)
//     顶点： 是从中间开始算的， -1 1
//     纹理坐标： 从0，1 ， (0,0)是左下角
    GLfloat vertexData[] = {
//        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
//        0.5, 0.5,  0.0f,    1.0f, 1.0f, //右上
//        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上

        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5f, 0.5f, 0.0f,   0.f, 1.f, // 左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下

    };
    
    //2.开辟顶点缓存区
    //(1).创建顶点缓存区标识符ID
    GLuint bufferID;
    glGenBuffers(1, &bufferID);
    //(2).绑定顶点缓存区.(明确作用)
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    //(3).将顶点数组的数据copy到顶点缓存区中(GPU显存中)
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    //顶点坐标数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat*)NULL + 0);
    
    //纹理坐标数据
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat*)NULL + 3);
    
}

- (void)setupTexture {
    //1.获取纹理图片路径
    NSString *path = [[NSBundle mainBundle]· pathForResource:@"2000140048_14" ofType:@"png"];
    
    //2.设置纹理参数
    //纹理坐标原点是左下角,但是图片显示原点应该是左上角.
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:nil];

    //3.使用苹果GLKit 提供GLKBaseEffect 完成着色器工作(顶点/片元)
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.texture2d1.enabled = true;
    self.effect.texture2d1.name = textureInfo.name;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClear(GL_DEPTH_BUFFER_BIT);
    glClear(GL_STENCIL_BUFFER_BIT);
    glClear(GL_COLOR_BUFFER_BIT);

    //2.准备绘制
    [self.effect prepareToDraw];
    
    //3.开始绘制
    glDrawArrays(GL_TRIANGLES, 0, 6); // 三角形的方式绘制
}


@end
