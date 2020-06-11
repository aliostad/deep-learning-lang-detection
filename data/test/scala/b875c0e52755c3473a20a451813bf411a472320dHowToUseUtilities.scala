import jp.kobe_u.scarab._, dsl._

object HowToUseUtilities {
  
  /* 制約の定義 (例としてラングフォードペア) */
  def defineConst(n: Int) = {
    for (i <- 1 to 2 * n) int('x(i), 1, n)
    for (i <- 1 to n)
      add(Or(for (j <- 1 to 2 * n - i - 1) yield And(('x(j) === 'x(j + i + 1)), ('x(j) === i))))
  }
  
  /* SATソルバーの統計情報の出力 */
  def runWithStatistics = {
    defineConst(4)
    find
    println(solution)
    dumpStat // dumpStat("/tmp/test.stat") と引数を持たせればファイルへ統計情報を出力
    reset    
  }

  /* CNFの出力 (cnf出力用のソルバーを指定しなければならないことに注意) */
  def generateCNF = {
    use(new Sat4j("Dimacs")) // cnf出力用のソルバーの使用を
    defineConst(4)
    dumpCnf // dumpCnf("/tmp/test.cnf") と引数を持たせればファイルへCNF出力
    reset
  }
  
  def main(args: Array[String]) {
    runWithStatistics
    println
    generateCNF
  }
}