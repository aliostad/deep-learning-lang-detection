/**
Randomise provides utility methods for getting random numbers in a range
and for randomising arrays
*/

package org.loom.utility

import scala.util.Random

object Randomise {

   /**
   Calculate a random number between a positive minimum and a positive maximum (inclusive)
   @param min
   @param max
   */
   def range(min: Int, max: Int): Int = {
      val ranGen = new Random()
      val diff: Int = ((max + 1) - min)//need max + 1 to get the max value, otherwise always falls short
      (ranGen.nextInt(diff)) + min
   }

   /**
   Calculate a random number between a positive minimum and a positive maximum (inclusive)
   @param min
   @param max
   */
   def range(min: Double, max: Double): Double = {
      val ranGen = new Random()
      val diff: Double = ((max + 1) - min)//need max + 1 to get the max value, otherwise always falls short
      (ranGen.nextInt(diff.asInstanceOf[Int])) + min
   }

   /**
   Randomise an array of Ints
   @param a the array of Ints
   */
   def arrayOfInts(a: Array[Int]): Array[Int] = {
      var oldArray: Array[Int] = a.clone()
      val newArray: Array[Int] = oldArray.clone()
      val ranGen = new Random()
      for (i <- 0 until a.length) {
         val ran: Int = ranGen.nextInt(oldArray.length)
         newArray(i) = oldArray(ran)
         val oldList = oldArray.toList
         val listy = oldList.filterNot(x => x == newArray(i))
         oldArray = listy.toArray
      }
      newArray
   }

   /**
   Randomise a list of Ints
   @param list the List of Ints
   */
   def listOfInts(list: List[Int]): List[Int] = {
      var oldArray: Array[Int] = list.toArray
      val newArray: Array[Int] = list.toArray
      val ranGen = new Random()
      for (i <- 0 until list.length) {
         val ran: Int = ranGen.nextInt(oldArray.length)
         newArray(i) = oldArray(ran)
         val oldList = oldArray.toList
         val listy = oldList.filterNot(x => x == newArray(i))
         oldArray = listy.toArray
      }
      newArray.iterator.toList
   }

   /**
   Randomise an array of Doubles
   @param a the array of Doubles
   */
   def arrayOfDoubles(a: Array[Double]): Array[Double] = {
      var oldArray: Array[Double] = a.clone()
      val newArray: Array[Double] = oldArray.clone()
      val ranGen = new Random()
      for (i <- 0 until a.length) {
         val ran: Int = ranGen.nextInt(oldArray.length)
         newArray(i) = oldArray(ran)
         val oldList = oldArray.toList
         val listy = oldList.filterNot(x => x == newArray(i))
         oldArray = listy.toArray
      }
      newArray
   }

   /**
   Randomise a list of Doubles
   @param list the List of Doubles
   */
   def listOfDoubles(list: List[Double]): List[Double] = {
      var oldArray: Array[Double] = list.toArray
      val newArray: Array[Double] = list.toArray
      val ranGen = new Random()
      for (i <- 0 until list.length) {
         val ran: Int = ranGen.nextInt(oldArray.length)
         newArray(i) = oldArray(ran)
         val oldList = oldArray.toList
         val listy = oldList.filterNot(x => x == newArray(i))
         oldArray = listy.toArray
      }
      newArray.iterator.toList
   }

   /**
   Randomise an array of Strings
   @param a the array of Strings
   */
   def arrayOfStrings(a: Array[String]): Array[String] = {
      var oldArray: Array[String] = a.clone()
      val newArray: Array[String] = oldArray.clone()
      val ranGen = new Random()
      for (i <- 0 until a.length) {
         val ran: Int = ranGen.nextInt(oldArray.length)
         newArray(i) = oldArray(ran)
         val oldList = oldArray.toList
         val listy = oldList.filterNot(x => x == newArray(i))
         oldArray = listy.toArray
      }
      newArray
   }

   /**
   Randomise a list of Strings
   @param list the List of Strings
   */
   def listOfStrings(list: List[String]): List[String] = {
      var oldArray: Array[String] = list.toArray
      val newArray: Array[String] = list.toArray
      val ranGen = new Random()
      for (i <- 0 until list.length) {
         val ran: Int = ranGen.nextInt(oldArray.length)
         newArray(i) = oldArray(ran)
         val oldList = oldArray.toList
         val listy = oldList.filterNot(x => x == newArray(i))
         oldArray = listy.toArray
      }
      newArray.iterator.toList
   }

}
