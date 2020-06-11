package com.sms.action;

import javax.annotation.Resource;

import com.opensymphony.xwork2.Action;
import com.sms.entity.ManagePaylevelSalary;
import com.sms.entity.ManagePositionSalary;
import com.sms.entity.ManageSalaryChange;
import com.sms.service.IManageSalaryManage;

public class ManageTest {
	private Integer level;
	private Integer off;
	private Integer cha;
	private Integer salary;
	private ManageSalaryChange manageSalaryChange;
	private ManagePositionSalary managePositionSalary;
	private ManagePaylevelSalary managePaylevelSalary;
	
	@Resource
	private IManageSalaryManage iManageSalaryManage;
	
	public ManageSalaryChange getManageSalaryChange() {
		return manageSalaryChange;
	}
	public void setManageSalaryChange(ManageSalaryChange manageSalaryChange) {
		this.manageSalaryChange = manageSalaryChange;
	}
	public ManagePositionSalary getManagePositionSalary() {
		return managePositionSalary;
	}
	public void setManagePositionSalary(ManagePositionSalary managePositionSalary) {
		this.managePositionSalary = managePositionSalary;
	}
	public ManagePaylevelSalary getManagePaylevelSalary() {
		return managePaylevelSalary;
	}
	public void setManagePaylevelSalary(ManagePaylevelSalary managePaylevelSalary) {
		this.managePaylevelSalary = managePaylevelSalary;
	}

	public IManageSalaryManage getManageSalaryManage() {
		return iManageSalaryManage;
	}
	public void setManageSalaryManage(IManageSalaryManage manageSalaryManage) {
		this.iManageSalaryManage = manageSalaryManage;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public Integer getOff() {
		return off;
	}
	public void setOff(Integer off) {
		this.off = off;
	}
	public Integer getCha() {
		return cha;
	}
	public void setCha(Integer cha) {
		this.cha = cha;
	}
	public Integer getSalary() {
		return salary;
	}
	public void setSalary(Integer salary) {
		this.salary = salary;
	}
	
	public String computeSalary(){
		System.out.println(level);
		iManageSalaryManage.setAllManage(level, off, cha);
		salary=iManageSalaryManage.getSalary();
		
		System.out.println(salary);
		return Action.SUCCESS;
	}
	
	public String addCha(){
		iManageSalaryManage.addManSalCha(manageSalaryChange);
		
		return Action.SUCCESS;
	}
	
	public String addPay(){
		iManageSalaryManage.addManPaySal(managePaylevelSalary);
		
		return Action.SUCCESS;
	}
	
	public String addPos(){
		System.out.println(managePositionSalary.getLevel());
		System.out.println(managePositionSalary.getPosition());
		System.out.println(managePositionSalary.getSalaryStandard());
		System.out.println(managePositionSalary.getStartPayLevel());
		iManageSalaryManage.addManPosSal(managePositionSalary);
		
		return Action.SUCCESS;
	}
}
