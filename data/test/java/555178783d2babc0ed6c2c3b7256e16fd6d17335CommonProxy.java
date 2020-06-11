package andrew.powersuits.common;

import andrew.powersuits.network.AndrewPacketHandler;
import andrew.powersuits.network.MPSAPacketHandler;


public class CommonProxy {

    //private static CommonTickHandler commonTickHandler;
    public static MPSAPacketHandler packetHandler;


    public void registerHandlers() {
        //commonTickHandler = new CommonTickHandler();
        //TickRegistry.registerTickHandler(commonTickHandler, Side.SERVER);
        //CommonTickHandler.load();

        packetHandler = new MPSAPacketHandler();
        //packetHandler.register();
    }

    public void registerRenderers() {
    }

    public static String translate(String str) {
        return str;
    }


}
