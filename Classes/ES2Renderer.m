//
//  ES2Renderer.m
//  gles1
//
//  Created by and on 05/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ES2Renderer.h"

#import "opengl_common/meshes.h"

// uniform index
enum {
	PROJECTION,
	MODELVIEW,
	NORMAL_MATRIX,
	
	TEXTURE_UNIT,
	
	LIGHT_ON_OFF,
	LIGHT_TYPE,
	LIGHT_DIR,
	LIGHT_SPOT_POS,
	LIGHT_SPOT_ANGLE,
	LIGHT_SPOT_EXP,
	LIGHT_C_ATT,
	LIGHT_L_ATT,
	LIGHT_Q_ATT,
	LIGHT_DIFFUSE,
	LIGHT_AMBIENT,
	LIGHT_SPECULAR,
	
	MATERIAL_DIFFUSE,
	MATERIAL_AMBIENT,
	MATERIAL_SPECULAR,
	MATERIAL_SHININESS,
	NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// attribute index
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
	ATTRIB_NORMAL,
	ATTRIB_TEXTCOORD,
    NUM_ATTRIBUTES
};

@interface ES2Renderer (PrivateMethods)
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ES2Renderer

// Create an OpenGL ES 2.0 context
- (id)init
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

        if (!context || ![EAGLContext setCurrentContext:context] || ![self loadShaders])
        {
            [self release];
            return nil;
        }

        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffers(1, &defaultFramebuffer);
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
		
		glGenRenderbuffers(1, &depthRenderbuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
		
		[self _init];
		
		[self setup];
		
		[self textures];
		
		[self vbos];
		
		[self lights:YES];	
			
    }

    return self;
}



-(void)_init
{	
	//Color3DSet(&light0Ambient[0], 0.2, 0.2, 0.2, 1.0);
	//Color3DSet(&light0Diffuse[0], 0.5, 0.5, 0.5, 1.0);
	//Color3DSet(&light0Specular[0], 0.8, 0.8, 0.8, 1.0);
	//Vertex3DSet(&light0Position[0], 0.0, 0.0, 10.0);
	//Vertex3DSet(&objectPoint[0], 0.0, 0.0, -3.0);
	
	//getSolidSphere(&(sphere.verticies), &(sphere.normals), &(sphere.nrOfVerticies), NULL,
	//			   NULL, NULL, 1.0, 8, 8);
	//getSolidSphere(&(strip1.verticies), &(strip1.normals), &(strip1.nrOfVerticies), &(fan1.verticies),
	//			   &(fan1.normals), &(fan1.nrOfVerticies), 0.2, 6, 6);	
	//getCube(&(cube.verticies), &(cube.normals), &(cube.nrOfVerticies), &(cube.indicies), &(cube.nrOfIndicies), 0.5);
	//getCube2_c(&(cube2.verticies), &(cube2.nrOfVerticies), &(cube2.indicies), &(cube2.nrOfIndicies), 0.5);
	//getRectStrip2(&(rect2.verticies), &(rect2.nrOfVerticies), &(rect2.indicies), &(rect2.nrOfIndicies), 0.5);
	
	mesh_add_subset(&rect2_t);
	mesh_add_subset(&back_rect2_t);
	
	getRectStrip2_t(&(rect2_t.verticies), &(rect2_t.num_verticies), &(rect2_t.indicies[0]), &(rect2_t.num_indicies[0]), 0.5, NO);
	getRectStrip2_t(&(back_rect2_t.verticies), &(back_rect2_t.num_verticies), &(back_rect2_t.indicies[0]), &(back_rect2_t.num_indicies[0]), 0.5, YES);
	
}


-(void)_dealloc
{
	mesh_free(&rect2_t);
	mesh_free(&back_rect2_t);
}

-(void)load_texture:(NSString *)spath
{
	NSString *path = [[NSBundle mainBundle] pathForResource:spath ofType:@"png"];
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    if (image == nil)
        NSLog(@"Do real error checking here");
	
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef _context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( _context, CGRectMake( 0, 0, width, height ) );
	
	CGContextTranslateCTM (_context, 0, height);
	CGContextScaleCTM (_context, 1.0, -1.0);
	
    CGContextTranslateCTM( _context, 0, height - height );
    CGContextDrawImage( _context, CGRectMake( 0, 0, width, height ), image.CGImage );
	
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	
    CGContextRelease(_context);
	
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
    glUseProgram(program);
	
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);
	glEnable(GL_BLEND);
	glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	//glBlendFunc(GL_ONE, GL_SRC_COLOR);
	
	//glViewport(0, 0, backingWidth, backingHeight);
	
	matrix_set_identity(projection);
	
	
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
	frustum(projection, -size, size, -size/(0.67), size/(0.67), zNear, zFar);
	
}


