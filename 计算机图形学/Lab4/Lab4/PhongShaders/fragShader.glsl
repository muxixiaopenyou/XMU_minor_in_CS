#version 430

in vec3 varyingNormal;
in vec3 varyingLightDir;
in vec3 varyingLightDir2;
in vec3 varyingVertPos;

out vec4 fragColor;

struct PositionalLight
{	vec4 ambient;  
	vec4 diffuse;  
	vec4 specular;  
	vec3 position;
};

struct Material
{	vec4 ambient;  
	vec4 diffuse;  
	vec4 specular;  
	float shininess;
};

uniform vec4 globalAmbient;
uniform PositionalLight light;
uniform PositionalLight light2;

uniform Material material;
uniform mat4 mv_matrix;	 
uniform mat4 proj_matrix;
uniform mat4 norm_matrix;

void main(void)
{	// normalize the light, normal, and view vectors:
	vec3 L = normalize(varyingLightDir);
	vec3 L2 = normalize(varyingLightDir2);
	vec3 N = normalize(varyingNormal);
	vec3 V = normalize(-varyingVertPos);
	
	// compute light reflection vector, with respect N:
	vec3 R = normalize(reflect(-L, N));
	vec3 R2 = normalize(reflect(-L2, N));
	
	// get the angle between the light and surface normal:
	float cosTheta = dot(L,N);
	float cosTheta2 = dot(L2,N);
	
	// angle between the view vector and reflected light:
	float cosPhi = dot(V,R);
	float cosPhi2 = dot(V,R2);

	// compute ADS contributions (per pixel):
	vec3 ambient = ((globalAmbient * material.ambient) + (light.ambient * material.ambient) + (light2.ambient * material.ambient)).xyz;

	vec3 diffuse = light.diffuse.xyz * material.diffuse.xyz * max(cosTheta,0.0);
	vec3 diffuse2 = light2.diffuse.xyz * material.diffuse.xyz * max(cosTheta2,0.0);

	vec3 specular = light.specular.xyz * material.specular.xyz * pow(max(cosPhi,0.0), material.shininess);
	vec3 specular2 = light2.specular.xyz * material.specular.xyz * pow(max(cosPhi2,0.0), material.shininess);

	vec3 finalColor = ambient + diffuse + specular + diffuse2 + specular2;

	fragColor = vec4(clamp(finalColor, 0.0, 1.0), 1.0);

}

