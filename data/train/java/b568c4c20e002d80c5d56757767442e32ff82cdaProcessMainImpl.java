package EDU.pku.ly.Process.Implementation;

import EDU.cmu.Atlas.owls1_1.process.Process;
import EDU.pku.ly.Process.ProcessDelete;
import EDU.pku.ly.Process.ProcessInquiry;
import EDU.pku.ly.Process.ProcessMain;
import EDU.pku.ly.Process.ProcessParser;
import EDU.pku.ly.Process.util.ProcessResource;
import edu.pku.ly.SqlOpe.SQLHelper;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProcessMainImpl implements ProcessMain {

	private static final long serialVersionUID = -1L;
	
	public ProcessMainImpl()
	{}
	
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
		
		System.out.println("time:" + (t2 - t1));
	}

	public void ProcessPublishEntry(Process process, int service_id) {
		// TODO Auto-generated method stub
		
		ProcessParser parser = new ProcessParserImpl();
		parser.ProcessParserEntry(process, service_id);
	}
	
	
	
	public Process ProcessInquiryEntry(int service_id)
	{
		ProcessInquiry inquiry = new ProcessInquiryImpl();
		return inquiry.ProcessInquiryEntry(service_id);
	}

	public int ProcessDeleteEntry(int service_id) {
		// TODO Auto-generated method stub
		
		ProcessDelete delete = new ProcessDeleteImpl();
		return delete.ProcessDeleteEntry(service_id);
	}
}
