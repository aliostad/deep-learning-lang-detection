Ext.namespace('Srims');

//service
Ext.namespace('Srims.service');
Srims.service.ResourceService = '/Service/Resource.asmx';

Ext.namespace('Srims.service');
Srims.service.ExportService = '/Service/Export.asmx';

Ext.namespace('Srims.service.common');
Srims.service.common.AnnouncementService = '/Service/Common/Announcement.asmx';
Srims.service.common.NoticeTextService = '/Service/Common/NoticeText.asmx';
Srims.service.common.OutsourcingService = '/Service/Common/Outsourcing.asmx';
Srims.service.common.OutsourcingUnitService = '/Service/Common/OutsourcingUnit.asmx';
Srims.service.common.SubjectService = '/Service/Common/Subject.asmx';
Srims.service.common.LogService = '/Service/Common/Log.asmx';
Srims.service.common.SystemSettingService = '/Service/Common/SystemSetting.asmx'
Srims.service.common.EmailService = '/Service/Common/Email.asmx';
Srims.service.common.ViewService = '/Service/Common/View.asmx';

Ext.namespace('Srims.service.users');
Srims.service.users.UserService = '/Service/Users/User.asmx';
Srims.service.users.MessageService = '/Service/Users/Message.asmx';

Ext.namespace('Srims.service.experts');
Srims.service.experts.ExpertService = '/Service/Experts/Expert.asmx';
Srims.service.experts.DepartmentService = '/Service/Experts/Department.asmx';
Srims.service.experts.ExpertInfoHistoryService = '/Service/Experts/ExpertInfoHistory.asmx';

Ext.namespace('Srims.service.bases');
Srims.service.bases.BaseService = '/Service/Bases/Base.asmx';

Ext.namespace('Srims.service.projects');
Srims.service.projects.ProjectService = '/Service/Projects/Project.asmx';
Srims.service.projects.ProjectMemberService = '/Service/Projects/ProjectMember.asmx';
Srims.service.projects.StateHistoryService = '/Service/Projects/ProjectStateHistory.asmx';

Ext.namespace('Srims.service.recovery');
Srims.service.recovery.RecoveryService = '/Service/Recovery/Recovery.asmx';

Ext.namespace('Srims.service.type');
Srims.service.type.ManagementFeesService = '/Service/type/ManagementFees.asmx'
Srims.service.type.ProjectRankService = '/Service/type/ProjectRank.asmx'
Srims.service.type.ProjectTypeService = '/Service/type/ProjectType.asmx'
Srims.service.type.ProjectSupportCategoryService = '/Service/type/ProjectSupportCategory.asmx'
Srims.service.type.ProjectSupportFieldService = '/Service/type/ProjectSupportField.asmx'
Srims.service.type.ProjectSupportSubFieldService = '/Service/type/ProjectSupportSubField.asmx'

Ext.namespace('Srims.service.fund');
Srims.service.fund.FundAllocationService = '/Service/Fund/FundAllocation.asmx';
Srims.service.fund.FundAllocationStateHistoryService = '/Service/Fund/FundAllocationStateHistory.asmx';
Srims.service.fund.FundDescendService = '/Service/Fund/FundDescend.asmx';
Srims.service.fund.FundDescendStateHistoryService = '/Service/Fund/FundDescendStateHistory.asmx';
Srims.service.fund.PayPlanItemService = '/Service/Fund/PayPlanItem.asmx';
Srims.service.fund.FinanceService = '/Service/Fund/Finance.asmx';
Srims.service.fund.FinanceFundDescendService = '/Service/Fund/FinanceFundDescend.asmx';
Srims.service.fund.VoucherService = '/Service/Fund/Voucher.asmx';
Srims.service.fund.FinanceBakService = '/Service/Fund/FinanceBak.asmx';
Srims.service.fund.VoucherOutService = '/Service/Fund/VoucherOut.asmx';
Srims.service.fund.FundMemberService = '/Service/Fund/FundMember.asmx';
Srims.service.fund.VoucherStateHistoryService = '/Service/Fund/VoucherStateHistory.asmx';

Ext.namespace('Srims.service.documents');
Srims.service.documents.DocumentService = '/Service/Documents/Document.asmx';
Srims.service.documents.ContractService = '/Service/Documents/Contract.asmx';
Srims.service.documents.DocumentModelService = '/Service/Documents/DocumentModel.asmx';
Srims.service.documents.AwardDocumentService = '/Service/Documents/AwardDocument.asmx';

Ext.namespace('Srims.service.awards');
Srims.service.awards.AwardService = '/Service/Awards/Award.asmx';
Srims.service.awards.AwardWinnerService = '/Service/Awards/AwardWinner.asmx';

Ext.namespace('Srims.service.patents');
Srims.service.patents.PatentService = '/Service/Patents/Patent.asmx';
Srims.service.patents.PatentAgencyService = '/Service/Patents/PatentAgency.asmx';
Srims.service.patents.PatentInventerService = '/Service/Patents/PatentInventer.asmx';
Srims.service.patents.PatentAgencyService = '/Service/Patents/PatentAgency.asmx';

Ext.namespace('Srims.service.papers');
Srims.service.papers.PaperService = '/Service/Papers/Paper.asmx';
Srims.service.papers.PaperAuthorService = '/Service/Papers/PaperAuthor.asmx';
Srims.service.papers.MagazineService = '/Service/Papers/Magazine.asmx';
Srims.service.papers.MagazineInformationService = '/Service/Papers/MagazineInformation.asmx';
Srims.service.papers.MagazineOccupationService = '/Service/Papers/MagazineOccupation.asmx';
Srims.service.papers.LiberalArtsPaperService = '/Service/Papers/LiberalArtsPaper.asmx';
Srims.service.papers.LiberalArtsPaperAuthorService = '/Service/Papers/LiberalArtsPaperAuthor.asmx';

Ext.namespace('Srims.service.statistic');
Srims.service.statistic.StatisticsService = '/Service/Statistics/Statistics.asmx';

Ext.namespace('Srims.service.stamp');
Srims.service.stamp.StampService = '/Service/Stamps/Stamp.asmx';
Srims.service.stamp.StampApplicationService = '/Service/Stamps/StampApplication.asmx';
Srims.service.stamp.StampStateHistoryService = '/Service/Stamps/StampStateHistory.asmx';
Srims.service.stamp.StuffStampService = '/Service/Stamps/StuffStamp.asmx';
Srims.service.stamp.StuffService = '/Service/Stamps/Stuff.asmx';
Srims.service.stamp.StampApplicationTypeService = '/Service/Stamps/StampApplicationType.asmx';
Srims.service.stamp.StampApplicationTypeGroupService = '/Service/Stamps/StampApplicationTypeGroup.asmx';
Srims.service.stamp.StampFirstAdminService = '/Service/Stamps/StampApplicationFirstAdmin.asmx';
Srims.service.stamp.StampSecondAdminService = '/Service/Stamps/StampApplicationSecondAdmin.asmx';

Ext.namespace('Srims.service.performance');
Srims.service.performance.PerformanceService = '/Service/Performance/Performance.asmx';
Srims.service.performance.PerformanceAllocationService = '/Service/Performance/PerformanceAllocation.asmx';
Srims.service.performance.PerformanceAllocationStateHistoryService = '/Service/Performance/PerformanceAllocationStateHistory.asmx';
Srims.service.performance.PerformanceVoucherService = '/Service/Performance/PerformanceVoucher.asmx';
Srims.service.performance.PerformanceVoucherStateHistoryService = '/Service/Performance/PerformanceVoucherStateHistory.asmx';
