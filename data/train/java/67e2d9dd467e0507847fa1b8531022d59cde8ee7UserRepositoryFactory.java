package main.java.com.Arkioner.schibstedTest.model.User;

/**
 * Created by arkioner on 17/05/15.
 */
public class UserRepositoryFactory
{
    private UserRepositoryInterface instanceRepository;
    private static UserRepositoryFactory instanceFactory;


    public static UserRepositoryFactory getInstance()
    {
        if(null == instanceFactory) {
            instanceFactory = new UserRepositoryFactory();
        }
        return instanceFactory;

    }

    public UserRepositoryInterface getUserRepository()
    {
        if(null == instanceRepository){
            instanceRepository = InMemoryUserRepository.getInstance();
        }
        return instanceRepository;
    }
}