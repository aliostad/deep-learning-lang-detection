package com.sandbox.chapter15_Annotations.annotationsForJavaFeatures

/**
 * Created by Jolin&Vash on 2014/9/21.
 */
import scala.reflect._

class Person {
  @BeanProperty var name : String = _
  @BooleanBeanProperty var old: Boolean = false
}

/*
$ javap Person
Compiled from "Person.scala"
public class Person implements scala.ScalaObject {
  public java.lang.String name();
  public void name_$eq(java.lang.String);
  public void setName(java.lang.String);
  public boolean old();
  public void old_$eq(boolean);
  public void setOld(boolean);
  public boolean isOld(); // Note the "is" prefix
  public java.lang.String getName();
  public Person();
}
*/
