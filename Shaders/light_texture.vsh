attribute vec3 position;
attribute vec3 normal;
attribute vec2 textcoord;

//varying

//textures
varying vec2 fragmentTextureCoordinates;

//normal
varying vec3 vNormal;

//lights
//varying vec4 diffuse[2],ambient[2];
varying vec3 lightDir[2],halfVector[2];
varying float dist[2];

//uniforms

//matrices
uniform mat4 projection;
uniform mat4 modelview;
uniform mat3 normal_matrix;

//lights
uniform int light_on_off[2];
uniform int light_type[2];
uniform vec3 light_dir[2];
uniform vec3 light_spot_pos[2];
uniform vec4 light_diffuse[2];
uniform vec4 light_ambient[2];

//material
uniform vec4 material_diffuse;
uniform vec4 material_ambient;

	
void main()
{	
	vec4 pos = vec4(position, 1.0);
	vec3 e = vec3(modelview * pos);
	
	int MAX_LIGHTS = 2;

	vNormal = normalize(normal_matrix * normal);
	fragmentTextureCoordinates = textcoord;
	
	for (int i=0; i<MAX_LIGHTS; i++){
		if (light_on_off[i] == 0) continue;
		
		if (light_type[i] == 0){ //sun
			lightDir[i] = light_dir[i];
		} else { //type 1, 2 (point, spot)
			vec3 aux;
			aux = vec3(light_spot_pos[i] - e);
			
			lightDir[i] = normalize(aux);
			dist[i] = length(aux);
		}
		halfVector[i] = normalize(lightDir[i] - e);
		//diffuse[i] = material_diffuse * light_diffuse[i];
		//ambient[i] = material_ambient * light_ambient[i];
		//diffuse[i] = light_diffuse[i];
		//ambient[i] = light_ambient[i];
	}

	gl_Position = projection * modelview * pos;
} 

/*void main() {

	vec3 normal1, lightDir;
	vec4 diffuse, ambient;
	float NdotL;
	
	/* first transform the normal into eye space and normalize the result *
	normal1 = normalize(normal_matrix * normal);
	
	/* now normalize the light's direction. Note that according to the
	OpenGL specification, the light is stored in eye space. Also since 
	we're talking about a directional light, the position field is actually 
	direction *
	//lightDir = normalize(vec3(gl_LightSource[0].position));
	lightDir = light_dir;
	
	/* compute the cos of the angle between the normal and lights direction. 
	The light is directional so the direction is constant for every vertex.
	Since these two are normalized the cosine is the dot product. We also 
	need to clamp the result to the [0,1] range. *
	NdotL = max(dot(normal1, lightDir), 0.0);
	
	/* Compute the diffuse term *
	diffuse = material_diffuse * light_diffuse;
	ambient = material_ambient * light_ambient;
	
	colorVarying =  NdotL * diffuse + ambient;
	
	gl_Position = projection * modelview * position;
}*/