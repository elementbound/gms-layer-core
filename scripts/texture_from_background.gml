///texture_from_background(source)
with(instance_create(0,0, texture_permanent)) {
    background = argument0;
    source = "<internal>";

    width = background_get_width(background);
    height = background_get_height(background);
    
    data = background_get_texture(background);

    return id;
}
