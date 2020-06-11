package com.page5of4.codon.useful.repositories;

public class GenericRepositoryProxy<K, V> implements Repository<K, V> {
   private final Repository<Object, Object> repository;

   @SuppressWarnings("unchecked")
   public GenericRepositoryProxy(RepositoryFactory repositoryFactory, Class<? extends Repository<K, V>> repositoryClass) {
      super();
      this.repository = (Repository<Object, Object>)repositoryFactory.createRepository(repositoryClass);
   }

   @Override
   @SuppressWarnings("unchecked")
   public V get(K key) {
      return (V)repository.get(key);
   }

   @Override
   public void delete(K key) {
      repository.delete(key);
   }

   @Override
   public void add(K key, V value) {
      repository.add(key, value);
   }
}
