package no.hib.megagruppe.webpoll.data;

import javax.enterprise.inject.Instance;
import javax.inject.Inject;
import javax.inject.Singleton;

@Singleton
public class RepositoryFactoryImpl implements RepositoryFactory {
    private Instance<ResponseRepository> responseRepository;
    private Instance<SurveyRepository> surveyRepository;
    private Instance<UserRepository> userRepository;

    @Inject
    public RepositoryFactoryImpl(Instance<SurveyRepository> surveyRepository,
                                 Instance<UserRepository> userRepository,
                                 Instance<ResponseRepository> responseRepository) {
        this.surveyRepository = surveyRepository;
        this.userRepository = userRepository;
        this.responseRepository = responseRepository;
    }

    @Override
    public SurveyRepository getSurveyRepository() {
        return surveyRepository.get();
    }

    @Override
    public UserRepository getUserRepository() {
        return userRepository.get();
    }

	@Override
	public ResponseRepository getResponseRepository() {
		return responseRepository.get();
	}
    
    
}
