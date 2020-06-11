package com.ipi.test;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.ipi.bean.Service;
import com.ipi.bean.ServiceDtl;
import com.ipi.bean.ServiceDtlPK;

/** @author Saifi Ahmada Jul 12, 2013 11:50:45 AM  **/

public class Test6 {
	
	public static void main(String[] args) {
		
		SessionFactory sf = new Configuration().configure().buildSessionFactory();
		
		Session ses = sf.openSession();
		
		ses.beginTransaction();
		
		String serviceId = "SER/2013/01/0001";
		Service service = new Service(serviceId);
		service.setNopol("DA1234OP");
		service.setServiceNama("SERVICE");
		
		ServiceDtl dtl = new ServiceDtl(new ServiceDtlPK(serviceId, "JOB01"));
		dtl.setHarga(10000);
		dtl.setService(service);
		
		ServiceDtl dtl2 = new ServiceDtl(new ServiceDtlPK(serviceId, "JOB02"));
		dtl2.setHarga(20000);
		dtl2.setService(service);
		
		ServiceDtl dtl3 = new ServiceDtl(new ServiceDtlPK(serviceId, "JOB03"));
		dtl3.setHarga(30000);
		dtl3.setService(service);
		
		ServiceDtl dtl4 = new ServiceDtl(new ServiceDtlPK(serviceId, "JOB04"));
		dtl4.setHarga(40000);
		dtl4.setService(service);
		
		ServiceDtl dtl5 = new ServiceDtl(new ServiceDtlPK(serviceId, "JOB05"));
		dtl5.setHarga(50000);
		dtl5.setService(service);
		
		service.getServiceDtlSet().add(dtl);
		service.getServiceDtlSet().add(dtl2);
		service.getServiceDtlSet().add(dtl3);
		service.getServiceDtlSet().add(dtl4);
		service.getServiceDtlSet().add(dtl5);
		
		ses.save(service);
		
		ses.getTransaction().commit();
		
		ses.close();
	}
	
}

