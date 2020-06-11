package br.usp.ime.mac5732.estudo.typestate;

public class Teste {
  public static void abc(@Openable FileHandler handler) {
    
  }
  public static void main(String [] args) {
//    FileHandler handler = new FileHandler();
//    handler.open().close(); //ok
    
    //FileHandler handler = new FileHandler();
    //handler.close(); // nok

    //@Openable FileHandler handler = new FileHandler();
    //handler.read(); // nok

   //FileHandler h1 = new FileHandler();
   //FileHandler h2 = h1;
   
   //h1.open();  
   //h2.read(); //Aliasing error
    
    @Openable FileHandler h1 = new FileHandler();
    @Readable FileHandler h2 = h1.open();

    h2.read(); // OK
    h1 = h2.close(); // OK
    h2 = h1.open(); // OK
  }
}
