precision lowp float;

//varying

//normal
varying vec3 vNormal;

//lights
varying vec4 diffuse[2],ambient[2];
varying vec3 lightDir[2],halfVector[2];
varying float dist[2];

//uniforms

//lights
uniform highp int light_on_off[2];
uniform highp int light_type[2];
uniform highp vec3 light_dir[2];
uniform vec4 light_specular[2];
uniform float light_c_att[2];
uniform float light_l_att[2];
uniform float light_q_att[2];
uniform float light_spot_angle[2];
uniform float light_spot_exp[2];

//material
uniform lowp vec4 material_specular;
uniform float material_shininess;

void main()
{
	vec3 n,halfV,viewV,ldir;
	float NdotL,NdotHV;
	int MAX_LIGHTS = 2;
	float att = 1.0;
	float spotEffect;
	
	n = normalize(vNormal);
		
	vec4 color = vec4(0.0,0.0,0.0,0.0);
	
	for (int i=0; i<MAX_LIGHTS; i++){
		if (light_on_off[i] == 0) continue;
	
		halfV = normalize(halfVector[i]);
		NdotHV = max(dot(n,halfV),0.0);
	
		if (light_type[i] == 0){ //sun
	
			color += ambient[i];
			
			NdotL = max(dot(n,lightDir[i]),0.0);

			if (NdotL > 0.0) {
				color += diffuse[i] * NdotL;
			}
		} else if (light_type[i] == 1){//point
			NdotL = max(dot(n,normalize(lightDir[i])),0.0);
			if (NdotL > 0.0) {
				att = 1.0 / (light_c_att[i] + light_l_att[i] * dist[i] + light_q_att[i] * dist[i] * dist[i]);	
				color += att * (diffuse[i] * NdotL + ambient[i]);	
			}
		} else {//spot
			NdotL = max(dot(n,normalize(lightDir[i])),0.0);
			if (NdotL > 0.0) {
				spotEffect = dot(light_dir[i], normalize(-lightDir[i]));
				if (spotEffect > light_spot_angle[i]) {
					spotEffect = pow(spotEffect, light_spot_exp[i]);
					att = spotEffect / (light_c_att[i] + light_l_att[i] * dist[i] + light_q_att[i] * dist[i] * dist[i]);	
					color += att * (diffuse[i] * NdotL + ambient[i]);	
					color += att * material_specular * light_specular[i] * pow(NdotHV,material_shininess);
					continue;
				} else continue;
			} 
		}
		
		if (NdotL > 0.0) 
			color += att * material_specular * light_specular[i] * pow(NdotHV,material_shininess);	
	}

	gl_FragColor = color;
}
