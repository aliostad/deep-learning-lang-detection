/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.mycompany.CRMFly.hibernateAccess;

import com.mycompany.CRMFly.entities.Contracts;
import com.mycompany.CRMFly.entities.Payments;
import com.mycompany.CRMFly.entities.Requests;
import com.mycompany.CRMFly.entities.SalesProcess;
import com.mycompany.CRMFly.entities.Shipments;
import java.util.List;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 *
 * @author Александр
 */
@Repository
public class ProcessDAOImpl implements ProcessDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    
    
     @Override
     public void addProcess(SalesProcess process) {
        sessionFactory.getCurrentSession().save(process);
     }
    
    @Override
    public List<SalesProcess> getAllProcesses() {
      return sessionFactory.getCurrentSession().
                 createCriteria(SalesProcess.class).list();   
      }
    
    @Override
     public List<SalesProcess> listProcesses() {

        return sessionFactory.getCurrentSession().createQuery("from com.mycompany.CRMFly.entities.Processs")
            .list();
    }
     
     
       @Override
     public void removeProcess(SalesProcess process) {
        if (null != process) {
            sessionFactory.getCurrentSession().delete(process);
        }
     }
        
     @Override
     public void changeProcess (SalesProcess process) {
         sessionFactory.getCurrentSession().update(process);
     }
     
     
     @Override
     public SalesProcess getProcessForId (Long id) {
      //   return (Contracts) sessionFactory.getCurrentSession().
     //            load(Contracts.class, id);
         return (SalesProcess) sessionFactory.getCurrentSession().
                 get(SalesProcess.class, id);
     }
     
      @Override
     public List<Payments> getProcessPayments (Long id) {
         org.hibernate.Session sess =  sessionFactory.getCurrentSession();
        sess.enableFetchProfile("process-with-payments");
         SalesProcess process = (SalesProcess) sess.
                 get(SalesProcess.class, id);
        return process.getPayments();
     }
     
     @Override
     public List<Shipments> getProcessShipments (Long id) {
         org.hibernate.Session sess =  sessionFactory.getCurrentSession();
        sess.enableFetchProfile("process-with-shipments");
         SalesProcess process = (SalesProcess) sess.
                 get(SalesProcess.class, id);
        return process.getShipments();
     }
     
     @Override
     public void addContractConnection (SalesProcess process, Contracts contract)
     {
         org.hibernate.Session sess =  sessionFactory.getCurrentSession();
        sess.enableFetchProfile("process-with-contract");
        contract.setProcess(process);
        sess.update(contract);
        process.setContract(contract);
        sess.update(process);
     }
     
     @Override
     public void addRequestConnection (SalesProcess process, Requests request)
     {
         org.hibernate.Session sess =  sessionFactory.getCurrentSession();
        sess.enableFetchProfile("process-with-request");
        request.setProcess(process);
        sess.update(request);
        process.setOffer(request);
        sess.update(process);
     }
     
     @Override
     public void addPaymentConnection (SalesProcess process, Payments payment)
     {
         org.hibernate.Session sess =  sessionFactory.getCurrentSession();
        sess.enableFetchProfile("process-with-contract");
        payment.setContractOnPayment(process.getContract());
        sess.update(payment);
        sess.enableFetchProfile("process-with-payments");
        process=(SalesProcess) sess.
                 get(SalesProcess.class, process.getId());
        process.getPayments().add(payment);
        sess.update(process);
     }
     
     
     @Override
     public void addShipmentConnection (SalesProcess process, Shipments shipment)
     {
         org.hibernate.Session sess =  sessionFactory.getCurrentSession();
        sess.enableFetchProfile("process-with-contract");
        shipment.setContract(process.getContract());
        sess.update(shipment);
        sess.enableFetchProfile("process-with-shipments");
        process=(SalesProcess) sess.
                 get(SalesProcess.class, process.getId());
        process.getShipments().add(shipment);
        sess.update(process);
     }
     
     @Override
     public Requests getProcessRequest (Long id)
     {
         org.hibernate.Session sess =  sessionFactory.getCurrentSession();
        sess.enableFetchProfile("process-with-request");
         SalesProcess process = (SalesProcess) sess.
                 get(SalesProcess.class, id);
        return process.getOffer();
     }
     
     @Override
     public Contracts getProcessContract (Long id)
     {
         org.hibernate.Session sess =  sessionFactory.getCurrentSession();
        sess.enableFetchProfile("process-with-contract");
         SalesProcess process = (SalesProcess) sess.
                 get(SalesProcess.class, id);
        return process.getContract();
     }

    
    
    
}
