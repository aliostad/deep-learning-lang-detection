package jozepoko.stock_trader.core.domain.service.util.shell

import java.io.File
import scala.sys.process._

/**
 * シェルコマンドを実行するよ
 */
class ShellCommandExecutor {
  /**
   * シェルコマンドを実行する。
   * @param command 実行したいコマンド
   * @param currentDirectory コマンドを実行したいディレクトリ
   * @return コマンドの実行結果の標準出力 or 標準エラー出力
   */
  def exec(command: String, currentDirectory: File = new File(".")): Either[String, String] = {
    val process = Process(command, currentDirectory)
    runProcess(process)
  }

  def execWithSpecialCaracter(command: String, currentDirectory: File = new File(".")): Either[String, String] = {
    val process = Process(List("sh", "-c", command), currentDirectory)
    runProcess(process)
  }

  def sendMail(echoCommand: String, emailCommand: String): Either[String, String] = {
    val echoProcess = Process(echoCommand.replace("\n", "\\n"))
    runProcess(echoProcess)
    val emailProcess = Process(emailCommand)
    val process = echoProcess #| emailProcess
    runProcess(process)
  }

  private[this] def runProcess(process: ProcessBuilder): Either[String, String] = {
    val stdout = new StringBuilder
    val stderr = new StringBuilder
    val result = process.run(ProcessLogger(
      (o: String) => stdout.append(o + "\n"),
      (e: String) => stderr.append(e + "\n")
    ))
    result.exitValue() match {
      case 0 => Right(stdout.result())
      case _ => Left(stderr.result())
    }
  }
}
