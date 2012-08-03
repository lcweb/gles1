//
//  ES1Renderer.m
//  gles1
//
//  Created by and on 05/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ES1Renderer.h"




@implementation ES1Renderer

// Create an OpenGL ES 1.1 context
- (id)init
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

        if (!context || ![EAGLContext setCurrentContext:context])
        {
            [self release];
            return nil;
        }

        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		
		
		glGenRenderbuffersOES(1, &depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
		
		[self _init];
	}

    return self;
}



-(void)_init
{	
	Color3DSet(&light0Ambient[0], 0.2, 0.2, 0.2, 1.0);
	Color3DSet(&light0Diffuse[0], 0.5, 0.5, 0.5, 1.0);
	Color3DSet(&light0Specular[0], 0.8, 0.8, 0.8, 1.0);
	Vertex3DSet(&light0Position[0], 0.0, 0.0, 10.0);
	Vertex3DSet(&objectPoint[0], 0.0, 0.0, -3.0);
	
	getSolidSphere(&(strip.verticies), &(strip.normals), &(strip.nrOfVerticies), &(fan.verticies),
					   &(fan.normals), &(fan.nrOfVerticies), 1.0, 50, 50);
	getSolidSphere(&(strip1.verticies), &(strip1.normals), &(strip1.nrOfVerticies), &(fan1.verticies),
				   &(fan1.normals), &(fan1.nrOfVerticies), 0.2, 6, 6);	
	getCube(&(cube.verticies), &(cube.normals), &(cube.nrOfVerticies), &(cube.indicies), &(cube.nrOfIndicies), 0.5);
	getCube2(&(cube2.verticies), &(cube2.nrOfVerticies), &(cube2.indicies), &(cube2.nrOfIndicies), 0.5);
	getRectStrip2(&(rect2.verticies), &(rect2.nrOfVerticies), &(rect2.indicies), &(rect2.nrOfIndicies), 0.5);
	getRectStrip2_t(&(rect2_t.verticies), &(rect2_t.nrOfVerticies), &(rect2_t.indicies), &(rect2_t.nrOfIndicies), 0.5);
}

-(void)_dealloc
{
	free_mesh(&strip);
	free_mesh(&fan);
	
	free_mesh(&cube);
	
	free_mesh2(&cube2);
	
	free_mesh2(&rect2);
}

-(void)load_texture
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"];
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    if (image == nil)
        NSLog(@"Do real error checking here");
	
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
	
	CGContextTranslateCTM (context, 0, height);
	CGContextScaleCTM (context, 1.0, -1.0);
	
    CGContextTranslateCTM( context, 0, height - height );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
	
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	
    CGContextRelease(context);
	
    free(imageData);
    [image release];
    [texData release];
}

-(void)load_texture_pvrtc
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"pvrtc"];
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
	
    // This assumes that source PVRTC image is 4 bits per pixel and RGB not RGBA
    // If you use the default settings in texturetool, e.g.:
    //
    //      texturetool -e PVRTC -o texture.pvrtc texture.png
    //
    // then this code should work fine for you.
    glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, 512, 512, 0, [texData length], [texData bytes]);
}


-(void)setup
{
	glEnable(GL_DEPTH_TEST);
	glShadeModel(GL_SMOOTH);
	//glEnable(GL_CULL_FACE);
	glEnable(GL_BLEND);
	//glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glBlendFunc(GL_ONE, GL_SRC_COLOR);

	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
    //glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	
	glViewport(0, 0, backingWidth, backingHeight);
	
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	glFrustumf(-size,                                          
			   size,                                          
			   -size/(0.67)  ,   
			   size/(0.67)  ,   
			   zNear,                                         
			   zFar);  
	
	glMatrixMode(GL_MODELVIEW);
	
}

-(void)lights:(BOOL)identity
{	
	static const GLfloat light_position[] = { 0.0, 0.0, 10.0, 1.0 };
	//static const GLfloat light_vector[] = { 0.0, 0.0, -1.0 };
	
	if (identity)
		glLoadIdentity();
	
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	
	glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, (const GLfloat *)light0Specular);
	

	static GLfloat px = 0.0, py = 0.0, pz = 0;
	//px += 0.05;
	//py += 0.05;
	//glTranslatef(px, py, pz);
	
	glLightfv(GL_LIGHT0, GL_POSITION, light_position); 
	
    const Vertex3D lightVector = Vector3DMakeWithStartAndEndPoints(light0Position[0], objectPoint[0]);
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, (GLfloat *)&lightVector);
	//glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, light_vector);
    glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 25.0);
}

-(void)textures
{
	glEnable(GL_TEXTURE_2D);
	
	glGenTextures(1, &texture[0]);
	
	glBindTexture(GL_TEXTURE_2D, texture[0]);
	
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	
	[self load_texture];
}

- (void)vbos
{
	glGenBuffers(1, &rect2_t.vertexVbo);
    glGenBuffers(1, &rect2_t.indexVbo);
	
    glBindBuffer(GL_ARRAY_BUFFER, rect2_t.vertexVbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(TexturedVertexData3D)*(rect2_t.nrOfVerticies), rect2_t.verticies, GL_STATIC_DRAW);
	
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, rect2_t.indexVbo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*(rect2_t.nrOfIndicies), rect2_t.indicies, GL_STATIC_DRAW);
	
}

