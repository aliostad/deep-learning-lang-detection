package model.process;

import model.data.Table;

import java.util.List;

/**
 * Represents a DataProcess chain, where the output of the first process is piped into the next.
 *
 * Created by Boudewijn on 20-5-2015.
 */
public class SerialProcess extends DataProcess {

	private List<DataProcess> processList;

	/**
	 * Construct a new SerialProcess.
	 * @param processList The process chain for this process.
	 */
	public SerialProcess(List<DataProcess> processList) {
		this.processList = processList;
	}

	@Override
	protected Table doProcess() {
		Table result = getInput();
		for (DataProcess i : processList) {
			i.setDataModel(getDataModel());
			i.setInput(result);
			result = i.process();
		}
		return result;
	}
}
