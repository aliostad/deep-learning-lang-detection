/* 
 * LDIF
 *
 * Copyright 2011-2014 Universität Mannheim, MediaEvent Services GmbH & Co. KG
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ldif.local.runtime.impl

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FlatSpec
import org.scalatest.matchers.ShouldMatchers
import ldif.local.datasources.dump.DumpExecutor
import ldif.datasources.dump.{DumpModule, DumpConfig}

@RunWith(classOf[JUnitRunner])
class DumpExecutorTest extends FlatSpec with ShouldMatchers {

  val sourceUrl = "https://raw.github.com/wbsg/ldif/master/ldif/ldif-singlemachine/src/test/resources/integration/sources/source.nq"

  val executor = new DumpExecutor
  val qq = new QuadQueue

  /* Disabled - remote test */
//  it should "load remote file correctly" in {
//    executor.execute(task,null,qq)
//    qq.size should equal (8)
//  }

  private lazy val task = {
    val config = new DumpConfig(Traversable(sourceUrl))
    val module = new DumpModule(config)
    module.tasks.head
  }

}