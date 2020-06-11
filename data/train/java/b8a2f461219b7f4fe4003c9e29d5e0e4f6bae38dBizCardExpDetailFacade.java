package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.fileio.FileImportService;
import tw.com.skl.exp.kernel.model6.logic.BizCardService;
import tw.com.skl.exp.kernel.model6.logic.TranLogService;
import tw.com.skl.exp.kernel.model6.logic.UserService;


/**
 * 商務卡消費明細Facade
 * 
 * @author jackson
 *
 * @version 1.0, 2009/9/25
 */
public class BizCardExpDetailFacade{
    /**檔案匯入Service基礎介面*/
    private FileImportService fileImportService;
    /**商務卡 Service*/
    private BizCardService bizCardService;
    /**使用者的 Service*/
    private UserService userService;
    /**轉檔記錄 Service*/
    private TranLogService tranLogService;

    /**
     * @return 檔案匯入Service基礎介面
     */
    public FileImportService getFileImportService() {
        return fileImportService;
    }
    /**
     * @param 檔案匯入Service基礎介面
     */
    public void setFileImportService(FileImportService fileImportService) {
        this.fileImportService = fileImportService;
    }
    /**
     * @param 商務卡 Service
     */
    public void setBizCardService(BizCardService bizCardService) {
        this.bizCardService = bizCardService;
    }
    /**
     * @return 商務卡 Service
     */
    public BizCardService getBizCardService() {
        return bizCardService;
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
    /** @return 轉檔記錄 Service 介面 */
    public TranLogService getTranLogService() {
        return tranLogService;
    }
    /** @param tranLogService 轉檔記錄 Service 介面 */
    public void setTranLogService(TranLogService tranLogService) {
        this.tranLogService = tranLogService;
    }    

}
