package ch.kostceco.tools.siardval.content.impl.internal.service;

import org.osgi.service.log.LogService;

import ch.kostceco.tools.siardval.content.api.service.ContentValidator;
import ch.kostceco.tools.siardval.xml.api.service.XmlService;
import ch.kostceco.tools.siardval.zip.api.service.ZipService;

public class ContentValidatorComponent implements ContentValidator
{
	private LogService logService;
	
	private ZipService zipService;
	
	private XmlService xmlService;
	
	protected void bindLogService(LogService service)
	{
		this.logService = service;
	}

	protected void unbindLogService(LogService service)
	{
		this.logService = null;
	}

	protected void bindZipService(ZipService service)
	{
		this.zipService = service;
	}

	protected void unbindZipService(ZipService service)
	{
		this.zipService = null;
	}

	protected void bindXmlService(XmlService service)
	{
		this.xmlService = service;
	}

	protected void unbindXmlService(XmlService service)
	{
		this.xmlService = null;
	}

}
