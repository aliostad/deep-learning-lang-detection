using System;
using FluentValidation;
using ThreeBytes.Email.Dispatch.Management.Entities;
using ThreeBytes.Email.Dispatch.Management.Validations.Abstract;
using ThreeBytes.Email.Dispatch.Management.Validations.Concrete.Validators;

namespace ThreeBytes.Email.Dispatch.Management.Validations.Concrete.Resolvers
{
    public class EmailDispatchManagementEmailMessageValidatorResolver : IEmailDispatchManagementEmailMessageValidatorResolver
    {
        private readonly Func<SendEmailDispatchManagementEmailMessageValidator> sendEmailDispatchManagementEmailMessageValidator;

        public EmailDispatchManagementEmailMessageValidatorResolver(Func<SendEmailDispatchManagementEmailMessageValidator> sendEmailDispatchManagementEmailMessageValidator)
        {
            this.sendEmailDispatchManagementEmailMessageValidator = sendEmailDispatchManagementEmailMessageValidator;
        }

        public IValidator<EmailDispatchManagementEmailMessage> SendValidator()
        {
            return sendEmailDispatchManagementEmailMessageValidator();
        }
    }
}
