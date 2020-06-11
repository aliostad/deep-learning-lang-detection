using System;
using FluentValidation;
using ThreeBytes.Email.Dashboard.DispatchYearly.Entities;
using ThreeBytes.Email.Dashboard.DispatchYearly.Validations.Abstract;
using ThreeBytes.Email.Dashboard.DispatchYearly.Validations.Concrete.Validators;

namespace ThreeBytes.Email.Dashboard.DispatchYearly.Validations.Concrete.Resolvers
{
    public class DashboardDispatchYearlyEmailValidatorResolver : IDashboardDispatchYearlyEmailValidatorResolver
    {
        private readonly Func<CreateDashboardDispatchYearlyEmailValidator> createDashboardDispatchYearlyEmailValidator;

        public DashboardDispatchYearlyEmailValidatorResolver(Func<CreateDashboardDispatchYearlyEmailValidator> createDashboardDispatchYearlyEmailValidator)
        {
            this.createDashboardDispatchYearlyEmailValidator = createDashboardDispatchYearlyEmailValidator;
        }

        public IValidator<DashboardDispatchYearlyEmail> CreateValidator()
        {
            return createDashboardDispatchYearlyEmailValidator();
        }
    }
}
