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