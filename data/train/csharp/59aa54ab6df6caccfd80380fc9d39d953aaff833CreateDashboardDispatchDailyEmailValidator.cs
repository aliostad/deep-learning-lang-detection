using FluentValidation;
using ThreeBytes.Email.Dashboard.DispatchDaily.Entities;

namespace ThreeBytes.Email.Dashboard.DispatchDaily.Validations.Concrete.Validators
{
    public class CreateDashboardDispatchDailyEmailValidator : AbstractValidator<DashboardDispatchDailyEmail>
    {
        public CreateDashboardDispatchDailyEmailValidator()
        {
            RuleFor(x => x.ApplicationName).NotNull().NotEmpty().Length(1, 20);
            RuleFor(x => x.To).NotNull().NotEmpty().EmailAddress().Length(1, 128);
            RuleFor(x => x.Subject).NotNull().NotEmpty().Length(1, 255);
            RuleFor(x => x.DispatchDate).NotNull();
        }
    }
}
