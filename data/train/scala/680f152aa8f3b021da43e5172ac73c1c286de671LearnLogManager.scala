package dadacore.learnlog

/** LearnLogManager used to manage [[dadacore.learnlog.LearnLogReader]]s and [[dadacore.learnlog.LearnLogWriter]]s
  * used to initialize model initially and for subsequent writing new text to the same log.
  */
trait LearnLogManager {
  /**
   * Return reader to read all learn log from starting
   * @return reader that allows to iterate over learn log from its start
   */
  def reader:LearnLogReader

  /**
   * Return writer to write to learn log
   * @return writer that allows to append to learn log
   */
  def writer:LearnLogWriter
}
