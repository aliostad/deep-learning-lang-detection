package spell.services;

import spell.services.impl.SourceServiceImpl;
import spell.services.impl.ComponentServiceImpl;
import spell.services.impl.ItemTypeServiceImpl;
import spell.services.impl.MagicItemServiceImpl;
import spell.services.impl.PlayerClassServiceImpl;
import spell.services.impl.SchoolServiceImpl;
import spell.services.impl.SlotServiceImpl;
import spell.services.impl.SpellServiceImpl;

/**
 * Factory class that returns the appropriate service.
 */
public class ServiceFactory {

	private static SpellService spellService = new SpellServiceImpl();
	private static PlayerClassService playerClassService = new PlayerClassServiceImpl();
	private static ComponentService componentService = new ComponentServiceImpl();
	private static SlotService slotService = new SlotServiceImpl();
	private static ItemTypeService itemTypeService = new ItemTypeServiceImpl();
	private static SchoolService schoolService = new SchoolServiceImpl();
	private static MagicItemService magicItemService = new MagicItemServiceImpl();
	private static SourceService sourceService = new SourceServiceImpl();

	/** Returns GenericDataService. */
	public static SpellService getSpellService() {
		return spellService;
	}
	public static PlayerClassService getPlayerClassService() {
		return playerClassService;
	}
	public static ComponentService getComponentService() {
		return componentService;
	}
	public static SchoolService getSchoolService() {
		return schoolService;
	}
	public static MagicItemService getMagicItemService() {
		return magicItemService;
	}
	public static SlotService getSlotService() {
		return slotService;
	}
	public static ItemTypeService getItemTypeService() {
		return itemTypeService;
	}
	public static SourceService getSourceService() {
		return sourceService;
	}

}
