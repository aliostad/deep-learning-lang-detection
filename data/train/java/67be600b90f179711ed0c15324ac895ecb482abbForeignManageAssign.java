package action;

import java.beans.IntrospectionException;
import java.util.List;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.stereotype.Controller;

import service.IForeignManageService;
import Model.ForeignManage;
import Utilx.ViewStringSet;
import ViewModel.ForeignManageViewModel;
import ViewModel.ViewClass;

import com.opensymphony.xwork2.ActionSupport;

import javax.annotation.Resource;

@Action (value="foreignManageAssign",results={
		@Result(name="add",location="/ForeignManageaddoredit.jsp"),
		@Result(name="edit",location="/ForeignManageaddoredit.jsp"),
		@Result(name="list",location="/ForeignManagelist.jsp")})
@Controller
public class ForeignManageAssign extends ActionSupport{
	
	private ForeignManageViewModel cvm;
	
	 private String foreignId;
	 
	 @Resource(name = "foreignManageService")
	private IForeignManageService foreignManageService;

	private List list;

	public ForeignManageViewModel getCvm() {
		return cvm;
	}

	public void setCvm(ForeignManageViewModel cvm) {
		this.cvm = cvm;
	}

	public String getForeignId() {
		return foreignId;
	}

	public void setForeignId(String foreignManageId) {
		this.foreignId = foreignManageId;
	}

	
	
	public String add(){
		ForeignManageViewModel foreignManageViewModel=new ForeignManageViewModel();
		
		ForeignManage foreignManage = new ForeignManage();
		
		ViewClass vc=new ViewClass();
		 vc.action="foreignManageAction!add";
		 vc.message="<div class='col-md-6 col-md-offset-1'><h2>添加外来人口信息</h2></div>";
		 foreignManageViewModel.viewClass=vc;
		
		ViewStringSet viewStringSet = new ViewStringSet(foreignManage);
		
		foreignManageViewModel.setInput(viewStringSet.Addset());
		
		cvm = foreignManageViewModel;
		
		
		return "add";
		
	}
	
	public String edit(){
		
		ForeignManageViewModel foreignManageViewModel=new ForeignManageViewModel();
		
		ForeignManage foreignManage = foreignManageService.edit(Integer.parseInt(foreignId));
		
		ViewClass vc=new ViewClass();
		 vc.action="foreignManageAction!edit";
		 vc.message="<div class='col-md-6 col-md-offset-1'><h2>编辑外来人口信息</h2></div>";
		 foreignManageViewModel.viewClass=vc;
		
		ViewStringSet viewStringSet = new ViewStringSet(foreignManage);
		
		foreignManageViewModel.setInput(viewStringSet.updateset());
		
		cvm = foreignManageViewModel;
		
		
		return "edit";
		
	}
	
	public String list() throws IllegalArgumentException, IllegalAccessException, IntrospectionException{
		
		 ForeignManageViewModel foreignManageViewModel=new ForeignManageViewModel();
		
		 list = foreignManageService.findall();
		 
		 ViewStringSet viewStringSet = new ViewStringSet();
			
			foreignManageViewModel.setList(viewStringSet.listSet(list));
			
			cvm = foreignManageViewModel;
			
			
			return "list";
	}
	 
	 
	 
	 
}
