import org.apache.jackrabbit.core.TransientRepository;
import javax.jcr.Repository;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

// Description: Log in to repository 
public class FirstHop {

    public static void main(String[] args) throws RepositoryException {
        Repository repository = new TransientRepository();
        Session session = repository.login();
        try {
            String user = session.getUserID();
            String name = repository.getDescriptor(Repository.REP_NAME_DESC);
            System.out.println(
                                "Logged in as " + user + " to a " + name + " repository.");

        } finally {
            session.logout();
        }
    }
}
