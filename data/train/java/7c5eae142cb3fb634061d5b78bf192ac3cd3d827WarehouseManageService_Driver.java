package blservice.stockmanagermanblservice;

import java.rmi.RemoteException;

import vo.stocmanagermanvo.WarehouseWarningvo;

public class WarehouseManageService_Driver {

	public void drive(WarehouseManageService warehouseManageService) throws RemoteException{
		WarehouseWarningvo information = WarehouseWarningvo.getInformation();
		warehouseManageService.in(null, null);
		warehouseManageService.out(null, null);
//		warehouseManageService.search();
		//warehouseManageService.set();
		warehouseManageService.initialize();
	}
	
	public static void main(String[] args) throws RemoteException{
		WarehouseManageService_Driver driver = new WarehouseManageService_Driver();
		WarehouseManageService_Stub stub = new WarehouseManageService_Stub();
		driver.drive(stub);
	}
}
