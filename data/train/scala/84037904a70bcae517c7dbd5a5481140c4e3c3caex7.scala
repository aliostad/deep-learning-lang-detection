import net.namin.sav.annotation.verify
import net.namin.sav.lib._

object ex7 {
  @verify
  class BankAccount {
    var balance = 0

    @verify
    def withdraw(amount: Int) {
      precondition(amount >= 0 && balance >= amount)
      val old_balance = old(balance)
      balance -= amount
      postcondition(balance == old_balance - amount && balance >= 0)
    }

    @verify
    def deposit(amount: Int) {
      precondition(amount >= 0 && balance >= 0)
      val old_balance = old(balance)
      balance += amount
      postcondition(balance == old_balance + amount && balance >= 0)
    }
  }

  @verify
  class DoubleBankAccount {
    val savings = new BankAccount
    val checking = new BankAccount

    @verify
    def transfer(amount: Int) {
      precondition(amount >= 0 && savings.balance >= amount && checking.balance >= 0)
      val old_savings_balance = old(savings.balance)
      val old_checking_balance = old(checking.balance)

      assert(amount >= 0 && savings.balance >= amount && checking.balance >= 0 && savings.balance == old_savings_balance && checking.balance == old_checking_balance)
      savings.withdraw(amount)
      assert(amount >= 0 && savings.balance >= 0 && checking.balance >= 0 && savings.balance == old_savings_balance - amount && checking.balance == old_checking_balance)
      checking.deposit(amount)

      postcondition(savings.balance + checking.balance == old_savings_balance + old_checking_balance && savings.balance >= 0 && checking.balance >= 0)
    }
  }

}
