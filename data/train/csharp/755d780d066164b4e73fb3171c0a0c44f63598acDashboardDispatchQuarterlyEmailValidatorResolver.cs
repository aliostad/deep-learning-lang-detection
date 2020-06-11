using System;
using FluentValidation;
using ThreeBytes.Email.Dashboard.DispatchQuarterly.Entities;
using ThreeBytes.Email.Dashboard.DispatchQuarterly.Validations.Abstract;
using ThreeBytes.Email.Dashboard.DispatchQuarterly.Validations.Concrete.Validators;

namespace ThreeBytes.Email.Dashboard.DispatchQuarterly.Validations.Concrete.Resolvers
{
    public class DashboardDispatchQuarterlyEmailValidatorResolver : IDashboardDispatchQuarterlyEmailValidatorResolver
    {
        private readonly Func<CreateDashboardDispatchQuarterlyEmailValidator> createDashboardDispatchQuarterlyEmailValidator;

        public DashboardDispatchQuarterlyEmailValidatorResolver(Func<CreateDashboardDispatchQuarterlyEmailValidator> createDashboardDispatchQuarterlyEmailValidator)
        {
            this.createDashboardDispatchQuarterlyEmailValidator = createDashboardDispatchQuarterlyEmailValidator;
        }

        public IValidator<DashboardDispatchQuarterlyEmail> CreateValidator()
        {
            return createDashboardDispatchQuarterlyEmailValidator();
        }
    }
}
