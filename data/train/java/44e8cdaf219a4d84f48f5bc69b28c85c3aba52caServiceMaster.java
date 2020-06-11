
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.fks.ui.constants;

//import com.eks.pmo.timelive.PortfolioService;
//import com.eks.pmo.timelive.PortfolioServiceService;
import com.fks.article.service.ArticleDownloadResp;
import com.fks.article.service.ArticleSearchReq;
import com.fks.article.service.DownloadArticleService;
import com.fks.article.service.DownloadArticleServiceService;
import com.fks.article.service.Resp;
import com.fks.ods.service.ODSService;
import com.fks.ods.service.ODSServiceService;
import com.fks.promo.comm.service.CommService;
import com.fks.promo.comm.service.CommServiceService;
import com.fks.promo.init.CommonPromotionService;
import com.fks.promo.init.CommonPromotionServiceService;
import com.fks.promo.init.SearchPromotionService;
import com.fks.promo.init.SearchPromotionServiceService;
import com.fks.promo.init.TransPromoService;
import com.fks.promo.init.TransPromoServiceService;
import com.fks.promo.master.service.CategoryMCHService;
import com.fks.promo.master.service.CategoryMCHServiceService;
import com.fks.promo.master.service.OrganizationMasterService;
import com.fks.promo.master.service.OrganizationMasterServiceService;
import com.fks.promo.master.service.OtherMasterService;
import com.fks.promo.master.service.OtherMasterServiceService;
import com.fks.promo.master.service.RoleMasterService;
import com.fks.promo.master.service.RoleMasterServiceService;
import com.fks.promo.master.service.UserMasterService;
import com.fks.promo.master.service.UserMasterServiceService;
import com.fks.promo.task.TaskService;
import com.fks.promo.task.TaskServiceService;
import com.fks.promotion.approval.service.ApprRejHoldPromotionReqService;
import com.fks.promotion.approval.service.ApprRejHoldPromotionReqServiceService;
import com.fks.promotion.service.PromotionInitiateService;
import com.fks.promotion.service.PromotionInitiateServiceService;
import com.fks.promotion.service.PromotionProposalService;
import com.fks.promotion.service.PromotionProposalServiceService;
import com.fks.promotion.service.ProposalSearch;
import com.fks.promotion.service.ProposalSearchService;
import com.fks.reports.service.ReportService;
import com.fks.reports.service.ReportServiceService;
import org.apache.log4j.Logger;

/**
 *
 * @author Paresb 
 */
public class ServiceMaster {

    private static final Logger logger = Logger.getLogger(ServiceMaster.class);
    //MasterServiceService masterServiceport = new MasterServiceService();
    //public final static MasterService MST_SERVIER_PORT;
    private static RoleMasterService roleMasterService;
    private static OtherMasterService otherMasterService;
    private static CategoryMCHService categoryMCHService;
    private static OrganizationMasterService organizationMasterService;
    private static UserMasterService userMasterService;
    private static PromotionProposalService promotionProposalService;
    private static ODSService odsService;
    private static PromotionInitiateService promotionInitiateService;
    private static ProposalSearch proposalSearchService;
    private static TransPromoService transPromoService;
    private static SearchPromotionService searchPromotionService;
    private static ApprRejHoldPromotionReqService apprRejHoldPromotionReqService;
    private static CommonPromotionService commonPromotionService;
    private static TaskService taskService;
    private static CommService commService;
    private static DownloadArticleService downloadArticleService;
    private static ReportService reportService;

    private ServiceMaster() {
    }

    static {
        roleMasterService = new RoleMasterServiceService().getRoleMasterServicePort();
        otherMasterService = new OtherMasterServiceService().getOtherMasterServicePort();
        categoryMCHService = new CategoryMCHServiceService().getCategoryMCHServicePort();
        organizationMasterService = new OrganizationMasterServiceService().getOrganizationMasterServicePort();
        userMasterService = new UserMasterServiceService().getUserMasterServicePort();
        promotionProposalService = new PromotionProposalServiceService().getPromotionProposalServicePort();
        odsService = new ODSServiceService().getODSServicePort();
        promotionInitiateService = new PromotionInitiateServiceService().getPromotionInitiateServicePort();
        proposalSearchService = new ProposalSearchService().getProposalSearchPort();
        transPromoService = new TransPromoServiceService().getTransPromoServicePort();
        searchPromotionService = new SearchPromotionServiceService().getSearchPromotionServicePort();
        apprRejHoldPromotionReqService = new ApprRejHoldPromotionReqServiceService().getApprRejHoldPromotionReqServicePort();
        commonPromotionService = new CommonPromotionServiceService().getCommonPromotionServicePort();
        taskService = new TaskServiceService().getTaskServicePort();
        commService= new CommServiceService().getCommServicePort();
        downloadArticleService=new DownloadArticleServiceService().getDownloadArticleServicePort();
        reportService = new ReportServiceService().getReportServicePort();
        logger.info("----- All Ports are created successfully ------- ");
    }

