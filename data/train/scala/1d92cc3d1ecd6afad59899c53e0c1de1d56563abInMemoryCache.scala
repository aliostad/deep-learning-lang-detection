package name.neuhalfen.todosimple.test.di

import name.neuhalfen.todosimple.domain.application.Cache
import name.neuhalfen.todosimple.domain.model.{Event, AggregateRoot, UniqueId}


/**
 * In Memory cache for aggregate roots.
 *
 *
 * @tparam ENTITY the type of aggregate root to manage.
 */
class InMemoryCache[ENTITY  <: AggregateRoot[ENTITY, Event[ENTITY]]] extends Cache[ENTITY] {
  private val cache: scala.collection.mutable.Map[UniqueId[ENTITY], ENTITY] = scala.collection.mutable.Map.empty

  @Override
  def put(aggregate: ENTITY): Unit = {
    cache.put(aggregate.id, aggregate)
  }

  @Override
  def get(aggregateId: UniqueId[ENTITY]): Option[ENTITY] = {
    cache.get(aggregateId)
  }

}

