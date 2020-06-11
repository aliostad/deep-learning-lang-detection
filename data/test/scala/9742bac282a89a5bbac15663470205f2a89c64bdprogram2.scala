package org.hablapps.fpinscala
package lenguajes.io

/**
 * Complica el programa 1 un poco, haciendo que antes de nada se
 * escriba por pantalla "Introduce un número por favor:".
 *
 * Ejemplo de ejecución:
 *
 *   scala> runWriteANumber2
 *   Introduce un número por favor:
 *   (Escribe "8")
 *   8 es un número par
 *
 * Para probar estos programas puedes ejecutar el comando de sbt: 
 *   `test-tema3-ejercicio2`
 */
object Program2{

  // Versión impura
  import lenguajes.io.ImpureIO
  
  trait Impure{ IO: ImpureIO.IO with Program1.Impure => 
    import IO._

    def writeANumberBis: Unit = {
      write("Introduce un número por favor:")
      writeANumber
    }

  }

  // Versión pura
  object Pure{
    import IO.Syntax._

    def writeANumberBis[F[_]: IO]: F[Unit] = 
        for {
      _ <- write "introduce un num"
      _ <- write writeANumber
    } yield ()    
    
  }

}
