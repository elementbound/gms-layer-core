///meshgen_cylinder(steps)
// Generates a 2x2x2 cylinder with flat shading

var steps = argument0;
var mesh = mesh_create(); 

// Generate top cap
for(var i = 0; i < steps; i++) {
    mesh_vertex(mesh, 0,0,1, 0,0,1, 0.5,0);
    
    var pos = dirvec3(i/steps*360, 0);
    var u = i/steps;
    mesh_vertex(mesh, pos[0],pos[1],1, 0,0,1, u,0);
    
    var pos = dirvec3((i+1)/steps*360, 0);
    var u = (i+1)/steps;
    mesh_vertex(mesh, pos[0],pos[1],1, 0,0,1, u,0);
}

// Generate bottom cap
for(var i = 0; i < steps; i++) {
    mesh_vertex(mesh, 0,0,-1, 0,0,-1, 0.5,1);
    
    var pos = dirvec3(i/steps*360, 0);
    var u = i/steps;
    mesh_vertex(mesh, pos[0],pos[1],-1, 0,0,-1, u,1);
    
    var pos = dirvec3((i+1)/steps*360, 0);
    var u = (i+1)/steps;
    mesh_vertex(mesh, pos[0],pos[1],-1, 0,0,-1, u,1);
}

// Generate sides
for(var i = 0; i < steps; i++) {
    var v_current = dirvec3(i/steps*360, 0);
    var v_next = dirvec3((i+1)/steps*360, 0);
    var v_mid = dirvec3((i+0.5)/steps*360, 0);
    
    var u_current = i/steps;
    var u_next = (i+1)/steps;
    
    mesh_vertex(mesh, v_current[0],v_current[1], 1, v_mid[0],v_mid[1],0, u_current,0);
    mesh_vertex(mesh, v_next[0],   v_next[1],    1, v_mid[0],v_mid[1],0, u_next,   0);
    mesh_vertex(mesh, v_current[0],v_current[1],-1, v_mid[0],v_mid[1],0, u_current,1);
    
    mesh_vertex(mesh, v_next[0],   v_next[1],    1, v_mid[0],v_mid[1],0, u_next,   0);
    mesh_vertex(mesh, v_current[0],v_current[1],-1, v_mid[0],v_mid[1],0, u_current,1);
    mesh_vertex(mesh, v_next[0],   v_next[1],   -1, v_mid[0],v_mid[1],0, u_next,   1);
}

// Build and return
mesh_build(mesh);
return mesh;
