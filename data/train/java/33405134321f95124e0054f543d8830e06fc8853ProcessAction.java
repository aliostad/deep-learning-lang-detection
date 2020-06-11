/*
 * @(#)ProcessAction.java 2015-4-4 下午02:45:11 erp-manufacture
 */
package com.erp.action;

import java.util.Date;
import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.erp.model.Process;
import com.erp.model.ProcessDetail;
import com.erp.model.Product;

/**
 * ProcessAction
 * @author wang
 * @version 1.0
 *
 */
@Component("processAction")
@Scope("prototype")
public class ProcessAction extends BaseAction {
    private Process process;

    private List<Process> processList;

    private ProcessDetail processDetail;

    private List<ProcessDetail> processDetailList;

    private Product product;

    private List<Product> productList;

    public String listProcess() {
        processList = processService.list();
        productList = productService.list();
        return SUCCESS;
    }

    public String saveProcess() {
        process.setDate(new Date());
        process.setUser(loginUser);
        processService.saveOrUpdate(process);
        msg = "success";
        return SUCCESS;
    }

    public String destoryProcess() {
        process = processService.getEntityById(process.getId());
        for (ProcessDetail pd : process.getProcessDetailList()) {
            processDetailService.delete(pd);
        }
        processService.delete(process);
        return SUCCESS;
    }

    public String listProcessDetail() {
        process = processService.getEntityById(process.getId());
        processDetailList = process.getProcessDetailList();
        return SUCCESS;
    }

    public String saveProcessDetail() {
        processDetailService.saveOrUpdate(processDetail);
        msg = "success";
        return SUCCESS;
    }

    public String destoryProcessDetail() {
        processDetailService.delete(processDetail);
        return SUCCESS;
    }

    /**
     * 返回  process
     * @return process
     */
    public Process getProcess() {
        return process;
    }

    /**
     * 设置 process
     * @param process process
     */
    public void setProcess(Process process) {
        this.process = process;
    }

    /**
     * 返回  processList
     * @return processList
     */
    public List<Process> getProcessList() {
        return processList;
    }

    /**
     * 设置 processList
     * @param processList processList
     */
    public void setProcessList(List<Process> processList) {
        this.processList = processList;
    }

    /**
     * 返回  processDetail
     * @return processDetail
     */
    public ProcessDetail getProcessDetail() {
        return processDetail;
    }

    /**
     * 设置 processDetail
     * @param processDetail processDetail
     */
    public void setProcessDetail(ProcessDetail processDetail) {
        this.processDetail = processDetail;
    }

    /**
     * 返回  processDetailList
     * @return processDetailList
     */
    public List<ProcessDetail> getProcessDetailList() {
        return processDetailList;
    }

    /**
     * 设置 processDetailList
     * @param processDetailList processDetailList
     */
    public void setProcessDetailList(List<ProcessDetail> processDetailList) {
        this.processDetailList = processDetailList;
    }

    /**
     * 返回  product
     * @return product
     */
    public Product getProduct() {
        return product;
    }

    /**
     * 设置 product
     * @param product product
     */
    public void setProduct(Product product) {
        this.product = product;
    }

    /**
     * 返回  productList
     * @return productList
     */
    public List<Product> getProductList() {
        return productList;
    }

    /**
     * 设置 productList
     * @param productList productList
     */
    public void setProductList(List<Product> productList) {
        this.productList = productList;
    }

}
