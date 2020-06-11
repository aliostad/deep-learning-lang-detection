 /*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Persistence;

/**
 *
 * @author arocha
 */
public interface RepositoryFactory {

    IExpenseRepository iexpenseRepository();

    TypeOfExpenseRepository TypeOfExpenseRepository();

    IncomeTypeRepository buildIncomeTypeRepository();

    IPaymentTypeRepository buildPaymentTypeRepository();

    IPayModeRepository buildPayModeRepository();

    StartingBalanceRepository buildStartingBalanceRepository();

    IExpensesLimitsRepository buildExpensesLimitsRepository();

    IncomeRepository buildIncomeRepository();
    
    CheckingAccountRepository buildCheckingAccountRepository();
}
