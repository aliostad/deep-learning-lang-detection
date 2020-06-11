package com.rimi.ctibet.web.dao.daoimpl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.stereotype.Repository;

import com.rimi.ctibet.common.dao.impl.BaseDaoImpl;
import com.rimi.ctibet.domain.Merchant;
import com.rimi.ctibet.domain.MerchantManage;
import com.rimi.ctibet.web.dao.IMerchantManageDao;
@Repository("merchantManageDao")
public class MerchantManageDaoImpl extends BaseDaoImpl<MerchantManage> implements IMerchantManageDao{

	@Override
	public List<MerchantManage> getMerchantManage() {
		final String sql = "from MerchantManage mm where mm.available = 1 ";
		List<MerchantManage> merchantManageList = new ArrayList<MerchantManage>(); 
		merchantManageList = getHibernateTemplate().execute(
					new HibernateCallback<List<MerchantManage>>() {
						@Override
						public List<MerchantManage> doInHibernate(org.hibernate.Session arg0)
								throws HibernateException, SQLException {
							Query query = arg0.createQuery(sql);
							if(query.list().size()>=1)
							  return (List<MerchantManage>) query.list();
							else 
							  return null;	
						}
					});
		return merchantManageList;
	}

	@Override
	public void saveMerchantManage(MerchantManage mm) {
		 save(mm);
	}

	@Override
	public void clearOldMerchantManage() {
		 List<MerchantManage> oldMms = getMerchantManage();
	     if(oldMms!=null&&oldMms.size()>=1){
		  for (MerchantManage merchantManage : oldMms) {
			delete(merchantManage);
		  }
		}
	}
}
