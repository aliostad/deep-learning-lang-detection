package dwo.gameserver.handler;

import dwo.gameserver.handler.items.BeastSoulShot;
import dwo.gameserver.handler.items.BeastSpice;
import dwo.gameserver.handler.items.BeastSpiritShot;
import dwo.gameserver.handler.items.BlessedSpiritShot;
import dwo.gameserver.handler.items.Book;
import dwo.gameserver.handler.items.Calculator;
import dwo.gameserver.handler.items.ChangeAttribute;
import dwo.gameserver.handler.items.ChristmasTree;
import dwo.gameserver.handler.items.CustomItems;
import dwo.gameserver.handler.items.Elixir;
import dwo.gameserver.handler.items.EnchantAttribute;
import dwo.gameserver.handler.items.EnchantScrolls;
import dwo.gameserver.handler.items.EnergyStarStone;
import dwo.gameserver.handler.items.EventItem;
import dwo.gameserver.handler.items.ExtractableItems;
import dwo.gameserver.handler.items.FishShots;
import dwo.gameserver.handler.items.Harvester;
import dwo.gameserver.handler.items.ItemSkills;
import dwo.gameserver.handler.items.ItemSkillsTemplate;
import dwo.gameserver.handler.items.ManaPotion;
import dwo.gameserver.handler.items.Maps;
import dwo.gameserver.handler.items.MercTicket;
import dwo.gameserver.handler.items.NicknameColor;
import dwo.gameserver.handler.items.OrbisBox;
import dwo.gameserver.handler.items.PaganKeys;
import dwo.gameserver.handler.items.PetFood;
import dwo.gameserver.handler.items.QuestStart;
import dwo.gameserver.handler.items.Recipes;
import dwo.gameserver.handler.items.RollingDice;
import dwo.gameserver.handler.items.ScrollOfResurrection;
import dwo.gameserver.handler.items.Seed;
import dwo.gameserver.handler.items.ShapeShifting;
import dwo.gameserver.handler.items.ShowHtml;
import dwo.gameserver.handler.items.SoulShots;
import dwo.gameserver.handler.items.SpecialXMas;
import dwo.gameserver.handler.items.SpiritShot;
import dwo.gameserver.handler.items.SummonItems;
import dwo.gameserver.handler.items.TeleportBookmark;
import dwo.gameserver.model.items.base.L2EtcItem;
import org.apache.log4j.Level;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

import java.util.HashMap;
import java.util.Map;

public class ItemHandler implements IHandler<IItemHandler, L2EtcItem>
{
	protected static Logger _log = LogManager.getLogger(ItemHandler.class);

	private final Map<String, IItemHandler> _handlers;

	private ItemHandler()
	{
		_handlers = new HashMap<>();
		registerHandler(new BeastSoulShot());
		registerHandler(new BeastSpice());
		registerHandler(new BeastSpiritShot());
		registerHandler(new BlessedSpiritShot());
		registerHandler(new Book());
		registerHandler(new Calculator());
		registerHandler(new ChristmasTree());
		registerHandler(new CustomItems());
		registerHandler(new Elixir());
		registerHandler(new EnchantAttribute());
		registerHandler(new EnchantScrolls());
		registerHandler(new EnergyStarStone());
		registerHandler(new EventItem());
		registerHandler(new ExtractableItems());
		registerHandler(new OrbisBox());
		registerHandler(new FishShots());
		registerHandler(new Harvester());
		registerHandler(new ItemSkills());
		registerHandler(new ItemSkillsTemplate());
		registerHandler(new ManaPotion());
		registerHandler(new Maps());
		registerHandler(new MercTicket());
		registerHandler(new NicknameColor());
		registerHandler(new PaganKeys());
		registerHandler(new PetFood());
		registerHandler(new QuestStart());
		registerHandler(new Recipes());
		registerHandler(new RollingDice());
		registerHandler(new ScrollOfResurrection());
		registerHandler(new ShowHtml());
		registerHandler(new Seed());
		registerHandler(new SoulShots());
		registerHandler(new SpecialXMas());
		registerHandler(new SpiritShot());
		registerHandler(new SummonItems());
		registerHandler(new TeleportBookmark());
		registerHandler(new ChangeAttribute());
		registerHandler(new ShapeShifting());
		_log.log(Level.INFO, "Loaded " + size() + " Item Handlers");
	}

	public static ItemHandler getInstance()
	{
		return SingletonHolder._instance;
	}

	@Override
	public void registerHandler(IItemHandler handler)
	{
		_handlers.put(handler.getClass().getSimpleName(), handler);
	}

	@Override
	public void removeHandler(IItemHandler handler)
	{
		synchronized(this)
		{
			_handlers.remove(handler.getClass().getSimpleName());
		}
	}

	/**
	 * Returns the handler of the item
	 *
	 * @param item designating the L2EtcItem
	 * @return IItemHandler
	 */
	@Override
	public IItemHandler getHandler(L2EtcItem item)
	{
		if(item == null || item.getHandlerName() == null)
		{
			return null;
		}
		return _handlers.get(item.getHandlerName());
	}

	@Override
	public int size()
	{
		return _handlers.size();
	}

	private static class SingletonHolder
	{
		protected static final ItemHandler _instance = new ItemHandler();
	}
}
