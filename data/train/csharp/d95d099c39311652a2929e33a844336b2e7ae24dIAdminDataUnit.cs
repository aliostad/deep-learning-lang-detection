using EventManagementSystem.Data.Repositories.Interfaces;
using EventManagementSystem.Data.UnitOfWork.Base;

namespace EventManagementSystem.Data.UnitOfWork.Interfaces
{
    public interface IAdminDataUnit : IDataUnitOfWork
    {
        IRoomsRepository RoomsRepository { get; }
        IFacilitiesRepository FacilitiesRepository { get; }
        IRoomFacilitiesRepository RoomFacilitiesRepository { get; }
        IGolfsRepository GolfsRepository { get; }
        IGolfFollowResourcesRepository GolfFollowResourceRepository { get; }
        IUsersRepository UsersRepository { get; }
        IUserGroupsRepository UserGroupsRepository { get; }
        IUserJobTypesRepository UserJobTypesRepository { get; }
        IUserDepartmentsRepository UserDepartmentsRepository { get; }
        IPermissionsRepository PermissionsRepository { get; }
        IUserPermissionsRepository UserPermissionsRepository { get; }
        IUserGroupPermissionsRepository UserGroupPermissionsRepository { get; }
        IPermissionGroupsRepository PermissionGroupsRepository { get; }

        IEventOptionsRepository EventOptionsRepository { get; }
        IEventTypeOptionsRepository EventTypeOptionsRepository { get; }
        IEventTypesRepository EventTypesRepository { get; }
        IEventStatusesRepository EventStatusesRepository { get; }
        IEventStatusOptionsRepository EventStatusOptionsRepository { get; }

        IProductsRepository ProductsRepository { get; }
        IProductTypesRepository ProductTypesRepository { get; }
        IProductGroupsRepository ProductGroupsRepository { get; }
        IProductDepartmentsRepository ProductDepartmentsRepository { get; }
        IProductEventTypesRepository ProductEventTypesRepository { get; }
        IProductVatRatesRepository ProductVatRatesRepository { get; }
        IProductOptionsRepository ProductOptionsRepository { get; }

        IMailTemplatesRepository MailTemplatesRepository { get; }
        IMailTemplateCategoriesRepository MailTemplateCategoriesRepository { get; }
        IMailTemplateTypesRepository MailTemplateTypesRepository { get; }

        IFollowUpStatusesRepository FollowUpStatusesRepository { get; }
        IEnquiryStatusesRepository EnquiryStatusesRepository { get; }
        IEnquiryReceiveMethodsRepository EnquiryReceiveMethodsRepository { get; }

        IDefaultSettingsForEnquiriesRepository DefaultSettingsForEnquiriesRepository { get; }
        IDocumentsRepository DocumentsRepository { get; }
        IEventsRepository EventsRepository { get; }
        ITillDivisionsRepository TillDivisionsRepository { get; }

        ITillsRepository TillsRepository { get; }
        ISystemSettingsRepository SystemSettingsRepository { get; }
        IEventTypeTODOsRepository EventTypeTODOsRepository { get; }
        IMembershipGroupStylesRepository MembershipGroupStylesRepository { get; }
        IMembershipGroupAgesRepository MembershipGroupAgesRepository { get; }
        IMembershipGroupsRepository MembershipGroupsRepository { get; }
        IMembershipCategoriesRepository MembershipCategoriesRepository { get; }
        IMembershipCategoryGroupDefaultsRepository MembershipCategoryGroupDefaultsRepository { get; }
        IMembershipFullPaymentCostsRepository MembershipFullPaymentCostsRepository { get; }
        IMembershipMonthlyPaymentOngoingCostsRepository MembershipMonthlyPaymentOngoingCostsRepository { get; }
        IMembershipMonthlyPaymentUpFrontCostsRepository MembershipMonthlyPaymentUpFrontCostsRepository { get; }
        IMembershipTokensRepository MembershipTokensRepository { get; }
        IMembershipLinkTypesRepository MembershipLinkTypesRepository { get; }
        IMembershipOptionBoxesRepository MembershipOptionBoxesRepository { get; }
        IMembershipOptionBoxReasonsRepository MembershipOptionBoxReasonsRepository { get; }
        IMembershipGroupEPOSRepository MembershipGroupEPOSRepository { get; }
        IMembershipCategoryGroupDefaultEPOSRepository MembershipCategoryGroupDefaultEPOSRepository { get; }
        IEmailHeadersRepository EmailHeadersRepository { get; }
    }
}
