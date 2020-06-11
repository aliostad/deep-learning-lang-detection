package fr.ign.rjmcmc4s.rjmcmc.visitor

import fr.ign.rjmcmc4s.configuration.Configuration
import fr.ign.rjmcmc4s.rjmcmc.sampler.Sampler

class CompositeVisitor (val visitors: Seq[Visitor]) extends Visitor {
  def init(dump: Int, save: Int) = visitors.map(v=>v.init(dump, save))
  def begin(config: Configuration, sampler: Sampler) = visitors.map(v=>v.begin(config, sampler))
  def visit(config: Configuration, sampler: Sampler) = visitors.map(v=>v.visit(config, sampler))
  def end(config: Configuration, sampler: Sampler) = visitors.map(v=>v.end(config, sampler))
}
