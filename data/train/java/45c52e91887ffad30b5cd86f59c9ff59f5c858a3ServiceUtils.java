/**
 * 
 */
package com.jm.util;

import com.jm.service.spi.ExchangeRecordService;
import com.jm.service.spi.GoodsService;
import com.jm.service.spi.OriginalEventService;
import com.jm.service.spi.UserService;
import com.jm.service.spi.UserTraceService;

/**
 * @author LuZheqi
 * 
 */
public class ServiceUtils {
	private static UserService userService;
	private static OriginalEventService originalEventService;
	private static UserTraceService userTraceService;
	private static GoodsService goodsService;
	private static ExchangeRecordService exchangeRecordService;

	public static ExchangeRecordService getExchangeRecordService() {
		return exchangeRecordService;
	}

	public static void setExchangeRecordService(
			ExchangeRecordService exchangeRecordService) {
		ServiceUtils.exchangeRecordService = exchangeRecordService;
	}

	public static GoodsService getGoodsService() {
		return goodsService;
	}

	public static void setGoodsService(GoodsService goodsService) {
		ServiceUtils.goodsService = goodsService;
	}

	/**
	 * @return the Userservice
	 */
	public static UserService getUserService() {
		return userService;
	}

	/**
	 * @return the Originaleventservice
	 */
	public static OriginalEventService getOriginalEventService() {
		return originalEventService;
	}

	public static void setUserService(UserService userService) {
		ServiceUtils.userService = userService;
	}

	public static void setOriginalEventService(
			OriginalEventService originalEventService) {
		ServiceUtils.originalEventService = originalEventService;
	}

	/**
	 * @return the userTraceService
	 */
	public static UserTraceService getUserTraceService() {
		return userTraceService;
	}

	/**
	 * @param userTraceService
	 *            the userTraceService to set
	 */
	public static void setUserTraceService(
			UserTraceService userTraceService) {
		ServiceUtils.userTraceService = userTraceService;
	}
}
