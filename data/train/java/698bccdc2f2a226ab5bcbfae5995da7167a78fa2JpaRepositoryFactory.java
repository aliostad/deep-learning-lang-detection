/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Persistence;


import Persistence.Jpa.IncomeTypeJpaRepository;
import Persistence.Inmemory.ExpenseTypeRepository;
import Persistence.Jpa.ExpenseJpaRepository;
import Persistence.Jpa.IncomeJpaRepository;
import Persistence.Jpa.IncomeTypeJpaRepository;
import Persistence.Inmemory.ExpenseTypeRepository;
import Persistence.Jpa.ExpenseJpaRepository;
import Persistence.Jpa.ExpenseTypeJpaRepository;
import Persistence.Jpa.PaymentMeansJpaRepository;

/**
 *
 * @author Ricardo Rocha
 */
public class JpaRepositoryFactory implements IRepositoryFactory{

    @Override
    public IExpenseRepository getExpenseRepository() {
           return new ExpenseJpaRepository();
    }

    @Override
    public IExpenseTypeRepository getExpenseTypeRepository() {
        return new ExpenseTypeJpaRepository();
    }

    @Override
    public IPaymentMeansRepository getPaymentMeansRepository() {
        return new PaymentMeansJpaRepository();
    }

    @Override
    public IIncomeTypeRepository getIncomeTypeRepository() {
        return new IncomeTypeJpaRepository();
    }

    @Override
    public IIncomeRepository getIncomeRepository() {
        return new IncomeJpaRepository();
    }
}
    
