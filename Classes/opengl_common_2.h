#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


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
	GLuint      normalVbo;
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




//column major order
typedef GLfloat Matrix3D[16];

static inline float fastAbs(float x) { return (x < 0) ? -x : x; }
static inline GLfloat fastSinf(GLfloat x)
{
	// fast sin function; maximum error is 0.001
	const float P = 0.225;
	
	x = x * M_1_PI;
	int k = (int) round(x);
	x = x - k;
    
	float y = (4 - 4 * fastAbs(x)) * x;
    
	y = P * (y * fastAbs(y) - y) + y;
    
	return (k&1) ? -y : y;
}

#if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
#define VFP_CLOBBER_S0_S31 "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8",  \
"s9", "s10", "s11", "s12", "s13", "s14", "s15", "s16",  \
"s17", "s18", "s19", "s20", "s21", "s22", "s23", "s24",  \
"s25", "s26", "s27", "s28", "s29", "s30", "s31"
#define VFP_VECTOR_LENGTH(VEC_LENGTH) "fmrx    r0, fpscr                         \n\t" \
"bic     r0, r0, #0x00370000               \n\t" \
"orr     r0, r0, #0x000" #VEC_LENGTH "0000 \n\t" \
"fmxr    fpscr, r0                         \n\t"
#define VFP_VECTOR_LENGTH_ZERO "fmrx    r0, fpscr            \n\t" \
"bic     r0, r0, #0x00370000  \n\t" \
"fmxr    fpscr, r0            \n\t" 
#endif
static inline void Matrix3DMultiply(Matrix3D m1, Matrix3D m2, Matrix3D result)
{
#if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
    __asm__ __volatile__ ( VFP_VECTOR_LENGTH(3)
                          
                          // Interleaving loads and adds/muls for faster calculation.
                          // Let A:=src_ptr_1, B:=src_ptr_2, then
                          // function computes A*B as (B^T * A^T)^T.
                          
                          // Load the whole matrix into memory.
                          "fldmias  %2, {s8-s23}    \n\t"
                          // Load first column to scalar bank.
                          "fldmias  %1!, {s0-s3}    \n\t"
                          // First column times matrix.
                          "fmuls s24, s8, s0        \n\t"
                          "fmacs s24, s12, s1       \n\t"
                          
                          // Load second column to scalar bank.
                          "fldmias %1!,  {s4-s7}    \n\t"
                          
                          "fmacs s24, s16, s2       \n\t"
                          "fmacs s24, s20, s3       \n\t"
                          // Save first column.
                          "fstmias  %0!, {s24-s27}  \n\t" 
                          
                          // Second column times matrix.
                          "fmuls s28, s8, s4        \n\t"
                          "fmacs s28, s12, s5       \n\t"
                          
                          // Load third column to scalar bank.
                          "fldmias  %1!, {s0-s3}    \n\t"
                          
                          "fmacs s28, s16, s6       \n\t"
                          "fmacs s28, s20, s7       \n\t"
                          // Save second column.
                          "fstmias  %0!, {s28-s31}  \n\t" 
                          
                          // Third column times matrix.
                          "fmuls s24, s8, s0        \n\t"
                          "fmacs s24, s12, s1       \n\t"
                          
                          // Load fourth column to scalar bank.
                          "fldmias %1,  {s4-s7}    \n\t"
                          
                          "fmacs s24, s16, s2       \n\t"
                          "fmacs s24, s20, s3       \n\t"
                          // Save third column.
                          "fstmias  %0!, {s24-s27}  \n\t" 
                          
                          // Fourth column times matrix.
                          "fmuls s28, s8, s4        \n\t"
                          "fmacs s28, s12, s5       \n\t"
                          "fmacs s28, s16, s6       \n\t"
                          "fmacs s28, s20, s7       \n\t"
                          // Save fourth column.
                          "fstmias  %0!, {s28-s31}  \n\t" 
                          
                          VFP_VECTOR_LENGTH_ZERO
                          : "=r" (result), "=r" (m2)
                          : "r" (m1), "0" (result), "1" (m2)
                          : "r0", "cc", "memory", VFP_CLOBBER_S0_S31
                          );
#else
    result[0] = m1[0] * m2[0] + m1[4] * m2[1] + m1[8] * m2[2] + m1[12] * m2[3];
    result[1] = m1[1] * m2[0] + m1[5] * m2[1] + m1[9] * m2[2] + m1[13] * m2[3];
    result[2] = m1[2] * m2[0] + m1[6] * m2[1] + m1[10] * m2[2] + m1[14] * m2[3];
    result[3] = m1[3] * m2[0] + m1[7] * m2[1] + m1[11] * m2[2] + m1[15] * m2[3];
    
    result[4] = m1[0] * m2[4] + m1[4] * m2[5] + m1[8] * m2[6] + m1[12] * m2[7];
    result[5] = m1[1] * m2[4] + m1[5] * m2[5] + m1[9] * m2[6] + m1[13] * m2[7];
    result[6] = m1[2] * m2[4] + m1[6] * m2[5] + m1[10] * m2[6] + m1[14] * m2[7];
    result[7] = m1[3] * m2[4] + m1[7] * m2[5] + m1[11] * m2[6] + m1[15] * m2[7];
    
    result[8] = m1[0] * m2[8] + m1[4] * m2[9] + m1[8] * m2[10] + m1[12] * m2[11];
    result[9] = m1[1] * m2[8] + m1[5] * m2[9] + m1[9] * m2[10] + m1[13] * m2[11];
    result[10] = m1[2] * m2[8] + m1[6] * m2[9] + m1[10] * m2[10] + m1[14] * m2[11];
    result[11] = m1[3] * m2[8] + m1[7] * m2[9] + m1[11] * m2[10] + m1[15] * m2[11];
    
    result[12] = m1[0] * m2[12] + m1[4] * m2[13] + m1[8] * m2[14] + m1[12] * m2[15];
    result[13] = m1[1] * m2[12] + m1[5] * m2[13] + m1[9] * m2[14] + m1[13] * m2[15];
    result[14] = m1[2] * m2[12] + m1[6] * m2[13] + m1[10] * m2[14] + m1[14] * m2[15];
    result[15] = m1[3] * m2[12] + m1[7] * m2[13] + m1[11] * m2[14] + m1[15] * m2[15];
#endif
    
}


