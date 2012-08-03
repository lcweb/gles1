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
    /**triangleFanVertexCount = slices+2;
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
    */
    // Calculate the triangle strip for the sphere body
    *triangleStripVertexCount = (slices + 1) * 2 * stacks;
    triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(Vertex3D));
    int counter = 0;
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
    //*triangleFanVertexHandle = triangleFanVertices;
    //*triangleFanNormalHandle = triangleFanNormals;
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


static void getCube2_c(ColoredVertexData3D **triangleStripVertexHandle,   
					   GLuint *triangleStripVertexCount,
					   GLushort **indices,
					   GLuint *indices_count,
					   GLfloat radius)
{
	ColoredVertexData3D *triangleStripVertices;
	
	Vertex3D surface_normals[12];
	
	*triangleStripVertexCount = 8;
    
	triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(ColoredVertexData3D));
	
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
	
	const Color3D colors[] = {
		{1.0, 0.0, 0.0, 1.0},
		{1.0, 0.5, 0.0, 1.0},
		{1.0, 1.0, 0.0, 1.0},
		{0.5, 1.0, 0.0, 1.0},
		{0.0, 1.0, 0.0, 1.0},
		{0.0, 1.0, 0.5, 1.0},
		{0.0, 1.0, 1.0, 1.0},
		{0.0, 0.5, 1.0, 1.0},
	};
	
	for (int i=0; i<*triangleStripVertexCount;i++)
		triangleStripVertices[i].color = colors[i];
	
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
							GLfloat radius,
							BOOL back_face)
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
	
	GLfloat n = 1.0;
	if (back_face) n = -1.0;
	Vertex3DSet(&(triangleStripVertices[0].normal), 0, 0, n);
	Vertex3DSet(&(triangleStripVertices[1].normal), 0, 0, n);
	Vertex3DSet(&(triangleStripVertices[2].normal), 0, 0, n);
	Vertex3DSet(&(triangleStripVertices[3].normal), 0, 0, n);
	Vertex3DSet(&(triangleStripVertices[4].normal), 0, 0, n);
	Vertex3DSet(&(triangleStripVertices[5].normal), 0, 0, n);
	Vertex3DSet(&(triangleStripVertices[6].normal), 0, 0, n);
	Vertex3DSet(&(triangleStripVertices[7].normal), 0, 0, n);
	Vertex3DSet(&(triangleStripVertices[8].normal), 0, 0, n);
	
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

