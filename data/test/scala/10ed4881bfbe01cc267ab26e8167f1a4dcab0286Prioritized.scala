package com.googlecode.mapperdao.state.prioritise

import com.googlecode.mapperdao._
import state.persistcmds._
import state.persistcmds.EntityRelatedCmd
import state.persistcmds.ExternalEntityRelatedCmd
import com.googlecode.mapperdao.schema.{OneToOneReverse, OneToOne, ManyToOne, OneToMany}

/**
 * prioritized cmds
 *
 * @author: kostas.kougios
 *          Date: 04/01/13
 */
case class Prioritized(
	high: List[List[PersistCmd]],
	low: List[PersistCmd],
	lowest: List[PersistCmd],
	related: List[RelatedCmd],
	dependent: List[DependsCmd]
	)
{
	private val relatedById = related.filter(_.newVM != null).groupBy(_.newVM) ++ (
		related.filterNot(_.oldVMO == None).groupBy(_.oldVMO.get)
		)

	def relatedFor(vm: ValuesMap) = relatedById.getOrElse(vm, Nil)

	def relatedColumns(vm: ValuesMap, applyOnOldValue: Boolean) = relatedFor(vm).map {
		case EntityRelatedCmd(_, column, newVM, _, foreignTpe, foreignVM, oldForeignVMO, _) =>
			column match {
				case ManyToOne(_, columns, foreign) =>
					columns zip (
						if (applyOnOldValue) {
							val fvm = oldForeignVMO.getOrElse(foreignVM)
							fvm match {
								case null => Prioritized.nullList
								case ovm => ovm.toListOfPrimaryKeys(foreignTpe)
							}
						}
						else {
							if (foreignVM == null)
								Prioritized.nullList
							else {
								foreignVM.toListOfPrimaryKeys(foreignTpe)
							}
						}
						)
				case OneToMany(_, foreign, foreignColumns) =>
					if (applyOnOldValue) {
						val fvm = oldForeignVMO.getOrElse(foreignVM)
						foreignColumns zip fvm.toListOfPrimaryKeys(foreignTpe)
					} else {
						foreignColumns zip foreignVM.toListOfPrimaryKeys(foreignTpe)
					}
				case OneToOne(_, foreign, selfColumns) =>
					selfColumns zip (
						if (applyOnOldValue) {
							val fvm = oldForeignVMO.getOrElse(foreignVM)
							fvm match {
								case null => Prioritized.nullList
								case ovm => ovm.toListOfPrimaryKeys(foreignTpe)
							}
						}
						else {
							if (foreignVM == null)
								Prioritized.nullList
							else {
								foreignVM.toListOfPrimaryKeys(foreignTpe)
							}
						}
						)
				case OneToOneReverse(_, foreign, foreignColumns) =>
					foreignColumns zip (
						if (applyOnOldValue) {
							val fvm = oldForeignVMO.getOrElse(foreignVM)
							fvm match {
								case null => Prioritized.nullList
								case ovm =>
									ovm.toListOfPrimaryKeys(foreignTpe)
							}
						}
						else {
							if (foreignVM == null)
								Prioritized.nullList
							else {
								foreignVM.toListOfPrimaryKeys(foreignTpe)
							}
						}
						)
			}
		case ExternalEntityRelatedCmd(_, column, _, _, foreignTpe, foreignKeys, oldForeignKeys) =>
			column match {
				case ManyToOne(_, columns, foreign) =>
					if (applyOnOldValue)
						if (oldForeignKeys.isDefined)
							columns zip oldForeignKeys.get
						else Nil
					else
						columns zip foreignKeys
			}
	}.flatten

	def relatedKeys(vm: ValuesMap) = {
		val rel = relatedFor(vm)
		rel.collect {
			case EntityRelatedCmd(_, column, newVM, _, foreignTpe, foreignVM, oldForeignVMO, true) =>
				column match {
					case OneToMany(_, foreign, foreignColumns) =>
						val fks = foreignColumns zip foreignVM.toListOfPrimaryKeys(foreignTpe)
						fks
					case OneToOneReverse(_, foreign, foreignColumns) =>
						val fks = if (foreignVM == null)
							foreignColumns zip Prioritized.nullList
						else
							foreignColumns zip foreignVM.toListOfPrimaryKeys(foreignTpe)
						fks
					case OneToOne(_, foreign, selfColumns) =>
						val fVM = oldForeignVMO.getOrElse(foreignVM)
						val fks = if (fVM == null)
							selfColumns zip Prioritized.nullList
						else
							selfColumns zip fVM.toListOfPrimaryKeys(foreignTpe)
						fks
				}
		}.flatten
	}
}

object Prioritized
{
	private val nullList = List(null, null, null, null)
}
