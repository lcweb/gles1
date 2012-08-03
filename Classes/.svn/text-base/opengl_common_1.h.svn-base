#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


#define kZNear                          0.01
#define kZFar                           1000.0
#define kFieldOfView                    45.0

// Macros
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

typedef struct {
	GLfloat	x;
	GLfloat y;
	GLfloat z;
} Vertex3D;

static inline Vertex3D Vertex3DMake(CGFloat inX, CGFloat inY, CGFloat inZ)
{
	Vertex3D ret;
	ret.x = inX;
	ret.y = inY;
	ret.z = inZ;
	return ret;
}
static inline void Vertex3DSet(Vertex3D *vertex, CGFloat inX, CGFloat inY, CGFloat inZ)
{
    vertex->x = inX;
    vertex->y = inY;
    vertex->z = inZ;
}



typedef struct {
	GLfloat	red;
	GLfloat	green;
	GLfloat	blue;
	GLfloat alpha;
} Color3D;
static inline Color3D Color3DMake(CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    Color3D ret;
	ret.red = inRed;
	ret.green = inGreen;
	ret.blue = inBlue;
	ret.alpha = inAlpha;
    return ret;
}
static inline void Color3DSet(Color3D *color, CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    color->red = inRed;
    color->green = inGreen;
    color->blue = inBlue;
    color->alpha = inAlpha;
}



struct
{
	GLuint		nrOfVerticies;
	GLuint		nrOfIndicies;
	
	GLuint		vertexVbo;
	GLuint		indexVbo;
	Vertex3D	*verticies;
    GLushort	*indicies;
	Vertex3D    *normals;
	
}
typedef Mesh;


typedef struct {
    GLfloat     s;
    GLfloat     t;
} TextureCoord3D;

static inline void TextureCoord3DSet(TextureCoord3D *texture, CGFloat s, CGFloat t)
{
    texture->s = s;
    texture->t = t;
}


typedef struct {
    Vertex3D    vertex;
    Vertex3D    normal;
} VertexData3D;
typedef struct {
    Vertex3D        vertex;
    Vertex3D        normal;
    TextureCoord3D  texCoord;
} TexturedVertexData3D;
typedef struct {
    Vertex3D    vertex;
    Vertex3D    normal;
    Color3D     color;
} ColoredVertexData3D;


struct
{
	GLuint		nrOfVerticies;
	GLuint		nrOfIndicies;
	
	GLuint		vertexVbo;
	GLuint		indexVbo;
	ColoredVertexData3D	*verticies;
    GLushort	*indicies;
}
typedef Mesh2_c;
struct
{
	GLuint		nrOfVerticies;
	GLuint		nrOfIndicies;
	
	GLuint		vertexVbo;
	GLuint		indexVbo;
	TexturedVertexData3D	*verticies;
    GLushort	*indicies;
}
typedef Mesh2_t;
struct
{
	GLuint		nrOfVerticies;
	GLuint		nrOfIndicies;
	
	GLuint		vertexVbo;
	GLuint		indexVbo;
	VertexData3D	*verticies;
    GLushort	*indicies;
}
typedef Mesh2;

static inline void free_mesh(Mesh * m){
	if (m->verticies)
		free(m->verticies);
	if (m->indicies)
		free(m->indicies);
	if (m->normals)
		free(m->normals);
}
static inline void free_mesh2(Mesh2 * m){
	if (m->verticies)
		free(m->verticies);
	if (m->indicies)
		free(m->indicies);
}
static inline void free_mesh2_c(Mesh2_c * m){
	if (m->verticies)
		free(m->verticies);
	if (m->indicies)
		free(m->indicies);
}
static inline void free_mesh2_t(Mesh2_t * m){
	if (m->verticies)
		free(m->verticies);
	if (m->indicies)
		free(m->indicies);
}



