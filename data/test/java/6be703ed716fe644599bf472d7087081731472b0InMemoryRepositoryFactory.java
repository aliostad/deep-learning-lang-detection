/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package eapli.expensemanager.persistence.inmemory;

import eapli.expensemanager.persistence.AlertLimitRepository;
import eapli.expensemanager.persistence.CheckingAccountRepository;
import eapli.expensemanager.persistence.ExpenseRepository;
import eapli.expensemanager.persistence.ExpenseTypeRepository;
import eapli.expensemanager.persistence.IncomeRepository;
import eapli.expensemanager.persistence.IncomeTypeRepository;
import eapli.expensemanager.persistence.PaymentMeanRepository;
import eapli.expensemanager.persistence.RepositoryFactory;
import eapli.expensemanager.persistence.SavingPlanRepository;

/**
 * a concrete factory - in memory
 *
 * @author Paulo Gandra Sousa
 */
public class InMemoryRepositoryFactory implements RepositoryFactory {

    @Override
    public ExpenseRepository expenseRepository() {
        return new eapli.expensemanager.persistence.inmemory.ExpenseRepositoryImpl();
    }

    @Override
    public SavingPlanRepository savingPlanRepository() {
        return new eapli.expensemanager.persistence.inmemory.SavingPlanRepositoryImpl();
    }

    @Override
    public ExpenseTypeRepository expenseTypeRepository() {
        return new eapli.expensemanager.persistence.inmemory.ExpenseTypeRepositoryImpl();
    }

    @Override
    public IncomeRepository incomeRepository() {
        return new eapli.expensemanager.persistence.inmemory.IncomeRepositoryImpl();
    }

    @Override
    public IncomeTypeRepository incomeTypeRepository() {
        return new eapli.expensemanager.persistence.inmemory.IncomeTypeRepositoryImpl();
    }

    @Override
    public CheckingAccountRepository checkingAccountRepository() {
        return new eapli.expensemanager.persistence.inmemory.CheckingAccountRepositoryImpl();
    }

    @Override
    public PaymentMeanRepository paymentMeanRepository() {
        return new eapli.expensemanager.persistence.inmemory.PaymentMeanRepositoryImpl();
    }

    @Override
    public AlertLimitRepository alertLimitRepository() {
        return new eapli.expensemanager.persistence.inmemory.AlertLimitRepositoryImpl();
    }
}