-(void)lights:(BOOL)identity
{	
	light[0].on_off = 0;
	light[0].type = 2;
	vertex_set(&light[0].dir, 0.0, 0.0, -1.0);
	vertex_set(&light[0].spot_pos, 0.0, 0.0, 10.0);
	color_set(&light[0].diffuse, 0.5, 0.5, 0.5, 1.0);
	color_set(&light[0].ambient, 0.1, 0.1, 0.1, 1.0);
	color_set(&light[0].specular, 0.9, 0.9, 0.9, 1.0);
	light[0].c_att = 1.0;
	light[0].l_att = 0.0;
	light[0].q_att = 0.0;
	light[0].spot_angle = cosf(DEGREES_TO_RADIANS(2.0));
	light[0].spot_exp = 1000.0;	
	
	light[1].on_off = 1;
	light[1].type = 0;
	vertex_set(&light[1].dir, 0.0, 0.0, 1.0);
	vertex_set(&light[1].spot_pos, 0.0, 0.0, -10.0);
	color_set(&light[1].diffuse, 0.5, 0.5, 0.5, 1.0);
	color_set(&light[1].ambient, 0.1, 0.1, 0.1, 1.0);
	color_set(&light[1].specular, 0.3, 0.3, 0.3, 1.0);
	light[1].c_att = 1.0;
	light[1].l_att = 0.0;
	light[1].q_att = 0.0;
	light[1].spot_angle = 45.0;
	light[1].spot_exp = 0.0;	
}


-(void)textures
{
	glEnable(GL_TEXTURE_2D);
	
	glGenTextures(1, &texture[0]);
	
	glActiveTexture(GL_TEXTURE0); 
	glBindTexture(GL_TEXTURE_2D, texture[0]);
	
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	
	[self load_texture:@"texture"];
	
	
	
	glGenTextures(1, &texture[1]);
	
	glActiveTexture(GL_TEXTURE1); 
	glBindTexture(GL_TEXTURE_2D, texture[1]);
	
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	
	[self load_texture:@"texture1"];	
}


- (void)vbos
{
/*	glGenBuffers(1, &cube2.vertexVbo);
    glGenBuffers(1, &cube2.indexVbo);
	
    glBindBuffer(GL_ARRAY_BUFFER, cube2.vertexVbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(ColoredVertexData3D)*(cube2.nrOfVerticies), cube2.verticies, GL_STATIC_DRAW);
	
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cube2.indexVbo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*(cube2.nrOfIndicies), cube2.indicies, GL_STATIC_DRAW);

	
	
	
	glGenBuffers(1, &sphere.vertexVbo);
    glGenBuffers(1, &sphere.normalVbo);
	
    glBindBuffer(GL_ARRAY_BUFFER, sphere.vertexVbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex3D)*(sphere.nrOfVerticies), sphere.verticies, GL_STATIC_DRAW);
	
    glBindBuffer(GL_ARRAY_BUFFER, sphere.normalVbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex3D)*(sphere.nrOfVerticies), sphere.normals, GL_STATIC_DRAW);
	*/
	
	
	glGenBuffers(1, &rect2_t.vbo);
	glGenBuffers(1, &rect2_t.ibo[0]);
	
    glBindBuffer(GL_ARRAY_BUFFER, rect2_t.vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(VertexNormTexInt)*(rect2_t.num_verticies), rect2_t.verticies, GL_STATIC_DRAW);
	
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, rect2_t.ibo[0]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*(rect2_t.num_indicies[0]), rect2_t.indicies[0], GL_STATIC_DRAW);
	
	glGenBuffers(1, &back_rect2_t.vbo);
	glGenBuffers(1, &back_rect2_t.ibo[0]);
	
    glBindBuffer(GL_ARRAY_BUFFER, back_rect2_t.vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(VertexNormTexInt)*(back_rect2_t.num_verticies), back_rect2_t.verticies, GL_STATIC_DRAW);
	
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, back_rect2_t.ibo[0]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*(back_rect2_t.num_indicies[0]), back_rect2_t.indicies[0], GL_STATIC_DRAW);
}

