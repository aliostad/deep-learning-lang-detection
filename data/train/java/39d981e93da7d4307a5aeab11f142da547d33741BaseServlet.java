package com.en.servlet;

import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import com.en.handler.AccessPointHandler;
import com.en.handler.AdminStockRegisterHandler;
import com.en.handler.AjaxHandler;
import com.en.handler.ApprovalHandler;
import com.en.handler.AttendanceHandler;
import com.en.handler.Basehandler;
import com.en.handler.BranchDayEntryHandler;
import com.en.handler.BranchDayEntryReportHandler;
import com.en.handler.BranchStockEntryHandler;
import com.en.handler.BranchStockHandler;
import com.en.handler.CollectionHandler;
import com.en.handler.CreditNoteHandler;
import com.en.handler.CreditNoteRptHandler;
import com.en.handler.CustomerEmailRptHandler;
import com.en.handler.CustomerGroupHandler;
import com.en.handler.CustomerHandler;
import com.en.handler.CustomerLedgerRptHandler;
import com.en.handler.EnquiryHandler;
import com.en.handler.EnquiryRptHandler;
import com.en.handler.ExcelHandler;
import com.en.handler.ExhibitionOrderHandler;
import com.en.handler.ExhibitionQuotationHandler;
import com.en.handler.HomeSettingHandler;
import com.en.handler.ItemCategoryHandler;
import com.en.handler.ItemDetailsHandler;
import com.en.handler.ItemGroupHandler;
import com.en.handler.ItemHandler;
import com.en.handler.LabourBillRptHandler;
import com.en.handler.LabourInvoiceHandler;
import com.en.handler.LedgerAdjustmentHandler;
import com.en.handler.LoginHandler;
import com.en.handler.LogoutHandler;
import com.en.handler.OfferHandler;
import com.en.handler.OrderHandler;
import com.en.handler.OrderReportHandler;
import com.en.handler.PromotionalMailHandler;
import com.en.handler.PromotionalSMSHandler;
import com.en.handler.PurchaseHandler;
import com.en.handler.PurchaseReportHandler;
import com.en.handler.PurchaseReturnHandler;
import com.en.handler.PurchaseReturnRptHandler;
import com.en.handler.QuotationHandler;
import com.en.handler.SalaryHandler;
import com.en.handler.SalesHandler;
import com.en.handler.SalesReportHandler;
import com.en.handler.SalesTaxReportHandler;
import com.en.handler.SalesmanDailyHandler;
import com.en.handler.SalesmanEnquiryHandler;
import com.en.handler.SalesmanOrderHandler;
import com.en.handler.SalesmanQuotationHandler;
import com.en.handler.StockRegisterHandler;
import com.en.handler.TaxHandler;
import com.en.handler.MessengerHandler;
import com.en.handler.TransferHandler;
import com.en.handler.TransferReportHandler;
import com.en.handler.TransferRequestHandler;
import com.en.handler.UserAccessHandler;
import com.en.handler.UserHandler;
import com.en.util.Constant;

public abstract class BaseServlet extends HttpServlet implements Constant{

	private static final long serialVersionUID = -2042216527569795845L;

	public void init() throws ServletException {
		super.init();
		initailizeMap();
	}
	
	protected HashMap<String,Basehandler> pageMap = new HashMap<String,Basehandler>();

