package io.mark4carter;

import org.springframework.beans.factory.annotation.Autowired;

public class EntryFacade {
  
  private final CustomerRepository customerRepository;
  private final TechnicianRepository technicianRepository;
  private final InvoiceRepository invoiceRepository;
  
  
  public static void assignTechnician(Customer customer) {
    
  }
  
  @Autowired
  public EntryFacade(CustomerRepository customerRepository,
      TechnicianRepository technicianRepository,
      InvoiceRepository invoiceRepository) {
    this.customerRepository = customerRepository;
    this.invoiceRepository = invoiceRepository;
    this.technicianRepository = technicianRepository;
  }

}
