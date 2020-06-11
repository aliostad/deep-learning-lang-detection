/* Copyright 2009-2015 EPFL, Lausanne */

package leon.web
package client
package react

import monifu.reactive.subjects._

import shared.messages._


/** Exposes those events as [[monifu.reactive.subjects.Subject]]. */
object Events {

  val repositoriesLoaded = PublishSubject[RepositoriesLoaded]() // dump "RepositoriesLoaded"
  val repositoryLoaded   = PublishSubject[RepositoryLoaded  ]() // dump "RepositoryLoaded"
  val fileLoaded         = PublishSubject[FileLoaded        ]() // dump "FileLoaded"
  val branchChanged      = PublishSubject[BranchChanged     ]() // dump "BranchChanged"
  val codeUpdated        = PublishSubject[CodeUpdated       ]() // dump "CodeUpdated"
  val gitProgress        = PublishSubject[GitProgress       ]() // dump "GitProgress"
  val gitOperationDone   = PublishSubject[GitOperationDone  ]() // dump "GitOperationDone"

}

