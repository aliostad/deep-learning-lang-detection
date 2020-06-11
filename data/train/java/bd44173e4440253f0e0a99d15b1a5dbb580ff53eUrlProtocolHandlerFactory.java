package org.pals.analysis.analyser.handler.remoteFileHandler;

public class UrlProtocolHandlerFactory
{
	public static final String FILE_PROTOCOL = "file";
	public static final String S3_PROTOCOL = "https://(.*)@(.*).s3.amazonaws.com/(.*)";
	public static final String HOST = null;

	public static RemoteFileHandler getHandler(String protocol)
	{
		RemoteFileHandler handler = null;
		if(protocol.equals(FILE_PROTOCOL)) handler = new FileProtocolHandler();
		else if(protocol.equals(S3_PROTOCOL)) handler = new S3ProtocolHandler();
		else handler = null;
		return handler;
	}
}
