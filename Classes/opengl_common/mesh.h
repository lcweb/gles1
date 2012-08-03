//Texture, Material, Mesh



//Texture
typedef struct {
	GLint texture;
} Texture;


//Material
typedef struct {
	Color emission;
	Color ambient;
	Color diffuse;
	Color specular;
	GLfloat shininess;
} Material;




//Mesh
typedef struct  {
	//private
	GLbyte int_offset;//type 0 -> 8, 1 -> 6, 2-> 7, 3 -> 3
	
	//options
	GLbyte inter;//1 = interleaved, 0
	GLbyte type;//0 = vertex+norm+tex  1=vertex+norm  2=vertex+color  3=vertex
	GLbyte method;//0 = GL_TRIANGLES, others = not supported 
		
	//verticies
	GLint num_verticies;
	
	GLint vbo;
	GLint nbo;//inter = 0 && type = 0,1
	GLint cbo;//inter = 0 && type = 2
	GLint tbo;//inter = 0 && type = 0
	
	GLfloat * verticies;//inter = 1

	Vertex * v;////inter = 0 
	Vertex * normals;//inter = 0 && type = 0,1
	Color * colors;//inter = 0 && type = 2
	Tex * texs;//inter = 0 && type = 0
	
	//subsets
	GLint num_subsets;
	
	GLbyte * opaque;//array  //1 = opaque, 0
	GLbyte * _static;//array  //1 = static 0
	Material * m;//array
	Texture * t;//array
	Texture * t1;//array   multitexturing
	Texture * t2;//array   multitexturing
	GLint * num_indicies;//array
	GLshort ** indicies;//array
	GLint * ibo;//array
	
} Mesh;



static inline void mesh_add_subset(Mesh * m){
	m->num_subsets++;
	
	m->num_indicies = realloc(m->num_indicies, m->num_subsets + sizeof(GLint));
	m->indicies = realloc(m->indicies, m->num_subsets + sizeof(GLshort *));
	m->ibo = realloc(m->ibo, m->num_subsets + sizeof(GLint));
	
	//...
}


static inline void mesh_init(Mesh * m, GLbyte inter, GLbyte type ){
	m->method = 0;
	m->inter = inter;
	m->type = type;
	
	m->int_offset = type;
	if (type == 0) m->int_offset = 8;
	else if (type == 1) m->int_offset = 6;
	else if (type == 2) m->int_offset = 7;
	
	m->v = NULL;
	m->normals = NULL;
	m->colors = NULL;
	m->texs = NULL;
	
	m->num_subsets = 0;
}


static inline void mesh_free_buffered(Mesh * m){
	if (m->verticies) free(m->verticies);
	
	if (m->v) free(m->v);
	if (m->normals) free(m->normals);
	if (m->colors) free(m->colors);
	if (m->texs) free(m->texs);
	
	for (int i=0; i<m->num_subsets; i++) free(m->indicies[i]);
	
}

static inline void mesh_free(Mesh * m){
	mesh_free_buffered(m);
	
	if (m->opaque) free(m->opaque);
	if (m->m) free(m->m);
	if (m->t) free(m->t);
	if (m->t1) free(m->t1);
	if (m->t2) free(m->t2);
	if (m->num_indicies) free(m->num_indicies);
	if (m->ibo) free(m->ibo);
}


