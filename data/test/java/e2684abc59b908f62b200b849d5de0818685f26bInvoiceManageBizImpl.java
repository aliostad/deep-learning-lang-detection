package com.jonda.erp.wedding.biz.manage.impl;

import com.jonda.erp.wedding.biz.manage.InvoiceManageBiz;
import com.jonda.erp.wedding.domain.wedding.order.Invoice;
import com.jonda.erp.wedding.service.InvoiceManageService;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * Created by rejoady on 2014/10/5.
 */
@Component("invoiceManageBiz")
public class InvoiceManageBizImpl implements InvoiceManageBiz {

    @Resource
    private InvoiceManageService invoiceManageService;

    @Override
    public void createInvoice(Invoice invoice) {
        invoiceManageService.createInvoice(invoice);
    }

    @Override
    public void deleteInvoice(Invoice invoice) {
        invoiceManageService.deleteInvoice(invoice);
    }

}
