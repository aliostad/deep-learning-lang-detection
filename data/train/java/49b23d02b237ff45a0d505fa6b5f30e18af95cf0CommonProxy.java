package com.tomatheb.mobinhibitor.proxy;

import com.tomatheb.mobinhibitor.handler.LivingEventHandler;
import com.tomatheb.mobinhibitor.handler.LivingSpawnHandler;
import com.tomatheb.mobinhibitor.handler.LivingSpecialSpawnHandler;
import net.minecraftforge.common.MinecraftForge;

public abstract class CommonProxy implements IProxy
{
    public void registerEventHandlers()
    {
        LivingEventHandler livingEventHandler = new LivingEventHandler();
        LivingSpawnHandler livingSpawnHandler = new LivingSpawnHandler();
        LivingSpecialSpawnHandler livingSpecialSpawnHandler = new LivingSpecialSpawnHandler();


        MinecraftForge.EVENT_BUS.register(livingEventHandler);
        MinecraftForge.EVENT_BUS.register(livingSpawnHandler);
        MinecraftForge.EVENT_BUS.register(livingSpecialSpawnHandler);
    }
}
