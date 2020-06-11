package com.wiiy.pb.action;

import java.util.List;

import com.wiiy.commons.action.JqGridBaseAction;
import com.wiiy.commons.util.BeanUtil;
import com.wiiy.hibernate.Filter;
import com.wiiy.hibernate.Result;

import com.wiiy.pb.entity.ParkingManage;
import com.wiiy.pb.service.ParkingManageService;

/**
 * @author my
 */
public class ParkingManageAction extends JqGridBaseAction<ParkingManage>{
	
	private ParkingManageService parkingManageService;
	private Result result;
	private ParkingManage parkingManage;
	private Long id;
	private String ids;
	private List<ParkingManage> parkingManages;
	private Long garageId;

	public String listByGarage(){
		return refresh(new Filter(ParkingManage.class).eq("garageId", id));
	}
	
	public String save(){
		result = parkingManageService.save(parkingManage);
		return JSON;
	}
	
	public String view(){
		System.out.println(garageId);
		parkingManages = parkingManageService.getListByFilter(new Filter(ParkingManage.class).eq("garageId", garageId)).getValue();
		return VIEW;
	}
	
	public String edit(){
		result = parkingManageService.getBeanById(id);
		return EDIT;
	}
	
	public String update(){
		ParkingManage dbBean = parkingManageService.getBeanById(parkingManage.getId()).getValue();
		BeanUtil.copyProperties(parkingManage, dbBean);
		result = parkingManageService.update(dbBean);
		return JSON;
	}
	
	public String delete(){
		if(id!=null){
			result = parkingManageService.deleteById(id);
		} else if(ids!=null){
			result = parkingManageService.deleteByIds(ids);
		}
		return JSON;
	}
	
	public String list(){
		return refresh(new Filter(ParkingManage.class).eq("garageId", id));
	}
	
	@Override
	protected List<ParkingManage> getListByFilter(Filter fitler) {
		return parkingManageService.getListByFilter(fitler).getValue();
	}
	
	
	public ParkingManage getParkingManage() {
		return parkingManage;
	}

	public void setParkingManage(ParkingManage parkingManage) {
		this.parkingManage = parkingManage;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public void setParkingManageService(ParkingManageService parkingManageService) {
		this.parkingManageService = parkingManageService;
	}
	
	public Result getResult() {
		return result;
	}
	public List<ParkingManage> getParkingManages() {
		return parkingManages;
	}

	public void setParkingManages(List<ParkingManage> parkingManages) {
		this.parkingManages = parkingManages;
	}
	public Long getGarageId() {
		return garageId;
	}

	public void setGarageId(Long garageId) {
		this.garageId = garageId;
	}
}
