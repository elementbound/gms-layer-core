///texture_reload(texture)
with(argument0) {
    if(object_index == texture_volatile) {
        var background = background_add(source, 0,0);
    
        if(!background_exists(background)) {
            data = assets.default_texture;
            reload_needed = false;
            
            return false; 
        }
        
        width = background_get_width(background);
        height = background_get_height(background);
        
        surface = surface_create(width, height);
        surface_set_target(surface);
            d3d_set_projection_ortho(0,0, width,height, 0);
            draw_clear_alpha(c_black, 0);
            draw_background(background, 0,0);
        surface_reset_target();
        
        data = surface_get_texture(surface);
        
        background_delete(background); 
        reload_needed = false; 
        
        return true; 
    }
}
