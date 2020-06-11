package chess.tablero

import chess._

class TableroUtils(val tablero: Tablero) {

  //conteo de piezas
  def cantidadDePiezas(implicit color: Color) = tablero.foldRight(0)((e, acc) => if (e.trebejo.color == color && !e.estaVacio) acc + 1 else acc)

  //quien esta en XY
  def trebejoEn(en: Posicion): Option[Trebejo] = tablero.find(e => e.posicion == en && !e.estaVacio) map (_.trebejo)

  def agregar(en: Posicion, trebejo: Trebejo): Tablero = tablero.map {
    case old if (old.posicion == en) => new Escaque(old.color, en, trebejo)
    case x => x
  }

}