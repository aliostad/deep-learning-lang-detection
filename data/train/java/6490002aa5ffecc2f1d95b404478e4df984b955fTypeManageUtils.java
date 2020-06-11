package com.baoz.yx.utils;

import com.baoz.yx.entity.YXTypeManage;

public class TypeManageUtils {
	/**
	 * 获得收款相对于开票的延后月数
	 * @param typeManage
	 * @return
	 */
	public static int getHarvestMonth(YXTypeManage typeManage){
		return Integer.parseInt(typeManage.getInfo());
	}
	
	/**
	 * 是否可以重复阶段
	 * @param typeManage
	 * @return
	 */
	public static boolean isCanDuplicatePhase(YXTypeManage typeManage){
		return "1".equals(typeManage.getInfo());
	}
}
