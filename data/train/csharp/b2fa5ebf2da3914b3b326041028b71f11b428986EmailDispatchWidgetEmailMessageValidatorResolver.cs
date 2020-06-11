using System;
using FluentValidation;
using ThreeBytes.Email.Dispatch.Widget.Entities;
using ThreeBytes.Email.Dispatch.Widget.Validations.Abstract;
using ThreeBytes.Email.Dispatch.Widget.Validations.Concrete.Validators;

namespace ThreeBytes.Email.Dispatch.Widget.Validations.Concrete.Resolvers
{
    public class EmailDispatchWidgetEmailMessageValidatorResolver : IEmailDispatchWidgetEmailMessageValidatorResolver
    {
        private readonly Func<SendEmailDispatchWidgetEmailMessageValidator> sendEmailDispatchWidgetEmailMessageValidator;

        public EmailDispatchWidgetEmailMessageValidatorResolver(Func<SendEmailDispatchWidgetEmailMessageValidator> sendEmailDispatchWidgetEmailMessageValidator)
        {
            this.sendEmailDispatchWidgetEmailMessageValidator = sendEmailDispatchWidgetEmailMessageValidator;
        }

        public IValidator<EmailDispatchWidgetEmailMessage> CreateValidator()
        {
            return sendEmailDispatchWidgetEmailMessageValidator();
        }
    }
}
