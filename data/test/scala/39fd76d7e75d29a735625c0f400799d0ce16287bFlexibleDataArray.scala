/*
 *  Part of Blackboard spreadsheet. ©2010 Andrew Forrest. See LICENSE file for details.
 */
package net.dysphoria.blackboard.ui

import scala.collection.mutable
import net.dysphoria.blackboard._
import data.{types=>t}

class FlexibleDataArray(initialDims: Seq[ArrayAxis]) extends DataArray {
	val elementType = t.core.String

	private var _dimensions: Array[ArrayAxis] = initialDims.toArray
	private var _data = new IntArrayHashTable

	def dimensions = _dimensions

	def addDimension(dim: ArrayAxis){
		require(!(_dimensions contains dim))
		val oldNumberOfDims = _dimensions.length
		val newNumberOfDims = oldNumberOfDims + 1
		_dimensions = _dimensions ++ Some(dim)

		remapDimensions(oldK => {
			val newK = new Array[Int](newNumberOfDims)
			Array.copy(oldK, 0, newK, 0, oldNumberOfDims)
			newK(oldNumberOfDims) = 0
			newK
		})

		dim.axisChangedListeners += axisChanged
	}

	def removeDimension(dim: ArrayAxis){
		require(_dimensions contains dim)
		val dimIndex = (_dimensions indexOf dim)
		val newNumberOfDims = _dimensions.length - 1
		val newDimensions = new Array[ArrayAxis](newNumberOfDims)
		for(i <- 0 until newNumberOfDims if i != dimIndex)
			newDimensions(if (i < dimIndex) i else i - 1) = _dimensions(i)
		_dimensions = newDimensions

		remapDimensions(oldK => {
			if (oldK(dimIndex) != 0)
				// Delete any values not at position zero on removed dimension.
				null
			else {
				val newK = new Array[Int](newNumberOfDims)
				for(i <- 0 until newNumberOfDims if i != dimIndex)
					newK(if (i < dimIndex) i else i - 1) = oldK(i)
				newK
			}
		})

		dim.axisChangedListeners -= axisChanged
	}

	// NB! Changes index array in-place (which may cause problems with undo-
	// stacks later.
	private val axisChanged = (dim: Axis, index: Int, deleted: Int, added: Int) => {
		require(index >= 0 && deleted >= 0 && added >= 0)
		// Remap dimensions to accommodate inserted or deleted values.
		val dimIndex = (_dimensions indexOf dim)
		remapDimensions(oldK => {
			val v = oldK(dimIndex)
			if (v < index)
				oldK

			else if (v < (index + deleted))
				null
				
			else {
				oldK(dimIndex) = v - deleted + added
				oldK
			}
		})
	}

	// (Reasonably) safe to edit array in-place and return it, given that old data
	// set is discarded.
	private def remapDimensions(keyFunc: Array[Int]=>Array[Int]) {
		var newData = new IntArrayHashTable
		for((k, v) <- _data)
			keyFunc(k) match {
				case null => // do nothing
				case newKey => newData(newKey) = v
			}
		val oldData = _data
		_data = newData
		oldData.clear
	}

	def apply(coords: Map[Axis,Int]) = _data.getOrElse(flatten(coords), "")

	def update(coords: Map[Axis,Int], value: Any) {
		_data(flatten(coords)) = value
	}

	def flatten(coords: Map[Axis,Int]) = {
		val result = new Array[Int](dimensions.length)
		for(i <- 0 until dimensions.length)
			result(i) = coords(dimensions(i))
		result
	}

	class IntArrayHashTable extends mutable.HashMap[Array[Int], Any] {
		override def elemEquals(a: Array[Int], b: Array[Int]): Boolean = {
			if (a.length != b.length) return false
			for(i <- 0 until a.length if a(i) != b(i)) return false
			return true
		}

		override def elemHashCode(a: Array[Int]) =
			(0 /: a)((sum, v) => (sum * 41) ^ improve(v))
	}
}
