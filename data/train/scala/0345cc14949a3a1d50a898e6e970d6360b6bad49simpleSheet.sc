def binary(arr: Array[Int], l: Int, r: Int, rank: Int): Int = {
  println(l,r,rank)
  if (rank == 0) return l
  if (l == r) return -1
  val mid = arr((l+r)/2)
  def pos():Int = {
    var li = 0
    var ri = r
    var tmp = mid
    while (ri > li){
      while(arr(ri) > mid && ri > li) ri -= 1
      if (ri > li) {
        val old = tmp
        tmp = arr(ri)
        arr(ri) = old
      }

      while(arr(li) < mid && ri > li) li += 1
      if (ri > li) {
        val old = tmp
        tmp = arr(li)
        arr(li) = old
      }
    }
    li
  }
  val mp = pos()
  if (mp > rank) binary(arr, l, mp, rank) else binary(arr, mp, r , rank - mp)
}

binary(Array[Int](2,4,6,5,3,1),0,5,2 )

