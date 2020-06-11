package com.insigma.dao.impl;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import com.insigma.dao.PurviewManageDao;
import com.insigma.db.BaseDao;
import com.insigma.pojo.PurviewManage;

public class PurviewManageDaoImpl extends BaseDao implements PurviewManageDao{
	public boolean addPurviewManage(PurviewManage purviewManage){
		String sql="insert into purviewmanage(PurviewID,EmployeManage,OrderManage,SortManage,DishManage) values('"
		+purviewManage.getPurviewId()+"','"+purviewManage.getEmployeManage()+"','"+purviewManage.getOrderManage()+"','"
		+purviewManage.getSortManage()+"','"+purviewManage.getDishManage()+"');";
		//System.out.println(sql);
		return super.executeUpdate(sql);
	}
	public boolean removePurviewManageById(int id){
		String sql="delete from purviewmanage where id = "+id+"";
		return super.executeUpdate(sql);
	}
	public boolean modifyPurviewManageById(PurviewManage purviewManage){
		String sql="update purviewmanage set PurviewID=\""+purviewManage.getPurviewId()+"\"," +
		" EmployeManage=\""+purviewManage.getEmployeManage()+"\" ,OrderManage="+purviewManage.getOrderManage()+" ,SortManage=\""+purviewManage.getSortManage()+"" +
		"\", DishManage=\""+purviewManage.getDishManage()+"\" where id="+purviewManage.getId()+"";
		System.out.println(sql);
		return super.executeUpdate(sql);
	}
	public List<PurviewManage> queryPurviewManageAll(){
		String sql="select * from purviewmanage";
		List<PurviewManage> purviewManages=new ArrayList<PurviewManage>();
		List<HashMap<String, Object>> list=super.executeQuery(sql);
		if(list!=null&&list.size()>0){
			for (HashMap<String, Object> hashMap:list) {
				PurviewManage purviewManage=new PurviewManage((Integer)hashMap.get("id"),(Integer)hashMap.get("PurviewID"),
						(Integer)hashMap.get("EmployeManage"),(Integer)hashMap.get("OrderManage"),
						(Integer)hashMap.get("SortManage"),(Integer)hashMap.get("DishManage"));
				purviewManages.add(purviewManage);
			}
		}
		return purviewManages;
	}
	public PurviewManage queryPurviewManageById(int id){
		String sql="select * from purviewmanage where id="+id+"";
		PurviewManage purviewManage =null;
		List<HashMap<String, Object>> list=super.executeQuery(sql);
		if(list!=null&&list.size()==1){
			HashMap<String,Object> map =list.get(0);
			purviewManage=new PurviewManage((Integer)map.get("id"),(Integer)map.get("PurviewID"),
					(Integer)map.get("EmployeManage"),(Integer)map.get("OrderManage"),
					(Integer)map.get("SortManage"),(Integer)map.get("DishManage"));
		}
		return purviewManage;
	}
}
