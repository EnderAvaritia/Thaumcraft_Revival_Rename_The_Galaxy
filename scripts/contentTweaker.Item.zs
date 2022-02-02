#loader contenttweaker

import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.CreativeTab;
import mods.contenttweaker.Item;
import mods.contenttweaker.ActionResult;
import mods.contenttweaker.IItemUse;
import crafttweaker.world.IExplosion;

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

val iceCube as Item = VanillaFactory.createItem("ice_cube");
iceCube.creativeTab = <creativetab:Thaumcraft_Revival_Rename_The_Galaxy>;
iceCube.maxStackSize = 64;
iceCube.register();

val crystalEssenceLux as Item = VanillaFactory.createItem("crystal_essence_lux");
crystalEssenceLux.creativeTab = <creativetab:Thaumcraft_Revival_Rename_The_Galaxy>;
crystalEssenceLux.maxStackSize = 64;
crystalEssenceLux.maxDamage = 63;
crystalEssenceLux.onItemUse = function(player, world, pos, hand, facing, blockHit) 
{
    var lightPos = pos.getOffset(facing, 1);
    if (world.getBlockState(lightPos).isReplaceable(world, lightPos)) 
		{
			world.setBlockState(<block:botania:manaflame>, lightPos);
			player.getHeldItem(hand).shrink(1);
			return ActionResult.success();
		}
    return ActionResult.pass();
};
crystalEssenceLux.register();

val crystalEssenceExplosion as Item = VanillaFactory.createItem("crystal_essence_explosion");
crystalEssenceExplosion.creativeTab = <creativetab:Thaumcraft_Revival_Rename_The_Galaxy>;
crystalEssenceExplosion.maxStackSize = 64;
crystalEssenceExplosion.onItemUse = function(player, world, pos, hand, facing, blockHit) 
{
	world.performExplosion(null, pos.x, pos.y, pos.z, 5, false, true);
	player.getHeldItem(hand).shrink(1);
	return ActionResult.success();
};
crystalEssenceExplosion.register();