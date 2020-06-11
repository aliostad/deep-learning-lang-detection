package businesslogic.test.Manage;

import junit.framework.TestCase;
import State.AddState;
import State.DeleteState;
import State.InstitutionType;
import State.UserRole;
import VO.StaffVO;
import businesslogic.Impl.Manage.ManageController;

public class TestSearchStaff extends TestCase {

	public void testSearchStaff(){
		ManageController manageController=new ManageController();
		
		StaffVO staff5=new StaffVO("知识点","男",20,InstitutionType.Repository,UserRole.repository,"02500012","南京","12345");
		assertEquals(AddState.SUCCESS,manageController.addStaff(staff5));
		assertEquals(staff5.getName(),manageController.searchStaff("025000012").get(0).getName());
		assertEquals(DeleteState.SUCCESS,manageController.DeleteStaff(staff5));
		assertEquals(null,manageController.searchStaff("025000012"));
	}
}