static inline GLfloat Vector3DMagnitude(Vertex3D vector)
{
	return sqrtf((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z)); 
}
static inline void Vector3DNormalize(Vertex3D *vector)
{
	GLfloat vecMag = Vector3DMagnitude(*vector);
	if ( vecMag == 0.0 )
	{
		vector->x = 1.0;
		vector->y = 0.0;
		vector->z = 0.0;
        return;
	}
	vector->x /= vecMag;
	vector->y /= vecMag;
	vector->z /= vecMag;
}

static inline Vertex3D Vector3DMakeWithStartAndEndPoints(Vertex3D start, Vertex3D end)
{
	Vertex3D ret;
	ret.x = end.x - start.x;
	ret.y = end.y - start.y;
	ret.z = end.z - start.z;
	Vector3DNormalize(&ret);
	return ret;
}


typedef struct {
	Vertex3D v1;
	Vertex3D v2;
	Vertex3D v3;
} Triangle3D;
static inline Triangle3D Triangle3DMake(Vertex3D inV1, Vertex3D inV2, Vertex3D inV3)
{
	Triangle3D ret;
	ret.v1 = inV1;
	ret.v2 = inV2;
	ret.v3 = inV3;
	return ret;
}


static inline Vertex3D Triangle3DCalculateSurfaceNormal(Triangle3D triangle)
{
	Vertex3D u = Vector3DMakeWithStartAndEndPoints(triangle.v2, triangle.v1);
    Vertex3D v = Vector3DMakeWithStartAndEndPoints(triangle.v3, triangle.v1);
	
	Vertex3D ret;
	ret.x = (u.y * v.z) - (u.z * v.y);
	ret.y = (u.z * v.x) - (u.x * v.z);
	ret.z = (u.x * v.y) - (u.y * v.x);
	return ret;
}

static inline Vertex3D VertexAverage(Vertex3D v1, Vertex3D v2){
	Vertex3D ret;
	ret.x = (v1.x + v2.x)/2;
	ret.y = (v1.y + v2.y)/2;
	ret.z = (v1.z + v2.z)/2;
	return ret;
}
static inline Vertex3D VertexAverage3(Vertex3D v1, Vertex3D v2, Vertex3D v3){
	Vertex3D ret;
	ret.x = (v1.x + v2.x + v3.x)/3;
	ret.y = (v1.y + v2.y + v3.y)/3;
	ret.z = (v1.z + v2.z + v3.z)/3;
	return ret;
}
static inline Vertex3D VertexAverage4(Vertex3D v1, Vertex3D v2, Vertex3D v3, Vertex3D v4){
	Vertex3D ret;
	ret.x = (v1.x + v2.x + v3.x + v4.x)/4;
	ret.y = (v1.y + v2.y + v3.y + v4.y)/4;
	ret.z = (v1.z + v2.z + v3.z + v4.z)/4;
	return ret;
}
static inline Vertex3D VertexAverage5(Vertex3D v1, Vertex3D v2, Vertex3D v3, Vertex3D v4, Vertex3D v5){
	Vertex3D ret;
	ret.x = (v1.x + v2.x + v3.x + v4.x + v5.x)/5;
	ret.y = (v1.y + v2.y + v3.y + v4.y + v5.y)/5;
	ret.z = (v1.z + v2.z + v3.z + v4.z + v5.z)/5;
	return ret;
}

