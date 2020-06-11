package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.SequenceService;
import tw.com.skl.exp.kernel.model6.logic.UserService;

/**
 * 一般費用 Facade
 * 
 * @author Eustace
 * @version 1.0 2009/06/12
 */
public class PapersNoFacade {

    private SequenceService sequenceService ;
    /**使用者的 Service*/
    private UserService userService;

    public SequenceService getSequenceService() {
        return sequenceService;
    }
    public void setSequenceService(SequenceService sequenceService) {
        this.sequenceService = sequenceService;
    }
    /**
     * @param 使用者的 Service
     */
    public void setUserService(UserService userService) {
        this.userService = userService;
    }
    /**
     * @return 使用者的 Service
     */
    public UserService getUserService() {
        return userService;
    }

}
