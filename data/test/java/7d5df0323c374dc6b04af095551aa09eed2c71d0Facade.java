package com.ebiz.baida.middle.service;

/**
 * @author Hui,Gang
 * @version Build 2011-2-23 下午05:01:59
 */
public interface Facade {

	RoleInfoService getRoleInfoService();

	TableInfoService getTableInfoService();

	TemplateService getTemplateService();

	GenerateDomainService getGenerateDomainService();

	GenerateDaoService getGenerateDaoService();

	GenerateDaoSqlMapImplService getGenerateDaoSqlMapImplService();

	GenerateSqlMapService getGenerateSqlMapService();

	GenerateServiceService getGenerateServiceService();

	GenerateFacadeService getGenerateFacadeService();

	GenerateServiceImplService getGenerateServiceImplService();

	GenerateFacadeImplService getGenerateFacadeImplService();

	GenerateSqlMapConfigService getGenerateSqlMapConfigService();

	GenerateActionService getGenerateActionService();

	GenerateJspFormService getGenerateJspFormService();

	GenerateJspListService getGenerateJspListService();

	GenerateJspViewService getGenerateJspViewService();

}
