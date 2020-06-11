package rtmp

import java.security.{PrivateKey, PublicKey, KeyFactory, KeyPair}
import java.io.{FileInputStream, File}
import java.security.spec.{PKCS8EncodedKeySpec, X509EncodedKeySpec}

import akka.actor.ActorSystem
import akka.event.Logging

import com.typesafe.config.ConfigFactory
import com.typesafe.config.impl.SimpleConfigOrigin
import com.typesafe.config.impl.ConfigString

import rtmp.v2.Protocol
import rtmp.protocol.Response
import utils.HexBytesUtil
import rtmp.tests.StreamDumpReader


/**
 * Class used for reading dump packets sent by client.
 *
 * @param path
 */
class ClientDumpReader(path:String) extends StreamDumpReader(path, "in", "rtmp", 1) {

  
}

/**
 * Class used for reading dump of the packets sent by server as well as reading of the some 
 * server generated data ( keys, random bytes blocks ) 
 * 
 * @param path
 */
class ServerDumpReader(path:String) extends StreamDumpReader(path, "out", "rtmp", 1) {

  def loadRand1():Array[Byte] = {
    readBytes("hrand1.rtmp")
  }

  def loadRand2():Array[Byte] = {
    readBytes("hrand2.rtmp")
  }

  /**
   * Load key pair from file.
   *
   * @param path
   * @param algorithm             Needs to be "DH" for handshake keys.
   * @return
   */
  def loadKeyPair(path: String, algorithm: String): KeyPair = {


    val encodedPublicKey = readBytes("public.key")
    val encodedPrivateKey = readBytes("private.key")

    val keyFactory: KeyFactory = KeyFactory.getInstance("DH")

    val publicKeySpec: X509EncodedKeySpec = new X509EncodedKeySpec(encodedPublicKey)
    val publicKey: PublicKey = keyFactory.generatePublic(publicKeySpec)

    val privateKeySpec: PKCS8EncodedKeySpec = new PKCS8EncodedKeySpec(encodedPrivateKey)
    val privateKey: PrivateKey = keyFactory.generatePrivate(privateKeySpec)

    new KeyPair(publicKey, privateKey)
  }
}

/**
 *
 */
class Test {

  val clientDumpReader = new ClientDumpReader("dump")
  val serverDumpReader = new ServerDumpReader("dump")  
  
  val keyPair = serverDumpReader.loadKeyPair("dump", "DH")
  val rand1 = serverDumpReader.loadRand1()
  val rand2 = serverDumpReader.loadRand2()

  // val defaultConfig = ConfigFactory.load.getConfig("akka")
  // val config = defaultConfig.withValue("stdout-logleve", new ConfigString(SimpleConfigOrigin.newSimple(""),"DEBUG"))
  // val config = ConfigFactory.load("akka")
  // val config11 = ConfigFactory.load(classOf[Test].getClassLoader, "application.conf")
  // val config12 = ConfigFactory.load(classOf[Test].getClassLoader, "application")

  val config = ConfigFactory.load

  val system = ActorSystem("TestSystem", config)
  implicit val log = Logging.getLogger(system, this)

  log.info("RTMP Tests started")

  val protocol = new Protocol(keyPair, rand1, rand2)

  val handshake_in_1 = clientDumpReader.readPacket()
  val handshake_out_1 = serverDumpReader.readPacket()

  assertOutput("Handshake", protocol.handshake, handshake_in_1, handshake_out_1)

  // protocol.handshake(handshake_in_1)

  /**
   * Execute protocol handler and ensure that encoded response is equals to the loaded from dump file.
   *
   * @param f               Protocol handler method
   * @param in_bytes        Input bytes ( sent by client )
   * @param out_bytes       Output bytes ( sent by server as are result of the processing client request )
   */
  def assertOutput(stepName:String, f: (Array[Byte]) => Response, in_bytes: Array[Byte], out_bytes: Array[Byte] ) = {

    log.info("Test: {}", stepName)

    val response = f(in_bytes)
    val respData = response.serialize()
    val respBytes = respData.toArray

    if (log.isDebugEnabled) {
      log.debug("Response: {}", HexBytesUtil.bytes2hex(respBytes))
    }

    if (!java.util.Arrays.equals(respBytes, out_bytes)) {

      if (log.isDebugEnabled) {
        log.debug("Math:     {}", HexBytesUtil.bytes2hex(out_bytes))
      }

      throw new java.lang.AssertionError("Assertion failed. Generated response do not match to test.")
    }

    log.info("Test: {}\t\t [PASSED]", stepName)
  }
}
