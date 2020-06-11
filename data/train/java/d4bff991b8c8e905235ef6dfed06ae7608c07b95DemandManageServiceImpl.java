package edu.zju.cims201.GOF.service.demand;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import edu.zju.cims201.GOF.dao.demand.DemandManageDao;
import edu.zju.cims201.GOF.dao.demand.DemandValueDao;
import edu.zju.cims201.GOF.hibernate.pojoA.DemandManage;

@Service
@Transactional
public class DemandManageServiceImpl implements DemandManageService {
	private DemandManageDao demandManageDao;
	private DemandValueDao demandValueDao;

	public String addDemand(String demandName, String demandMemo){
		DemandManage dmExist =demandManageDao.findUniqueBy("demandName", demandName);
		if(dmExist != null){
			return "需求名已存在，请重新添加";
		}
		DemandManage dm =new DemandManage();
		dm.setDemandMemo(demandMemo);
		dm.setDemandName(demandName);
		
		demandManageDao.save(dm);
		return "添加成功！";
	}
	/**
	 * 未完善
	 * 还要考虑是否有order引用该demand
	 */
	
	public String deleteDemand(long id){
		demandValueDao.batchExecute("delete from DemandValue dv where dv.demandManage.id=?", id);
		demandManageDao.delete(id);
		return "删除成功！";
	}
	
	
	public String updateDemand(long id, String demandName, String demandMemo){
		List<DemandManage> dmList = demandManageDao.find("from DemandManage dm where id <> ? and demandName = ? ",id,demandName);
		if(dmList.size()!=0){
			return "需求名已存在，请重新修改";
		}
		DemandManage dm =demandManageDao.get(id);
		dm.setDemandMemo(demandMemo);
		dm.setDemandName(demandName);
		
		return "修改成功！";
	}
	
	
	public List<DemandManage> getAll(){
		List<DemandManage> list =demandManageDao.getAll();
		return list;
	}
	
	
	public DemandManageDao getDemandManageDao() {
		return demandManageDao;
	}
	@Autowired
	public void setDemandManageDao(DemandManageDao demandManageDao) {
		this.demandManageDao = demandManageDao;
	}
	
	public DemandValueDao getDemandValueDao() {
		return demandValueDao;
	}
	
	@Autowired
	public void setDemandValueDao(DemandValueDao demandValueDao) {
		this.demandValueDao = demandValueDao;
	}
	
}
