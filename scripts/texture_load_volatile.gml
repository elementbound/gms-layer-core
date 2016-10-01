///texture_load_volatile(source) 
with(instance_create(0,0, texture_volatile)) {
    var background = background_add(argument0, 0,0);
    
    if(!background_exists(background)) {
        show_error("Couldn't load " + argument0, 0);
        data = assets.default_texture;
        
        return id; 
    }
    
    source = argument0;

    width = background_get_width(background);
    height = background_get_height(background);
    
    surface = surface_create(width, height);
    surface_set_target(surface);
        d3d_set_projection_ortho(0,0, width,height, 0);
        draw_background(background, 0,0);
    surface_reset_target();
    
    data = surface_get_texture(surface);
    
    background_delete(background); 

    return id;
}
