
package spatial.ros

import forge._
import org.virtualized._
import spatial.ros.codegen.scalagen.RosScalaCodegen

trait FileWriteApi extends FileWriteExp {
  self: RosApi =>

}

trait FileWriteExp {
  self: RosExp =>
  
  implicit object FileWriteType extends Meta[FileWrite] {
    def wrapped(x: Exp[FileWrite]) = FileWrite(x)
    def stagedClass = classOf[FileWrite]
    def isPrimitive = false
  }

  implicit object FileWriteSrv extends Srv[FileWrite] {
    type Response = FileWriteRep
    def response(srv: FileWrite) = srv.response
  }

  implicit object FileWriteRepType extends Meta[FileWriteRep] {
    def wrapped(x: Exp[FileWriteRep]) = FileWriteRep(x)
    def stagedClass = classOf[FileWriteRep]
    def isPrimitive = false
  }

  case class FileWrite(s: Exp[FileWrite]) extends MetaAny[FileWrite] {
    @api def file_path: Text = Text(stage(FileWrite_file_path(s))(ctx))
    @api def offset: FixPt[FALSE,_64,_0] = FixPt(stage(FileWrite_offset(s))(ctx))
    @api def data: MetaArray[FixPt[FALSE,_8,_0]] = MetaArray(stage(FileWrite_data(s))(ctx))
    @api def response: FileWriteRep = FileWriteRep(stage(FileWriteReply(s))(ctx))
    @api def ===(that: FileWrite): Bool = ???
    @api def =!=(that: FileWrite): Bool = ???
    @api def toText: Text = textify(this)
  }

  case class FileWriteRep(s: Exp[FileWriteRep]) extends MetaAny[FileWriteRep] {
    @api def success: Bool = Bool(stage(FileWriteRep_success(s))(ctx))
    @api def r_errno: FixPt[TRUE,_32,_0] = FixPt(stage(FileWriteRep_r_errno(s))(ctx))
    @api def ===(that: FileWriteRep): Bool = ???
    @api def =!=(that: FileWriteRep): Bool = ???
    @api def toText: Text = textify(this)
  }

  
case class FileWrite_file_path(msg: Exp[FileWrite]) extends Op[Text] {
  def mirror(f: Tx) = stage(FileWrite_file_path(f(msg)))(EmptyContext)
}

  
case class FileWrite_offset(msg: Exp[FileWrite]) extends Op[FixPt[FALSE,_64,_0]] {
  def mirror(f: Tx) = stage(FileWrite_offset(f(msg)))(EmptyContext)
}

  
case class FileWrite_data(msg: Exp[FileWrite]) extends Op[MetaArray[FixPt[FALSE,_8,_0]]] {
  def mirror(f: Tx) = stage(FileWrite_data(f(msg)))(EmptyContext)
}

  
case class FileWriteRep_success(srv: Exp[FileWriteRep]) extends Op[Bool] {
  def mirror(f: Tx) = stage(FileWriteRep_success(f(srv)))(EmptyContext)
}

  
case class FileWriteRep_r_errno(srv: Exp[FileWriteRep]) extends Op[FixPt[TRUE,_32,_0]] {
  def mirror(f: Tx) = stage(FileWriteRep_r_errno(f(srv)))(EmptyContext)
}

  case class FileWriteReply(srv: Exp[FileWrite]) extends Op[FileWriteRep]{
    def mirror(f: Tx) = stage(FileWriteReply(f(srv)))(EmptyContext)
  }
  case class NewFileWrite(file_path: Exp[Text], offset: Exp[FixPt[FALSE,_64,_0]], data: Exp[MetaArray[FixPt[FALSE,_8,_0]]]) extends Op[FileWrite] {
    def mirror(f: Tx) = stage(NewFileWrite(f(file_path), f(offset), f(data)))(EmptyContext)
  }

  
  object FileWrite {

  @api def apply(file_path: Text, offset: FixPt[FALSE,_64,_0], data: MetaArray[FixPt[FALSE,_8,_0]]): FileWrite = FileWrite(stage(NewFileWrite(file_path.s, offset.s, data.s))(ctx))
  }

  object FileWriteRep {

  }

}

trait ScalaGenFileWrite extends RosScalaCodegen {
  val IR: RosExp
  import IR._

  override protected def emitNode(lhs: Sym[_], rhs: Op[_]): Unit = rhs match {
    case FileWrite_file_path(msg) => emit(src"val $lhs = $msg.file_path")
    case FileWrite_offset(msg) => emit(src"val $lhs = $msg.offset")
    case FileWrite_data(msg) => emit(src"val $lhs = $msg.data")
    case FileWriteRep_success(msg) => emit(src"val $lhs = $msg.success")
    case FileWriteRep_r_errno(msg) => emit(src"val $lhs = $msg.r_errno")
    case NewFileWrite(file_path, offset, data) =>
      emit(src"val $lhs = FileWrite($file_path, $offset, $data)")
    case FileWriteReply(srv) =>
      emit(src"val $lhs = $srv.response")
    case _ => super.emitNode(lhs, rhs)
  }

}

