//rotate, translate, frustum, ortho, 
//normal_matrix_from_modelview

static inline void rotate(Matrix m, GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
{
	Matrix r;
	matrix_set_rotation_radians(r, angle, x, y, z);
	
	matrix_mul(m, r, m);
}

static inline void translate(Matrix m, GLfloat x, GLfloat y, GLfloat z)
{
	Matrix t;
	matrix_set_translation(t, x, y, z);
	
	matrix_mul(m, t, m);
}

static inline void frustum(Matrix r, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far)
{
	Matrix m;
	
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


static inline void ortho(Matrix r, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far)
{
	Matrix m;
	
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




static inline void normal_matrix_from_modelview(GLfloat * normal_matrix, Matrix modelview)
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