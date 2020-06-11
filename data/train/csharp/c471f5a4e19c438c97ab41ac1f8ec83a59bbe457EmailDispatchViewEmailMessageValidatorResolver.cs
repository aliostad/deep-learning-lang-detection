using System;
using FluentValidation;
using ThreeBytes.Email.Dispatch.View.Entities;
using ThreeBytes.Email.Dispatch.View.Validations.Abstract;
using ThreeBytes.Email.Dispatch.View.Validations.Concrete.Validators;

namespace ThreeBytes.Email.Dispatch.View.Validations.Concrete.Resolvers
{
    public class EmailDispatchViewEmailMessageValidatorResolver : IEmailDispatchViewEmailMessageValidatorResolver
    {
        private readonly Func<SendEmailDispatchViewEmailMessageValidator> sendEmailDispatchViewEmailMessageValidator;

        public EmailDispatchViewEmailMessageValidatorResolver(Func<SendEmailDispatchViewEmailMessageValidator> sendEmailDispatchViewEmailMessageValidator)
        {
            this.sendEmailDispatchViewEmailMessageValidator = sendEmailDispatchViewEmailMessageValidator;
        }

        public IValidator<EmailDispatchViewEmailMessage> CreateValidator()
        {
            return sendEmailDispatchViewEmailMessageValidator();
        }
    }
}
