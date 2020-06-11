using System;
using FluentValidation;
using ThreeBytes.Email.Dashboard.DispatchMonthly.Entities;
using ThreeBytes.Email.Dashboard.DispatchMonthly.Validations.Abstract;
using ThreeBytes.Email.Dashboard.DispatchMonthly.Validations.Concrete.Validators;

namespace ThreeBytes.Email.Dashboard.DispatchMonthly.Validations.Concrete.Resolvers
{
    public class DashboardDispatchMonthlyEmailValidatorResolver : IDashboardDispatchMonthlyEmailValidatorResolver
    {
        private readonly Func<CreateDashboardDispatchMonthlyEmailValidator> createDashboardDispatchMonthlyEmailValidator;

        public DashboardDispatchMonthlyEmailValidatorResolver(Func<CreateDashboardDispatchMonthlyEmailValidator> createDashboardDispatchMonthlyEmailValidator)
        {
            this.createDashboardDispatchMonthlyEmailValidator = createDashboardDispatchMonthlyEmailValidator;
        }

        public IValidator<DashboardDispatchMonthlyEmail> CreateValidator()
        {
            return createDashboardDispatchMonthlyEmailValidator();
        }
    }
}
