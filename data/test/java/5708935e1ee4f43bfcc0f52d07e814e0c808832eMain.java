package gamesubscription.client.main;
import gamesubscription.client.controller.ManageSubscriptionGameGUIController;
import gamesubscription.client.controller.ManageGameGUIController;
import gamesubscription.client.controller.ManageSubscriptionGUIController;
import gamesubscription.client.gui.ManageGameGUI;
import gamesubscription.client.service.ClientService;
import gamesubscription.client.service.GameService;
import gamesubscription.client.service.SubscriptionGameService;
import gamesubscription.client.service.SubscriptionService;

import javax.swing.SwingUtilities;

public class Main {

	public static void main(String[] args) {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				GameService gameService = new GameService();
				SubscriptionService subscriptionService = new SubscriptionService();
				ClientService clientService = new ClientService();
				SubscriptionGameService subscriptionGameService = new SubscriptionGameService();
				
				ManageGameGUIController manageGameGUIController = new ManageGameGUIController(gameService);
				ManageSubscriptionGUIController manageSubscriptionGUIController = new ManageSubscriptionGUIController(subscriptionService);
				ManageSubscriptionGameGUIController manageClientGUIController = new ManageSubscriptionGameGUIController(clientService, subscriptionGameService);
				
				ManageGameGUI manageGameGUI = new ManageGameGUI(manageGameGUIController);
				manageGameGUI.setSubscriptionController(manageSubscriptionGUIController);
				manageGameGUI.setClientController(manageClientGUIController);
				manageGameGUI.setLocationRelativeTo(null);
				manageGameGUI.setVisible(true);
				
			}
		});
	}
}
