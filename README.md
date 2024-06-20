## Provided file is for ExtDB3
If you're using ExtDB2 (don't) just copy the diff (lines 60 to 124)
# Exile-Tree-Remover-Object
This is an altered Tweak for Arma 3 Exile Mod, originally made by ELRabito

I had a problem with some of the objects not being assigned to any of the terrain types. This made it impossible for this tweak to hide them, since it relies on terrain object types.

I started thinking on how to adjust this code so it can also remove objects without type.

## HOW DOES THIS WORK:

First of all, you need the object names. Those can be partial (eg. "fallenbranch") or complete ("cliff_stone_big_lc_f.p3d"). To find object names, look at the object you want removed and type "getModelInfo cursorObject" command - you will receive an array in return, and the first value and the one with '.p3d' at the end is the object name.

 

1. Add object names: Once you have object name (or multiple) you can add them into one of two already prepared arrays e.g. _extraFilterVegetation or _extraFilterRocks (or you can create new one).

2. Set radius: The drawback of this solution is that it is recommended to define a single _radius for all arrays. It is not mandatory, but if different values for _radius are set, some objects might not be detected.

 

Aside from that, copy the rest of the code and apply the same instructions as OP (https://forums.bohemia.net/forums/topic/229447-tree-remover-object/)

 

In the example I pasted as code above, I wanted to have different buildables to deal with different terrain objects i.e. 'Land_Camping_Light_F' removes trees and bushes, 'Land_Small_Stone_02_F' removes rocks, and 'PortableHelipadLight_01_green_F' removes all of the above. If you just want to remove stuff around the flag, you only need one _extraFilters[] and subsequently, you only need to a single _filteredObjects[]

 

All thanks to @El' Rabito for the original code. 
