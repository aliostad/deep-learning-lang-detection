package com.onedatapoint.config;

import com.onedatapoint.repo.*;

public class Config {

	private static Config instance = null;
	private QuestionRepository questionRepository = null;
	private MedicationRepository medicationRepository = null;
	private ResponseRepository responseRepository = null;
	

	/**
	 * Use Config.getInstance()
	 */
	private Config() {
		questionRepository = new QuestionRepositoryImpl();
		responseRepository = new ResponseRepositoryImpl();
		medicationRepository = new MedicationRepositoryImpl();
	} 
	
	public static Config getInstance() {
		if (Config.instance == null) {
			Config.instance = new Config();
		}
		return Config.instance;
	}
	
	public QuestionRepository getQuestionRepository() {
		return questionRepository;
	}
	
	public ResponseRepository getResponseRepository() {
		return responseRepository;
	}
	
	public MedicationRepository getMedicationRepository() {
		return medicationRepository;
	}
	
}
