package com.goodsquick.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.goodsquick.model.GoodsOrdinaryHouse;
import com.goodsquick.model.GoodsRepository;
import com.goodsquick.model.GoodsRepositoryUser;

public interface RepositoryService {

	public List<GoodsRepository> saveOrUpdateRepository(HttpServletRequest request, GoodsRepository goodsRepository) throws Exception;
	public List<GoodsRepository> getRepositoryByLoginName(String loginName) throws Exception;
	public List<GoodsRepository> getRepositoryByLoginNameAndType(String loginName,String type, boolean excludeSelf) throws Exception;
	public GoodsRepository getRepositoryByCode(String repositoryCode) throws Exception;
	public void updateRepositoryUser(GoodsRepositoryUser repositoryUser) throws Exception;
	public void removeRepository(GoodsRepository goodsRepositoryFromPage) throws Exception;
	
	public List<GoodsRepositoryUser> getRepositoryUserByRepositoryCode(String repositoryCode, String currentUser) throws Exception;
	public List<GoodsRepositoryUser> getRepositoryUserByUserId(String repositoryCode, String userId) throws Exception;
	
	public void saveRepositoryUser(GoodsRepositoryUser repositoryUser) throws Exception;
	public void removeRepositoryUser(GoodsRepositoryUser repositoryUser) throws Exception;
	
	public List<GoodsOrdinaryHouse> getRepositoryAssetByLoginNameAndType(String loginName,String type, boolean excludeSelf) throws Exception;
	public List<GoodsRepository> getRepositoryByName(String repositoryName) throws Exception;
}
