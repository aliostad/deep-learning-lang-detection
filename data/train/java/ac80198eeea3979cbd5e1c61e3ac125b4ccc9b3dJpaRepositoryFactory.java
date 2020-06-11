package eapli.expensemanager.persistence;

public class JpaRepositoryFactory implements IRepositoryFactory {

    @Override
    public IExpenseRepository expenseRepository() {
        return new eapli.expensemanager.persistence.jpa.ExpenseRepositoryImpl();
    }

    @Override
    public IExpenseTypeRepository expenseTypeRepository() {
        return new eapli.expensemanager.persistence.jpa.ExpenseTypeRepositoryImpl();
    }
    
    @Override
    public IIncomeRepository incomeRepository() {
        return new eapli.expensemanager.persistence.jpa.IncomeRepositoryImpl();
    }

    @Override
    public IIncomeTypeRepository incomeTypeRepository() {
        return new eapli.expensemanager.persistence.jpa.IncomeTypeRepositoryImpl();
    }
    
    @Override
    public IPaymentMeansRepository paymentMeansRepository() {
        return new eapli.expensemanager.persistence.jpa.PaymentMeansRepositoryImpl();
    }
}
