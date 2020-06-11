package com.alexanderfinn.httpserver.example.store;

import java.util.HashMap;
import java.util.Map;

public class RepositoryFactory {
  
  private static final RepositoryFactory instance = new RepositoryFactory();
  private final Map<Class, ObjectRepository> repositories = new HashMap<Class, ObjectRepository>();
  
  private RepositoryFactory() {
  }
  
  public static RepositoryFactory getInstance() {
    return instance;
  }
  
  public <T> ObjectRepository<T> getObjectRepository(Class<T> clazz) {
    ObjectRepository objectRepository = repositories.get(clazz);
    return objectRepository;
  }
  
  public <T> void setObjectRepository(Class<T> clazz, ObjectRepository<T> repository) {
    repositories.put(clazz, repository);
  }

}
