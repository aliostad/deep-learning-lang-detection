package inai.adapter.past

import inai.adapter.Print

object PrintOldBanner {
  /**
   * 文字列からインスタンスを生成する
   */
  def printer(string: String): Print = {
    val b = new OldBanner(string)
    new PrintOldBanner(b)
  }
  /**
   * XMLの msg からインスタンスを生成する
   */
  def printer(xml: scala.xml.Elem): Print = {
    val msg = xml \ "@msg"
    printer(msg.headOption.getOrElse("").toString())
  }
}
class PrintOldBanner(banner: OldBanner) extends Print {
  def printStrong = banner.withAster
  def printWeak = banner.withParen
}
