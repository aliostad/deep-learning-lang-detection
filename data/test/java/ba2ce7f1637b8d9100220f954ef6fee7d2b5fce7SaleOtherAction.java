package SaleCD.action;

import SaleCD.model.ManageGeneralModel;
import java.util.ArrayList;
import java.util.List;

public class SaleOtherAction extends IndexAction {

    private ManageGeneralModel manageGeneralModel;
    private List manageGeneralList;

    public SaleOtherAction() {
        manageGeneralModel = new ManageGeneralModel();
    }

    public ManageGeneralModel getManageGeneralModel() {
        return manageGeneralModel;
    }

    public void setManageGeneralModel(ManageGeneralModel manageGeneralModel) {
        this.manageGeneralModel = manageGeneralModel;
    }

    public List getManageGeneralList() {
        return manageGeneralList;
    }

    public void setManageGeneralList(List manageGeneralList) {
        this.manageGeneralList = manageGeneralList;
    }

    public String index() {
        manageGeneralList = manageGeneralModel.list();
        return "SUCCESS";
    }
}
