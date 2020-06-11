package com.flywet.platform.bi.core.model;

import org.apache.commons.pool.PoolableObjectFactory;
import org.apache.log4j.Logger;
import org.pentaho.di.core.database.DatabaseMeta;
import org.pentaho.di.core.plugins.PluginRegistry;
import org.pentaho.di.core.plugins.RepositoryPluginType;
import org.pentaho.di.repository.Repository;
import org.pentaho.di.repository.RepositoryMeta;
import org.pentaho.di.repository.kdr.KettleDatabaseRepository;


public class RepositoryFactory implements PoolableObjectFactory {
	private final Logger logger = Logger.getLogger(RepositoryFactory.class);
	
	private RepositoryMeta repositoryMeta;

	public RepositoryFactory(RepositoryMeta repositoryMeta) {
		this.repositoryMeta = repositoryMeta;
	}
	
	/**
	 * 产生一个新资源库对象对象
	 */
	@Override
	public Object makeObject() throws Exception {
		logger.info("创建Repository对象");
		Repository rep = PluginRegistry.getInstance().loadClass(
				RepositoryPluginType.class, repositoryMeta,
				Repository.class);
		rep.init(repositoryMeta);
		rep.connect();
		return rep;
	}

	/**
	 * 还原对象状态
	 */
	@Override
	public void passivateObject(Object obj) {
		Repository rep = (Repository) obj;
		rep.clearSharedObjectCache();
//		rep.clearUserInfo();
	}

	@Override
	public void activateObject(Object obj) throws Exception {
	}

	@Override
	public void destroyObject(Object obj) throws Exception {
		logger.info("销毁无效Repository对象");
		if (obj == null) {
			return;
		}
		
		Repository repository = (Repository) obj;
		repository.clearSharedObjectCache();
		repository.clearUserInfo();
		repository.disconnect();
		repository = null;
	}

	@Override
	public boolean validateObject(Object obj) {
		if (obj == null) {
			return false;
		}
		
		KettleDatabaseRepository repository = (KettleDatabaseRepository) obj;
		try {
			DatabaseMeta meta = repository.getDatabaseMeta();
			String connSql = meta.getConnectSQL();
			repository.getDatabase().execStatement(connSql);
		} catch (Exception e) {
			logger.error("Repository状态验证未通过");
			return false;
		}
		
		return true;
	}
}

