package me.mmarz11.aod.handlers;

import me.mmarz11.aod.handlers.map.BuildBreakHandler;
import me.mmarz11.aod.handlers.map.MapHandler;
import me.mmarz11.aod.handlers.player.ArrowHandler;
import me.mmarz11.aod.handlers.player.BrainHandler;
import me.mmarz11.aod.handlers.player.HungerHandler;
import me.mmarz11.aod.handlers.player.LoginHandler;
import me.mmarz11.aod.handlers.player.PermissionHandler;
import me.mmarz11.aod.handlers.player.PlayerTypeHandler;
import me.mmarz11.aod.handlers.player.PortalHandler;
import me.mmarz11.aod.handlers.player.RespawnHandler;
import me.mmarz11.aod.handlers.player.StatHandler;
import me.mmarz11.aod.handlers.player.TeamkillHandler;
import me.mmarz11.aod.handlers.round.KitHandler;
import me.mmarz11.aod.handlers.round.ScoreboardHandler;
import me.mmarz11.aod.handlers.round.TimerHandler;

public class Handlers {
	public ScoreboardHandler scoreboardHandler = new ScoreboardHandler();
	public TimerHandler timerHandler = new TimerHandler();
	public PlayerTypeHandler playerTypeHandler = new PlayerTypeHandler();
	public ConfigHandler configHandler = new ConfigHandler();
	public MapHandler mapHandler = new MapHandler();
	public TeamkillHandler teamkillHandler = new TeamkillHandler();
	public LoginHandler loginHandler = new LoginHandler();
	public PortalHandler portalHandler = new PortalHandler();
	public KitHandler kitHandler = new KitHandler();
	public HungerHandler hungerHandler = new HungerHandler();
	public BuildBreakHandler buildBreakHandler = new BuildBreakHandler();
	public RespawnHandler respawnHandler = new RespawnHandler();
	public StatHandler statHandler = new StatHandler();
	public PermissionHandler permissionHandler = new PermissionHandler();
	public ArrowHandler arrowHandler = new ArrowHandler();
	public BrainHandler brainHandler = new BrainHandler();

	public void init() {
		configHandler.init();
		brainHandler.init();
		mapHandler.init();
		scoreboardHandler.init();
	}
}