- (void)uniform:(Material *)m
{
	//matrices
	glUniformMatrix4fv(uniforms[PROJECTION], 1, GL_FALSE, projection);
	glUniformMatrix4fv(uniforms[MODELVIEW], 1, GL_FALSE, modelview);
	glUniformMatrix3fv(uniforms[NORMAL_MATRIX], 1, GL_FALSE, normal_matrix);
	
	//lights
	//copy
	GLint _light_on_off[MAX_LIGHTS];
	GLint _light_type[MAX_LIGHTS];
	Vertex _light_dir[MAX_LIGHTS];
	Vertex _light_spot_pos[MAX_LIGHTS];
	GLfloat _light_spot_angle[MAX_LIGHTS];
	GLfloat _light_spot_exp[MAX_LIGHTS];
	Color _light_diffuse[MAX_LIGHTS];
	Color _light_ambient[MAX_LIGHTS];
	Color _light_specular[MAX_LIGHTS];
	GLfloat _light_c_att[MAX_LIGHTS];
	GLfloat _light_l_att[MAX_LIGHTS];
	GLfloat _light_q_att[MAX_LIGHTS];
	
	int lights_used = 2;
	
	for (int i=0; i<lights_used; i++){
		_light_on_off[i] = light[i].on_off;
		_light_type[i] = light[i].type;
		vertex_set(&_light_dir[i], light[i].dir.x, light[i].dir.y, light[i].dir.z);
		vertex_set(&_light_spot_pos[i], light[i].spot_pos.x, light[i].spot_pos.y, light[i].spot_pos.z);
		_light_spot_angle[i] = light[i].spot_angle;
		_light_spot_exp[i] = light[i].spot_exp;
		color_set(&_light_diffuse[i], light[i].diffuse.red, light[i].diffuse.green, light[i].diffuse.blue, light[i].diffuse.alpha);
		color_set(&_light_ambient[i], light[i].ambient.red, light[i].ambient.green, light[i].ambient.blue, light[i].ambient.alpha);
		color_set(&_light_specular[i], light[i].specular.red, light[i].specular.green, light[i].specular.blue, light[i].specular.alpha);
		_light_c_att[i] = light[i].c_att;
		_light_l_att[i] = light[i].l_att;
		_light_q_att[i] = light[i].q_att;
	}
	
	for (int i=lights_used; i<MAX_LIGHTS; i++)
		_light_on_off[i] = 0;
	
	
	glUniform1iv(uniforms[LIGHT_ON_OFF], MAX_LIGHTS, _light_on_off);
	glUniform1iv(uniforms[LIGHT_TYPE], MAX_LIGHTS, _light_type);
	glUniform3fv(uniforms[LIGHT_DIR], MAX_LIGHTS, (GLfloat *)_light_dir);
	glUniform3fv(uniforms[LIGHT_SPOT_POS], MAX_LIGHTS, (GLfloat *)_light_spot_pos);
	glUniform1fv(uniforms[LIGHT_SPOT_ANGLE], MAX_LIGHTS, _light_spot_angle);
	glUniform1fv(uniforms[LIGHT_SPOT_EXP], MAX_LIGHTS, _light_spot_exp);
	glUniform4fv(uniforms[LIGHT_DIFFUSE], MAX_LIGHTS, (GLfloat *)_light_diffuse);
	glUniform4fv(uniforms[LIGHT_AMBIENT], MAX_LIGHTS, (GLfloat *)_light_ambient);
	glUniform4fv(uniforms[LIGHT_SPECULAR], MAX_LIGHTS, (GLfloat *)_light_specular);
	glUniform1fv(uniforms[LIGHT_C_ATT], MAX_LIGHTS, _light_c_att);
	glUniform1fv(uniforms[LIGHT_L_ATT], MAX_LIGHTS, _light_l_att);
	glUniform1fv(uniforms[LIGHT_Q_ATT], MAX_LIGHTS, _light_q_att);
	
	//material
	glUniform4f(uniforms[MATERIAL_DIFFUSE], m->diffuse.red, m->diffuse.green, m->diffuse.blue, m->diffuse.alpha);
	glUniform4f(uniforms[MATERIAL_AMBIENT], m->ambient.red, m->ambient.green, m->ambient.blue, m->ambient.alpha);
	glUniform4f(uniforms[MATERIAL_SPECULAR], m->specular.red, m->specular.green, m->specular.blue, m->specular.alpha);
	glUniform1f(uniforms[MATERIAL_SHININESS], m->shininess);	
	
	
	//texture
	glUniform1i(uniforms[TEXTURE_UNIT], 1);
}


