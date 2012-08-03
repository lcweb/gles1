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
//uniform vec4 material_diffuse;
//uniform vec4 material_ambient;

	
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

