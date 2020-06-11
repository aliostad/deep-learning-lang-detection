using System;
using FluentValidation;
using ThreeBytes.Email.Dispatch.List.Entities;
using ThreeBytes.Email.Dispatch.List.Validations.Abstract;
using ThreeBytes.Email.Dispatch.List.Validations.Concrete.Validators;

namespace ThreeBytes.Email.Dispatch.List.Validations.Concrete.Resolvers
{
    public class EmailDispatchListEmailMessageValidatorResolver : IEmailDispatchListEmailMessageValidatorResolver
    {
        private readonly Func<SendEmailDispatchListEmailMessageValidator> sendEmailDispatchListEmailMessageValidator;

        public EmailDispatchListEmailMessageValidatorResolver(Func<SendEmailDispatchListEmailMessageValidator> sendEmailDispatchListEmailMessageValidator)
        {
            this.sendEmailDispatchListEmailMessageValidator = sendEmailDispatchListEmailMessageValidator;
        }

        public IValidator<EmailDispatchListEmailMessage> CreateValidator()
        {
            return sendEmailDispatchListEmailMessageValidator();
        }
    }
}
