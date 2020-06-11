package action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.stereotype.Controller;

import Model.HouseManage;
import service.IHouseManageService;

import javax.annotation.Resource;

@Action (value="houseManageAction",results={
		@Result(name="list",type="redirectAction",location="houseManageAssign!list"),
		@Result(name="suc",location="/index.jsp")
		})
		
@Controller
public class HouseManageAction {

	
	@Resource(name = "houseManageService")
	private IHouseManageService houseManageService;
	
	
	private HouseManage houseManage;
	
	private String houseId;
	
	
	public HouseManage getHouseManage() {
		return houseManage;
	}
	public void setHouseManage(HouseManage houseManage) {
		this.houseManage = houseManage;
	}

	
	
	public String add(){
		houseManageService.addoredit(houseManage);
		return "list";
	}
	public String edit(){
		houseManageService.addoredit(houseManage);
		return "list";
	}
	public String delete(){
		houseManageService.deletebyid(Integer.parseInt(houseId));
		return "list";
	}
	public String getHouseId() {
		return houseId;
	}
	public void setHouseId(String houseId) {
		this.houseId = houseId;
	}
}
