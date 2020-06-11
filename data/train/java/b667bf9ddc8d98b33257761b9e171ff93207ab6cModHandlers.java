package nl.scribblon.riftcraft.init;

import cpw.mods.fml.common.FMLCommonHandler;
import cpw.mods.fml.common.eventhandler.EventBus;
import net.minecraftforge.common.MinecraftForge;
import nl.scribblon.riftcraft.handler.ConfigurationHandler;
import nl.scribblon.riftcraft.handler.EnderPearlHandler;
import nl.scribblon.riftcraft.handler.EnderShardHandler;
import nl.scribblon.riftcraft.handler.TestHandler;

/**
 * Created by Scribblon for RiftCraft.
 * Date Creation: 29-7-2014
 */
public class ModHandlers {

    public static final ConfigurationHandler CONFIGURATION_HANDLER = new ConfigurationHandler();
    public static final TestHandler PLAYER_HANDLER = new TestHandler();
    public static final EnderPearlHandler ENDER_TOSS_HANDLER = new EnderPearlHandler();
    public static final EnderShardHandler ENDER_SHARD_HANDLER = new EnderShardHandler();

    public static void init(){
        EventBus fmlBus = FMLCommonHandler.instance().bus();
        fmlBus.register(CONFIGURATION_HANDLER);

        EventBus forgeBus = MinecraftForge.EVENT_BUS;
        forgeBus.register(PLAYER_HANDLER);
        forgeBus.register(ENDER_TOSS_HANDLER);
        forgeBus.register(ENDER_SHARD_HANDLER);
    }
}
