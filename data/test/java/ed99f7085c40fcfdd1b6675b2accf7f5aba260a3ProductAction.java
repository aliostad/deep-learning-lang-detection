package SaleCD.action;

import SaleCD.model.ManageGeneralModel;
import java.util.List;

public class ProductAction extends IndexAction {

    private ManageGeneralModel manageGeneralModel;
    private List manageGeneralList;

    public ProductAction() {
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

    public String execute() {
        manageGeneralList = manageGeneralModel.list();
        return "SUCCESS";
    }
}
