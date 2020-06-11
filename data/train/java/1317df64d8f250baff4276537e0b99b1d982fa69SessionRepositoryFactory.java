package main.java.com.Arkioner.schibstedTest.core.http.session;

/**
 * Created by arkioner on 17/05/15.
 */
public class SessionRepositoryFactory
{
    private SessionRepositoryInterface instanceRepository;
    private static SessionRepositoryFactory instanceFactory;


    public static SessionRepositoryFactory getInstance()
    {
        if(null == instanceFactory) {
            instanceFactory = new SessionRepositoryFactory();
        }
        return instanceFactory;

    }

    public SessionRepositoryInterface getSessionRepository()
    {
        if(null == instanceRepository){
            instanceRepository = InMemorySessionRepository.getInstance();
        }
        return instanceRepository;
    }


}