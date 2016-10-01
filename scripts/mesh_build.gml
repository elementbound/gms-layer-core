///mesh_build(mesh)
with(argument0) {
    if(buffer != -1)
        vertex_delete_buffer(buffer);
        
    buffer = vertex_create_buffer(); 
    vertex_count = ds_list_size(positions)/3;
    
    vertex_begin(buffer, renderer.vf_default);
    for(var i = 0; i < vertex_count; i++) {
        var vx = positions[|i*3+0];
        var vy = positions[|i*3+1];
        var vz = positions[|i*3+2];
        
        var nx = normals[|i*3+0];
        var ny = normals[|i*3+1];
        var nz = normals[|i*3+2];
        
        var u = texcoords[|i*2+0];
        var v = texcoords[|i*2+1];
        v = 1-v;
        
        vertex_position_3d(buffer, vx,vy,vz);
        vertex_texcoord(buffer, u,v); 
        vertex_normal(buffer, nx,ny,nz); 
    }
    vertex_end(buffer);
    
    return true; 
}