    public static TaskService getTaskService() {
        return taskService;
    }

    public static void setTaskService(TaskService taskService) {
        ServiceMaster.taskService = taskService;
    }

    public static CommonPromotionService getCommonPromotionService() {
        return commonPromotionService;
    }

    public static void setCommonPromotionService(CommonPromotionService commonPromotionService) {
        ServiceMaster.commonPromotionService = commonPromotionService;
    }

    public static CategoryMCHService getCategoryMCHService() {
        return categoryMCHService;
    }

    public static void setCategoryMCHService(CategoryMCHService categoryMCHService) {
        ServiceMaster.categoryMCHService = categoryMCHService;
    }

    public static RoleMasterService getRoleMasterService() {
        return roleMasterService;
    }

    public static void setRoleMasterService(RoleMasterService roleMasterService) {
        ServiceMaster.roleMasterService = roleMasterService;
    }

    public static OtherMasterService getOtherMasterService() {
        return otherMasterService;
    }

    public static void setOtherMasterService(OtherMasterService otherMasterService) {
        ServiceMaster.otherMasterService = otherMasterService;
    }

    public static OrganizationMasterService getOrganizationMasterService() {
        return organizationMasterService;
    }

    public static void setOrganizationMasterService(OrganizationMasterService organizationMasterService) {
        ServiceMaster.organizationMasterService = organizationMasterService;
    }

    public static UserMasterService getUserMasterService() {
        return userMasterService;
    }

    public static void setUserMasterService(UserMasterService userMasterService) {
        ServiceMaster.userMasterService = userMasterService;
    }

    public static PromotionProposalService getPromotionProposalService() {
        return promotionProposalService;
    }

    public static void setPromotionProposalService(PromotionProposalService promotionProposalService) {
        ServiceMaster.promotionProposalService = promotionProposalService;
    }

    public static ODSService getOdsService() {
        return odsService;
    }

    public static void setOdsService(ODSService odsService) {
        ServiceMaster.odsService = odsService;
    }

    public static PromotionInitiateService getPromotionInitiateService() {
        return promotionInitiateService;
    }

    public static void setPromotionInitiateService(PromotionInitiateService promotionInitiateService) {
        ServiceMaster.promotionInitiateService = promotionInitiateService;
    }

    public static ProposalSearch getProposalSearchService() {
        return proposalSearchService;
    }

    public static void setProposalSearchService(ProposalSearch proposalSearchService) {
        ServiceMaster.proposalSearchService = proposalSearchService;
    }

    public static TransPromoService getTransPromoService() {
        return transPromoService;
    }

    public static void setTransPromoService(TransPromoService transPromoService) {
        ServiceMaster.transPromoService = transPromoService;
    }

    public static SearchPromotionService getSearchPromotionService() {
        return searchPromotionService;
    }

    public static void setSearchPromotionService(SearchPromotionService searchPromotionService) {
        ServiceMaster.searchPromotionService = searchPromotionService;
    }

    public static ApprRejHoldPromotionReqService getApprRejHoldPromotionReqService() {
        return apprRejHoldPromotionReqService;
    }

    public static void setApprRejHoldPromotionReqService(ApprRejHoldPromotionReqService apprRejHoldPromotionReqService) {
        ServiceMaster.apprRejHoldPromotionReqService = apprRejHoldPromotionReqService;
    }

    public static CommService getCommService() {
        return commService;
    }

    public static void setCommService(CommService commService) {
        ServiceMaster.commService = commService;
    }

    public static DownloadArticleService getDownloadArticleService() {
        return downloadArticleService;
    }

    public static void setDownloadArticleService(DownloadArticleService downloadArticleService) {
        ServiceMaster.downloadArticleService = downloadArticleService;
    }

    public static ReportService getReportService() {
        return reportService;
    }

    public static void setReportService(ReportService reportService) {
        ServiceMaster.reportService = reportService;
    }
    
    
}
