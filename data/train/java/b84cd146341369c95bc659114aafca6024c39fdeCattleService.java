package com.skan.potal.web.potal.cattle.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skan.potal.web.potal.cattle.repository.CattleBuyInfoRepository;
import com.skan.potal.web.potal.cattle.repository.CattleCalfRecodeRepository;
import com.skan.potal.web.potal.cattle.repository.CattleChildbirthRecodeRepository;
import com.skan.potal.web.potal.cattle.repository.CattleCureInfoRepository;
import com.skan.potal.web.potal.cattle.repository.CattleRegisterRepository;
import com.skan.potal.web.potal.cattle.repository.CattleSellStoreInfoRepository;

@Service
public class CattleService {
	
	@Autowired CattleRegisterRepository 		cattleRegisterRepository;  
	@Autowired CattleBuyInfoRepository 			cattleBuyInfoRepository; 
	@Autowired CattleCalfRecodeRepository 		cattleCalfRecodeRepository; 
	@Autowired CattleChildbirthRecodeRepository cattleChildbirthRecodeRepository; 
	@Autowired CattleCureInfoRepository 		cattleCureInfoRepository; 
	@Autowired CattleSellStoreInfoRepository 	cattleSellStoreInfoRepository;
	
	
	public void cattleSave() throws Exception {
		
		
		
	}
	
	
}