// This is a modified version of the function of the same name from 
// the Mesa3D project ( http://mesa3d.org/ ), which is  licensed
// under the MIT license, which allows use, modification, and 
// redistribution
static inline void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez,
							 GLfloat centerx, GLfloat centery, GLfloat centerz,
							 GLfloat upx, GLfloat upy, GLfloat upz)
{
	GLfloat m[16];
	GLfloat x[3], y[3], z[3];
	GLfloat mag;
	
	/* Make rotation matrix */
	
	/* Z vector */
	z[0] = eyex - centerx;
	z[1] = eyey - centery;
	z[2] = eyez - centerz;
	mag = sqrtf(z[0] * z[0] + z[1] * z[1] + z[2] * z[2]);
	if (mag) {			/* mpichler, 19950515 */
		z[0] /= mag;
		z[1] /= mag;
		z[2] /= mag;
	}
	
	/* Y vector */
	y[0] = upx;
	y[1] = upy;
	y[2] = upz;
	
	/* X vector = Y cross Z */
	x[0] = y[1] * z[2] - y[2] * z[1];
	x[1] = -y[0] * z[2] + y[2] * z[0];
	x[2] = y[0] * z[1] - y[1] * z[0];
	
	/* Recompute Y = Z cross X */
	y[0] = z[1] * x[2] - z[2] * x[1];
	y[1] = -z[0] * x[2] + z[2] * x[0];
	y[2] = z[0] * x[1] - z[1] * x[0];
	
	/* mpichler, 19950515 */
	/* cross product gives area of parallelogram, which is < 1.0 for
	 * non-perpendicular unit-length vectors; so normalize x, y here
	 */
	
	mag = sqrtf(x[0] * x[0] + x[1] * x[1] + x[2] * x[2]);
	if (mag) {
		x[0] /= mag;
		x[1] /= mag;
		x[2] /= mag;
	}
	
	mag = sqrtf(y[0] * y[0] + y[1] * y[1] + y[2] * y[2]);
	if (mag) {
		y[0] /= mag;
		y[1] /= mag;
		y[2] /= mag;
	}
	
#define M(row,col)  m[col*4+row]
	M(0, 0) = x[0];
	M(0, 1) = x[1];
	M(0, 2) = x[2];
	M(0, 3) = 0.0;
	M(1, 0) = y[0];
	M(1, 1) = y[1];
	M(1, 2) = y[2];
	M(1, 3) = 0.0;
	M(2, 0) = z[0];
	M(2, 1) = z[1];
	M(2, 2) = z[2];
	M(2, 3) = 0.0;
	M(3, 0) = 0.0;
	M(3, 1) = 0.0;
	M(3, 2) = 0.0;
	M(3, 3) = 1.0;
#undef M
	glMultMatrixf(m);
	
	/* Translate Eye to Origin */
	glTranslatef(-eyex, -eyey, -eyez);
	
}

static inline void print_mmatrix(){
	GLfloat modelMatrix[16];
	glGetFloatv(GL_MODELVIEW, modelMatrix);
	for (int i=0;i<16;i++)
		NSLog(@"%f ", modelMatrix[i]);
}


static void getSolidSphere(Vertex3D **triangleStripVertexHandle,   // Will hold vertices to be drawn as a triangle strip. 
					//      Calling code responsible for freeing if not NULL
                    Vertex3D **triangleStripNormalHandle,   // Will hold normals for vertices to be drawn as triangle 
					//      strip. Calling code is responsible for freeing if 
					//      not NULL
                    GLuint *triangleStripVertexCount,       // On return, will hold the number of vertices contained in
					//      triangleStripVertices
					// =========================================================
                    Vertex3D **triangleFanVertexHandle,     // Will hold vertices to be drawn as a triangle fan. Calling
					//      code responsible for freeing if not NULL
                    Vertex3D **triangleFanNormalHandle,     // Will hold normals for vertices to be drawn as triangle 
					//      strip. Calling code is responsible for freeing if 
					//      not NULL
                    GLuint *triangleFanVertexCount,         // On return, will hold the number of vertices contained in
					//      the triangleFanVertices
					// =========================================================
                    GLfloat radius,                         // The radius of the circle to be drawn
                    GLuint slices,                          // The number of slices, determines vertical "resolution"
                    GLuint stacks)                          // the number of stacks, determines horizontal "resolution"
