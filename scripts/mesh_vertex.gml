///mesh_vertex(mesh, x,y,z, nx,ny,nz, u,v)
with(argument0) {
    ds_list_add(positions, argument1,argument2,argument3);
    ds_list_add(normals, argument4,argument5,argument6);
    ds_list_add(texcoords, argument7,argument8);
    
    return true;
}

return false; 
