package com.tecacet.text.search;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.junit.Test;

public class ExtensionDocumentHandlerFactoryTest {

	@Test
	public void testGetDocument() throws FileNotFoundException, IOException,
			DocumentHandlerException {

		ExtensionDocumentHandlerFactory handlerFactory = new ExtensionDocumentHandlerFactory(
				"document.factory.properties");
		DocumentHandler handler = handlerFactory.getHandlerForExtension("doc");
		assertEquals("com.tecacet.text.search.handler.MicrosoftTextHandler",
				handler.getClass().getName());
		handler = handlerFactory.getHandlerForExtension("docx");
		assertEquals("com.tecacet.text.search.handler.MicrosoftTextHandler",
				handler.getClass().getName());
		handler = handlerFactory.getHandlerForExtension("xls");
		assertEquals("com.tecacet.text.search.handler.MicrosoftTextHandler",
				handler.getClass().getName());
		handler = handlerFactory.getHandlerForExtension("xlsx");
		assertEquals("com.tecacet.text.search.handler.MicrosoftTextHandler",
				handler.getClass().getName());
		handler = handlerFactory.getHandlerForExtension("ppt");
		assertEquals("com.tecacet.text.search.handler.MicrosoftTextHandler",
				handler.getClass().getName());
		
		
		handler = handlerFactory.getHandlerForExtension("html");
		assertEquals("com.tecacet.text.search.handler.HTMLHandler",
				handler.getClass().getName());
		handler = handlerFactory.getHandlerForExtension("htm");
		assertEquals("com.tecacet.text.search.handler.HTMLHandler",
				handler.getClass().getName());
		
		handler = handlerFactory.getHandlerForExtension("rtf");
		assertEquals("com.tecacet.text.search.handler.RTFDocumentHandler",
				handler.getClass().getName());
	}

	@Test
	public void testNoExtension() throws IOException, DocumentHandlerException {
		File file = new File("no_extension");
		file.createNewFile();
		DocumentHandlerFactory handlerFactory = new ExtensionDocumentHandlerFactory();
		assertNull(handlerFactory.getHandlerForFile(file));
		file.delete();
	}
	
}
