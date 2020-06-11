package org.yamkazu.jaxws.client;

import java.net.URL;

import javax.xml.namespace.QName;

import org.junit.Test;

public class EchoServiceServiceTest {

	@Test
	public void hoge() throws Exception {
		try {
			// EchoServiceService echoServiceService = new EchoServiceService();
			EchoServiceService echoServiceService = new EchoServiceService(
					new URL(
							"http://localhost:8088/mockEchoServicePortBinding?wsdl"),
					new QName("http://server.jaxws.yamkazu.org/",
							"EchoServiceService"));
			EchoService echoServicePort = echoServiceService
					.getEchoServicePort();
			String echo = echoServicePort.echo("aaa");
			System.out.println(echo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
