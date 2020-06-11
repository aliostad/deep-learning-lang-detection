package com.xiaoy.core.bpm.action;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;

import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Results;

import com.xiaoy.core.bpm.entity.ProcessDefine;

@Namespace("/bpm")
@Results( {
})
public class ProcessdefineAction extends BpmBaseAction{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8336776834707489171L;
	private File processZip;
	private String processZipFileName; 				// 上传文件的文件名
	private String processZipContentType; 			// 上传文件的类型
	
	private ProcessDefine processDefine;
	
	public void deploymentList (){
		try {
			List<ProcessDefine>ProcessDefines = processDefineService.deploymentProcessList(initFilter());
//			request.setAttribute("processDefines",ProcessDefines );
			renderJson(ProcessDefines);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
//		return "deploymentlist";
	}
	
	public String deploymentForm () {
		
		return "deploymentform";
	}
	
	
	/**
	 * 部署一个流程
	 * @return
	 */
	public void deploymentProcess () {
		
		try {
//			processDefineService.deploymentProcess(processZipFileName, );
//			ProcessDefine pd = new ProcessDefine();
//			pd.setName(processZipFileName);
			processDefine.setName(processZipFileName);
			processDefineService.deploymentProcess(processDefine, new FileInputStream(processZip));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
//		return "deploymentprocess";
	}

	
	//-----------------------------------------------
	public File getProcessZip() {
		return processZip;
	}

	public void setProcessZip(File processZip) {
		this.processZip = processZip;
	}

	public String getProcessZipFileName() {
		return processZipFileName;
	}

	public void setProcessZipFileName(String processZipFileName) {
		this.processZipFileName = processZipFileName;
	}

	public String getProcessZipContentType() {
		return processZipContentType;
	}

	public void setProcessZipContentType(String processZipContentType) {
		this.processZipContentType = processZipContentType;
	}

	public ProcessDefine getProcessDefine() {
		return processDefine;
	}

	public void setProcessDefine(ProcessDefine processDefine) {
		this.processDefine = processDefine;
	}


	@Override
	protected String setTemplateKey() {
		return "processDefine";
	}
}
