package com.youthor.bsp.core.demo.dao.impl;

import org.hibernate.Session;

import com.youthor.bsp.core.abdf.common.base.BaseDAOHibernate;
import com.youthor.bsp.core.demo.dao.ISimpleProcessDemoDAO;
import com.youthor.bsp.core.demo.model.SimpleProcessDemo;
import com.youthor.bsp.core.demo.model.SimpleProcessDemo1;
import com.youthor.bsp.core.demo.model.SimpleProcessDemo2;


public class SimpleProcessDemoDAOImpl extends BaseDAOHibernate implements  ISimpleProcessDemoDAO{

    protected Class getModelClass() {
        // TODO Auto-generated method stub
        return SimpleProcessDemo.class;
    }

    public String updateSimpleProcessDemo(SimpleProcessDemo simpleProcessDemo) {
        this.doUpdateObject(simpleProcessDemo);
        return simpleProcessDemo.getSimpleId();
    }

    public String addSimpleProcessDemo(SimpleProcessDemo simpleProcessDemo) {
        this.doCreateObject(simpleProcessDemo);
        return simpleProcessDemo.getSimpleId();
    }

    public SimpleProcessDemo getSimpleProcessDemoById(String id) {
        // TODO Auto-generated method stub
        return (SimpleProcessDemo)this.doFindObjectById(id);
    }

    @Override
    public SimpleProcessDemo1 getSimpleProcessDemo1ById(String id) {
        Session session = this.getSession();
        return (SimpleProcessDemo1)session.get(SimpleProcessDemo1.class, id);
        
    }

    @Override
    public String addSimpleProcessDemo1(SimpleProcessDemo1 simpleProcessDemo1) {
        this.getSession().save(simpleProcessDemo1);
        return simpleProcessDemo1.getId();
    }

    @Override
    public String updateSimpleProcessDemo1(SimpleProcessDemo1 simpleProcessDemo1) {
        this.getSession().update(simpleProcessDemo1);
        return simpleProcessDemo1.getId();
    }

	@Override
	public String addSimpleProcessDemo2(SimpleProcessDemo2 simpleProcessDemo2) {
		this.getSession().save(simpleProcessDemo2);
        return simpleProcessDemo2.getId();
	}

	@Override
	public SimpleProcessDemo2 getSimpleProcessDemo2ById(String id) {
		Session session = this.getSession();
        return (SimpleProcessDemo2)session.get(SimpleProcessDemo2.class, id);
	}

	@Override
	public String updateSimpleProcessDemo2(SimpleProcessDemo2 simpleProcessDemo2) {
		this.getSession().update(simpleProcessDemo2);
        return simpleProcessDemo2.getId();
	}

	

	

}