- (void)render
{
    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];

    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
	
	//static GLfloat set = 0;
	//if (!set) {
	//	set++;
		
		//[self setup];
		
		//[self vbos];
		
		//[self lights:YES];	
		
		//[self textures];
	//}		
	

    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    
    static GLfloat rot = 0.0f;
    rot+=0.05;	
	
	matrix_set_identity(modelview);
	translate(modelview, 0.0, 0.0, -3.0);
	rotate(modelview, rot, 0.0, 1.0, 0.0);	
	
	normal_matrix_from_modelview(normal_matrix, modelview);
	
	Material m;
	color_set(&m.diffuse, 0.5, 0.5, 0.5, 1.0);
	color_set(&m.ambient, 0.0, 0.0, 0.0, 1.0);
	color_set(&m.specular, 0.8, 0.8, 0.8, 1.0);
	m.shininess = 300.0;

	[self uniform:&m];
	
	
	//glActiveTexture(GL_TEXTURE0); 
	//glBindTexture(GL_TEXTURE_2D, texture[1]);


    //attribute values
	/*glBindBuffer(GL_ARRAY_BUFFER, cube2.vertexVbo);
	glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, sizeof(ColoredVertexData3D), (void*)offsetof(ColoredVertexData3D,vertex));
    glEnableVertexAttribArray(ATTRIB_VERTEX);
	glVertexAttribPointer(ATTRIB_COLOR, 4, GL_FLOAT, 0, sizeof(ColoredVertexData3D), (void*)offsetof(ColoredVertexData3D,color));
    glEnableVertexAttribArray(ATTRIB_COLOR);
	glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, 0, sizeof(ColoredVertexData3D), (void*)offsetof(ColoredVertexData3D,normal));
    glEnableVertexAttribArray(ATTRIB_NORMAL);*/
	
	/*glBindBuffer(GL_ARRAY_BUFFER, sphere.vertexVbo);
	glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, 0, (void*)0);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
	glBindBuffer(GL_ARRAY_BUFFER, sphere.normalVbo);
	glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, 0, 0, (void*)0);
	glEnableVertexAttribArray(ATTRIB_NORMAL);*/
	
//	glCullFace(GL_BACK);
	glFrontFace(GL_CCW);
	
	glBindBuffer(GL_ARRAY_BUFFER, rect2_t.vbo);
	glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, sizeof(VertexNormTexInt), (void*)offsetof(VertexNormTexInt,vertex));
	glEnableVertexAttribArray(ATTRIB_VERTEX);
	
	glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, 0, sizeof(VertexNormTexInt), (void*)offsetof(VertexNormTexInt,normal));
	glEnableVertexAttribArray(ATTRIB_NORMAL);
	
	glVertexAttribPointer(ATTRIB_TEXTCOORD, 2, GL_FLOAT, 0, sizeof(VertexNormTexInt), (void*)offsetof(VertexNormTexInt,tex));
	glEnableVertexAttribArray(ATTRIB_TEXTCOORD);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, rect2_t.ibo[0]);
	glDrawElements(GL_TRIANGLE_STRIP, rect2_t.num_indicies[0], GL_UNSIGNED_SHORT, (void*)0);
	
//translate(modelview, 0.0, 0.0, -0.1);
//[self uniform:&m];	
	
	//glCullFace(GL_FRONT);
	glFrontFace(GL_CW);
	
   	glBindBuffer(GL_ARRAY_BUFFER, back_rect2_t.vbo);
	glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, sizeof(VertexNormTexInt), (void*)offsetof(VertexNormTexInt,vertex));
	glEnableVertexAttribArray(ATTRIB_VERTEX);
	
	glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, 0, sizeof(VertexNormTexInt), (void*)offsetof(VertexNormTexInt,normal));
	glEnableVertexAttribArray(ATTRIB_NORMAL);
	
	glVertexAttribPointer(ATTRIB_TEXTCOORD, 2, GL_FLOAT, 0, sizeof(VertexNormTexInt), (void*)offsetof(VertexNormTexInt,tex));
	glEnableVertexAttribArray(ATTRIB_TEXTCOORD); 
	
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, back_rect2_t.ibo[0]);
	glDrawElements(GL_TRIANGLE_STRIP, back_rect2_t.num_indicies[0], GL_UNSIGNED_SHORT, (void*)0);		
	

	// Validate program before drawing. This is a good check, but only really necessary in a debug build.
    // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
    if (![self validateProgram:program])
    {
        NSLog(@"Failed to validate program: %d", program);
        return;
    }
