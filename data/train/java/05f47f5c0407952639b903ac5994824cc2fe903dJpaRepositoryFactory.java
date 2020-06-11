/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package eapli.expensemanager.persistence.jpa;

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
 * a concrete factory - hibernate
 *
 * @author Paulo Gandra Sousa
 */
public class JpaRepositoryFactory implements RepositoryFactory {

    @Override
    public ExpenseRepository expenseRepository() {
        return new eapli.expensemanager.persistence.jpa.ExpenseRepositoryImpl();
    }

    @Override
    public ExpenseTypeRepository expenseTypeRepository() {
        return new eapli.expensemanager.persistence.jpa.ExpenseTypeRepositoryImpl();
    }

    @Override
    public IncomeRepository incomeRepository() {
        return new eapli.expensemanager.persistence.jpa.IncomeRepositoryImpl();
    }

    @Override
    public IncomeTypeRepository incomeTypeRepository() {
        return new eapli.expensemanager.persistence.jpa.IncomeTypeRepositoryImpl();
    }

    @Override
    public CheckingAccountRepository checkingAccountRepository() {
        return new eapli.expensemanager.persistence.jpa.CheckingAccountRepositoryImpl();
    }

    @Override
    public SavingPlanRepository savingPlanRepository() {
        return new eapli.expensemanager.persistence.jpa.SavingPlanRepositoryImpl();
    }

    @Override
    public PaymentMeanRepository paymentMeanRepository() {
        return new eapli.expensemanager.persistence.jpa.PaymentMeanRepositoryImpl();
    }

      @Override
      public AlertLimitRepository alertLimitRepository() {
            return new eapli.expensemanager.persistence.jpa.AlertLimitRepositoryImpl();
      }
}
