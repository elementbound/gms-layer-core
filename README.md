# layer-core

![Final product](https://raw.githubusercontent.com/elementbound/gms-layer-core/master/dev/final.png)

This sample is one part fancy 3D content, one part trying to cut back on memory usage.

My current project, at this moment, consumes around 1 GB of RAM while running. Most of this comes from textures.
I load my textures from external files and simply store them as backgrounds, which takes a huge amount of memory.
To combat this, I have decided to have two types of textures:
  * _Permanent textures_: This is what my current project uses. Load image into background, be happy with that, devour all the RAMs.
  * _Volatile textures_: These textures are stored in surfaces, which reside (mostly?)* on the GPU.
    The drawback is that they can just vanish at any time. To combat this, volatile textures are always checked, and if they are
    lost, they resort to a default texture, and get reloaded some time later. Reloading textures is spread out over multiple steps,
    so the game doesn't just lock up for several seconds.

I also hope that the thing looks nice :P

## Stats ##

  * With volatile textures: 108 MB
  * With permanent textures: 153 MB

Since I happen to not use too many textures ( although I cranked up the resolution a bit, just in case ), the difference is not
earth-shattering.

After adding 21 MBs of 2k PNG files and running it again:
  * With volatile textures: 350 MB
  * With permanent textures: 520 MB

## Settings ##

The demo starts off in full-screen, in desktop resolution by default. You can change this behaviour by changing rSize's Creation
Code. Most of it is self-explanatory. There are two modes of anti-aliasing. You can set aa_mode to _'msaa'_, which is the default
method supported by GMS. The other method, _'brute'_ is a quick hack, because _'msaa'_ doesn't smooth the edges inside the core.
If you use _'brute'_, it's not really worth it to set _aa_ above 2.

## Code ##

Some things worth checking out are:

### Shaders ###

With the lava shader, I didn't want to run into the usual problem of properly unwrapping spheres. I decided to generate my
meshes, so I didn't have to bother with mesh loaders ( that'll happen in another tutorial/samle :P ). So I just went with
a regular UV sphere, which is known to distort on the poles, unless you use some special method of unwrapping.

My solution here was triplanar mapping. [This](https://gamedevelopment.tutsplus.com/articles/use-tri-planar-texture-mapping-for-better-terrain--gamedev-13821)
article explains it pretty well.

 ---

The shaders also often use ramps, which is also a nice little trick worth knowing.

 ---

With the pillars sticking out from the core, the process is a bit more complex. To see the original concept, you can look
at dev/concept.blend's M.Earth material. It's composed of a gradient over the whole cylinder, and a messy grass part on
both ends.

For the grass part, I also sample a pre-baked noise texture, and compare it to a threshold. This value is calculated based
on the cylinder's UVs. We can use the fact that the V coordinate goes from zero to one, spanning the mesh's whole height.
So, if the grass is high enough, it's visible, otherwise it isn't. With the same method, we also apply a gradient to the
grass part.

The best way to understand this is to either look at the .blend file, or to look at the pixel shader code.

Since I don't use any kind of lighting in this demo, that also has to be faked somehow. In Blender, I use approximate
indirect lights. But looking at it, it's easy to notice that it's mostly random-brightness gradients on the sides of
the cylinder. That's easily done through a texture. The sides texture contains 32 gradients with various intensity,
and the cylinder's UV's are transformed in the vertex shader to only cover six random gradients ( next to each other ).

This mostly works, the only exception is when two cylinders with very different brightnesses overlap.

Lastly, we need to give the cylinders the feeling that they are over a molten core, so we add a weak ambient lighting.

### Assets ###

The sample uses a very basic asset manager. The concept is to have a central object managing all the resources, with
a dedicated map to each resource type. These can be later used to access each resource by name. If you'd like to get
more fancy, you could write get/set/exists/load scripts for each resource type. This would allow for a 'default'
resource to be returned when the selected one doesn't exist. This can't easily be done with the raw map accesses
I do in this sample.

 ---

Another aspect of the asset management is loading. You could delegate this functionality to a different object, and
you could also separate the loading code to different objects/scripts, but in our case, the assets are simple enough
to just have everything in the _assets_ object.

So, we have a queue for resources to be loaded. Each resource is queued as a (type, name, data...) triplet. Note that
the data part can have multiple values.

For example, the only data a texture needs is the file name:
> ('texture', 'earth-ramp', 'textures/earth-gradient.png')

However, if we want to generate a mesh, we also need to know how detailed it should be:
> ('mesh/gen', 'cylinder', meshgen_cylinder, 6)

The loader dequeues a single task in each step to execute. This way we can have very simple ( and non-animated! )
progress bars. You could also easily extend this loader to support async tasks ( like load an image from a URL and
not block while we wait for the image ). Just make each task an object, that lives until the task is complete
( and preferably does not ruin the framerate too much ).

### Meshes ###

See _mesh_data_. We could easily go with just storing vertex buffers in the _assets_ object's mesh pool, but that's
a bit limited. Storing some form of additional mesh data ( even if it's just a vertex count ) gives many more
possibilities. To stay with our example, we could easily output the amount of submitted vertices, or the number
of rendered faces just by simply keeping an accumulator variable.

This also lets us easily manipulate meshes - transform them, remove faces, bend them, or even spawn a particle at
each vertex for some fun effects. This also increases memory usage, so the mesh data lists could be just cleared
after the mesh is built ( aka. its vertex buffer is generated from the lists containing vertex data ).

 ---

Since a single mesh could be rendered multiple times at different places, we also have a _mesh_object_ object.
These point to a _mesh_data_ instance to use, and have their own transform.

The more interesting part about this object is that it also handles shader data. Now I'm not saying that this
is generally a nice design, since in more complex renderers and scenes, the same mesh instance could be rendered
multiple times per frame, with different shaders, parameters and goals.

However, in our case, each mesh instance is rendered only once, with only one shader, per frame. So it made sense
to store the shader settings in the instance itself, too. This allows for a very handy and convenient way
to specify shader settings. Combine this with the ease of querying resources, and you get something like this:

```
// From scene object, Alarm 0 event:
with(instance_create(0,0, mesh_object)) {
    data = assets.meshes[?"cylinder"];
    texture = assets.textures[?"earth-ramp"];

    // [...]

    shader = shd_earth;

    samplers[?"u_Sides"] = assets.textures[?"sides"];
    samplers[?"u_Noise"] = assets.textures[?"grass-noise"];
    samplers[?"u_GrassRamp"] = assets.textures[?"grass-ramp"];

    uniforms[?"u_GrassStart"] = random_range(0.925, 0.975);
    uniforms[?"u_SideIntensity"] = random_range(0.75, 1);
    uniforms[?"u_Ambient"] = array(0.95/4, 0.325/4, 0.0/4, 0.0);
    uniforms[?"u_TextureMatrix"] = matrix_build(irandom(32)/32,0,0, 0,0,0, 6/32,1,1);

    // [...]
}
```

You can update these values at any time, so animating shader parameters is pretty easy as well.

### Utility scripts ###

See _concat_. This script takes an arbitrary amount of arguments, concatenates them as strings
and returns the result. Handy for most kind of string assembly. Until we have a 16 argument
limit, keep an eye on that.

_rtdbg_ stands for real-time debug. Whether this makes sense or not ( it blocks the whole game ),
I'll let you be the judge of that. Argument-wise it is the same as _concat_, except it displays
the result in a message box.

__All scripts in the project are public domain. This includes everything in the scripts directory.__
For the rest of the project, see [LICENSE](LICENSE). 
