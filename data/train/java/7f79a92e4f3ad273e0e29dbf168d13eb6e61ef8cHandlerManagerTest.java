/**
 * Copyright (C) 2015 Stubhub.
 */
package io.bigdime.core.handler;

import static org.mockito.Mockito.when;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;

import org.mockito.Mockito;
import org.springframework.test.util.ReflectionTestUtils;
import org.testng.Assert;
import org.testng.annotations.Test;

import io.bigdime.core.ActionEvent;
import io.bigdime.core.ActionEvent.Status;
import io.bigdime.core.Handler;
import io.bigdime.core.HandlerException;

public class HandlerManagerTest {

	@Test(expectedExceptions = HandlerException.class)
	public void testProcessWithNullHandlers()
			throws HandlerException, InterruptedException, IllegalHandlerStateException {
		HandlerManager handlerManager = new HandlerManager(null, null);
		handlerManager.execute();
	}

	@Test
	public void testConstructor() {
		LinkedHashSet<Handler> handlerSet = new LinkedHashSet<>();
		Handler mockHandler1 = Mockito.mock(Handler.class);
		Handler mockHandler2 = Mockito.mock(Handler.class);
		Handler mockHandler3 = Mockito.mock(Handler.class);
		handlerSet.add(mockHandler1);
		handlerSet.add(mockHandler2);
		handlerSet.add(mockHandler3);
		Mockito.when(mockHandler1.getName()).thenReturn("mock-handler-1");
		Mockito.when(mockHandler2.getName()).thenReturn("mock-handler-2");
		Mockito.when(mockHandler3.getName()).thenReturn("mock-handler-3");

		HandlerManager handlerManager = new HandlerManager(handlerSet, null);
		HandlerNode handlerNode = (HandlerNode) ReflectionTestUtils.getField(handlerManager, "handlerNodeHead");
		Assert.assertSame(handlerNode.getHandler(), mockHandler1);
		Assert.assertSame(handlerNode.getNext().getHandler(), mockHandler2);
		Assert.assertSame(handlerNode.getNext().getNext().getHandler(), mockHandler3);

	}

	@Test
	public void testProcess() throws InterruptedException, HandlerException {
		LinkedHashSet<Handler> handlerSet = new LinkedHashSet<Handler>();
		Handler mockHandler1 = Mockito.mock(Handler.class);
		Handler mockHandler2 = Mockito.mock(Handler.class);
		Handler mockHandler3 = Mockito.mock(Handler.class);
		handlerSet.add(mockHandler1);
		handlerSet.add(mockHandler2);
		handlerSet.add(mockHandler3);
		Mockito.when(mockHandler1.getName()).thenReturn("mock-handler-1");
		Mockito.when(mockHandler2.getName()).thenReturn("mock-handler-2");
		Mockito.when(mockHandler3.getName()).thenReturn("mock-handler-3");

		HandlerManager handlerManager = new HandlerManager(handlerSet, null);

		Mockito.when(mockHandler1.process()).thenReturn(Status.READY);
		Mockito.when(mockHandler2.process()).thenReturn(Status.CALLBACK).thenReturn(Status.READY);
		Mockito.when(mockHandler3.process()).thenReturn(Status.READY).thenReturn(Status.BACKOFF);
		handlerManager.execute();
		Mockito.verify(mockHandler1, Mockito.times(1)).process();
		Mockito.verify(mockHandler2, Mockito.times(2)).process();
		Mockito.verify(mockHandler3, Mockito.times(2)).process();
		Assert.assertSame(ReflectionTestUtils.getField(handlerManager, "state"), HandlerManager.STATE.STOPPED);
	}

	@Test
	public void testProcessInfinite() throws HandlerException, InterruptedException, IllegalHandlerStateException {

		LinkedHashSet<Handler> handlers = new LinkedHashSet<Handler>();
		Handler handler = Mockito.mock(Handler.class);
		when(handler.getName()).thenReturn("handler2name");
		handlers.add(handler);
		final HandlerManager handlerManager = new HandlerManager(handlers, null);

		Thread t = new Thread() {
			@Override
			public void run() {
				try {
					Thread.sleep(10);
				} catch (InterruptedException e) {
				}
				while (!Thread.interrupted()) {
					ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.STOPPING);
				}
			}
		};

		Mockito.when(handler.process()).thenReturn(Status.READY);
		t.start();
		handlerManager.execute();
		Mockito.verify(handler, Mockito.atLeast(1)).process();

