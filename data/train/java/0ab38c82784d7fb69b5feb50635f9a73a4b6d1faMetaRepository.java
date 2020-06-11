package com.technoetic.xplanner.domain.repository;

/**
 * The Interface MetaRepository.
 */
public interface MetaRepository {
    
    /**
     * Gets the repository.
     *
     * @param objectClass
     *            the object class
     * @return the repository
     */
    ObjectRepository getRepository(Class objectClass);

    /**
     * Sets the repository.
     *
     * @param objectClass
     *            the object class
     * @param repository
     *            the repository
     */
    void setRepository(Class objectClass, ObjectRepository repository);
}
