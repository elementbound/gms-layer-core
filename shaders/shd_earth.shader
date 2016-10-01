attribute vec3 in_Position; 
attribute vec2 in_TextureCoord; 

varying vec2 v_Texcoord;
varying vec2 v_TransformCoord;

uniform mat4 u_TextureMatrix; 

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
    
    v_Texcoord = in_TextureCoord;
    v_TransformCoord = (u_TextureMatrix * vec4(in_TextureCoord, 0.0, 1.0)).xy;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_Texcoord;
varying vec2 v_TransformCoord;

uniform float u_SideIntensity;
uniform vec4 u_Ambient;
uniform sampler2D u_Sides;
uniform sampler2D u_Noise; 

void main()
{
    vec4 base = texture2D( gm_BaseTexture, v_Texcoord );
    vec4 side = texture2D(u_Sides, v_TransformCoord);
    vec4 crustColor = mix(base, base*side, u_SideIntensity) + u_Ambient;
    
    float noise = texture2D(u_Noise, v_TransformCoord).x; 
    float thresh = abs(v_Texcoord.y*2.0 - 1.0);
    thresh = pow(thresh, 16.0);
    
    if(noise < thresh)
        gl_FragColor = vec4(0.37, 0.405, 0.0, 1.0);
    else 
        gl_FragColor = crustColor;
}

