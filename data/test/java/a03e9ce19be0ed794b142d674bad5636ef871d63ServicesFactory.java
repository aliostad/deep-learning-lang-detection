package com.generic.core.services.serviceimpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import com.generic.core.services.service.AreaServiceI;
import com.generic.core.services.service.CategoriesServiceI;
import com.generic.core.services.service.CityServiceI;
import com.generic.core.services.service.ItemServiceI;
import com.generic.core.services.service.LandmarkServiceI;
import com.generic.core.services.service.ShopsItemsServiceI;
import com.generic.core.services.service.ShopsLandmarkServiceI;
import com.generic.core.services.service.ShopsServiceI;
import com.generic.core.services.service.SizeServiceI;
import com.generic.core.services.service.TransactionServiceI;
import com.generic.core.services.service.UserInterestsServiceI;
import com.generic.core.services.service.UsersServiceI;

@Repository
public class ServicesFactory {

	@Resource
	private CategoriesServiceI categoriesService;
	@Resource
	private ItemServiceI itemService;
	/*@Resource
	private LocationServiceI locationService;*/
	@Resource
	private ShopsServiceI shopsService;
	@Resource
	private SizeServiceI sizeService;
	@Resource
	private ShopsItemsServiceI shopsItemsService;
	@Resource
	private TransactionServiceI transactionService;
	@Resource
	private UserInterestsServiceI userInterestsService;
	@Resource
	private UsersServiceI userService;
	@Resource
	private ShopsLandmarkServiceI shopsLandmarkService;
	/*@Resource
	private ShopsLocationsServiceI shopsLocationService;*/
	@Resource
	private CityServiceI cityService;
	@Resource
	private AreaServiceI areaService;
	@Resource
	private LandmarkServiceI landmarkService;
	
	public CityServiceI getCityService() {
		return cityService;
	}
	public void setCityService(CityServiceI cityService) {
		this.cityService = cityService;
	}
	public AreaServiceI getAreaService() {
		return areaService;
	}
	public void setAreaService(AreaServiceI areaService) {
		this.areaService = areaService;
	}
	public LandmarkServiceI getLandmarkService() {
		return landmarkService;
	}
	public void setLandmarkService(LandmarkServiceI landmarkService) {
		this.landmarkService = landmarkService;
	}
	public ShopsLandmarkServiceI getShopsLandmarkService() {
		return shopsLandmarkService;
	}
	public void setShopsLandmarkService(ShopsLandmarkServiceI shopsLandmarkService) {
		this.shopsLandmarkService = shopsLandmarkService;
	}
	public CategoriesServiceI getCategoriesService() {
		return categoriesService;
	}
	public void setCategoriesService(CategoriesServiceI categoriesService) {
		this.categoriesService = categoriesService;
	}
	public ItemServiceI getItemService() {
		return itemService;
	}
	public void setItemService(ItemServiceI itemService) {
		this.itemService = itemService;
	}
	/*public LocationServiceI getLocationService() {
		return locationService;
	}
	public void setLocationService(LocationServiceI locationService) {
		this.locationService = locationService;
	}*/
	public ShopsServiceI getShopsService() {
		return shopsService;
	}
	public void setShopsService(ShopsServiceI shopsService) {
		this.shopsService = shopsService;
	}

	public ShopsItemsServiceI getShopsItemsService() {
		return shopsItemsService;
	}
	public void setShopsItemsService(ShopsItemsServiceI shopsItemsService) {
		this.shopsItemsService = shopsItemsService;
	}
	public TransactionServiceI getTransactionService() {
		return transactionService;
	}
	public void setTransactionService(TransactionServiceI transactionService) {
		this.transactionService = transactionService;
	}
	public UserInterestsServiceI getUserInterestsService() {
		return userInterestsService;
	}
	public void setUserInterestsService(UserInterestsServiceI userInterestsService) {
		this.userInterestsService = userInterestsService;
	}
	public UsersServiceI getUserService() {
		return userService;
	}
	public void setUserService(UsersServiceI userService) {
		this.userService = userService;
	}
	/*public ShopsLocationsServiceI getShopsLocationService() {
		return shopsLocationService;
	}
	public void setShopsLocationService(ShopsLocationsServiceI shopsLocationService) {
		this.shopsLocationService = shopsLocationService;
	}*/
	public SizeServiceI getSizeService() {
		return sizeService;
	}
	public void setSizeService(SizeServiceI sizeService) {
		this.sizeService = sizeService;
	}
	
}