// =========================================================
{
    
    GLfloat rho, drho, theta, dtheta;
    GLfloat x, y, z;
    GLfloat s, ds;
    GLfloat nsign = 1.0;
    drho = M_PI / (GLfloat) stacks;
    dtheta = 2.0 * M_PI / (GLfloat) slices;
    
    Vertex3D *triangleStripVertices, *triangleFanVertices;
    Vertex3D *triangleStripNormals, *triangleFanNormals;
    
    // Calculate the Triangle Fan for the endcaps
    *triangleFanVertexCount = slices+2;
    triangleFanVertices = calloc(*triangleFanVertexCount, sizeof(Vertex3D));
    triangleFanVertices[0].x = 0.0;
    triangleFanVertices[0].y = 0.0; 
    triangleFanVertices[0].z = nsign * radius;
    int counter = 1;
    for (int j = 0; j <= slices; j++) 
    {
        theta = (j == slices) ? 0.0 : j * dtheta;
        x = -sin(theta) * sin(drho);
        y = cos(theta) * sin(drho);
        z = nsign * cos(drho);
        triangleFanVertices[counter].x = x * radius;
        triangleFanVertices[counter].y = y * radius;
        triangleFanVertices[counter++].z = z * radius;
    }
    
    
    // Normals for a sphere around the origin are darn easy - just treat the vertex as a vector and normalize it.
    triangleFanNormals = malloc(*triangleFanVertexCount * sizeof(Vertex3D));
    memcpy(triangleFanNormals, triangleFanVertices, *triangleFanVertexCount * sizeof(Vertex3D));
    for (int i = 0; i < *triangleFanVertexCount; i++)
        Vector3DNormalize(&triangleFanNormals[i]);
    
    // Calculate the triangle strip for the sphere body
    *triangleStripVertexCount = (slices + 1) * 2 * stacks;
    triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(Vertex3D));
    counter = 0;
    for (int i = 0; i < stacks; i++) {
        rho = i * drho;
		
        s = 0.0;
        for (int j = 0; j <= slices; j++) 
        {
            theta = (j == slices) ? 0.0 : j * dtheta;
            x = -sin(theta) * sin(rho);//Xcos(theta/2)  X=sin(rho)
            y = cos(theta) * sin(rho);
            z = nsign * cos(rho);
            // TODO: Implement texture mapping if texture used
            //                TXTR_COORD(s, t);
            triangleStripVertices[counter].x = x * radius;
            triangleStripVertices[counter].y = y * radius;
            triangleStripVertices[counter++].z = z * radius;
            x = -sin(theta) * sin(rho + drho);
            y = cos(theta) * sin(rho + drho);
            z = nsign * cos(rho + drho);
            //                TXTR_COORD(s, t - dt);
            s += ds;
            triangleStripVertices[counter].x = x * radius;
            triangleStripVertices[counter].y = y * radius;
            triangleStripVertices[counter++].z = z * radius;
        }
    }
    
    triangleStripNormals = malloc(*triangleStripVertexCount * sizeof(Vertex3D));
    memcpy(triangleStripNormals, triangleStripVertices, *triangleStripVertexCount * sizeof(Vertex3D));
    for (int i = 0; i < *triangleStripVertexCount; i++)
		Vector3DNormalize(&triangleStripNormals[i]);
    
    *triangleStripVertexHandle = triangleStripVertices;
    *triangleStripNormalHandle = triangleStripNormals;
    *triangleFanVertexHandle = triangleFanVertices;
    *triangleFanNormalHandle = triangleFanNormals;
}

