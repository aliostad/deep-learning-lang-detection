////////////////////////////////////////////////////////////////////////////////
//                             [ Early Moose ]                                //
//                                                                            //
//           [process.scala]                                                  //
//                              https://github.com/Elesthor/Early-Moose       //
////////////////////////////////////////////////////////////////////////////////
//                                              \                             //
//                                               \   \_\_    _/_/             //
//                                                \      \__/                 //
//                                                  ---  (oo)\_______   /     //
//                                                       (__)\       )\/      //
//                                                           ||-----||        //
//                                                           ||     ||        //
////////////////////////////////////////////////////////////////////////////////


import scala.collection.mutable.SynchronizedQueue

class MetaProc(pLefta: Process, ka: Int, metaPRighta: Option[MetaProc])
{
  val pLeft = pLefta
  val k = ka
  val metaPRight = metaPRighta

  def retString(x: Int): String =
  {
    "| "*x+"MetaProc: (^"+k+")\n"+pLeft.retString(x+1)+
    (
      metaPRight match
      {
        case None         => ""
        case Some(pRight) => pRight.retString(x) // pas +1 pour ne pas faire apparaitre à la meme hauteur
      }
    )
  }
}

abstract class Process
{
  def retString (x: Int): String
  def replace(x: String , T: Term): Process
}

case class PTrivial() extends Process
{
  def retString(x: Int) = "| "*x+"•\n"
    //def retString (x: Int): String = "Trivial Process: 0"
  def replace(x: String , T: Term): Process = new PTrivial()
}
case class PIn (c: String, v: TVar, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PIn:\n"+"| "*(x+1)+c+"\n"+v.retString(x+1)+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PIn(c, v, p.replace(x,T))
  }
}
case class PInk(c: String, v: TVar, u: Term, y: TVar, k: Int, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PInk: "+k+"\n"+"| "*(x+1)+c+"\n"+v.retString(x+1)+u.retString(x+1)+y.retString(x+1)+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PInk(c, v, u.replace(x,T), y, k, p.replace(x,T))
  }
}
case class POut(c: String, t: Term, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"POut:\n"+"| "*(x+1)+c+"\n"+t.retString(x+1)+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new POut(c, t.replace(x,T), p.replace(x,T))
  }
}
case class PConnect(c: String, host: String, port: Int, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PConnect:\n"+"| "*(x+1)+c+"\n"+"| "*(x+1)+host+"\n"+"| "*(x+1)+port+"\n"+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PConnect(c, host, port, p.replace(x,T))
  }
}
case class PAccept(c: String, port: Int, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PAccept:\n"+"| "*(x+1)+c+"\n"+"| "*(x+1)+port+"\n"+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PAccept(c, port, p.replace(x,T))
  }
}
case class PClose(c: String, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PClose:\n"+"| "*(x+1)+c+"\n"+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PClose(c, p.replace(x,T))
  }
}
case class PWait(c: String, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PWait:\n"+"| "*(x+1)+c+"\n"+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PWait(c, p.replace(x,T))
  }
}
case class PIf (v: Term, pIf: Process, pElse: Process, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PIf:\n"+v.retString(x+1)+pIf.retString(x+1)+pElse.retString(x+1)+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PIf(v.replace(x,T), pIf.replace(x,T), pElse.replace(x,T), p.replace(x,T))
  }
}
case class PNew(s: VConst, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PNew:\n"+s.retString(x+1)+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PNew(s, p.replace(x,T))
  }
}

case class PAff(name: String, value: Term, p: Process) extends Process
{
  def retString(x: Int) = "| "*x+"PAff:\n"+"| "*(x+1)+name+value.retString(x+1)+p.retString(x)
  def replace(x: String , T: Term): Process =
  {
    new PAff(name, value.replace(x, T), p.replace(x,T))
  }
}

