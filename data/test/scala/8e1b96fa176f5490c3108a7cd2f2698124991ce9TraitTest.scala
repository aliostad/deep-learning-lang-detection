package com.scala


object TraitTest {

  abstract class Developer {
    def codeMessage: String
    def code() = println(codeMessage)
  }

  //Trait is simliar like Interface in Java. but inside this we can declare normal and abstract methods.
  // Starting in Java 8, we can declare a default method inside an interface
  trait manage{
    def mangeMessage: String
    def manage() = println(mangeMessage)
  }

  class SeniorDeveloper extends Developer {
    val codeMessage = "I am a senior developer and an excellent programmer"
  }

  class JuniorDeveloper extends Developer {
    val codeMessage = "I am a junior developer and a good programmer"
  }

  class LeadDeveloper extends Developer with manage{
    val codeMessage = "I'm a Lead developer and an excellent programmer"
    val mangeMessage = "I'm a Lead developer and  and manage project well"
  }

  def main(args: Array[String]) {
    val developers = List(new SeniorDeveloper, new JuniorDeveloper)
    developers.foreach(developer => developer.code())
    //Usage of Trait
    val leadDeveloper: LeadDeveloper = new LeadDeveloper()
    leadDeveloper.code()
    leadDeveloper.manage()
  }

}
