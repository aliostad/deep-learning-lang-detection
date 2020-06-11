/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Persistence;

import Persistence.Inmemory.IncomeTypeRepository;
import Persistence.Inmemory.IncomeRepository;
import Persistence.Inmemory.PaymentMeansRepository;
import Persistence.Inmemory.ExpenseTypeRepository;
import Persistence.Inmemory.ExpenseRepository;

/**
 *
 * @author Jose Nuno Loureiro
 */
public class InMemoryRepositoryFactory {
    //SINGLETON
    
    private InMemoryRepositoryFactory(){
    }
    
    private static InMemoryRepositoryFactory instance = null;
    
    public static InMemoryRepositoryFactory getInstance(){
        if(instance==null){
            instance = new InMemoryRepositoryFactory();
        }
        
        return instance;
     }
    
    public IExpenseRepository expenseRepository(){
        return new ExpenseRepository();
    }
    
    public IExpenseTypeRepository expenseTypeRepository(){
        return new ExpenseTypeRepository();
    }
    
    public IPaymentMeansRepository paymentMeansRepository(){
        return new PaymentMeansRepository();
    }
    
    public IIncomeRepository incomeRepository(){
        return new IncomeRepository();
    }
    
    public IIncomeTypeRepository incomeTypeRepository(){
        return new IncomeTypeRepository();
    }
    
}
