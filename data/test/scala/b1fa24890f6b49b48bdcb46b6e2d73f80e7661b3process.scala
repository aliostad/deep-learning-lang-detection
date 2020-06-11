//
// Copyright (c) 2015 IronCore Labs
//
package com.ironcorelabs.davenport
package syntax

import scalaz.concurrent.Task
import scalaz.stream.Process
import db.DBOps
import datastore.Datastore

// The convention is for syntax objects to start with lower case, so they look
// like package names. Scalastyle doesn't care for this, so ignore the line.
final object process extends ProcessOps // scalastyle:ignore

trait ProcessOps {
  implicit class OurProcessOps[M[_], A](self: Process[M, A]) {
    def execute(d: Datastore)(implicit ev: Process[M, A] =:= Process[DBOps, A]): Process[Task, A] =
      d.executeP(self)
  }
}
