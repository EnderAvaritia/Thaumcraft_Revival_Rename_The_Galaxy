#loader contenttweaker

import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.CreativeTab;
import mods.contenttweaker.Item;

val TRRG_Tab as CreativeTab = VanillaFactory.createCreativeTab("Thaumcraft_Revival_Rename_The_Galaxy",<item:avaritia:resource>);
TRRG_Tab.register();

val gravel as Item = VanillaFactory.createItem("gravel");
gravel.creativeTab = <creativetab:Thaumcraft_Revival_Rename_The_Galaxy>;
gravel.maxStackSize = 64;
gravel.register();

val stoneStick as Item = VanillaFactory.createItem("stone_stick");
stoneStick.creativeTab = <creativetab:Thaumcraft_Revival_Rename_The_Galaxy>;
stoneStick.maxStackSize = 64;
stoneStick.register();

val straw as Item = VanillaFactory.createItem("straw");
straw.creativeTab = <creativetab:Thaumcraft_Revival_Rename_The_Galaxy>;
straw.maxStackSize = 64;
straw.register();