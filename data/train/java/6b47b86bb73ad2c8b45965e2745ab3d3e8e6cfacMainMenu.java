package main.menu;


public class MainMenu extends TextMenu {

	private TextMenuItem logout = new TextMenuItem("Log ud");
	
	public MainMenu() {
		super("Hovedmenu", false, false);
		ManageTaskMenu manageTaskMenu = new ManageTaskMenu();
		EditUserMenu editUserMenu = new EditUserMenu();
		ManageGroupMenu manageGroupMenu = new ManageGroupMenu();
		ManageProjectMenu manageProjectMenu = new ManageProjectMenu();
		ManageTimeEntryMenu manageTimeEntryMenu = new ManageTimeEntryMenu();
		
		addItems(logout, editUserMenu, manageTaskMenu, manageGroupMenu, manageProjectMenu, manageTimeEntryMenu);
	}

}
