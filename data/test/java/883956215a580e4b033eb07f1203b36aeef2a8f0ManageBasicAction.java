package SaleCD.action;

import SaleCD.model.ManageBasicModel;
import SaleCD.model.ManageGeneralModel;
import java.util.List;

public class ManageBasicAction extends IndexAction {

    private List manageGeneralList;
    private List manageBasicList;
    private ManageBasicModel manageBasicModel;
    private ManageGeneralModel manageGeneralModel;

    public ManageBasicAction() {
        manageBasicModel = new ManageBasicModel();
        manageGeneralModel = new ManageGeneralModel();
    }

    public List getManageGeneralList() {
        return manageGeneralList;
    }

    public void setManageGeneralList(List manageGeneralList) {
        this.manageGeneralList = manageGeneralList;
    }

    public ManageGeneralModel getManageGeneralModel() {
        return manageGeneralModel;
    }

    public void setManageGeneralModel(ManageGeneralModel manageGeneralModel) {
        this.manageGeneralModel = manageGeneralModel;
    }

    public List getManageBasicList() {
        return manageBasicList;
    }

    public void setManageBasicList(List manageBasicList) {
        this.manageBasicList = manageBasicList;
    }

    public ManageBasicModel getManageBasicModel() {
        return manageBasicModel;
    }

    public void setManageBasicModel(ManageBasicModel manageBasicModel) {
        this.manageBasicModel = manageBasicModel;
    }

    public String index() {
        manageGeneralList = manageGeneralModel.list();
        return "SUCCESS";
    }
}