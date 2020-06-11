package SaleCD.action;

import SaleCD.model.ManageGeneralModel;
import java.util.List;

public class ProductTypeAction extends IndexAction {

    private List manageGeneralList;
    private ManageGeneralModel manageGeneralModel;

    public ProductTypeAction() {
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

    public String index() {
        manageGeneralList = manageGeneralModel.list();
        return "SUCCESS";
    }
}