static void getCube(Vertex3D **triangleStripVertexHandle,   
			 Vertex3D **triangleStripNormalHandle,    
			 GLuint *triangleStripVertexCount,
			 GLushort **indices,
			 GLuint *indices_count,
			 GLfloat radius)
{
	Vertex3D *triangleStripVertices;
    Vertex3D *triangleStripNormals;
	
	Vertex3D surface_normals[12];
	
	*triangleStripVertexCount = 8;
    
	triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(Vertex3D));
	
	Vertex3DSet(&triangleStripVertices[0], -radius, radius, 0.5);
	Vertex3DSet(&triangleStripVertices[1], -radius, -radius, 0.5);
	Vertex3DSet(&triangleStripVertices[2], radius, radius, 0.5);
	Vertex3DSet(&triangleStripVertices[3], radius, -radius, 0.5);
	Vertex3DSet(&triangleStripVertices[4], radius, radius, -0.5);
	Vertex3DSet(&triangleStripVertices[5], radius, -radius, -0.5);
	Vertex3DSet(&triangleStripVertices[6], -radius, radius, -0.5);
	Vertex3DSet(&triangleStripVertices[7], -radius, -radius, -0.5);
	
	triangleStripNormals = calloc(*triangleStripVertexCount, sizeof(Vertex3D));
	
	surface_normals[0] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[0], triangleStripVertices[1],
																		 triangleStripVertices[2]));
	surface_normals[1] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[3], triangleStripVertices[2],
																		 triangleStripVertices[1]));
	surface_normals[2] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[2], triangleStripVertices[3],
																		 triangleStripVertices[4]));
	surface_normals[3] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[5], triangleStripVertices[4],
																		 triangleStripVertices[3]));
	surface_normals[4] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[4], triangleStripVertices[5],
																		 triangleStripVertices[6]));
	surface_normals[5] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[7], triangleStripVertices[6],
																		 triangleStripVertices[5]));
	surface_normals[6] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[6], triangleStripVertices[7],
																		 triangleStripVertices[0]));
	surface_normals[7] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[1], triangleStripVertices[0],
																		 triangleStripVertices[7]));
	surface_normals[8] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[2], triangleStripVertices[4],
																		 triangleStripVertices[0]));
	surface_normals[9] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[6], triangleStripVertices[0],
																		 triangleStripVertices[4]));
	surface_normals[10] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[5], triangleStripVertices[3],
																		  triangleStripVertices[7]));
	surface_normals[11] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[1], triangleStripVertices[7],
																		  triangleStripVertices[3]));
	
	triangleStripNormals[0] = VertexAverage5(surface_normals[0], surface_normals[8], surface_normals[9], surface_normals[6], surface_normals[7]);
	triangleStripNormals[1] = VertexAverage4(surface_normals[0], surface_normals[1], surface_normals[7], surface_normals[11]);
	triangleStripNormals[2] = VertexAverage4(surface_normals[0], surface_normals[1], surface_normals[2], surface_normals[8]);
	triangleStripNormals[3] = VertexAverage5(surface_normals[1], surface_normals[2], surface_normals[3], surface_normals[10], surface_normals[11]);
	triangleStripNormals[4] = VertexAverage5(surface_normals[2], surface_normals[3], surface_normals[4], surface_normals[8], surface_normals[9]);
	triangleStripNormals[5] = VertexAverage4(surface_normals[3], surface_normals[4], surface_normals[5], surface_normals[10]);
	triangleStripNormals[6] = VertexAverage4(surface_normals[4], surface_normals[5], surface_normals[9], surface_normals[6]);
	triangleStripNormals[7] = VertexAverage5(surface_normals[5], surface_normals[6], surface_normals[7], surface_normals[10], surface_normals[11]);
	
	
	/*NSLog(@"x: %f; y: %f; z: %f;", surface_normals[0].x, surface_normals[0].y, surface_normals[0].z); 
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[1].x, surface_normals[1].y, surface_normals[1].z); 
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[2].x, surface_normals[2].y, surface_normals[2].z); 
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[3].x, surface_normals[3].y, surface_normals[3].z);  
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[4].x, surface_normals[4].y, surface_normals[4].z);  
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[5].x, surface_normals[5].y, surface_normals[5].z);  
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[6].x, surface_normals[6].y, surface_normals[6].z);  
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[7].x, surface_normals[7].y, surface_normals[7].z); 
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[8].x, surface_normals[8].y, surface_normals[7].z); 
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[9].x, surface_normals[9].y, surface_normals[7].z); 
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[10].x, surface_normals[10].y, surface_normals[7].z); 
	 NSLog(@"x: %f; y: %f; z: %f;", surface_normals[11].x, surface_normals[11].y, surface_normals[7].z); 
	 NSLog(@" ");
	 NSLog(@"x: %f; y: %f; z: %f;", triangleStripNormals[0].x, triangleStripNormals[0].y, triangleStripNormals[0].z);
	 NSLog(@"x: %f; y: %f; z: %f;", triangleStripNormals[1].x, triangleStripNormals[1].y, triangleStripNormals[1].z);
	 NSLog(@"x: %f; y: %f; z: %f;", triangleStripNormals[2].x, triangleStripNormals[2].y, triangleStripNormals[2].z);
	 NSLog(@"x: %f; y: %f; z: %f;", triangleStripNormals[3].x, triangleStripNormals[3].y, triangleStripNormals[3].z);
	 NSLog(@"x: %f; y: %f; z: %f;", triangleStripNormals[4].x, triangleStripNormals[4].y, triangleStripNormals[4].z);
	 NSLog(@"x: %f; y: %f; z: %f;", triangleStripNormals[5].x, triangleStripNormals[5].y, triangleStripNormals[5].z);
	 NSLog(@"x: %f; y: %f; z: %f;", triangleStripNormals[6].x, triangleStripNormals[6].y, triangleStripNormals[6].z);
	 NSLog(@"x: %f; y: %f; z: %f;", triangleStripNormals[7].x, triangleStripNormals[7].y, triangleStripNormals[7].z);*/
	
	*triangleStripVertexHandle = triangleStripVertices;
    *triangleStripNormalHandle = triangleStripNormals;
	
	*indices_count = 36;
	
	*indices = calloc(*indices_count, sizeof(GLushort));
	
	GLushort icube[] = {
		0, 1, 2,
		2, 1, 3,
		2, 3, 4,
		4, 3, 5,
		4, 5, 6,
		
		6, 5, 7,
		6, 7, 0,
		0, 7, 1,
		2, 4, 0,
		0, 4, 6,
		5, 3, 7,
		7, 3, 1,
	};
	/*static const Color3D colors[] = {
	 {1.0, 0.0, 0.0, 1.0},
	 {1.0, 0.5, 0.0, 1.0},
	 {1.0, 1.0, 0.0, 1.0},
	 {0.5, 1.0, 0.0, 1.0},
	 {0.0, 1.0, 0.0, 1.0},
	 {0.0, 1.0, 0.5, 1.0},
	 {0.0, 1.0, 1.0, 1.0},
	 {0.0, 0.5, 1.0, 1.0},
	 };*/
	for (int i=0; i<*indices_count;i++)
		(*indices)[i] = icube[i];
	
	
}	



