package com.clothes.user;

import com.clothes.action.BaseActionSupport;
import com.clothes.service.ClothesCartItemService;
import com.clothes.service.ClothesCartService;
import com.clothes.service.ClothesCheckService;
import com.clothes.service.ClothesPayService;
import com.clothes.service.ClothesProductService;
import com.clothes.service.ClothesSubscribeItemService;
import com.clothes.service.ClothesSubscribeService;
import com.clothes.service.ClothesUserService;

public class PayAction extends BaseActionSupport{
	// °T®§¶Ç°e
	private ClothesCheckService clothesCheckService;
	private ClothesProductService clothesProductService;
	private ClothesUserService clothesUserService;
	private ClothesCartItemService clothesCartItemService;
	private ClothesCartService clothesCartService;
	private ClothesPayService clothesPayService;
	private ClothesSubscribeService clothesSubscribeService;
	private ClothesSubscribeItemService clothesSubscribeItemService;
	// °T®§¶Ç°e
	public ClothesCheckService getClothesCheckService() {
		return clothesCheckService;
	}
	public void setClothesCheckService(ClothesCheckService clothesCheckService) {
		this.clothesCheckService = clothesCheckService;
	}
	public ClothesProductService getClothesProductService() {
		return clothesProductService;
	}
	public void setClothesProductService(ClothesProductService clothesProductService) {
		this.clothesProductService = clothesProductService;
	}
	public ClothesUserService getClothesUserService() {
		return clothesUserService;
	}
	public void setClothesUserService(ClothesUserService clothesUserService) {
		this.clothesUserService = clothesUserService;
	}
	public ClothesCartItemService getClothesCartItemService() {
		return clothesCartItemService;
	}
	public void setClothesCartItemService(
			ClothesCartItemService clothesCartItemService) {
		this.clothesCartItemService = clothesCartItemService;
	}
	public ClothesCartService getClothesCartService() {
		return clothesCartService;
	}
	public void setClothesCartService(ClothesCartService clothesCartService) {
		this.clothesCartService = clothesCartService;
	}
	public ClothesPayService getClothesPayService() {
		return clothesPayService;
	}
	public void setClothesPayService(ClothesPayService clothesPayService) {
		this.clothesPayService = clothesPayService;
	}
	public ClothesSubscribeService getClothesSubscribeService() {
		return clothesSubscribeService;
	}
	public void setClothesSubscribeService(
			ClothesSubscribeService clothesSubscribeService) {
		this.clothesSubscribeService = clothesSubscribeService;
	}
	public ClothesSubscribeItemService getClothesSubscribeItemService() {
		return clothesSubscribeItemService;
	}
	public void setClothesSubscribeItemService(
			ClothesSubscribeItemService clothesSubscribeItemService) {
		this.clothesSubscribeItemService = clothesSubscribeItemService;
	}
	
	
}
