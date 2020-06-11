package celestibytes.celestialwizardry.reference;

import celestibytes.celestialwizardry.client.handler.ClientRenderTickEventHandler;
import celestibytes.celestialwizardry.client.handler.KeyInputEventHandler;
import celestibytes.celestialwizardry.handler.ClientTickEventHandler;
import celestibytes.celestialwizardry.handler.ConfigChangedEventHandler;
import celestibytes.celestialwizardry.handler.DisconnectEHandler;
import celestibytes.celestialwizardry.handler.EntityEventHandler;
import celestibytes.celestialwizardry.handler.ItemExpireEventHandler;
import celestibytes.celestialwizardry.handler.PlayerEventHandler;
import celestibytes.celestialwizardry.handler.WorldEventHandler;

import cpw.mods.fml.relauncher.Side;
import cpw.mods.fml.relauncher.SideOnly;

public class EventHandlers
{
    @SideOnly(Side.CLIENT)
    public static class Client
    {
        public static final ClientTickEventHandler CLIENT_TICK_EVENT_HANDLER = new ClientTickEventHandler();
        public static final ClientRenderTickEventHandler CLIENT_RENDER_TICK_EVENT_HANDLER
                = new ClientRenderTickEventHandler();
        public static final KeyInputEventHandler KEY_INPUT_EVENT_HANDLER = new KeyInputEventHandler();
    }

    public static class Common
    {
        public static final PlayerEventHandler PLAYER_EVENT_HANDLER = new PlayerEventHandler();
        public static final EntityEventHandler ENTITY_EVENT_HANDLER = new EntityEventHandler();
        public static final WorldEventHandler WORLD_EVENT_HANDLER = new WorldEventHandler();
        public static final ItemExpireEventHandler ITEM_EXPIRE_EVENT_HANDLER = new ItemExpireEventHandler();
        public static final DisconnectEHandler DISCONNECT_EVENT_HANDLER = new DisconnectEHandler();
        public static final ConfigChangedEventHandler CONFIG_CHANGED_EVENT_HANDLER = new ConfigChangedEventHandler();
    }
}
