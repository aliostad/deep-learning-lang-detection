package chap7

object Main extends App {
  //ミックスインは定義時だけではなく、インスタンス化のタイミングで行うこともできます。
  val p = new Person("Yoko-chan") with Designer
  p.design
  p.coding
  
  val pm = new Person("Takamina") with ProjectManager
  pm.manage
  pm.coding
  
  /*
   * コンストラクタの実行順序を確認。
   * スーパークラスのコンストラクタ、自分自身のコンストラクタが呼ばれ、
   * その後ミックスインしている一番左のトレイトのコンストラクタから順番に呼ばれる
   */
  val c = new Child with A with B with C
  /*
    Parent
    Child
    trait A
    trait B
    trait C
   */  
}