attribute vec3 in_Position; 
attribute vec3 in_Normal; 

varying vec3 v_Position;
varying vec3 v_Normal;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
    
    vec4 world_pos = gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.0);
    v_Position = world_pos.xyz / world_pos.w; 
    v_Normal = in_Normal;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec3 v_Position;
varying vec3 v_Normal;

uniform float u_Subtract; 

uniform sampler2D u_Ramp; 

// Triplanar projection
vec4 textureTriplanar(sampler2D texture, vec3 texCoord, vec3 texWeights) 
{
    float fullWeight = dot(texWeights, vec3(1.0)); //x+y+z
    
    vec4 topColor   = texture2D(texture, texCoord.xy) * texWeights.z;
    vec4 frontColor = texture2D(texture, texCoord.xz) * texWeights.y;
    vec4 rightColor = texture2D(texture, texCoord.yz) * texWeights.x;
    
    return (topColor + frontColor + rightColor) / fullWeight;
}

void main()
{
    float intensity = textureTriplanar( gm_BaseTexture, v_Position, abs(normalize(v_Normal))).r;
    
    if(intensity < u_Subtract)
        discard; 
        
    gl_FragColor = texture2D(u_Ramp, vec2(intensity, 0.0));
}

