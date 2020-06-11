package uk.co.andrewmaddock.wedding.repository.gae;

import org.springframework.stereotype.Repository;

import uk.co.andrewmaddock.wedding.model.PlayList;
import uk.co.andrewmaddock.wedding.repository.AbstractGenericRepository;
import uk.co.andrewmaddock.wedding.repository.PlayListRepository;

/**
 * GAE implementation of the {@link PlayListRepository} interface.
 *
 * @author Andrew Maddock
 *         Date: 18/07/13 13:42
 */
@Repository
public class PlayListRepositoryGae extends AbstractGenericRepository<PlayList> implements PlayListRepository {
    
}
