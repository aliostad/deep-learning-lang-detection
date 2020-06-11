package EDU.pku.ly.Process;

import java.io.Serializable;
import java.sql.SQLException;

import EDU.cmu.Atlas.owls1_1.process.InputList;
import EDU.cmu.Atlas.owls1_1.process.OutputList;
import EDU.cmu.Atlas.owls1_1.process.Parameter;
import EDU.cmu.Atlas.owls1_1.process.PreConditionList;
import EDU.cmu.Atlas.owls1_1.process.Process;
import EDU.cmu.Atlas.owls1_1.process.ResultList;
import EDU.cmu.Atlas.owls1_1.process.implementation.ControlConstructImpl;

public interface ProcessInquiry extends Serializable{
	
	public Process ProcessInquiryEntry(int process_id, String flag);
	
	public Process ProcessInquiryEntry(int service_id);
	
	public Parameter ParameterInquiry(int param_id);
}
