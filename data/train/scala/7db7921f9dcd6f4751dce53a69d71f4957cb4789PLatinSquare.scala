import jp.kobe_u.scarab._, dsl._

object PLatinSquare {

  /* (制約定義) 汎対角線ラテン方陣 */
  def defineConst(n: Int, ad: Seq[Var] => Constraint) {
    for (i <- 1 to n; j <- 1 to n) int('x(i, j), 1, n)
    for (i <- 1 to n) {
      add(ad((1 to n).map(j => 'x(i, j))))
      add(ad((1 to n).map(j => 'x(j, i))))
      add(ad((1 to n).map(j => 'x(j, (i + j - 1) % n + 1))))
      add(ad((1 to n).map(j => 'x(j, (i + (j - 1) * (n - 1)) % n + 1))))
    }
  }
  /* 素朴なalldiff */
  def naiveAllDifferent(vs: Seq[Var]) = And(for (Seq(x, y) <- vs.combinations(2)) yield x !== y)
  /* 良いalldiff */
  def betterAllDifferent(vs: Seq[Var]) = alldiff(vs)

  /* 問題を解き，統計情報を標準出力に表示するサンプル */
  def run(n: Int, ad: Seq[Var] => Constraint) {
    defineConst(n,ad)
    find
    dumpStat // dumpStat("/tmp/test.stat") と引数を持たせればファイルへ統計情報を出力
    reset
  }
  
  /* 符号化されたSAT問題を標準出力に表示するサンプル */  
  def cnf(n: Int, ad: Seq[Var] => Constraint) {
    use(new Sat4j("Dimacs"))
    defineConst(n,ad)
    dumpCnf // dumpCnf("/tmp/test.cnf") と引数を持たせればファイルへCNF出力
    reset
  }
  

  def main(args: Array[String]) {
    run(7,naiveAllDifferent)
    println
    cnf(7,naiveAllDifferent)
    
//    run(7,betterAllDifferent)    
//    println    
//    cnf(7,betterAllDifferent)
  }

}