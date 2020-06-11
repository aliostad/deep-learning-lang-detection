package lehel.dsl

import cats.free.Free
import lehel.model.Processes.{ProcessSystem, RunningProcessSystem}
import lehel.model.{Path, Side}

object Commands {
  sealed trait Command[A]
  case class SetCurrentSide(newSide: Side) extends Command[Unit]
  case object GetCurrentSide extends Command[Side]
  case class GetCurrentPath(side: Side) extends Command[Path]
  case class SetCurrentPath(side: Side, newPath: Path) extends Command[Unit]
  case class DefineProcess(process: String, args: Seq[String]) extends Command[ProcessSystem]
  case class PipeProcess(existingProcess: ProcessSystem, process: String, args: Seq[String]) extends Command[ProcessSystem]
  case class PipeCode(existingProcess: ProcessSystem, code: String) extends Command[ProcessSystem]
  case class ExecuteProcess(process: ProcessSystem) extends Command[RunningProcessSystem]
  case class Evaluate[TResult](code: String, evaluable: Evaluable[TResult]) extends Command[TResult]
  case object Exit extends Command[Unit]

  def setCurrentSide(newSide: Side): Free[Command, Unit] = Free.liftF(SetCurrentSide(newSide))
  def getCurrentSide(): Free[Command, Side] = Free.liftF(GetCurrentSide)
  def getCurrentPath(side: Side): Free[Command, Path] = Free.liftF(GetCurrentPath(side))
  def setCurrentPath(side: Side, newPath: Path): Free[Command, Unit] = Free.liftF(SetCurrentPath(side, newPath))
  def defineProcess(process: String, args: String*): Free[Command, ProcessSystem] = Free.liftF(DefineProcess(process, args))
  def pipeProcess(existingProcess: ProcessSystem, process: String, args: String*): Free[Command, ProcessSystem] = Free.liftF(PipeProcess(existingProcess, process, args))
  def pipeCode(existingProcess: ProcessSystem, code: String): Free[Command, ProcessSystem] = Free.liftF(PipeCode(existingProcess, code))
  def executeProcess(process: ProcessSystem): Free[Command, RunningProcessSystem] = Free.liftF(ExecuteProcess(process))
  def evaluate[TResult](code: String)(implicit evaluable: Evaluable[TResult]): Free[Command, TResult] =
    Free.liftF(Evaluate(code, evaluable))
  def exit(): Free[Command, Unit] = Free.liftF(Exit)
}
