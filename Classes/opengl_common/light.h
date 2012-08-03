//Light


//Light
typedef struct {
	GLbyte on_off;
	GLbyte type;
	
	Vertex dir;
	
	Vertex spot_pos;	
	GLfloat spot_angle;
	GLfloat spot_exp;
	
	Color ambient;
	Color diffuse;
	Color specular;
	
	GLfloat c_att;
	GLfloat l_att;
	GLfloat q_att;
} Light;