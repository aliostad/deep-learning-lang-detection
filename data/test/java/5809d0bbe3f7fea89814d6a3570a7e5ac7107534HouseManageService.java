package serviceimp;

import java.util.List;

import org.springframework.stereotype.Service;

import service.IHouseManageService;
import Model.HouseManage;
import dao.IHouseManageDao;

import javax.annotation.Resource;

@Service("houseManageService")
public class HouseManageService  implements IHouseManageService{
	
	@Resource(name = "houseManageDAO")
	private IHouseManageDao houseManageDao;
	
	
	
	
	public void addoredit(HouseManage intent){
		houseManageDao.attachDirty(intent);
	}
	public HouseManage edit(int id){
		return houseManageDao.findById(id);
	}
	public List findall(){
		
		return	houseManageDao.findAll();
	}
	public void deletebyid(int id){
		houseManageDao.deletebyid(id);
	}
	
}
