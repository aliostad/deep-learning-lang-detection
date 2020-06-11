package tktl.gstudies.services;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Generic class for repository service
 * @author hkeijone
 */
public class GenericRepositoryService<T> {

    protected JpaRepository<T, Integer> repository;

    public void setRepository(JpaRepository<T, Integer> repository) {
        this.repository = repository;
    }
       
    public T save(T t){
        return this.repository.save(t);
    }
    
    public  List<T> findAll () {
        return this.repository.findAll();
    }
}
