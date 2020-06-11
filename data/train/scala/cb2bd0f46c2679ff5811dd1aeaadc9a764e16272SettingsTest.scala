package no.digipost.labs

import org.scalatest.FunSuite
import Settings._

class SettingsTest extends FunSuite {

  test("Settings should load config for default environment when no env key is specified") {
    val settings = Settings.load()
    assert(settings.environment === "development")
  }

  test("Settings should load config for specified environment") {
    assert(Settings.load(Prod).environment === "production")
    assert(Settings.load(Test).environment === "test")
    assert(Settings.load().environment === "development")
  }

}
