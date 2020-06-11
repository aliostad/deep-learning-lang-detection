package EDU.pku.ly.Process.Implementation;

import com.google.gson.Gson;

import EDU.cmu.Atlas.owls1_1.process.Process;
import EDU.pku.ly.Process.ProcessDelete;
import EDU.pku.ly.Process.ProcessInquiry;
import EDU.pku.ly.Process.ProcessMainNew;
import EDU.pku.ly.Process.ProcessParser;
import EDU.pku.ly.Process.util.ProcessResource;

public class ProcessMainNewImpl implements ProcessMainNew {
	
	
	
	@Override
	public void ProcessPublishEntry(String service_url) {
		// TODO Auto-generated method stub
		ProcessParser parser = new ProcessParserImpl();
		
		Process process = ProcessResource.GetOWLSProcess(service_url);
		
		long t1 = System.currentTimeMillis();
		
		for(int i = 0; i < 1000; i++)
		{
			parser.ProcessParserEntry(process, i);
		}
		
		long t2 = System.currentTimeMillis();
	}

//	@Override
//	public void ProcessPublishEntryWithProcess(Process process, int service_id) {
//		// TODO Auto-generated method stub
//		ProcessParser parser = new ProcessParserImpl();
//		parser.ProcessParserEntry(process, service_id);
//	}

	@Override
	public String ProcessInquiryEntry(int service_id) {
		// TODO Auto-generated method stub
		ProcessInquiry inquiry = new ProcessInquiryImpl();
		 
		Process p=inquiry.ProcessInquiryEntry(service_id);
		Gson son=new Gson();
		return son.toJson(p);
	}

	@Override
	public int ProcessDeleteEntry(int service_id) {
		// TODO Auto-generated method stub
		ProcessDelete delete = new ProcessDeleteImpl();
		return delete.ProcessDeleteEntry(service_id);
	}

}
