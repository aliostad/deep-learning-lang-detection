package com.dreamtech360.lfims.resources.api.activator;

import com.dreamtech360.lfims.service.base.LFIMSGenericServiceFactory;
import com.dreamtech360.lfims.service.base.LFIMSModelServiceFactory;
import com.dreamtech360.lfims.services.ServiceEnum;
import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;

public class LFIMSAPIContext implements BundleActivator {

	private static BundleContext bundleContext=null;
	
	public  static <T> LFIMSModelServiceFactory<T> getService(ServiceEnum modelType){
		
		LFIMSModelServiceFactory<T> service=(LFIMSModelServiceFactory<T>)bundleContext.getService(bundleContext.getServiceReference(modelType.getFactoryName()));
		return service;
		
	}
	
public  static <T> LFIMSGenericServiceFactory<T> getGenericService(ServiceEnum modelType){
		
	LFIMSGenericServiceFactory<T> service=(LFIMSGenericServiceFactory<T>)bundleContext.getService(bundleContext.getServiceReference(modelType.getFactoryName()));
		return service;
		
	}
	
	@Override
	public void start(BundleContext context) throws Exception {
		// TODO Auto-generated method stub
		bundleContext=context;
		/*serviceReference=new ArrayList<ServiceReference>();
		
		serviceReference.add(context.getServiceReference(BankMasterServiceFactory.class.getName()));
		BankMasterServiceFactory bankMasterServiceFactory=(BankMasterServiceFactory)context.getService(serviceReference.get(0));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.BANK_MASTER_SERVICE, bankMasterServiceFactory);
		
		serviceReference.add(context.getServiceReference(BranchMasterServiceFactory.class.getName()));
		BranchMasterServiceFactory branchMasterServiceFactory=(BranchMasterServiceFactory)context.getService(serviceReference.get(1));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.BRANCH_MASTER_SERVICE, branchMasterServiceFactory);
		
		serviceReference.add(context.getServiceReference(AdvocateMasterServiceFactory.class.getName()));
		AdvocateMasterServiceFactory advocateMasterServiceFactory=(AdvocateMasterServiceFactory)context.getService(serviceReference.get(2));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.ADVOCATE_MASTER_SERVICE, advocateMasterServiceFactory);
		
		serviceReference.add(context.getServiceReference(OurAdvocateMasterServiceFactory.class.getName()));
		OurAdvocateMasterServiceFactory ourAdvocateMasterServiceFactory=(OurAdvocateMasterServiceFactory)context.getService(serviceReference.get(3));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.OUR_ADVOCATE_MASTER_SERVICE, ourAdvocateMasterServiceFactory);
		
		serviceReference.add(context.getServiceReference(CourtMasterServiceFactory.class.getName()));
		CourtMasterServiceFactory courtMasterServiceFactory=(CourtMasterServiceFactory)context.getService(serviceReference.get(4));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.COURT_MASTER_SERVICE, courtMasterServiceFactory);
		
		serviceReference.add(context.getServiceReference(ExpensesMasterServiceFactory.class.getName()));
		ExpensesMasterServiceFactory expensesMasterServiceFactory=(ExpensesMasterServiceFactory)context.getService(serviceReference.get(5));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.EXPENSES_MASTER_SERVICE, expensesMasterServiceFactory);
		
		serviceReference.add(context.getServiceReference(NdpMasterServiceFactory.class.getName()));
		NdpMasterServiceFactory ndpMasterServiceFactory=(NdpMasterServiceFactory)context.getService(serviceReference.get(6));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.NDP_MASTER_SERVICE, ndpMasterServiceFactory);
		
		serviceReference.add(context.getServiceReference(CaseMgmtMaintenanceServiceFactory.class.getName()));
		CaseMgmtMaintenanceServiceFactory caseMgmtMaintenanceServiceFactory=(CaseMgmtMaintenanceServiceFactory)context.getService(serviceReference.get(7));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.CASE_MGMT_MAINTENANCE, caseMgmtMaintenanceServiceFactory);
		
		serviceReference.add(context.getServiceReference(CaseMasterServiceFactory.class.getName()));
		CaseMasterServiceFactory caseMasterServiceFactory=(CaseMasterServiceFactory)context.getService(serviceReference.get(8));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.CASE_MASTER, caseMasterServiceFactory);
		
		serviceReference.add(context.getServiceReference(CaseDefendentDetailsServiceFactory.class.getName()));
		CaseDefendentDetailsServiceFactory caseDefendentDetailsServiceFactory=(CaseDefendentDetailsServiceFactory)context.getService(serviceReference.get(9));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.CASE_DEFENDENT_DETAILS, caseDefendentDetailsServiceFactory);
		
		serviceReference.add(context.getServiceReference(CaseDiaryServiceFactory.class.getName()));
		CaseDiaryServiceFactory caseDiaryServiceFactory=(CaseDiaryServiceFactory)context.getService(serviceReference.get(10));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.CASE_DIARY, caseDiaryServiceFactory);
		
		serviceReference.add(context.getServiceReference(CaseImportantDocumentsServiceFactory.class.getName()));
		CaseImportantDocumentsServiceFactory caseImportantDocumentsServiceFactory=(CaseImportantDocumentsServiceFactory)context.getService(serviceReference.get(11));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.CASE_IMPORTANT_DOCUMENTS, caseImportantDocumentsServiceFactory);
		
		serviceReference.add(context.getServiceReference(CaseSecurityDetailsServiceFactory.class.getName()));
		CaseSecurityDetailsServiceFactory caseSecurityDetailsServiceFactory=(CaseSecurityDetailsServiceFactory)context.getService(serviceReference.get(12));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.CASE_SECURITY_DETAILS, caseSecurityDetailsServiceFactory);
		
		serviceReference.add(context.getServiceReference(LFIMSCacheManagementServiceFactory.class.getName()));
		LFIMSCacheManagementServiceFactory cacheManagementServiceFactory=(LFIMSCacheManagementServiceFactory)context.getService(serviceReference.get(13));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.CACHE_MANAGEMENT_SERVICE, cacheManagementServiceFactory);
		
		serviceReference.add(context.getServiceReference(LFIMSTransactionManagementServiceFactory.class.getName()));
		LFIMSTransactionManagementServiceFactory transactionManagementServiceFactory=(LFIMSTransactionManagementServiceFactory)context.getService(serviceReference.get(14));
		LFIMSServiceFactoryLocator.registerServiceFactory(ServiceEnum.TRANSACTION_MANAGEMENT_SERVICE, transactionManagementServiceFactory); */
	}

	@Override
	public void stop(BundleContext context) throws Exception {
	
	} 
}
