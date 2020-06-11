package com.github.philwills.delimited

trait RowWritable[-T] {
  def write(row: T): Row
}

object RowWritable {
  implicit def tuple2Writable[T1,T2](implicit t1: FieldWritable[T1], t2: FieldWritable[T2]) = new RowWritable[(T1,T2)]{
    def write(row: (T1, T2)) = Seq(t1.write(row._1), t2.write(row._2))
  }
  implicit def tuple3Writable[T1,T2,T3](implicit t1: FieldWritable[T1], t2: FieldWritable[T2], t3:FieldWritable[T3]) =
    new RowWritable[(T1,T2,T3)]{
    def write(row: (T1,T2,T3)) = Seq(t1.write(row._1), t2.write(row._2), t3.write(row._3))
  }
  implicit def seqWritable[T](implicit t: FieldWritable[T]) = new RowWritable[Seq[T]] {
    def write(row: Seq[T]) = row map (t.write)
  }
}