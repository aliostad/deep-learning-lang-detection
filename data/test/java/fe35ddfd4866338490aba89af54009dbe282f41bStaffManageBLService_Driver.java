package src.businesslogic.staffmanagebl;

import java.util.ArrayList;

import src.businesslogicservice.staffmanageblservice.StaffManageBLService;
import src.vo.StaffInfoVO;
import src.vo.UserVO;

public class StaffManageBLService_Driver {
	
	public void drive(StaffManageBLService staffManageBLService){
		StaffInfoVO staffInfoVO = staffManageBLService.getStaffInfo(000000);
		ArrayList<StaffInfoVO> staffInfoVOs = staffManageBLService.getAllStaff();
		staffManageBLService.changeAuthority(null, "Manager");
		staffManageBLService.addStaffInfo(new StaffInfoVO(000000,000000,"aaaaa",
				"Echo","Administrator",null,null,null));
		staffManageBLService.deleteStaff(000000);
		staffManageBLService.endManagement();
	}

}
