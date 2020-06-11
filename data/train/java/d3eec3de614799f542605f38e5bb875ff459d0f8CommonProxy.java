package atomatic.proxy;

import atomatic.handler.ConfigurationHandler;
import atomatic.handler.CraftingHandler;

import net.minecraftforge.common.MinecraftForge;

import cpw.mods.fml.common.FMLCommonHandler;

public abstract class CommonProxy implements IProxy
{
    @Override
    public void registerEventHandlers()
    {
        CraftingHandler craftingHandler = new CraftingHandler();

        FMLCommonHandler.instance().bus().register(new ConfigurationHandler());
        FMLCommonHandler.instance().bus().register(craftingHandler);
        MinecraftForge.EVENT_BUS.register(craftingHandler);
    }
}