	protected void initailizeMap() {
		
		pageMap.put(LoginHandler.getPageName(), new LoginHandler());
		
		pageMap.put(LogoutHandler.getPageName(), new LogoutHandler());
		
		pageMap.put(HomeSettingHandler.getPageName(), new HomeSettingHandler());
		
		pageMap.put(ItemGroupHandler.getPageName(), new ItemGroupHandler());
		
		pageMap.put(ItemCategoryHandler.getPageName(), new ItemCategoryHandler());
		
		pageMap.put(ItemHandler.getPageName(), new ItemHandler());
		
		pageMap.put(CustomerGroupHandler.getPageName(), new CustomerGroupHandler());
		
		pageMap.put(CustomerHandler.getPageName(), new CustomerHandler());
		
		pageMap.put(AccessPointHandler.getPageName(), new AccessPointHandler());
		
		pageMap.put(UserHandler.getPageName(), new UserHandler());
		
		pageMap.put(UserAccessHandler.getPageName(), new UserAccessHandler());
		
		pageMap.put(OfferHandler.getPageName(), new OfferHandler());
		
		pageMap.put(EnquiryHandler.getPageName(), new EnquiryHandler());
		
		pageMap.put(SalesmanEnquiryHandler.getPageName(), new SalesmanEnquiryHandler());
		
		pageMap.put(SalesmanDailyHandler.getPageName(), new SalesmanDailyHandler());
		
		pageMap.put(EnquiryRptHandler.getPageName(), new EnquiryRptHandler());
		
		pageMap.put(TaxHandler.getPageName(), new TaxHandler());
		
		pageMap.put(SalesHandler.getPageName(), new SalesHandler());
		
		pageMap.put(TransferHandler.getPageName(), new TransferHandler());
		
		pageMap.put(BranchDayEntryHandler.getPageName(), new BranchDayEntryHandler());
		
		pageMap.put(PurchaseHandler.getPageName(), new PurchaseHandler());
		
		pageMap.put(ExcelHandler.getPageName(), new ExcelHandler());
		
		pageMap.put(CollectionHandler.getPageName(), new CollectionHandler());
		
		pageMap.put(SalesReportHandler.getPageName(), new SalesReportHandler());
		
		pageMap.put(PurchaseReportHandler.getPageName(), new PurchaseReportHandler());
		
		pageMap.put(TransferReportHandler.getPageName(), new TransferReportHandler());
		
		pageMap.put(QuotationHandler.getPageName(), new QuotationHandler());
		
		pageMap.put(OrderHandler.getPageName(), new OrderHandler());
		
		pageMap.put(BranchDayEntryReportHandler.getPageName(), new BranchDayEntryReportHandler()); 
		
		pageMap.put(CustomerLedgerRptHandler.getPageName(), new CustomerLedgerRptHandler());
		
		pageMap.put(PromotionalMailHandler.getPageName(), new PromotionalMailHandler());
		
		pageMap.put(AjaxHandler.getPageName(), new AjaxHandler());
		 
		pageMap.put(ApprovalHandler.getPageName(), new ApprovalHandler());
		
		pageMap.put(BranchStockHandler.getPageName(), new BranchStockHandler());

		pageMap.put(LabourInvoiceHandler.getPageName(), new LabourInvoiceHandler());

		pageMap.put(LabourBillRptHandler.getPageName(), new LabourBillRptHandler());

		pageMap.put(CreditNoteHandler.getPageName(), new CreditNoteHandler());

		pageMap.put(CreditNoteRptHandler.getPageName(), new CreditNoteRptHandler());

		pageMap.put(PurchaseReturnHandler.getPageName(), new PurchaseReturnHandler());

		pageMap.put(PurchaseReturnRptHandler.getPageName(), new PurchaseReturnRptHandler());

		pageMap.put(LedgerAdjustmentHandler.getPageName(), new LedgerAdjustmentHandler());

		pageMap.put(ExhibitionOrderHandler.getPageName(), new ExhibitionOrderHandler());

		pageMap.put(ExhibitionQuotationHandler.getPageName(), new ExhibitionQuotationHandler());

		pageMap.put(OrderReportHandler.getPageName(), new OrderReportHandler());

		pageMap.put(CustomerEmailRptHandler.getPageName(), new CustomerEmailRptHandler());

		pageMap.put(TransferRequestHandler.getPageName(), new TransferRequestHandler());

		pageMap.put(StockRegisterHandler.getPageName(), new StockRegisterHandler());

		pageMap.put(PromotionalSMSHandler.getPageName(), new PromotionalSMSHandler());

		pageMap.put(ItemDetailsHandler.getPageName(), new ItemDetailsHandler());
		
		pageMap.put(SalesmanQuotationHandler.getPageName(), new SalesmanQuotationHandler());
		
		pageMap.put(SalesmanOrderHandler.getPageName(), new SalesmanOrderHandler());
		
		pageMap.put(AdminStockRegisterHandler.getPageName(), new AdminStockRegisterHandler());
		
		pageMap.put(SalesTaxReportHandler.getPageName(), new SalesTaxReportHandler());
		
		pageMap.put(BranchStockEntryHandler.getPageName(), new BranchStockEntryHandler());
		
		pageMap.put(MessengerHandler.getPageName(), new MessengerHandler());
		
		pageMap.put(AttendanceHandler.getPageName(), new AttendanceHandler());
		
		pageMap.put(SalaryHandler.getPageName(), new SalaryHandler());
		
	}

}
