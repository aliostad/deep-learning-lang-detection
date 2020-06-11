package com.nefariouszhen.khronos.ui.websocket

import java.io.Closeable
import java.util.concurrent.ExecutorService
import java.util.concurrent.atomic.AtomicBoolean

import com.fasterxml.jackson.annotation.JsonTypeName
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.scala.DefaultScalaModule
import com.google.common.util.concurrent.MoreExecutors
import com.google.inject.{Guice, Provides, Singleton}
import com.nefariouszhen.khronos.util.AssistedFactoryPublicModule
import com.nefariouszhen.khronos.websocket.{WebSocketWriter, WebSocketState, WebSocketRequest, WebSocketManager}
import io.dropwizard.jackson.Jackson
import net.codingwell.scalaguice.InjectorExtensions._
import org.atmosphere.websocket.WebSocket
import org.junit.Assert._
import org.junit.Test
import org.mockito.Matchers._
import org.mockito.Mockito._
import org.scalatest.Matchers

@JsonTypeName("reqfoo")
class ReqFoo extends WebSocketRequest
@JsonTypeName("reqbar")
class ReqBar extends ReqFoo

class WebSocketManagerTest extends Matchers {
  def reqfoo(id: Int = 1024, recurring: Boolean = false) = {
    s"""{"callbackId": $id, "type": "reqfoo", "recurring": "$recurring"}"""
  }

  def reqbar(id: Int = 1024, recurring: Boolean = false) = {
    s"""{"callbackId": $id, "type": "reqbar", "recurring": "$recurring"}"""
  }

  def cancelmsg(id: Int = 1024) = {
    s"""{"callbackId": $id, "type": "cancel"}"""
  }

  class DataSet {
    val injector = Guice.createInjector(new AssistedFactoryPublicModule {
      override def configure(): Unit = {
        bind[WebSocketManager].asEagerSingleton()
        bindFactory[WebSocketState, WebSocketState.Factory]()
        bind[ExecutorService].toInstance(MoreExecutors.sameThreadExecutor())
      }

      @Provides
      @Singleton
      def provideJackson(): ObjectMapper = {
        val om = Jackson.newObjectMapper
        om.registerModule(DefaultScalaModule)
        om
      }
    })

    def newSocket(uuid: String): WebSocket = {
      val socket = mock(classOf[WebSocket], RETURNS_DEEP_STUBS)
      when(socket.resource().uuid).thenReturn(uuid)
      manager.onOpen(socket)
      socket
    }

    val mapper = injector.instance[ObjectMapper]
    val manager = injector.instance[WebSocketManager]
    val socket = newSocket("1")

  }

  private[this] def onFoo(writer: WebSocketWriter, foo: ReqFoo): Unit = {
    writer.write("onreqfoo")
  }

  private[this] def onBar(writer: WebSocketWriter, bar: ReqBar): Unit = {
    writer.write("onreqbar")
  }

  private[this] def manageCallback(closed: AtomicBoolean)(writer: WebSocketWriter, foo: ReqFoo): Unit = {
    writer.manage(new Closeable() {
      def close(): Unit = closed.set(true)
    })
  }

  @Test
  def testSimpleCallback(): Unit = new DataSet {
    manager.registerCallback(onFoo)
    manager.onTextMessage(socket, reqfoo())

    verify(socket.resource, times(1)).write(contains("onreqfoo"))
  }

  @Test
  def testSuperCallback(): Unit = new DataSet {
    manager.registerCallback(onFoo)
    manager.onTextMessage(socket, reqbar())

    verify(socket.resource, times(1)).write(contains("onreqfoo"))
  }

  @Test
  def testNoMatchingCallback(): Unit = new DataSet {
    manager.registerCallback(onBar)
    manager.onTextMessage(socket, reqfoo())

    verify(socket.resource, never()).write(anyString)
  }

  @Test
  def testMostSpecificCallback(): Unit = new DataSet {
    manager.registerCallback(onFoo)
    manager.registerCallback(onBar)
    manager.onTextMessage(socket, reqbar())

    verify(socket.resource, times(1)).write(contains("onreqbar"))
  }

  @Test
  def testMostSpecificCallback2(): Unit = new DataSet {
    manager.registerCallback(onBar)
    manager.registerCallback(onFoo)
    manager.onTextMessage(socket, reqbar())

    verify(socket.resource, times(1)).write(contains("onreqbar"))
  }

