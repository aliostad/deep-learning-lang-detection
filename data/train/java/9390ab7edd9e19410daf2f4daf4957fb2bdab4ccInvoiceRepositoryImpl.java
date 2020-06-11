package com.globallogic.poc.push_server.dao;

import com.globallogic.poc.push_server.entity.Invoice;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Created by arkadii.tetelman on 3/19/14.
 */
public class InvoiceRepositoryImpl{

    @Autowired
    private InvoiceRepository invoiceRepository;

    public InvoiceRepositoryImpl(InvoiceRepository invoiceRepository) {
        this.invoiceRepository = invoiceRepository;
    }

    public InvoiceRepository getInvoiceRepository() {
        return invoiceRepository;
    }

    public void setInvoiceRepository(InvoiceRepository invoiceRepository) {
        this.invoiceRepository = invoiceRepository;
    }


}
