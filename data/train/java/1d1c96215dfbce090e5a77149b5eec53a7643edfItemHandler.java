package l2s.gameserver.handler.items;

import java.util.HashMap;
import java.util.Map;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.handler.items.impl.AppearanceStoneHandler;
import l2s.gameserver.handler.items.impl.AttributeStoneItemHandler;
import l2s.gameserver.handler.items.impl.BlessedSpiritShotItemHandler;
import l2s.gameserver.handler.items.impl.CalculatorItemHandler;
import l2s.gameserver.handler.items.impl.CapsuledItemHandler;
import l2s.gameserver.handler.items.impl.DefaultItemHandler;
import l2s.gameserver.handler.items.impl.EnchantScrollItemHandler;
import l2s.gameserver.handler.items.impl.EquipableItemHandler;
import l2s.gameserver.handler.items.impl.ForgottenScrollItemHandler;
import l2s.gameserver.handler.items.impl.HarvesterItemHandler;
import l2s.gameserver.handler.items.impl.KeyItemHandler;
import l2s.gameserver.handler.items.impl.MercenaryTicketItemHandler;
import l2s.gameserver.handler.items.impl.NameColorItemHandler;
import l2s.gameserver.handler.items.impl.PetSummonItemHandler;
import l2s.gameserver.handler.items.impl.RecipeItemHandler;
import l2s.gameserver.handler.items.impl.RollingDiceItemHandler;
import l2s.gameserver.handler.items.impl.SeedItemHandler;
import l2s.gameserver.handler.items.impl.SkillsItemHandler;
import l2s.gameserver.handler.items.impl.SkillsReduceItemHandler;
import l2s.gameserver.handler.items.impl.SoulCrystalItemHandler;
import l2s.gameserver.handler.items.impl.SoulShotItemHandler;
import l2s.gameserver.handler.items.impl.SpiritShotItemHandler;
import l2s.gameserver.handler.items.impl.WorldMapItemHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Bonux
 */
public class ItemHandler extends AbstractHolder
{
	private static final Logger _log = LoggerFactory.getLogger(ItemHandler.class);

	public static final IItemHandler DEFAULT_HANDLER = new DefaultItemHandler();
	public static final IItemHandler EQUIPABLE_HANDLER = new EquipableItemHandler();
	public static final IItemHandler ENCHANT_SCROLL_HANDLER = new EnchantScrollItemHandler();
	public static final IItemHandler APPEARANCE_STONE_HANDLER = new AppearanceStoneHandler();
	public static final IItemHandler ATTRIBUTE_STONE_HANDLER = new AttributeStoneItemHandler();
	public static final IItemHandler SOULSHOT_HANDLER = new SoulShotItemHandler();
	public static final IItemHandler SPIRITSHOT_HANDLER = new SpiritShotItemHandler();
	public static final IItemHandler BLESSED_SPIRITSHOT_HANDLER = new BlessedSpiritShotItemHandler();
	public static final IItemHandler SKILL_ITEM_HANDLER = new SkillsItemHandler();
	public static final IItemHandler SKILL_REDUCE_ITEM_HANDLER = new SkillsReduceItemHandler();
	public static final IItemHandler CAPSULED_ITEM_HANDLER = new CapsuledItemHandler();
	public static final IItemHandler PET_SUMMON_HANDLER = new PetSummonItemHandler();
	public static final IItemHandler RECIPE_HANDLER = new RecipeItemHandler();
	public static final IItemHandler FORGOTTEN_SCROLL_HANDLER = new ForgottenScrollItemHandler();
	public static final IItemHandler SEED_HANDLER = new SeedItemHandler();
	public static final IItemHandler SOUL_CRYSTALL_HANDLER = new SoulCrystalItemHandler();
	public static final IItemHandler MERCENARY_TICKET_HANDLER = new MercenaryTicketItemHandler();

	private static final ItemHandler _instance = new ItemHandler();

	private final Map<String, IItemHandler> _handlers = new HashMap<String, IItemHandler>();

	public static ItemHandler getInstance()
	{
		return _instance;
	}

	private ItemHandler()
	{
		registerItemHandler(DEFAULT_HANDLER);
		registerItemHandler(ENCHANT_SCROLL_HANDLER);
		registerItemHandler(EQUIPABLE_HANDLER);
		registerItemHandler(APPEARANCE_STONE_HANDLER);
		registerItemHandler(ATTRIBUTE_STONE_HANDLER);
		registerItemHandler(SOULSHOT_HANDLER);
		registerItemHandler(SPIRITSHOT_HANDLER);
		registerItemHandler(BLESSED_SPIRITSHOT_HANDLER);
		registerItemHandler(SKILL_ITEM_HANDLER);
		registerItemHandler(SKILL_REDUCE_ITEM_HANDLER);
		registerItemHandler(CAPSULED_ITEM_HANDLER);
		registerItemHandler(PET_SUMMON_HANDLER);
		registerItemHandler(RECIPE_HANDLER);
		registerItemHandler(FORGOTTEN_SCROLL_HANDLER);
		registerItemHandler(SEED_HANDLER);
		registerItemHandler(SOUL_CRYSTALL_HANDLER);
		registerItemHandler(MERCENARY_TICKET_HANDLER);

		registerItemHandler(new CalculatorItemHandler());
		registerItemHandler(new HarvesterItemHandler());
		registerItemHandler(new KeyItemHandler());
		registerItemHandler(new NameColorItemHandler());
		registerItemHandler(new RollingDiceItemHandler());
		registerItemHandler(new WorldMapItemHandler());
	}

	public void registerItemHandler(IItemHandler handler)
	{
		_handlers.put(handler.getClass().getSimpleName().replace("ItemHandler", ""), handler);
	}

	public void removeHandler(IItemHandler handler)
	{
		_handlers.remove(handler.getClass().getSimpleName().replace("ItemHandler", ""));
	}

	public IItemHandler getItemHandler(String handler)
	{
		if(handler.contains("ItemHandler"))
			handler = handler.replace("ItemHandler", "");

		if(_handlers.isEmpty() || !_handlers.containsKey(handler))
		{
			_log.warn("ItemHandler: Cannot find handler [" + handler + "]!");
			return DEFAULT_HANDLER;
		}

		return _handlers.get(handler);
	}

	@Override
	public int size()
	{
		return _handlers.size();
	}

	@Override
	public void clear()
	{
		_handlers.clear();
	}
}
