package com.ambiata.ivory.operation.debug

import org.specs2._
import com.ambiata.ivory.core._
import com.ambiata.ivory.core.arbitraries.Arbitraries._

class DumpFactsMapperSpec extends Specification with ScalaCheck { def is = s2"""

  accept always allows facts if entities and attributes are empty    $passthrough
  allows facts if entities match and attributes are empty            $entities
  allows facts if attributes match and entities are empty            $attributes
  block facts if entities don't match and attributes are empty       $noentities
  block facts if attributes don't match and entities are empty       $noattributes

  render contains all details (excepting value)                      $render
  render contains value details                                      $value
  renderWith uses the optimizing buffer                              $buffer

"""

  def passthrough = prop((f: Fact, s: String) =>
    DumpFactsMapper(Set(), Set(), s).accept(f) ==== true)

  def entities = prop((f: Fact, s: String, entities: Set[String]) =>
    DumpFactsMapper(entities + f.entity, Set(), s).accept(f) ==== true)

  def attributes = prop((f: Fact, s: String, attributes: Set[String]) =>
    DumpFactsMapper(Set(), attributes + f.featureId.toString, s).accept(f) ==== true)

  def noentities = prop((f: Fact, s: String, entities: Set[String]) => (!entities.contains(f.entity) && !entities.isEmpty)==> {
    DumpFactsMapper(entities, Set(), s).accept(f) ==== false })

  def noattributes = prop((f: Fact, s: String, attributes: Set[String]) => (!attributes.contains(f.featureId.toString) && !attributes.isEmpty) ==> {
    DumpFactsMapper(Set(), attributes, s).accept(f) ==== false })

  def render = prop((f: Fact, s: String) => {
    val r = DumpFactsMapper(Set(), Set(), s).render(f)
    (r.contains(f.entity),
     r.contains(f.namespace.name.toString),
     r.contains(f.feature),
     r.contains(f.datetime.localIso8601),
     r.contains(s)) ==== ((true, true, true, true, true)) })

  def value = prop((f: Fact, s: String, n: Int) => {
    val r = DumpFactsMapper(Set(), Set(), s).render(f.withValue(IntValue(n)))
    r.contains(n.toString) ==== true })

  def buffer = prop((f: Fact, s: String) => {
    val buffer = new StringBuilder
    DumpFactsMapper(Set(), Set(), s).renderWith(f, buffer)
    buffer.size > 0 })
}
