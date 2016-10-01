//dirvec3(dir, pitch)
var v, f;
f=dcos(argument1);

v[0]= dcos(argument0)*f;
v[1]=-dsin(argument0)*f;
v[2]= dsin(argument1);

return v;
