/* Copyright 2009-2015 EPFL, Lausanne */

package leon.web
package client
package react

import monifu.reactive.subjects._

import shared.messages._

/** Exposes those events as [[monifu.reactive.subjects.Subject]]. */
object Events {

  final val repositoriesLoaded = PublishSubject[RepositoriesLoaded]() // dump "RepositoriesLoaded"
  final val repositoryLoaded   = PublishSubject[RepositoryLoaded  ]() // dump "RepositoryLoaded"
  final val fileLoaded         = PublishSubject[FileLoaded        ]() // dump "FileLoaded"
  final val branchChanged      = PublishSubject[BranchChanged     ]() // dump "BranchChanged"
  final val codeUpdated        = PublishSubject[CodeUpdated       ]() // dump "CodeUpdated"
  final val gitProgress        = PublishSubject[GitProgress       ]() // dump "GitProgress"
  final val gitOperationDone   = PublishSubject[GitOperationDone  ]() // dump "GitOperationDone"
  final val userUpdated        = PublishSubject[UserUpdated       ]() // dump "UserUpdated"

}

