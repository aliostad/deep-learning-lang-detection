package devopsdistilled.operp.server.context.account;

import javax.inject.Inject;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.rmi.RmiServiceExporter;

import devopsdistilled.operp.server.data.service.account.PaidTransactionService;
import devopsdistilled.operp.server.data.service.account.PayableAccountService;
import devopsdistilled.operp.server.data.service.account.ReceivableAccountService;
import devopsdistilled.operp.server.data.service.account.ReceivedTransactionService;

@Configuration
public class AccountRmiContext {

	@Inject
	private PayableAccountService payableAccountService;

	@Inject
	private ReceivableAccountService receivableAccountService;

	@Inject
	private PaidTransactionService paidTransactionService;

	@Inject
	private ReceivedTransactionService receivedTransactionService;

	@Bean
	public RmiServiceExporter rmiPayableAccountServiceExporter() {
		RmiServiceExporter rmiServiceExportor = new RmiServiceExporter();
		rmiServiceExportor.setServiceInterface(PayableAccountService.class);
		String serviceName = rmiServiceExportor.getServiceInterface()
				.getCanonicalName();
		rmiServiceExportor.setServiceName(serviceName);
		rmiServiceExportor.setService(payableAccountService);
		rmiServiceExportor.setRegistryPort(1099);
		return rmiServiceExportor;
	}

	@Bean
	public RmiServiceExporter rmiReceivableAccountServiceExporter() {
		RmiServiceExporter rmiServiceExportor = new RmiServiceExporter();
		rmiServiceExportor.setServiceInterface(ReceivableAccountService.class);
		String serviceName = rmiServiceExportor.getServiceInterface()
				.getCanonicalName();
		rmiServiceExportor.setServiceName(serviceName);
		rmiServiceExportor.setService(receivableAccountService);
		rmiServiceExportor.setRegistryPort(1099);
		return rmiServiceExportor;
	}

	@Bean
	public RmiServiceExporter rmiPaidTransactionServiceExporter() {
		RmiServiceExporter rmiServiceExportor = new RmiServiceExporter();
		rmiServiceExportor.setServiceInterface(PaidTransactionService.class);
		String serviceName = rmiServiceExportor.getServiceInterface()
				.getCanonicalName();
		rmiServiceExportor.setServiceName(serviceName);
		rmiServiceExportor.setService(paidTransactionService);
		rmiServiceExportor.setRegistryPort(1099);
		return rmiServiceExportor;
	}

	@Bean
	public RmiServiceExporter rmiReceivedTransactionServiceExporter() {
		RmiServiceExporter rmiServiceExportor = new RmiServiceExporter();
		rmiServiceExportor
				.setServiceInterface(ReceivedTransactionService.class);
		String serviceName = rmiServiceExportor.getServiceInterface()
				.getCanonicalName();
		rmiServiceExportor.setServiceName(serviceName);
		rmiServiceExportor.setService(receivedTransactionService);
		rmiServiceExportor.setRegistryPort(1099);
		return rmiServiceExportor;
	}
}
