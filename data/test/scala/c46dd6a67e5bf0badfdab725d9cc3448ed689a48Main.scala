import scala.io.StdIn
import scala.collection.mutable.Stack

object Main {
  def main(args: Array[String]): Unit = {
    val s = StdIn.readLine
    val st = Stack[Array[String]]()
    var ans = Set[String]()

    st.push(Array(s, ""))
    while (!st.isEmpty) {
      val oldStr = st.top(0)
      val newStr = st.top(1)
      st.pop

      if (oldStr.length == 0) {
        ans += newStr
      } else {
        st.push(Array(oldStr.tail, newStr + oldStr.head))
        st.push(Array(oldStr.init, newStr + oldStr.last))
      }
    }

    println(ans.size)
  }
}
