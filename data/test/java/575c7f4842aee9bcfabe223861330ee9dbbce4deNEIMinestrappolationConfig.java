package minestrapteam.minestrappolation.nei;

import codechicken.nei.api.API;
import codechicken.nei.api.IConfigureNEI;
import codechicken.nei.recipe.TemplateRecipeHandler;
import minestrapteam.minestrappolation.client.gui.GuiFreezer;
import minestrapteam.minestrappolation.client.gui.GuiMelter;
import minestrapteam.minestrappolation.client.gui.GuiSawmill;
import minestrapteam.minestrappolation.client.gui.GuiStonecutter;
import minestrapteam.minestrappolation.lib.MReference;
import minestrapteam.minestrappolation.nei.handler.*;

public class NEIMinestrappolationConfig implements IConfigureNEI
{
	public static ShapedStonecuttingHandler		shapedStonecuttingHandler		= new ShapedStonecuttingHandler();
	public static ShapelessStonecuttingHandler	shapelessStonecuttingHandler	= new ShapelessStonecuttingHandler();
	public static ShapedSawingHandler			shapedSawingHandler				= new ShapedSawingHandler();
	public static ShapelessSawingHandler		shapelessSawingHandler			= new ShapelessSawingHandler();
	public static MelterRecipeHandler			melterHandler					= new MelterRecipeHandler();
	public static MelterFuelHandler				melterFuelHandler				= new MelterFuelHandler();
	public static FreezerRecipeHandler			freezerHandler			= new FreezerRecipeHandler();
	public static FreezerFuelHandler			freezerFuelHandler				= new FreezerFuelHandler();
	
	public static ItemAddonRecipeHandler		platingHandler					= new ItemAddonRecipeHandler();
	
	@Override
	public void loadConfig()
	{
		registerHandler(shapedStonecuttingHandler);
		registerHandler(shapelessStonecuttingHandler);
		registerHandler(shapedSawingHandler);
		registerHandler(shapelessSawingHandler);
		registerHandler(melterHandler);
		registerHandler(melterFuelHandler);
		registerHandler(freezerHandler);
		registerHandler(freezerFuelHandler);
		
		registerHandler(platingHandler);
		
		API.registerGuiOverlay(GuiStonecutter.class, "stonecutter");
		API.registerGuiOverlay(GuiSawmill.class, "sawmill");
		API.registerGuiOverlay(GuiMelter.class, "melting");
		API.registerGuiOverlay(GuiFreezer.class, "freezer");
	}
	
	private static void registerHandler(TemplateRecipeHandler handler)
	{
		API.registerRecipeHandler(handler);
		API.registerUsageHandler(handler);
	}
	
	@Override
	public String getName()
	{
		return MReference.NAME;
	}
	
	@Override
	public String getVersion()
	{
		return MReference.VERSION;
	}
}
