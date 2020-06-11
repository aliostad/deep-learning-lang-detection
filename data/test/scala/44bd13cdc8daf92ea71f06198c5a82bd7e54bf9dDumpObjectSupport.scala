/*
 * Copyright 2013 Akiyoshi Sugiki, University of Tsukuba
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package kumoi.shell.dump

import kumoi.shell.aaa._
import java.rmi._
import kumoi.shell.cache._


/**
 * Dump support for the first-class objects.
 * 
 * @author Akiyoshi SUGIKI
 */
@remote trait DumpObjectSupport extends Remote {
	@nocache def dump(path: String)(implicit auth: AAA): String
}