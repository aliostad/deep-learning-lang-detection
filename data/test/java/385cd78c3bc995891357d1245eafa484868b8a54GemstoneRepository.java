package sample.app.dao.repo;

import org.springframework.data.gemfire.repository.GemfireRepository;
import org.springframework.stereotype.Repository;

import sample.app.domain.Gemstone;

/**
 * The GemstoneRepo class...
 * @author John Blum
 * @see org.springframework.data.gemfire.repository.GemfireRepository
 * @see org.springframework.stereotype.Repository
 * @since 1.0.0
 */
@Repository("gemfireGemstoneDao")
@SuppressWarnings("unused")
public interface GemstoneRepository extends GemfireRepository<Gemstone, Long> {

}
