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
