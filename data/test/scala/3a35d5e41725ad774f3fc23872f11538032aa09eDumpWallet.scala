package com.wlangiewicz

import java.io.File
import org.bitcoinj.core.Wallet

/**
 * DumpWallet loads a serialized wallet and prints information about what it contains.
 * It contains public and private keys and addresses.
 *
 * Usage:
 *    sbt "run-main com.wlangiewicz.DumpWallet /home/w/bitcoinj/examples/forwarding-service.wallet"
 *
 */
object DumpWallet extends App {
  def performDump(path: String): Unit = {
    val wallet: Wallet = Wallet.loadFromFile(new File(path))
    Console.println(wallet.toString(true, true, true, null))
  }

  override def main(args: Array[String]): Unit = {
    if (args.length != 1) {
      Console.println("Usage: scala DumpWallet <path>")
    }
    else {
      performDump(args(0))
    }
  }
}
