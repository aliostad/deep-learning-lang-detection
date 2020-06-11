package com.roundarch.repository;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@SuppressWarnings("restriction")
@Component
public class JsonSerializerRepositoryInitializer {

	@Autowired(required = false)
	private InterviewerRepository interviewerRepository;

	@Autowired(required = false)
	private RecruitRepository recruitRepository;

	@Autowired(required = false)
	private DocumentRepository documentRepository;

	@Autowired(required = false)
	private DocumentMetadataRepository documentMetadataRepository;

	@PostConstruct
	public void init() {
		JsonIdSerializers.setRecruitRepository(recruitRepository);
		JsonIdSerializers.setInterviewerRepository(interviewerRepository);
		JsonIdSerializers.setDocumentRepository(documentRepository);
		JsonIdSerializers.setDocumentMetadataRepository(documentMetadataRepository);
	}

}
