using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CashRegister.BaseLib.Events;
using CashRegister.BaseLib;

namespace CashRegister.Controllers
{
	public class ControllerCoordinator
	{
		public Controller CurrentController;

		private AdministratorController administratorController;

		private CashierController cashierController;

		private LoginController loginController;

		public ControllerCoordinator()
		{
			loginController = new LoginController();
			administratorController = new AdministratorController();
			cashierController = new CashierController();

			loginController.LoginEvent += loginController_LoginEvent;
			administratorController.LogoutEvent += UserController_LogoutEvent;
			cashierController.LogoutEvent += UserController_LogoutEvent;
			
			CurrentController = loginController;
			CurrentController.DisplayMainForm();
		}

		void loginController_LoginEvent(object source, LoginEventArgs e)
		{
			if (e.UserRole == UserRole.ADMINISTRATOR)
			{
				switchAdministratorController();
			}
			else if (e.UserRole == UserRole.CASHIER)
			{
				switchToCashierController();
			}
		}


		public void switchToController(Controller nextController)
		{
			Console.Clear();
			CurrentController = nextController;
		}

		public void switchToCashierController()
		{
			Console.Clear();
			CurrentController = cashierController;
			CurrentController.DisplayMainForm();
		}

		private void UserController_LogoutEvent(object source, LogoutEventArgs e)
		{
			switchToLoginController();
		}

		public void switchToLoginController()
		{
			Console.Clear();
			CurrentController = loginController;
			CurrentController.DisplayMainForm();
		}

		public void switchAdministratorController()
		{
			Console.Clear();
			CurrentController = administratorController;
			CurrentController.DisplayMainForm();
		}
	}
}
