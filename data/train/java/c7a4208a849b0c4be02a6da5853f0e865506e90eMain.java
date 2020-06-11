package org.rapidpm.course.java8.lang.l01;

/**
 * Created by Sven Ruppert on 06.10.2014.
 */
public class Main {

  public static void main(String[] args) {
    final Service_A service_a = new Service_A() { };
    service_a.doIt();
    final Service_A_A service_a_a = new Service_A_A() { };
    service_a_a.doIt();
    final Service_B service_b = new Service_B() { };
    service_b.doIt();

    new Implementierung_A().doIt();


    Service.doItStatic();
    Service_A.doItStatic();

    Service.stringListe.add("A");

    service_a.stringListe.add("A1");
    service_b.stringListe.add("B1");

    for (final String s : service_b.stringListe) {
      System.out.println("s = " + s);
    }



  }


}
