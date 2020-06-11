package in.co.equations.modules.course;

import com.thenextpointer.crud.CrudService;
import com.thenextpointer.db.PersistenceService;
import com.thenextpointer.pagination.ListService;
import java.io.Serializable;

public class CourseService implements Serializable {

    private PersistenceService persistenceService;

    public PersistenceService getPersistenceService() {
        return persistenceService;
    }

    public void setPersistenceService(PersistenceService persistenceService) {
        this.persistenceService = persistenceService;
    }

    public CourseService() {
        
    }

    public CrudService getCrudService() {
        return persistenceService.getCrudService();
    }

    public ListService getListService() {
        return persistenceService.getListService();
    }
}
