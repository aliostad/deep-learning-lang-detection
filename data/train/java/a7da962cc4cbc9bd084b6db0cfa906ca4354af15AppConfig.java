package ex2;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

	@Bean
	public CustomerService customerService() {
		return new CustomerServiceImpl();
	}
	
	@Bean
	public BillPaymentService billPaymentService() {
		return new BillPaymentServiceImpl();
	}
	
	@Bean
	public BankService bankService() {
		BankServiceImpl bankService = new BankServiceImpl();
		bankService.setBillPaymentService(billPaymentService());
		bankService.setCustomerService(customerService());
		return bankService;
	}
}