- (void)render
{
    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];

    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	
	
	static GLfloat set = 0;
	if (!set) {
		set++;
		
		[self setup];
		
		[self vbos];
		
		[self lights:YES];	
		
		[self textures];
	}

	
	
	
	glClearColor(0.7, 0.7, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
   
	glLoadIdentity();
	
	static GLfloat ex = -0.0, ey = 0.0, ez = -1.0;
	static GLfloat cx = -0.0, cy = 0.0, cz = -3.0;
	static GLfloat upx = 0.0, upy = 1.0, upz = 0.0;
	//ey+=0.005;
	gluLookAt(ex, ey, ez, cx, cy, cz, upx, upy, upz);
	static GLfloat orb = 0.0;
	orb+=0.1;
	//glRotatef(orb, 0.f, 1.f, 0.f);
	
	//[self lights:NO];
	
	//glPushMatrix();
	
	glTranslatef(0.0f,0.0f,-3.0f);
	static GLfloat rot = 0.0;
	//rot++;
    glRotatef(rot,1.0f,0.0f,1.0f);
	
	glBindTexture(GL_TEXTURE_2D, texture[0]);
	
	glBindBuffer(GL_ARRAY_BUFFER, rect2_t.vertexVbo);
	glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), (void*)offsetof(TexturedVertexData3D,vertex));
	glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), (void*)offsetof(TexturedVertexData3D,normal));
	glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), (void*)offsetof(TexturedVertexData3D,texCoord));
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, rect2_t.indexVbo);
	glDrawElements(GL_TRIANGLE_STRIP, rect2_t.nrOfIndicies, GL_UNSIGNED_SHORT, (void*)0);
	  
	
	/*GLfloat ambientAndDiffuse[] = {0.0, 0.1, 0.9, 1.0};
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, ambientAndDiffuse);
	GLfloat specular[] = {0.8, 0.8, 0.8, 1.0};
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specular);
    glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 50.0);*/
	//GLfloat emission[] = {0.0, 0.4, 0.0, 1.0};
    //glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, emission);

	/*glVertexPointer(3, GL_FLOAT, sizeof(VertexData3D), &rect2.verticies[0].vertex);
	glNormalPointer(GL_FLOAT, sizeof(VertexData3D), &rect2.verticies[0].normal);
	glDrawElements(GL_TRIANGLE_STRIP, rect2.nrOfIndicies, GL_UNSIGNED_SHORT, rect2.indicies);*/
	
	/*GLfloat ambientAndDiffuse1[] = {0.0, 0.9, 0.1, 0.3};
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, ambientAndDiffuse1);
	GLfloat specular1[] = {0.9, 0.9, 0.9, 1.0};
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specular1);
	glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 50.0);*/
	
	//glTranslatef(0.8, 0, 0.5);
	//glDepthMask (GL_FALSE);

	
	/*glVertexPointer(3, GL_FLOAT, sizeof(VertexData3D), &rect2.verticies[0].vertex);
	glNormalPointer(GL_FLOAT, sizeof(VertexData3D), &rect2.verticies[0].normal);
	glDrawElements(GL_TRIANGLE_STRIP, rect2.nrOfIndicies, GL_UNSIGNED_SHORT, rect2.indicies);*/
	
	//glDepthMask (GL_TRUE);
	//glColor4f(0.9, 0.9, 0.9, 1.0);
	//glVertexPointer(3, GL_FLOAT, 0, cube.verticies);
	//glColorPointer(4, GL_FLOAT, 0, colors);
	//glNormalPointer(GL_FLOAT, 0, cube.normals);
	//glDrawElements(GL_TRIANGLES, cube.nrOfIndicies, GL_UNSIGNED_SHORT, cube.indicies);
	
	//glColor4f(0.9, 0.9, 0.9, 1.0);
	//glVertexPointer(3, GL_FLOAT, sizeof(VertexData3D), &cube2.verticies[0].vertex);
	//glColorPointer(4, GL_FLOAT, 0, colors);
	//glNormalPointer(GL_FLOAT, sizeof(VertexData3D), &cube2.verticies[0].normal);
	//glDrawElements(GL_TRIANGLES, cube.nrOfIndicies, GL_UNSIGNED_SHORT, cube.indicies);
	
	//glVertexPointer(3, GL_FLOAT, 0, fan.verticies);
    //glNormalPointer(GL_FLOAT, 0, fan_normal.verticies);
    //glDrawArrays(GL_TRIANGLE_FAN, 0, fan.nrOfVerticies);
	
	//glVertexPointer(3, GL_FLOAT, 0, strip.verticies);
    //glNormalPointer(GL_FLOAT, 0, strip.normals);
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, strip.nrOfVerticies);
	
	
	//glLoadIdentity();//fix
	//glPopMatrix();
	
	
	//glTranslatef(0.3,0.0,-1.0);  
	//static GLfloat rot1 = 0;
	//rot1++;
    //glRotatef(rot1,0.0f,1.0f,0.0f);
	
	
	//glVertexPointer(3, GL_FLOAT, 0, fan1.verticies);
    //glNormalPointer(GL_FLOAT, 0, fan1.normals);
    //glDrawArrays(GL_TRIANGLE_FAN, 0, fan1.nrOfVerticies);
	
	//glVertexPointer(3, GL_FLOAT, 0, strip1.verticies);
    //glNormalPointer(GL_FLOAT, 0, strip1.normals);
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, strip1.nrOfVerticies);
	
	
	//glDisableClientState(GL_VERTEX_ARRAY);
    //glDisableClientState(GL_NORMAL_ARRAY);
	
	

    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
    // Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

    return YES;
}

- (void)dealloc
{
	[self _dealloc];
	
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
	if (depthRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }

    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];

    [context release];
    context = nil;

    [super dealloc];
}

@end
