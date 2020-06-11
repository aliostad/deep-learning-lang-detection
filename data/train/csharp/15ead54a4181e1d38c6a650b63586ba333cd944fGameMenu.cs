using UnityEngine;
using System.Collections;

public class GameMenu : MonoBehaviour 
{ 
	public bool is3D = false;//an game 3d


    void GetMenu ()
	{
		if(MenuControllerGenerator.controller.playWithAI)
		{
			ServerController.serverController.coins -= ServerController.serverController.prize;
			ServerController.serverController.coins = Mathf.Clamp(ServerController.serverController.coins, ServerController.serverController.minCoins, ServerController.serverController.maxCoins);
			Profile.SetUserDate(ServerController.serverController.myName + "_Coins", ServerController.serverController.coins);

			ServerController.serverController.otherCoins += ServerController.serverController.prize;
			ServerController.serverController.otherCoins = Mathf.Clamp(ServerController.serverController.otherCoins, ServerController.serverController.minCoins, ServerController.serverController.maxCoins);
			Profile.SetUserDate(ServerController.serverController.otherName + "_Coins", ServerController.serverController.otherCoins);

			MenuControllerGenerator.controller.playWithAI = false;
			MenuControllerGenerator.controller.OnGoBack();
		} else
		{
			if(ServerController.serverController)
			{
				//Decrease the coins, when player has disconnected in game time
				ServerController.serverController.coins -= ServerController.serverController.prize;
				ServerController.serverController.coins = Mathf.Clamp(ServerController.serverController.coins, ServerController.serverController.minCoins, ServerController.serverController.maxCoins);
				Profile.SetUserDate(ServerController.serverController.myName + "_Coins", ServerController.serverController.coins);

				
				ServerController.serverController.SendRPCToServer("OnOtherForceDisconnected", ServerController.serverController.otherNetworkPlayer);
				

				MasterServerGUI.Disconnect();
			}
			else
			{
				if(MenuControllerGenerator.controller.useNetwork)
				{
					MenuControllerGenerator.controller.OnGoBack();
				}
				else
				{
					MenuControllerGenerator.controller.LoadLevel(Application.loadedLevel);
				}
			}
		}
	}
	void ChangeCamera(Button btn)
	{
		is3D = btn.state;
	}
}
