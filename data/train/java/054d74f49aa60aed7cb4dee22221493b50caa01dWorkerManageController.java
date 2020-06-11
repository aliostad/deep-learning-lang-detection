package logic.controller;

import logic.interfaces.WorkerManageInterface;
import logic.model.WorkerManageModel;

public class WorkerManageController extends Controller implements WorkerManageInterface {
	private WorkerManageModel workerManageModel = new WorkerManageModel();

	@Override
	public void writeData(String[] s) {
		// TODO Auto-generated method stub
		workerManageModel.addWorker(s);
	}
	public Object[][] getTable(){
		return workerManageModel.getTable();
	}
	public String getWorkerByID(String ID){
		return workerManageModel.getWorkerByID(ID);
	}
	public boolean deleteWorker(String ID){
		Boolean b = workerManageModel.deleteWorker(ID);
		workerManageModel.writeData();
		return b;
	}
	public void changePosition(String ID,String position){
		workerManageModel.changePosition(ID, position);
		workerManageModel.writeData();
	}
	public void changePassword(String ID,String newCode){
		workerManageModel.changePassword(ID, newCode);
		workerManageModel.writeData();
	}

}
