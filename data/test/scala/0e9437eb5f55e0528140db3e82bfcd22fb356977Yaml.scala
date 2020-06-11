/*
 * Copyright 2012 Metamarkets Group Inc.
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

package com.metamx.common.scala

import com.metamx.common.scala.Predef._
import java.io.InputStream
import java.io.Reader
import java.io.Writer
import java.{util => ju}
import org.yaml.snakeyaml.DumperOptions
import org.yaml.{snakeyaml => snake}

import untyped.normalizeJava

object Yaml {

  def load(in: InputStream)                   : Any = load(in, create)
  def load(in: Reader)                        : Any = load(in, create)
  def load(in: String)                        : Any = load(in, create)
  def load(in: InputStream, yaml: snake.Yaml) : Any = yaml.load(in)
  def load(in: Reader,      yaml: snake.Yaml) : Any = yaml.load(in)
  def load(in: String,      yaml: snake.Yaml) : Any = yaml.load(in)

  def dump(x: Any)                                : String = dump(x,      create)
  def dump(x: Any, out: Writer)                   : Unit   = dump(x, out, create)
  def dump(x: Any,              yaml: snake.Yaml) : String = yaml.dump(normalizeJava(stripSharing(x))).stripLineEnd
  def dump(x: Any, out: Writer, yaml: snake.Yaml) : Unit   = yaml.dump(normalizeJava(stripSharing(x)), out)

  def pretty(x: Any)              : String = dump(x,      createPretty)
  def pretty(x: Any, out: Writer) : Unit   = dump(x, out, createPretty)

  def create       = new snake.Yaml
  def createPretty = new snake.Yaml(new DumperOptions withEffect { opts =>
    opts.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK)
  })

  // HACK: snakeyaml dumps shared structure (e.g. { val x = new ju.ArrayList; List(x,x) }) using
  // anchors (&*), which is never what we want in our use cases. I can't find anything in
  // DumperOptions to control this, so we simply strip all shared structure by converting to json
  // and back.
  def stripSharing(x: Any): Any = Jackson.normalize(x)

}