static inline void Matrix3DSetIdentity(Matrix3D matrix)
{
    matrix[0] = matrix[5] =  matrix[10] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;    
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
}
static inline void Matrix3DSetTranslation(Matrix3D matrix, GLfloat xTranslate, GLfloat yTranslate, GLfloat zTranslate)
{
    matrix[0] = matrix[5] =  matrix[10] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;    
    matrix[11] = 0.0;
    matrix[12] = xTranslate;
    matrix[13] = yTranslate;
    matrix[14] = zTranslate;   
}
static inline void Matrix3DSetScaling(Matrix3D matrix, GLfloat xScale, GLfloat yScale, GLfloat zScale)
{
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[0] = xScale;
    matrix[5] = yScale;
    matrix[10] = zScale;
    matrix[15] = 1.0;
}
static inline void Matrix3DSetUniformScaling(Matrix3D matrix, GLfloat scale)
{
    Matrix3DSetScaling(matrix, scale, scale, scale);
}
static inline void Matrix3DSetXRotationUsingRadians(Matrix3D matrix, GLfloat degrees)
{
    matrix[0] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[7] = matrix[8] = 0.0;    
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    
    matrix[5] = cosf(degrees);
    matrix[6] = -fastSinf(degrees);
    matrix[9] = -matrix[6];
    matrix[10] = matrix[5];
}
static inline void Matrix3DSetXRotationUsingDegrees(Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetXRotationUsingRadians(matrix, degrees * M_PI / 180.0);
}
static inline void Matrix3DSetYRotationUsingRadians(Matrix3D matrix, GLfloat degrees)
{
    matrix[0] = cosf(degrees);
    matrix[2] = fastSinf(degrees);
    matrix[8] = -matrix[2];
    matrix[10] = matrix[0];
    matrix[1] = matrix[3] = matrix[4] = matrix[6] = matrix[7] = 0.0;
    matrix[9] = matrix[11] = matrix[13] = matrix[12] = matrix[14] = 0.0;
    matrix[5] = matrix[15] = 1.0;
}
static inline void Matrix3DSetYRotationUsingDegrees(Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetYRotationUsingRadians(matrix, degrees * M_PI / 180.0);
}
static inline void Matrix3DSetZRotationUsingRadians(Matrix3D matrix, GLfloat degrees)
{
    matrix[0] = cosf(degrees);
    matrix[1] = fastSinf(degrees);
    matrix[4] = -matrix[1];
    matrix[5] = matrix[0];
    matrix[2] = matrix[3] = matrix[6] = matrix[7] = matrix[8] = 0.0;
    matrix[9] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[10] = matrix[15] = 1.0;
}
static inline void Matrix3DSetZRotationUsingDegrees(Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetZRotationUsingRadians(matrix, degrees * M_PI / 180.0);
}
static inline void Matrix3DSetRotationByRadians(Matrix3D matrix, GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
{
    GLfloat mag = sqrtf((x*x) + (y*y) + (z*z));
    if (mag == 0.0)
    {
        x = 1.0;
        y = 0.0;
        z = 0.0;
    }
    else if (mag != 1.0)
    {
        x /= mag;
        y /= mag;
        z /= mag;
    }
    
    GLfloat c = cosf(angle);
    GLfloat s = fastSinf(angle);
    matrix[3] = matrix[7] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[15] = 1.0;
    
    
    matrix[0] = (x*x)*(1-c) + c;
    matrix[1] = (y*x)*(1-c) + (z*s);
    matrix[2] = (x*z)*(1-c) - (y*s);
    matrix[4] = (x*y)*(1-c)-(z*s);
    matrix[5] = (y*y)*(1-c)+c;
    matrix[6] = (y*z)*(1-c)+(x*s);
    matrix[8] = (x*z)*(1-c)+(y*s);
    matrix[9] = (y*z)*(1-c)-(x*s);
    matrix[10] = (z*z)*(1-c)+c;
    
}
static inline void Matrix3DSetRotationByDegrees(Matrix3D matrix, GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
{
    Matrix3DSetRotationByRadians(matrix, angle * M_PI / 180.0, x, y, z);
}
static inline void Matrix3DSetShear(Matrix3D matrix, GLfloat xShear, GLfloat yShear)
{
    matrix[0] = matrix[5] =  matrix[10] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;    
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[1] = xShear;
    matrix[4] = yShear;
}



static inline void matrix_mul(Matrix3D m1, Matrix3D m2, Matrix3D result)
{
	Matrix3D res;
	
	Matrix3DMultiply(m1, m2, res);
	
	memcpy((void *)result, (void *)res, sizeof(GLfloat)*16);
}

static inline void rotate(Matrix3D m, GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
{
	Matrix3D r;
	Matrix3DSetRotationByDegrees(r, angle, x, y, z);
	
	matrix_mul(m, r, m);
}

static inline void translate(Matrix3D m, GLfloat x, GLfloat y, GLfloat z)
{
	Matrix3D t;
	Matrix3DSetTranslation(t, x, y, z);
	
	matrix_mul(m, t, m);
}



static void print_matrix(Matrix3D m, int size){
	for (int i=0;i<size;i++)
		NSLog(@"%f ", m[i]);
	NSLog(@" ");
}


static inline void frustum(Matrix3D r, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far)
{
	Matrix3D m;
	
	m[0] = (2.0*near)/(right-left);
	m[4] = 0.0;
	m[8] = (right+left)/(right-left);
	m[12] = 0.0;
	
	m[1] = 0.0;
	m[5] = (2.0*near)/(top-bottom);
	m[9] = (top+bottom)/(top-bottom);
	m[13] = 0.0;
	
	m[2] = 0.0;
	m[6] = 0.0;
	m[10] = -((far+near)/(far-near));
	m[14] = -((2.0*far*near)/(far-near));
	
	m[3] = 0.0;
	m[7] = 0.0;
	m[11] = -1.0;
	m[15] = 0.0;
	
	matrix_mul(r, m, r);
}


static inline void ortho(Matrix3D r, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far)
{
	Matrix3D m;
	
	m[0] = (2.0)/(right-left);
	m[4] = 0.0;
	m[8] = 0.0;
	m[12] = -(right+left)/(right-left);
	
	m[1] = 0.0;
	m[5] = (2.0)/(top-bottom);
	m[9] = 0.0;
	m[13] = -(top+bottom)/(top-bottom);
	
	m[2] = 0.0;
	m[6] = 0.0;
	m[10] = -((2.0)/(far-near));
	m[14] = -((far+near)/(far-near));
	
	m[3] = 0.0;
	m[7] = 0.0;
	m[11] = 0.0;
	m[15] = 1.0;
	
	matrix_mul(r, m, r);
}




static inline void normal_matrix_from_modelview(GLfloat * normal_matrix, Matrix3D modelview)
{
	normal_matrix[0] = modelview[0];
	normal_matrix[1] = modelview[1];
	normal_matrix[2] = modelview[2];
	
	normal_matrix[3] = modelview[4];
	normal_matrix[4] = modelview[5];
	normal_matrix[5] = modelview[6];
	
	normal_matrix[6] = modelview[8];
	normal_matrix[7] = modelview[9];
	normal_matrix[8] = modelview[10];
	
	//TODO scale support
}





//lights

#define MAX_LIGHTS 4

typedef struct {
	GLbyte on_off;
	GLbyte type;
	
	Vertex3D dir;
	
	Vertex3D spot_pos;	
	GLfloat spot_angle;
	GLfloat spot_exp;
	
	Color3D ambient;
	Color3D diffuse;
	Color3D specular;
	
	GLfloat c_att;
	GLfloat l_att;
	GLfloat q_att;
} Light;

//materials
typedef struct {
	Color3D emission;
	Color3D ambient;
	Color3D diffuse;
	Color3D specular;
	GLfloat shininess;
} Material;
