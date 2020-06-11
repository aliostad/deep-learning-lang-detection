package com.renren.dp.xlog.storage;

import com.renren.dp.xlog.config.Configuration;
import com.renren.dp.xlog.storage.impl.ComplexStorageRepository;
import com.renren.dp.xlog.storage.impl.DefaultStorageRepository;
import com.renren.dp.xlog.storage.impl.FileStorageRepository;

public class StorageRepositoryFactory {

	private static StorageRepository storageRepository=null;
	
	public static StorageRepository getInstance(){
		if(storageRepository==null){
			String storageRepositoryMode=Configuration.getString("storage.repository.mode");
			if(storageRepositoryMode==null || "0".equals(storageRepositoryMode)){
					storageRepository=new DefaultStorageRepository();
			}else if("1".equals(storageRepositoryMode)){
				storageRepository=new FileStorageRepository();
			}else if("2".equals(storageRepositoryMode)){
				storageRepository=new ComplexStorageRepository(new DefaultStorageRepository(),new FileStorageRepository());
			}
		}
		
		return storageRepository;
	}
}
