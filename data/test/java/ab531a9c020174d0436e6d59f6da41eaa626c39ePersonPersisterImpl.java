/**
 * 
 */
package ar.edu.unq;

/**
 * @author Cristian
 * 
 */
public class PersonPersisterImpl implements PersonPersister {

    private final Repository repository;

    public PersonPersisterImpl(final Repository repository) {
        this.repository = repository;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void save(final Person person) {
        try {
            repository.persists(person);
        } catch (RepositoryException e) {
            repository.rollback();
            throw new PersistenceException(e);
        }
    }

}
