///texture_load_permanent(source) 
with(instance_create(0,0, texture_volatile)) {
    background = background_add(argument0, 0,0);
    source = argument0;

    width = background_get_width(background);
    height = background_get_height(background);
    
    data = background_get_texture(background);

    return id;
}
