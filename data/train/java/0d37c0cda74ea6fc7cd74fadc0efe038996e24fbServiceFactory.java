package com.guesswhat.android.service.cfg;

import com.guesswhat.android.service.rs.face.DatabaseService;
import com.guesswhat.android.service.rs.face.ImageService;
import com.guesswhat.android.service.rs.face.QuestionService;
import com.guesswhat.android.service.rs.face.RecordService;
import com.guesswhat.android.service.rs.impl.DatabaseServiceImpl;
import com.guesswhat.android.service.rs.impl.ImageServiceImpl;
import com.guesswhat.android.service.rs.impl.QuestionServiceImpl;
import com.guesswhat.android.service.rs.impl.RecordServiceImpl;

public class ServiceFactory {

    private DatabaseService databaseService = null;
    private ImageService imageService = null;
    private QuestionService questionService = null;
    private RecordService recordService = null;

    private static ServiceFactory instance = null;

    private ServiceFactory() {
        databaseService = AsyncTaskServiceRegister.proxify(new DatabaseServiceImpl());
        imageService = AsyncTaskServiceRegister.proxify(new ImageServiceImpl());
        questionService = AsyncTaskServiceRegister.proxify(new QuestionServiceImpl());
        recordService = AsyncTaskServiceRegister.proxify(new RecordServiceImpl());
    }

    public static ServiceFactory getServiceFactory() {
        if (instance == null) {
            instance = new ServiceFactory();
        }
        return instance;
    }

	public DatabaseService getDatabaseService() {
		return databaseService;
	}

	public ImageService getImageService() {
		return imageService;
	}

	public QuestionService getQuestionService() {
		return questionService;
	}

	public RecordService getRecordService() {
		return recordService;
	}
	
}
