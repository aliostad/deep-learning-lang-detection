package eapli.expensemanager.persistence;

public class InMemoryRepositoryFactory implements IRepositoryFactory {
    
    @Override
    public IExpenseRepository expenseRepository() {
        return new eapli.expensemanager.persistence.inmemory.ExpenseRepositoryImpl();
    }

    @Override
    public IExpenseTypeRepository expenseTypeRepository() {
        return new eapli.expensemanager.persistence.inmemory.ExpenseTypeRepositoryImpl();
    }
    
    @Override
    public IIncomeRepository incomeRepository() {
        return new eapli.expensemanager.persistence.inmemory.IncomeRepositoryImpl();
    }

    @Override
    public IIncomeTypeRepository incomeTypeRepository() {
        return new eapli.expensemanager.persistence.inmemory.IncomeTypeRepositoryImpl();
    }
    
    @Override
    public IPaymentMeansRepository paymentMeansRepository() {
        return new eapli.expensemanager.persistence.inmemory.PaymentMeansRepositoryImpl();
    }
    
}