static void getCube2(VertexData3D **triangleStripVertexHandle,   
			  GLuint *triangleStripVertexCount,
			  GLushort **indices,
			  GLuint *indices_count,
			  GLfloat radius)
{
	VertexData3D *triangleStripVertices;
	
	Vertex3D surface_normals[12];
	
	*triangleStripVertexCount = 8;
    
	triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(VertexData3D));
	
	Vertex3DSet(&(triangleStripVertices[0].vertex), -radius, radius, 0.5);
	Vertex3DSet(&(triangleStripVertices[1].vertex), -radius, -radius, 0.5);
	Vertex3DSet(&(triangleStripVertices[2].vertex), radius, radius, 0.5);
	Vertex3DSet(&(triangleStripVertices[3].vertex), radius, -radius, 0.5);
	Vertex3DSet(&(triangleStripVertices[4].vertex), radius, radius, -0.5);
	Vertex3DSet(&(triangleStripVertices[5].vertex), radius, -radius, -0.5);
	Vertex3DSet(&(triangleStripVertices[6].vertex), -radius, radius, -0.5);
	Vertex3DSet(&(triangleStripVertices[7].vertex), -radius, -radius, -0.5);
	
	
	surface_normals[0] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[0].vertex, triangleStripVertices[1].vertex,
																		 triangleStripVertices[2].vertex));
	surface_normals[1] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[3].vertex, triangleStripVertices[2].vertex,
																		 triangleStripVertices[1].vertex));
	surface_normals[2] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[2].vertex, triangleStripVertices[3].vertex,
																		 triangleStripVertices[4].vertex));
	surface_normals[3] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[5].vertex, triangleStripVertices[4].vertex,
																		 triangleStripVertices[3].vertex));
	surface_normals[4] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[4].vertex, triangleStripVertices[5].vertex,
																		 triangleStripVertices[6].vertex));
	surface_normals[5] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[7].vertex, triangleStripVertices[6].vertex,
																		 triangleStripVertices[5].vertex));
	surface_normals[6] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[6].vertex, triangleStripVertices[7].vertex,
																		 triangleStripVertices[0].vertex));
	surface_normals[7] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[1].vertex, triangleStripVertices[0].vertex,
																		 triangleStripVertices[7].vertex));
	surface_normals[8] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[2].vertex, triangleStripVertices[4].vertex,
																		 triangleStripVertices[0].vertex));
	surface_normals[9] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[6].vertex, triangleStripVertices[0].vertex,
																		 triangleStripVertices[4].vertex));
	surface_normals[10] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[5].vertex, triangleStripVertices[3].vertex,
																		  triangleStripVertices[7].vertex));
	surface_normals[11] = Triangle3DCalculateSurfaceNormal(Triangle3DMake(triangleStripVertices[1].vertex, triangleStripVertices[7].vertex,
																		  triangleStripVertices[3].vertex));
	
	triangleStripVertices[0].normal = VertexAverage5(surface_normals[0], surface_normals[8], surface_normals[9], surface_normals[6], surface_normals[7]);
	triangleStripVertices[1].normal = VertexAverage4(surface_normals[0], surface_normals[1], surface_normals[7], surface_normals[11]);
	triangleStripVertices[2].normal = VertexAverage4(surface_normals[0], surface_normals[1], surface_normals[2], surface_normals[8]);
	triangleStripVertices[3].normal = VertexAverage5(surface_normals[1], surface_normals[2], surface_normals[3], surface_normals[10], surface_normals[11]);
	triangleStripVertices[4].normal = VertexAverage5(surface_normals[2], surface_normals[3], surface_normals[4], surface_normals[8], surface_normals[9]);
	triangleStripVertices[5].normal = VertexAverage4(surface_normals[3], surface_normals[4], surface_normals[5], surface_normals[10]);
	triangleStripVertices[6].normal = VertexAverage4(surface_normals[4], surface_normals[5], surface_normals[9], surface_normals[6]);
	triangleStripVertices[7].normal = VertexAverage5(surface_normals[5], surface_normals[6], surface_normals[7], surface_normals[10], surface_normals[11]);
	
	
	*triangleStripVertexHandle = triangleStripVertices;
	
	*indices_count = 36;
	
	*indices = calloc(*indices_count, sizeof(GLushort));
	
	GLushort icube[] = {
		0, 1, 2,
		2, 1, 3,
		2, 3, 4,
		4, 3, 5,
		4, 5, 6,
		
		6, 5, 7,
		6, 7, 0,
		0, 7, 1,
		2, 4, 0,
		0, 4, 6,
		5, 3, 7,
		7, 3, 1,
	};
	/*static const Color3D colors[] = {
	 {1.0, 0.0, 0.0, 1.0},
	 {1.0, 0.5, 0.0, 1.0},
	 {1.0, 1.0, 0.0, 1.0},
	 {0.5, 1.0, 0.0, 1.0},
	 {0.0, 1.0, 0.0, 1.0},
	 {0.0, 1.0, 0.5, 1.0},
	 {0.0, 1.0, 1.0, 1.0},
	 {0.0, 0.5, 1.0, 1.0},
	 };*/
	for (int i=0; i<*indices_count;i++)
		(*indices)[i] = icube[i];
	
	
}


