using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FluentValidation;

namespace SavingsSpa.Models
{
    public class InputSetValidator : AbstractValidator<InputSet>
    {
        public InputSetValidator()
        {
            RuleFor(i => i.InstrumentType).NotNull();
            RuleFor(i => i.InterestRate).NotNull();
            RuleFor(i => i.TermLength).NotNull()
                .When(i => i.InstrumentType == InstrumentType.RecurringDeposit
                    || i.InstrumentType == InstrumentType.TermDeposit);
            RuleFor(i => i.Principle).NotNull()
                            .When(i => i.InstrumentType == InstrumentType.TermDeposit);
            RuleFor(i => i.TermLengthType).NotNull()
                .When(i => i.InstrumentType == InstrumentType.RecurringDeposit
                    || i.InstrumentType == InstrumentType.TermDeposit);

            RuleFor(i => i.MonthlySaving).NotNull()
                .When(i => i.InstrumentType == InstrumentType.RecurringDeposit);
        }
    }
}