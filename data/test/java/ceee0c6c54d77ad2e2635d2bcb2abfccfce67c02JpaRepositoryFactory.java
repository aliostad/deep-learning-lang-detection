
package Persistence.JPA;

import Persistence.Interfaces.ExpenseRepository;
import Persistence.Interfaces.ExpenseTypeRepository;
import Persistence.Interfaces.IncomeRepository;
import Persistence.Interfaces.IncomeTypeRepository;
import Persistence.Interfaces.PaymentMeanRepository;
import Persistence.RepositoryFactory;

/**
 * Factory JPA
 *
 * @autor 1110186 & 1110590
 */
public class JpaRepositoryFactory implements RepositoryFactory{

    @Override
    public ExpenseRepository expenseRepository() {
       return new ExpenseRepositoryImp();
    }

    @Override
    public IncomeRepository incomeRepository() {
        return new IncomeRepositoryImp();
    }

    @Override
    public IncomeTypeRepository incomeTypeRepository() {
        return new IncomeTypeRepositoryImp();
    }

    @Override
    public PaymentMeanRepository paymentMeanRepository() {
        return new PaymentMeanRepositoryImp();
    }


    
}