		t.interrupt();
	}

	// @Test(expectedExceptions = HandlerException.class)
	public void testProcessWithException() throws HandlerException, InterruptedException {
		HandlerManager handlerManager = new HandlerManager(null, null);
		List<Handler> head = new ArrayList<>();
		Handler handler1 = Mockito.mock(Handler.class);
		Handler handler2 = Mockito.mock(Handler.class);
		head.add(handler1);
		head.add(handler2);

		ActionEvent mockActionEvent = Mockito.mock(ActionEvent.class);
		when(mockActionEvent.getBody()).thenReturn("test".getBytes(Charset.defaultCharset()));

		Mockito.when(handler1.process()).thenThrow(new HandlerException("unit-test"));
		ReflectionTestUtils.setField(handlerManager, "head", head);
		handlerManager.execute();

	}

	@Test(expectedExceptions = IllegalHandlerStateException.class)
	public void testUpdateStateRunningToRunning() throws HandlerException {
		HandlerManager handlerManager = new HandlerManager(null, null);
		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.RUNNING);
		handlerManager.execute();
	}

	/**
	 * If one of the handlers throw an exception, handlerManager.execute must
	 * throw it to it's caller.
	 * 
	 * @throws InterruptedException
	 * @throws HandlerException
	 */
	@Test
	public void testUpdateStateRunningToError() throws HandlerException {
		HandlerManager handlerManager = setupHandlerManagerWithHandlerThrowingException();
		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.INITIALIZED);
		try {
			handlerManager.execute();
			Assert.fail("must have thrown an excepion");
		} catch (HandlerException ex) {
			Assert.assertNotNull(ex);
		}
		Assert.assertEquals(ReflectionTestUtils.getField(handlerManager, "errorCount"), 1);
		Assert.assertSame(ReflectionTestUtils.getField(handlerManager, "state"), HandlerManager.STATE.STOPPED);
	}

	@Test
	public void testUpdateStateErrorToError() throws HandlerException {
		HandlerManager handlerManager = setupHandlerManagerWithHandlerThrowingException();

		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.INITIALIZED);
		try {
			handlerManager.execute();
			Assert.fail("must have thrown an excepion");
		} catch (HandlerException ex) {
		}
		Assert.assertSame(ReflectionTestUtils.getField(handlerManager, "state"), HandlerManager.STATE.STOPPED);
		try {
			handlerManager.execute();
			Assert.fail("must have thrown an excepion");
		} catch (HandlerException ex) {
		}
		Assert.assertEquals(ReflectionTestUtils.getField(handlerManager, "errorCount"), 2);
		Assert.assertSame(ReflectionTestUtils.getField(handlerManager, "state"), HandlerManager.STATE.STOPPED);
	}

	@Test
	public void testUpdateStateStoppedToRunning() throws HandlerException {
		HandlerManager handlerManager = setupHandlerManager();
		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.STOPPED);
		handlerManager.execute();
	}

	@Test
	public void testUpdateStateInitializedToRunning() throws HandlerException {
		HandlerManager handlerManager = setupHandlerManager();
		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.INITIALIZED);
		handlerManager.execute();
	}

	@Test
	public void testUpdateStateRunningToSTOPPING() throws HandlerException {
		HandlerManager handlerManager = setupHandlerManager();
		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.RUNNING);
		handlerManager.shutdown();
	}

	@Test
	public void testUpdateStateStoppedToSTOPPING() throws HandlerException {
		HandlerManager handlerManager = setupHandlerManager();
		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.STOPPED);
		handlerManager.shutdown();
	}

	@Test
	public void testUpdateStateStoppingToSTOPPING() throws HandlerException {
		HandlerManager handlerManager = setupHandlerManager();
		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.STOPPING);
		handlerManager.shutdown();
	}

	@Test
	public void testUpdateStateStoppedToSTOPPED() throws HandlerException {
		HandlerManager handlerManager = setupHandlerManager();
		ReflectionTestUtils.setField(handlerManager, "state", HandlerManager.STATE.STOPPED);
		ReflectionTestUtils.invokeMethod(handlerManager, "updateState", HandlerManager.STATE.STOPPED);
	}

	@Test
	public void testUpdateStateToSTOPPED() throws HandlerException {
		HandlerManager handlerManager = new HandlerManager(null, null);
		setupHandlerManager();
		ReflectionTestUtils.invokeMethod(handlerManager, "updateState", HandlerManager.STATE.INITIALIZED);
	}

	private HandlerManager setupHandlerManager() throws HandlerException {
		LinkedHashSet<Handler> handlers = new LinkedHashSet<Handler>();
		Handler handler1 = Mockito.mock(Handler.class);
		when(handler1.getName()).thenReturn("handler21name");
		ActionEvent mockActionEvent = Mockito.mock(ActionEvent.class);
		when(mockActionEvent.getBody()).thenReturn("".getBytes(Charset.defaultCharset()));
		when(handler1.process()).thenReturn(Status.READY).thenReturn(Status.BACKOFF);
		handlers.add(handler1);

		return new HandlerManager(handlers, null);

	}

	private HandlerManager setupHandlerManagerWithHandlerThrowingException() throws HandlerException {
		LinkedHashSet<Handler> handlers = new LinkedHashSet<Handler>();
		Handler handler1 = Mockito.mock(Handler.class);
		when(handler1.getName()).thenReturn("handler21name");
		when(handler1.process()).thenThrow(Mockito.mock(HandlerException.class));
		handlers.add(handler1);
		return new HandlerManager(handlers, null);
	}
}
