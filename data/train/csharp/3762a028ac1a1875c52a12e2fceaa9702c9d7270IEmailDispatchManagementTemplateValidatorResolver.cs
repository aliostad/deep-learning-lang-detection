using FluentValidation;
using ThreeBytes.Email.Dispatch.Management.Entities;

namespace ThreeBytes.Email.Dispatch.Management.Validations.Abstract
{
    public interface IEmailDispatchManagementTemplateValidatorResolver
    {
        IValidator<EmailDispatchManagementTemplate> CreateValidator();
        IValidator<EmailDispatchManagementTemplate> RenameValidator();
        IValidator<EmailDispatchManagementTemplate> UpdateContentsValidator();
        IValidator<EmailDispatchManagementTemplate> UpdateFromAddressValidator();
        IValidator<EmailDispatchManagementTemplate> DeleteValidator();
    }
}
