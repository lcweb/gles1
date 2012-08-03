//
//  ES2Renderer.h
//  gles1
//
//  Created by and on 05/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ESRenderer.h"

#import "opengl_common/inc.h"

@interface ES2Renderer : NSObject <ESRenderer>
{
@private
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer, depthRenderbuffer;

    GLuint program;
	
	//meshes
	//Mesh2_c cube2;
	//Mesh sphere;
	Mesh rect2_t, back_rect2_t;
	
	//lights
	Light light[2];
	
	//matrices
	Matrix projection;
	Matrix modelview;
	GLfloat normal_matrix[9];
	
	//texture
	GLuint      texture[2];	
}

- (void)render;
- (void)setup;
- (void)vbos;
- (void)lights:(BOOL)identity;
- (void)textures;
- (void)uniform:(Material *)m;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
- (void)load_texture:(NSString *)spath;
- (void)load_texture_pvrtc;

-(void)_init;
-(void)_dealloc;

@end

