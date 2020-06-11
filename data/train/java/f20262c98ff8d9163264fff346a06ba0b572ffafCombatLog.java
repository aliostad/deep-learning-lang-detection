package com.minecave.combatlog;

import com.minecave.combatlog.config.ConfigHandler;
import com.minecave.combatlog.npc.NPCHandler;
import org.bukkit.plugin.java.JavaPlugin;

public class CombatLog extends JavaPlugin {

    private ConfigHandler configHandler;
    private NPCHandler npcHandler;
    private TagHandler tagHandler;

    public void onEnable() {
        getConfigHandler().loadConfigs();
        getTagHandler().loadCombatLoggers();
        getServer().getPluginManager().registerEvents(new PlayerListener(this), this);
        getCommand("cl").setExecutor(new CLCommand(this));
        getLogger().info("has been enabled");
    }

    public void onDisable() {
        getTagHandler().saveCombatLoggers();
        getConfigHandler().saveConfigs();
        getLogger().info("has been disabled");
    }

    public ConfigHandler getConfigHandler() {
        if(configHandler == null) configHandler = new ConfigHandler(this);
        return configHandler;
    }

    public NPCHandler getNPCHandler() {
        if(npcHandler == null) npcHandler = new NPCHandler(this);
        return npcHandler;
    }

    public TagHandler getTagHandler() {
        if(tagHandler == null) tagHandler = new TagHandler(this);
        return tagHandler;
    }
}
