package com.application.util;

import com.application.service.AccountServiceDelegate;
import com.application.service.AdditionalRoleServiceDelegate;
import com.application.service.BRSServiceDelegate;
import com.application.service.MemberServiceDelegate;
import com.application.service.MenuServiceDelegate;
import com.application.service.ReportServiceDelegate;
import com.application.service.VoucherServiceDelegate;
import com.flat.services.AccountService;
import com.flat.services.AdditionalService;
import com.flat.services.BRSService;
import com.flat.services.CostCenterService;
import com.flat.services.MemberService;
import com.flat.services.MenuService;
import com.flat.services.ReportService;
import com.flat.services.VoucherService;


public class ServiceLocator {
	public static MemberServiceDelegate memberService;

	public static AccountServiceDelegate accountService;
	
	public static VoucherServiceDelegate voucherService;
	
	public static MenuServiceDelegate menuService;

	public static AccountService accountWebService;

	public static VoucherService voucherWebService;

	public static MemberService memberWebService;
	
	public static BRSService brsWebService;
	
	public static AdditionalService additionalRoleWebService;
	
	public static ReportService reportWebService;

	public static ReportService getReportWebService() {
		return reportWebService;
	}

	public void setReportWebService(ReportService reportWebService) {
		ServiceLocator.reportWebService = reportWebService;
	}

	public static AdditionalService getAdditionalRoleWebService() {
		return additionalRoleWebService;
	}

	public  void setAdditionalRoleWebService(
			AdditionalService additionalRoleWebService) {
		ServiceLocator.additionalRoleWebService = additionalRoleWebService;
	}

	public static BRSService getBrsWebService() {
		return brsWebService;
	}

	public  void setBrsWebService(BRSService brsWebService) {
		ServiceLocator.brsWebService = brsWebService;
	}

	public static MenuService menuWebService;

	public static CostCenterService costCenterService;
	
	public static ReportServiceDelegate reportService;
	
	public static AdditionalRoleServiceDelegate additionalRoleService;
	
	public static BRSServiceDelegate brsService;

	public static MenuService getMenuWebService() {
		return menuWebService;
	}

	public  void setMenuWebService(MenuService menuWebService) {
		ServiceLocator.menuWebService = menuWebService;
	}

	public static MemberService getMemberWebService() {
		return memberWebService;
	}

	public  void setMemberWebService(MemberService memberWebService) {
		ServiceLocator.memberWebService = memberWebService;
	}

	public static VoucherService getVoucherWebService() {
		return voucherWebService;
	}

	public void setVoucherWebService(VoucherService voucherWebService) {
		ServiceLocator.voucherWebService = voucherWebService;
	}

	public static AccountService getAccountWebService() {
		return accountWebService;
	}

	public void setAccountWebService(AccountService accountWebService) {
		ServiceLocator.accountWebService = accountWebService;
	}

	/**
	 * @return the memberService
	 */
	public static MemberServiceDelegate getMemberService() {
		return memberService;
	}

	/**
	 * @param memberService
	 *            the memberService to set
	 */
	public void setMemberService(MemberServiceDelegate memberService) {
		ServiceLocator.memberService = memberService;
	}

	/**
	 * @return the accountService
	 */
	public static AccountServiceDelegate getAccountService() {
		return accountService;
	}

	/**
	 * @param accountService
	 *            the accountService to set
	 */
	public void setAccountService(AccountServiceDelegate accountService) {
		ServiceLocator.accountService = accountService;
	}

	/**
	 * @return the costCenterService
	 */
	public static CostCenterService getCostCenterService() {
		return costCenterService;
	}

	/**
	 * @param costCenterService
	 *            the costCenterService to set
	 */
	public void setCostCenterService(CostCenterService costCenterService) {
		ServiceLocator.costCenterService = costCenterService;
	}

	/**
	 * @return the voucherService
	 */
	public static VoucherServiceDelegate getVoucherService() {
		return voucherService;
	}

	/**
	 * @param voucherService
	 *            the voucherService to set
	 */
	public void setVoucherService(VoucherServiceDelegate voucherService) {
		ServiceLocator.voucherService = voucherService;
	}

	/**
	 * @return the menuService
	 */
	public static MenuServiceDelegate getMenuService() {
		return menuService;
	}

	/**
	 * @param menuService
	 *            the menuService to set
	 */
	public void setMenuService(MenuServiceDelegate menuService) {
		ServiceLocator.menuService = menuService;
	}

	/**
	 * @return the reportService
	 */
	public static ReportServiceDelegate getReportService() {
		return reportService;
	}

	/**
	 * @param reportService
	 *            the reportService to set
	 */
	public void setReportService(ReportServiceDelegate reportService) {
		ServiceLocator.reportService = reportService;
	}

	/**
	 * @return the additionalRoleService
	 */
	public static AdditionalRoleServiceDelegate getAdditionalRoleService() {
		return additionalRoleService;
	}

	/**
	 * @param additionalRoleService
	 *            the additionalRoleService to set
	 */
	public void setAdditionalRoleService(
			AdditionalRoleServiceDelegate additionalRoleService) {
		ServiceLocator.additionalRoleService = additionalRoleService;
	}

	/**
	 * @return the brsService
	 */
	public static BRSServiceDelegate getBrsService() {
		return brsService;
	}

	/**
	 * @param brsService
	 *            the brsService to set
	 */
	public void setBrsService(BRSServiceDelegate brsService) {
		ServiceLocator.brsService = brsService;
	}

}
