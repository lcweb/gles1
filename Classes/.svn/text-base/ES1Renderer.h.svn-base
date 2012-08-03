//
//  ES1Renderer.h
//  gles1
//
//  Created by and on 05/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ESRenderer.h"

#import "opengl_common_1.h"

@interface ES1Renderer : NSObject <ESRenderer>
{
@private
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer, depthRenderbuffer;
	
	//mesh
	Mesh fan;
	Mesh strip;
	
	Mesh fan1;
	Mesh strip1;
	
	Mesh cube;
	
	Mesh2 cube2;
	
	Mesh2 rect2;
	Mesh2_t rect2_t;
	
	//light
	Color3D light0Ambient[1];
	Color3D light0Diffuse[1];
	Color3D light0Specular[1];
	Vertex3D light0Position[1];
	Vertex3D objectPoint[1];
	
	//texture
	GLuint      texture[1];
}

- (void)render;
- (void)setup;
- (void)lights:(BOOL)identity;
- (void)textures;
- (void)vbos;
- (void)load_texture;
- (void)load_texture_pvrtc;

-(void)_init;
-(void)_dealloc;

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
