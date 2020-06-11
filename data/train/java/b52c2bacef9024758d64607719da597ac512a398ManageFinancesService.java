package com.miteno.myAccount.manageFinances.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Service;

import com.miteno.common.dao.hibernate.HibernateDao;
import com.miteno.myAccount.manageFinances.entity.ManageFinances;
import com.miteno.myAccount.manageFinances.form.ManageFinancesForm;

@Service("manageFinancesService")
public class ManageFinancesService {

	@Resource
	private HibernateDao<ManageFinances,String> manageFinancesDao;
	
	public ManageFinancesForm search(ManageFinancesForm manageFinancesForm) {
		DetachedCriteria detachedCriteria = DetachedCriteria
				.forClass(ManageFinances.class);
		String name= manageFinancesForm.getName();
		String startDate = manageFinancesForm.getStart_date();
		String endDate = manageFinancesForm.getEnd_date();
		
		if (StringUtils.isNotEmpty(name)) {
			detachedCriteria.add(Restrictions.like("name", name,MatchMode.ANYWHERE));
		}
		if (StringUtils.isNotEmpty(startDate)) {
			detachedCriteria.add(Restrictions.ge("record_date", startDate));
		}
		if (StringUtils.isNotEmpty(endDate)) {
			detachedCriteria.add(Restrictions.le("record_date", endDate));
		}
		manageFinancesDao.findPageByDetachedCriteria(detachedCriteria,manageFinancesForm);
		return manageFinancesForm;
	}
	
	public void save(ManageFinances manageFinances){
		manageFinances.setRecord_date(new SimpleDateFormat("yyyyMMdd").format(new Date()));
		manageFinancesDao.save(manageFinances);
	}
	public void update(ManageFinances manageFinances){
		manageFinances.setRecord_date(new SimpleDateFormat("yyyyMMdd").format(new Date()));
		manageFinancesDao.merge(manageFinances);
	}
	public void delete(String id){
		manageFinancesDao.delete(ManageFinances.class, id);
	}
	public ManageFinances queryById(String id){
		return manageFinancesDao.get(ManageFinances.class, id);
	}
	/**
	 * //所有理财账户的总额
	 */
	public double record(){
		List <ManageFinances> manageFinancesList = manageFinancesDao.findAllByCriteria(ManageFinances.class);
		double total = 0;
		for(int i=0;i<manageFinancesList.size();i++){
			total = total + manageFinancesList.get(i).getMoney();
		}
		return total;
	}
	
	public boolean existsName(String name){
		if(manageFinancesDao.findAllByCriteria(ManageFinances.class, Restrictions.eq("name", name)).size()>0){
			return true;
		}
		return false;
	}
}
