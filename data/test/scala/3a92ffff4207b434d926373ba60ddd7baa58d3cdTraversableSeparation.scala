package com.googlecode.mapperdao.internal

import com.googlecode.mapperdao._
import java.util

/**
 * compares 2 traversables via object reference equality and returns
 * (added,intersect,removed)
 *
 * @author kostantinos.kougios
 *
 *         6 Sep 2011
 */
protected[mapperdao] object TraversableSeparation
{
	def separate[ID, T](entity: EntityBase[ID, T], oldTraversable: Traversable[T], newTraversable: Traversable[T]) = {
		// find replacements
		val (oldWithReplacement, oldT) = oldTraversable.partition {
			case p: Persisted if p.mapperDaoReplaced.isDefined => true
			case _ => false
		}
		val replacements = oldWithReplacement.asInstanceOf[Traversable[Persisted]].map(_.mapperDaoReplaced.get)

		val rm = new util.IdentityHashMap[Any, Any]
		replacements.foreach {
			r =>
				rm.put(r, r)
		}
		val newT = newTraversable.filterNot {
			t =>
				rm.containsKey(t)
		}

		val replaced = oldWithReplacement.toList.zip(replacements.toList)

		if (oldT.isEmpty)
			(newT, replaced, Nil)
		else if (newT.isEmpty)
			(Nil, replaced, oldT)
		else {
			// now separate the rest
			val (oldM, newM) = oldT.head match {
				case _: SimpleTypeValue[T, _] =>
					val eq = new EntityComparisonMap.ByObjectEquals[T]
					(new EntityComparisonMap(entity, eq), new EntityComparisonMap(entity, eq))
				case _ =>
					val eq = new EntityComparisonMap.EntityEquals(entity)
					(new EntityComparisonMap(entity, eq), new EntityComparisonMap(entity, eq))

			}
			oldM.addAll(oldT)
			newM.addAll(newT)

			val added = newT.filterNot(oldM.contains(_))
			val intersect = oldT.filter(newM.contains(_)).map(ot => (ot, newM(ot))) ++ replaced
			val removed = oldT.filterNot(newM.contains(_)).map(ot => ot.asInstanceOf[T with DeclaredIds[ID]])

			(added, intersect, removed)
		}
	}
}
