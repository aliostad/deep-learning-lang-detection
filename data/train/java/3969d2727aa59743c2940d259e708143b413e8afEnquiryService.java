package in.co.equations.modules.enquiry;

import com.thenextpointer.crud.CrudService;
import com.thenextpointer.db.PersistenceService;
import com.thenextpointer.pagination.ListService;

public class EnquiryService {

    private PersistenceService persistenceService;

    public PersistenceService getPersistenceService() {
        return persistenceService;
    }

    public void setPersistenceService(PersistenceService persistenceService) {
        this.persistenceService = persistenceService;
    }

    public EnquiryService() {
        
    }

    public CrudService getCrudService() {
        return persistenceService.getCrudService();
    }

    public ListService getListService() {
        return persistenceService.getListService();
    }
}
