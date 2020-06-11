package org.rocklass.fullstacklab.service;

import org.rocklass.fullstacklab.model.Item;
import org.rocklass.fullstacklab.repository.ItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Service;

/**
 * Item repository service
 * 
 * @author rocklass
 *
 */
@Service
public class ItemRepositoryService extends GenericRepositoryService<Item> implements ItemService {

    /**
     * Item JPA repository
     */
    private ItemRepository repository;

    /**
     * Get JPA repository for items
     * 
     * @return JPA repository
     */
    @Override
    public JpaRepository<Item, Long> getRepository() {
        return repository;
    }

    /**
     * Set JPA repository for entities
     * 
     * @param repository
     *            JPA repository
     */
    @Autowired
    @Override
    public void setRepository(final JpaRepository<Item, Long> repository) {
        this.repository = (ItemRepository) repository;
    }

    /**
     * Get entity name
     * 
     * @return item
     */

    @Override
    protected String getEntityName() {
        return "item";
    }
}
