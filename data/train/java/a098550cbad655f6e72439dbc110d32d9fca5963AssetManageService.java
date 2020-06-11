package cn.uuf.ltxxt.asset.service;

import java.util.List;

import cn.uuf.domain.asset.AssetManage;


public interface AssetManageService {
	public void save(AssetManage m);

	public void update(AssetManage m);

	public void delete(Long... id);

	public AssetManage getById(Long id);
	public Long getCount(AssetManage m);

	public List<AssetManage> queryList(AssetManage a, int s, int size);

	public List<AssetManage> find();

	public List<AssetManage> getAll();

	public String fmtLong(Long val, int size);
	
	public List queryBySql(String sql)throws Exception;

	public void updateHQL(String sql);
	public List<AssetManage> findByCriteria(AssetManage am)throws Exception;
}
