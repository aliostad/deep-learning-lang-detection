package chap7

/**
 * トレイトは、メソッドだけではなくフィールドも持てます。さらに、本体にコードを書けば
 * コンストラクタ処理もできます。しかし、基本コンストラクタに渡すためのパラメータは取れず、
 * 補助コンストラクタの定義ができない点に注意してください。
 */
trait ProjectManager {
  val budget:Int = 10000000
  println("budget=" + budget)
  def manage = println("プロジェクト管理します")
}