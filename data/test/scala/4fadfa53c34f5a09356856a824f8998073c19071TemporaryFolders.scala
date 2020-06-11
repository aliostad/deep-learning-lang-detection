package com.dreizak.tgv.infrastructure.testing

import org.junit.Rule
import org.junit.rules.TemporaryFolder
import org.scalatest.Suite

/**
 * Temporary folders for ScalaTest test suites, deleted automatically after the test.
 *
 * Provides an implicit `temporaryFolder` from which you can create new temporary folders.
 * Any folders will be deleted at the end of the test.
 *
 * This uses <a href='http://www.junit.org'>JUnit</a> rules as described for instance in
 * <a href='http://garygregory.wordpress.com/2010/01/20/junit-tip-use-rules-to-manage-temporary-files-and-folders/'>this
 * blog post</a>.
 */
trait TemporaryFolders {
  self: Suite =>

  @Rule
  implicit val testFolder = new TemporaryFolder()
}