static void getRectStrip2(VertexData3D **triangleStripVertexHandle,   
				   GLuint *triangleStripVertexCount,
				   GLushort **indices,
				   GLuint *indices_count,
				   GLfloat radius)
{
	VertexData3D *triangleStripVertices;
	
	Vertex3D surface_normals[8];
	
	*triangleStripVertexCount = 9;
    
	triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(VertexData3D));
	
	Vertex3DSet(&(triangleStripVertices[0].vertex), -radius, radius, 0);
	Vertex3DSet(&(triangleStripVertices[1].vertex), 0, radius, 0);
	Vertex3DSet(&(triangleStripVertices[2].vertex), radius, radius, 0);
	Vertex3DSet(&(triangleStripVertices[3].vertex), -radius, 0, 0);
	Vertex3DSet(&(triangleStripVertices[4].vertex), 0, 0, 0);
	Vertex3DSet(&(triangleStripVertices[5].vertex), radius, 0, 0);
	Vertex3DSet(&(triangleStripVertices[6].vertex), -radius, -radius, 0);
	Vertex3DSet(&(triangleStripVertices[7].vertex), 0, -radius, 0);
	Vertex3DSet(&(triangleStripVertices[8].vertex), radius, -radius, 0);
	
	Vertex3DSet(&(triangleStripVertices[0].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[1].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[2].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[3].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[4].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[5].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[6].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[7].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[8].normal), 0, 0, 1);
	
	
	*triangleStripVertexHandle = triangleStripVertices;
	
	*indices_count = 14;
	
	*indices = calloc(*indices_count, sizeof(GLushort));
	
	GLushort strip[] = {
		0,3,1,4,2,5,
		5,3,
		3,6,4,7,5,8
	};
	
	for (int i=0; i<*indices_count;i++)
		(*indices)[i] = strip[i];
	
	
}	


