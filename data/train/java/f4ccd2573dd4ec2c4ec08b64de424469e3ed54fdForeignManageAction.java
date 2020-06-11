package action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.stereotype.Controller;

import Model.ForeignManage;
import service.IForeignManageService;

import javax.annotation.Resource;

@Action (value="foreignManageAction",results={
		@Result(name="list",type="redirectAction",location="foreignManageAssign!list"),
		@Result(name="suc",location="/index.jsp")
		})
		
@Controller
public class ForeignManageAction {

	
	@Resource(name = "foreignManageService")
	private IForeignManageService foreignManageService;
	
	
	private ForeignManage foreignManage;
	
	private String foreignId;
	
	
	public ForeignManage getForeignManage() {
		return foreignManage;
	}
	public void setForeignManage(ForeignManage foreignManage) {
		this.foreignManage = foreignManage;
	}
	
	
	
	
	public String getForeignId() {
		return foreignId;
	}
	public void setForeignId(String foreignId) {
		this.foreignId = foreignId;
	}
	
	public String add(){
		foreignManageService.addoredit(foreignManage);
		return "list";
	}
	public String edit(){
		foreignManageService.addoredit(foreignManage);
		return "list";
	}
	public String delete(){
		foreignManageService.deletebyid(Integer.parseInt(foreignId));
		return "list";
	}
}
