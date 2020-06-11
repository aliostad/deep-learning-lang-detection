package no.hib.megagruppe.webpoll.fakes;

import no.hib.megagruppe.webpoll.data.RepositoryFactory;
import no.hib.megagruppe.webpoll.data.ResponseRepository;
import no.hib.megagruppe.webpoll.data.SurveyRepository;
import no.hib.megagruppe.webpoll.data.UserRepository;

public class FakeRepositoryFactory implements RepositoryFactory {
    private UserRepository userRepository = null;
    private SurveyRepository surveyRepository = null;
    private ResponseRepository responseRepository = null;

    public FakeRepositoryFactory(UserRepository userRepository, SurveyRepository surveyRepository, ResponseRepository responseRepository) {
        this.userRepository = userRepository;
        this.surveyRepository = surveyRepository;
        this.responseRepository = responseRepository;
    }

    @Override
    public SurveyRepository getSurveyRepository() {
        return surveyRepository;
    }

    @Override
    public UserRepository getUserRepository() {
        return userRepository;
    }

	@Override
	public ResponseRepository getResponseRepository() {
		return responseRepository;
	}
}
