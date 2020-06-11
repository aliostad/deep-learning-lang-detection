package serviceimp;

import java.util.List;

import org.springframework.stereotype.Service;

import service.IForeignManageService;
import Model.ForeignManage;
import dao.IForeignManageDao;

import javax.annotation.Resource;

@Service("foreignManageService")
public class ForeignManageService  implements IForeignManageService{
	
	@Resource(name = "foreignManageDAO")
	private IForeignManageDao foreignManageDao;
	
	
	
	
	public void addoredit(ForeignManage intent){
		foreignManageDao.attachDirty(intent);
	}
	public ForeignManage edit(int id){
		return foreignManageDao.findById(id);
	}
	public List findall(){
		
		return	foreignManageDao.findAll();
	}
	public void deletebyid(int id){
		foreignManageDao.deletebyid(id);
	}
	
}