static void getRectStrip2_t(TexturedVertexData3D **triangleStripVertexHandle,   
					 GLuint *triangleStripVertexCount,
					 GLushort **indices,
					 GLuint *indices_count,
					 GLfloat radius)
{
	TexturedVertexData3D *triangleStripVertices;
	
	Vertex3D surface_normals[8];
	
	*triangleStripVertexCount = 9;
    
	triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(TexturedVertexData3D));
	
	Vertex3DSet(&(triangleStripVertices[0].vertex), -radius, radius, 0);
	Vertex3DSet(&(triangleStripVertices[1].vertex), 0, radius, 0);
	Vertex3DSet(&(triangleStripVertices[2].vertex), radius, radius, 0);
	Vertex3DSet(&(triangleStripVertices[3].vertex), -radius, 0, 0);
	Vertex3DSet(&(triangleStripVertices[4].vertex), 0, 0, 0);
	Vertex3DSet(&(triangleStripVertices[5].vertex), radius, 0, 0);
	Vertex3DSet(&(triangleStripVertices[6].vertex), -radius, -radius, 0);
	Vertex3DSet(&(triangleStripVertices[7].vertex), 0, -radius, 0);
	Vertex3DSet(&(triangleStripVertices[8].vertex), radius, -radius, 0);
	
	Vertex3DSet(&(triangleStripVertices[0].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[1].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[2].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[3].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[4].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[5].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[6].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[7].normal), 0, 0, 1);
	Vertex3DSet(&(triangleStripVertices[8].normal), 0, 0, 1);
	
	TextureCoord3DSet(&(triangleStripVertices[0].texCoord), 0.0, 2.0);
	TextureCoord3DSet(&(triangleStripVertices[1].texCoord), 1.0, 2.0);
	TextureCoord3DSet(&(triangleStripVertices[2].texCoord), 2.0, 2.0);
	TextureCoord3DSet(&(triangleStripVertices[3].texCoord), 0.0, 1.0);
	TextureCoord3DSet(&(triangleStripVertices[4].texCoord), 1.0, 1.0);
	TextureCoord3DSet(&(triangleStripVertices[5].texCoord), 2.0, 1.0);
	TextureCoord3DSet(&(triangleStripVertices[6].texCoord), 0.0, 0.0);
	TextureCoord3DSet(&(triangleStripVertices[7].texCoord), 1.0, 0.0);
	TextureCoord3DSet(&(triangleStripVertices[8].texCoord), 2.0, 0.0);
	
	
	*triangleStripVertexHandle = triangleStripVertices;
	
	*indices_count = 14;
	
	*indices = calloc(*indices_count, sizeof(GLushort));
	
	GLushort strip[] = {
		0,3,1,4,2,5,
		5,3,
		3,6,4,7,5,8
	};
	
	for (int i=0; i<*indices_count;i++)
		(*indices)[i] = strip[i];
}	

