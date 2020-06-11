package org.tearne.crosser.distribution.components

import org.mockito.Mockito._
import org.scalatest.mock.MockitoSugar
import org.tearne.crosser.distribution.PlantEmpirical
import org.scalatest.FreeSpec

class ConvergenceCriterionTest extends FreeSpec with MockitoSugar{
	
	"ConvergenceCriterion should" - {
		"Stop if sufficient samples and tolerance acceptable" in {
			val oldDist = mock[PlantEmpirical]; when(oldDist.numSuccess).thenReturn(199)
			val newDist = mock[PlantEmpirical]; when(newDist.numSuccess).thenReturn(200)
	
			val metric = mock[Metric]
			when(metric.apply(oldDist,newDist)).thenReturn(100)
			val tolerance = 100
			val fewestPlants = 200
			val instance = new ConvergenceCriterion(metric, tolerance, fewestPlants)
			
			assert(instance.hasConverged(oldDist, newDist) === true)
		}
		
		"Not stop if too few samples" in {
			val oldDist = mock[PlantEmpirical]; when(oldDist.numSuccess).thenReturn(99)
			val newDist = mock[PlantEmpirical]; when(newDist.numSuccess).thenReturn(199)
	
			val metric = mock[Metric]
			when(metric.apply(oldDist,newDist)).thenReturn(99)
			val tolerance = 100
			val fewestPlants = 200
			val instance = new ConvergenceCriterion(metric, tolerance, fewestPlants)
			
			assert(!instance.hasConverged(oldDist, newDist))
		}
		
		"Not stop of distance is too large" in {
			val oldDist = mock[PlantEmpirical]; when(oldDist.numSuccess).thenReturn(99)
			val newDist = mock[PlantEmpirical]; when(newDist.numSuccess).thenReturn(199)
	
			val metric = mock[Metric]
			when(metric.apply(oldDist,newDist)).thenReturn(101)
			val tolerance = 100
			val fewestPlants = 200
			val instance = new ConvergenceCriterion(metric, tolerance, fewestPlants) 
			
			
			assert(!instance.hasConverged(oldDist, newDist))	
		}
	}
}