  @Test
  def testNoCrossTalk(): Unit = new DataSet {
    val socket2 = newSocket("2")
    manager.registerCallback(onFoo)

    manager.onTextMessage(socket, reqfoo())
    verify(socket.resource, times(1)).write(contains("onreqfoo"))
    verify(socket2.resource, never).write(contains("onreqfoo"))

    manager.onTextMessage(socket2, reqfoo())
    verify(socket.resource, times(1)).write(contains("onreqfoo"))
    verify(socket2.resource, times(1)).write(contains("onreqfoo"))
  }

  @Test
  def testClosesManagedWhenNonRecurring(): Unit = new DataSet {
    val closed = new AtomicBoolean()
    manager.registerCallback(manageCallback(closed))
    manager.onTextMessage(socket, reqfoo())
    assertTrue(closed.get)
  }

  @Test
  def testClosesManagedNotAutomaticallyClosedWhenRecurring(): Unit = new DataSet {
    val closed = new AtomicBoolean()
    manager.registerCallback(manageCallback(closed))
    manager.onTextMessage(socket, reqfoo(recurring = true))
    assertFalse(closed.get)
  }

  @Test
  def testClosesManagedWhenClosed(): Unit = new DataSet {
    val closed = new AtomicBoolean()
    def closeSocket(writer: WebSocketWriter, f: ReqFoo): Unit = {
      manager.onClose(socket)
      writer.manage(new Closeable() {
        def close(): Unit = closed.set(true)
      })
    }
    manager.registerCallback(closeSocket)
    manager.onTextMessage(socket, reqfoo(recurring = true))
    assertTrue(closed.get)
  }

  @Test
  def testClosesManagedOnClose(): Unit = new DataSet {
    val closed = new AtomicBoolean()
    manager.registerCallback(manageCallback(closed))
    manager.onTextMessage(socket, reqfoo(recurring = true))
    manager.onClose(socket)
    assertTrue(closed.get)
  }

  @Test
  def testReturnsSameCallbackId(): Unit = new DataSet {
    manager.registerCallback(onFoo)
    manager.onTextMessage(socket, reqfoo(id = 2048))
    verify(socket.resource, times(1)).write(contains("2048"))
  }

  @Test(expected = classOf[IllegalArgumentException])
  def testThrowsOnDuplicateCallbackType(): Unit = new DataSet {
    manager.registerCallback(onFoo)
    manager.registerCallback(onFoo)
  }

  @Test
  def testDoesNotThrowWithEmtyMessage(): Unit = new DataSet {
    manager.onTextMessage(socket, "")
  }

  @Test
  def testDoesNotThrowWithEmptyObjectMessage(): Unit = new DataSet {
    manager.onTextMessage(socket, "{}")
  }

  @Test
  def testDoesNotThrowWithoutCallback(): Unit = new DataSet {
    manager.onTextMessage(socket, reqfoo())
  }

  @Test
  def testReuseCallbackIdClosesManaged(): Unit = new DataSet {
    val foo = new AtomicBoolean()
    val bar = new AtomicBoolean()

    manager.registerCallback(manageCallback(foo))
    manager.registerCallback[ReqBar](manageCallback(bar))

    manager.onTextMessage(socket, reqfoo(recurring = true))
    manager.onTextMessage(socket, reqbar(recurring = true))

    assertTrue(foo.get)
    assertFalse(bar.get)
  }

  @Test
  def testCancelClosesManaged(): Unit = new DataSet {
    val closed = new AtomicBoolean()
    manager.registerCallback(manageCallback(closed))
    manager.onTextMessage(socket, reqfoo(recurring = true))
    manager.onTextMessage(socket, cancelmsg())
    assertTrue(closed.get)
  }

  @Test
  def testNoCancelTwoRecurring(): Unit = new DataSet {
    val foo = new AtomicBoolean()
    val bar = new AtomicBoolean()

    manager.registerCallback(manageCallback(foo))
    manager.registerCallback[ReqBar](manageCallback(bar))

    manager.onTextMessage(socket, reqfoo(recurring = true, id = 0))
    manager.onTextMessage(socket, reqbar(recurring = true, id = 1))

    assertFalse(foo.get)
    assertFalse(bar.get)
  }

  @Test
  def testCancelNoCrosstalk(): Unit = new DataSet {
    val foo = new AtomicBoolean()
    val bar = new AtomicBoolean()

    manager.registerCallback(manageCallback(foo))
    manager.registerCallback[ReqBar](manageCallback(bar))

    manager.onTextMessage(socket, reqfoo(recurring = true, id = 0))
    manager.onTextMessage(socket, reqbar(recurring = true, id = 1))
    manager.onTextMessage(socket, cancelmsg(id = 0))

    assertTrue(foo.get)
    assertFalse(bar.get)
  }
}
