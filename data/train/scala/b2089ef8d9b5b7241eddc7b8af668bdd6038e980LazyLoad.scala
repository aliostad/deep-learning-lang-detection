package com.googlecode.mapperdao

import com.googlecode.mapperdao.schema.{ColumnInfoRelationshipBase, ColumnInfoBase}

/**
 * LazyLoad configuration. Please look at the companion object
 *
 * @author kostantinos.kougios
 *
 *         18 Apr 2012
 */
abstract class LazyLoad
{
	// if true, all relationships will be lazy-loaded
	def all: Boolean

	// specify which relationships to lazy load, i.e. Set(ProductEntity.attributes) // will lazy load attributes
	def lazyLoaded: Set[ColumnInfoRelationshipBase[_, _, _, _]]

	def isLazyLoaded(ci: ColumnInfoBase[_, _]) = all || (ci match {
		case ci: ColumnInfoRelationshipBase[_, _, _, _] =>
			lazyLoaded.contains(ci)
		case _ => false
	})

	def isAnyColumnLazyLoaded(cis: Set[ColumnInfoRelationshipBase[_, _, _, _]]) = all || !lazyLoaded.intersect(cis).isEmpty
}

case object LazyLoadNone extends LazyLoad
{
	val all = false
	val lazyLoaded = Set[ColumnInfoRelationshipBase[_, _, _, _]]()
}

case object LazyLoadAll extends LazyLoad
{
	val all = true
	val lazyLoaded = Set[ColumnInfoRelationshipBase[_, _, _, _]]()
}

case class LazyLoadSome(lazyLoaded: Set[ColumnInfoRelationshipBase[_, _, _, _]]) extends LazyLoad
{
	val all = false
}

/**
 * allows configuring which of the related data will be lazy loaded. This is typically used
 * within a SelectConfig, i.e. SelectConfig(lazyLoad=LazyLoad.all)
 */
object LazyLoad
{
	// dont lazy load anything
	val none = LazyLoadNone
	// lazy load all related entities
	val all = LazyLoadAll

	// Lazy load some of the related data.
	// Specifies which relationships to lazy load, i.e. Set(ProductEntity.attributes) // will lazy load attributes
	def some(lazyLoaded: Set[ColumnInfoRelationshipBase[_, _, _, _]]): LazyLoad = LazyLoadSome(lazyLoaded = lazyLoaded)

	def apply(lazyLoaded: ColumnInfoRelationshipBase[_, _, _, _]*): LazyLoad = LazyLoadSome(lazyLoaded = lazyLoaded.toSet)
}