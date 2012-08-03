static void getRectStrip2_t(VertexNormTexInt **triangleStripVertexHandle,   
							GLuint *triangleStripVertexCount,
							GLushort **indices,
							GLuint *indices_count,
							GLfloat radius,
							BOOL back_face)
{
	VertexNormTexInt *triangleStripVertices;
	
	Vertex surface_normals[8];
	
	*triangleStripVertexCount = 9;
    
	triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(VertexNormTexInt));
	
	vertex_set(&(triangleStripVertices[0].vertex), -radius, radius, 0);
	vertex_set(&(triangleStripVertices[1].vertex), 0, radius, 0);
	vertex_set(&(triangleStripVertices[2].vertex), radius, radius, 0);
	vertex_set(&(triangleStripVertices[3].vertex), -radius, 0, 0);
	vertex_set(&(triangleStripVertices[4].vertex), 0, 0, 0);
	vertex_set(&(triangleStripVertices[5].vertex), radius, 0, 0);
	vertex_set(&(triangleStripVertices[6].vertex), -radius, -radius, 0);
	vertex_set(&(triangleStripVertices[7].vertex), 0, -radius, 0);
	vertex_set(&(triangleStripVertices[8].vertex), radius, -radius, 0);
	
	GLfloat n = 1.0;
	if (back_face) n = -1.0;
	vertex_set(&(triangleStripVertices[0].normal), 0, 0, n);
	vertex_set(&(triangleStripVertices[1].normal), 0, 0, n);
	vertex_set(&(triangleStripVertices[2].normal), 0, 0, n);
	vertex_set(&(triangleStripVertices[3].normal), 0, 0, n);
	vertex_set(&(triangleStripVertices[4].normal), 0, 0, n);
	vertex_set(&(triangleStripVertices[5].normal), 0, 0, n);
	vertex_set(&(triangleStripVertices[6].normal), 0, 0, n);
	vertex_set(&(triangleStripVertices[7].normal), 0, 0, n);
	vertex_set(&(triangleStripVertices[8].normal), 0, 0, n);
	
	tex_set(&(triangleStripVertices[0].tex), 0.0, 2.0);
	tex_set(&(triangleStripVertices[1].tex), 1.0, 2.0);
	tex_set(&(triangleStripVertices[2].tex), 2.0, 2.0);
	tex_set(&(triangleStripVertices[3].tex), 0.0, 1.0);
	tex_set(&(triangleStripVertices[4].tex), 1.0, 1.0);
	tex_set(&(triangleStripVertices[5].tex), 2.0, 1.0);
	tex_set(&(triangleStripVertices[6].tex), 0.0, 0.0);
	tex_set(&(triangleStripVertices[7].tex), 1.0, 0.0);
	tex_set(&(triangleStripVertices[8].tex), 2.0, 0.0);
	
	
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
