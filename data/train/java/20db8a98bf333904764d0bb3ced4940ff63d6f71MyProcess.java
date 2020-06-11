package br.com.orionsoft.monstrengo.core.process.metadata;

import br.com.orionsoft.monstrengo.core.process.metadata.MyProcess;
import br.com.orionsoft.monstrengo.core.annotations.ProcessMetadata;
import br.com.orionsoft.monstrengo.core.process.ProcessBasic;

@ProcessMetadata(label="LABEL", hint="HINT", description="DESCRIPTION")
public class MyProcess extends ProcessBasic
{

	public String getProcessName()
	{
		// TODO Auto-generated method stub
		return null;
	}
	
	
	public static void main(String[] args){
		System.out.println(MyProcess.class.getAnnotation(ProcessMetadata.class).description());
		System.out.println(MyProcess.class.getAnnotation(ProcessMetadata.class).hint());
		System.out.println(MyProcess.class.getAnnotation(ProcessMetadata.class).label());
	}

}
