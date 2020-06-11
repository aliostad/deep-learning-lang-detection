package org.codeswarm.processenrich

/** Contains the stdout and stderr output from a process,
  * with each stream represented by an instance of `A`.
  *
  * @param out The standard output stream (stdout)
  * @param err The standard error stream (stderr).
  */
case class ProcessOutput[A](out: A, err: A) {

  /** Apply a transformation `A => B` to both `out` and `err`
    * and return the result as a new `ProcessOutput`.
    */
  def map[B](f: A => B): ProcessOutput[B] = new ProcessOutput[B](f(out), f(err))

}

object ProcessOutput {

  /** Constructs a `ProcessOutput` of type `Unit`.
    */
  def apply(): ProcessOutput[Unit] = apply((), ())

  /** Constructs a `ProcessOutput` of type `A` whose values
    * are each set by evaluating `f`.
    */
  def apply[A](f: () => A): ProcessOutput[A] = ProcessOutput(f(), f())

}