#endif


	

	
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, sphere.nrOfVerticies);
	
	//glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cube2.indexVbo);
	//glDrawElements(GL_TRIANGLES, cube2.nrOfIndicies, GL_UNSIGNED_SHORT, cube2.indicies);
	//glDrawElements(GL_TRIANGLES, cube2.nrOfIndicies, GL_UNSIGNED_SHORT, (void*)0);

    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;

    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }

    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);

#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif

    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }

    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;

    glLinkProgram(prog);

#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif

    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;

    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;

    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }

    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;

    return TRUE;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;

    // Create shader program
    program = glCreateProgram();

    // Create and compile vertex shader
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"light_texture" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }

    // Create and compile fragment shader
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"light_texture" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }

    // Attach vertex shader to program
    glAttachShader(program, vertShader);

    // Attach fragment shader to program
    glAttachShader(program, fragShader);

    // Bind attribute locations
    // this needs to be done prior to linking
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(program, ATTRIB_COLOR, "color");
	glBindAttribLocation(program, ATTRIB_NORMAL, "normal");
	glBindAttribLocation(program, ATTRIB_TEXTCOORD, "textcoord");

    // Link program
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);

        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }

    // Get uniform locations
	uniforms[PROJECTION] = glGetUniformLocation(program, "projection");
	uniforms[MODELVIEW] = glGetUniformLocation(program, "modelview");
	uniforms[NORMAL_MATRIX] = glGetUniformLocation(program, "normal_matrix");
	
	uniforms[TEXTURE_UNIT] = glGetUniformLocation(program, "tex_sampler");
	
	uniforms[LIGHT_ON_OFF] = glGetUniformLocation(program, "light_on_off");
	uniforms[LIGHT_TYPE] = glGetUniformLocation(program, "light_type");
	uniforms[LIGHT_DIR] = glGetUniformLocation(program, "light_dir");
	uniforms[LIGHT_SPOT_POS] = glGetUniformLocation(program, "light_spot_pos");
	uniforms[LIGHT_SPOT_ANGLE] = glGetUniformLocation(program, "light_spot_angle");
	uniforms[LIGHT_SPOT_EXP] = glGetUniformLocation(program, "light_spot_exp");
	uniforms[LIGHT_C_ATT] = glGetUniformLocation(program, "light_c_att");
	uniforms[LIGHT_L_ATT] = glGetUniformLocation(program, "light_l_att");
	uniforms[LIGHT_Q_ATT] = glGetUniformLocation(program, "light_q_att");
	uniforms[LIGHT_DIFFUSE] = glGetUniformLocation(program, "light_diffuse");
	uniforms[LIGHT_AMBIENT] = glGetUniformLocation(program, "light_ambient");
	uniforms[LIGHT_SPECULAR] = glGetUniformLocation(program, "light_specular");
	
	uniforms[MATERIAL_DIFFUSE] = glGetUniformLocation(program, "material_diffuse");
	uniforms[MATERIAL_AMBIENT] = glGetUniformLocation(program, "material_ambient");
	uniforms[MATERIAL_SPECULAR] = glGetUniformLocation(program, "material_specular");	
	uniforms[MATERIAL_SHININESS] = glGetUniformLocation(program, "material_shininess");	

    // Release vertex and fragment shaders
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);

    return TRUE;
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{
    // Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
	
	glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);
	
	glViewport(0, 0, backingWidth, backingHeight);

    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }

    return YES;
}

- (void)dealloc
{
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffers(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
        glDeleteRenderbuffers(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
	if (depthRenderbuffer)
    {
        glDeleteRenderbuffers(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }

    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }

    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];

    [context release];
    context = nil;

    [super dealloc];
}

@end
