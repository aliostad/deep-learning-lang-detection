import com.persist.Units._
import com.persist.Mults._
//
//
meter(5).show
centi(meter)(3).show
foot(3).show
micro(farad).show
//
//
meter(3.2) in centi(meter)
per(mile,hour)(60) in per(foot,second)
cube(meter) in tablespoon
//
//
per(mega(bit)(10),second).show
per(tera(bit),square(inch)).show
per(cent(8),gallon) in per(dollar,cube(yard))
per(dollar(5.35),pound) in per(cent,ounce)
//
//
(dollar(10)+cent(12)).show
(foot(3)+inch(3)).show
(10.3 * second).show
(kilo(meter)(50)/hour).show
per(meter,foot(3)).show
per(meter,foot(3)) in one
//
//
val area = square(meter)
def Rectange(v: area.typ, v1: meter.typ) = {
  v * v1
}
Rectange(square(meter)(5),centi(meter)(7)).show
//
//
//dollar(4) + bit(5);  // will cause ct error
