package com.github.mbauhardt.k2p

import org.scalatest.FunSuite

class SecuritySuite extends FunSuite {

  test("Dump Keychain") {
    val keychain = Security.dumpKeychain(s"/Users/${System.getProperty("user.name")}/Library/Keychains/login.keychain")
    assert(keychain.contains(s"/Users/${System.getProperty("user.name")}/Library/Keychains/login.keychain"))
  }

  test("List Keychains") {
    val keychains = Security.listKeychains()
    assert(keychains.contains("/Library/Keychains/System.keychain"))
    assert(keychains.contains(s"/Users/${System.getProperty("user.name")}/Library/Keychains/login.keychain"))
  }
}
