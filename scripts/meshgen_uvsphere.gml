///meshgen_uvsphere(steps)
// Generate a 2x2x2 UV sphere 
// Please note all the useless triangles on the poles
// The sample is not focusing on mesh gen, so I'll let this slide 
// Feel free to fix that if you use this code in your own project 

var usteps = argument0*2;
var vsteps = argument0;
var mesh = mesh_create(); 

for(var i = 0; i < usteps; i++) {
    for(var j = 0; j < vsteps; j++) {
        var v00 = dirvec3(i/usteps*360,     j/vsteps*180-90);
        var v10 = dirvec3((i+1)/usteps*360, j/vsteps*180-90);
        var v11 = dirvec3((i+1)/usteps*360, (j+1)/vsteps*180-90);
        var v01 = dirvec3(i/usteps*360,     (j+1)/vsteps*180-90);
        
        var uv00 = array(i/usteps,     j/vsteps);
        var uv10 = array((i+1)/usteps, j/vsteps);
        var uv11 = array((i+1)/usteps, (j+1)/vsteps);
        var uv01 = array(i/usteps,     (j+1)/vsteps);
        
        mesh_vertex(mesh, v00[0],v00[1],v00[2], v00[0],v00[1],v00[2], uv00[0],uv00[1]);
        mesh_vertex(mesh, v10[0],v10[1],v10[2], v10[0],v10[1],v10[2], uv10[0],uv10[1]);
        mesh_vertex(mesh, v01[0],v01[1],v01[2], v01[0],v01[1],v01[2], uv01[0],uv01[1]);
        
        mesh_vertex(mesh, v10[0],v10[1],v10[2], v10[0],v10[1],v10[2], uv10[0],uv10[1]);
        mesh_vertex(mesh, v01[0],v01[1],v01[2], v01[0],v01[1],v01[2], uv01[0],uv01[1]);
        mesh_vertex(mesh, v11[0],v11[1],v11[2], v11[0],v11[1],v11[2], uv11[0],uv11[1]);
    }
}

mesh_build(mesh);
return mesh; 
