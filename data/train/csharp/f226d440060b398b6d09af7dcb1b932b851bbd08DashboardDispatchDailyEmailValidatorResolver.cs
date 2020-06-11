using System;
using FluentValidation;
using ThreeBytes.Email.Dashboard.DispatchDaily.Entities;
using ThreeBytes.Email.Dashboard.DispatchDaily.Validations.Abstract;
using ThreeBytes.Email.Dashboard.DispatchDaily.Validations.Concrete.Validators;

namespace ThreeBytes.Email.Dashboard.DispatchDaily.Validations.Concrete.Resolvers
{
    public class DashboardDispatchDailyEmailValidatorResolver : IDashboardDispatchDailyEmailValidatorResolver
    {
        private readonly Func<CreateDashboardDispatchDailyEmailValidator> createDashboardDispatchDailyEmailValidator;

        public DashboardDispatchDailyEmailValidatorResolver(Func<CreateDashboardDispatchDailyEmailValidator> createDashboardDispatchDailyEmailValidator)
        {
            this.createDashboardDispatchDailyEmailValidator = createDashboardDispatchDailyEmailValidator;
        }

        public IValidator<DashboardDispatchDailyEmail> CreateValidator()
        {
            return createDashboardDispatchDailyEmailValidator();
        }
    }
}
