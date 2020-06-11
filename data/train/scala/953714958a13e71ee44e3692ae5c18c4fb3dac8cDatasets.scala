package cernoch.sm.exp1

import cernoch.sm.financial.Financial
import cernoch.sm.mutagen.Mutagen
import cernoch.sm.movies.Movies
import cernoch.sm.protein.Protein
import cernoch.scalogic.BLC

/**
 *
 *
 * @author Radomír Černoch (radomir.cernoch at gmail.com)
 */
object Datasets {

  def all = List(
    ("mov",  (Movies.schema().map{BLC(_)}, Movies.dump)),
    ("fin",  (Financial.schema, Financial.dump)),
    ("mutH", mutagen(false)),
    ("mutE", mutagen(true)),
    ("prt1", protein(1)),
    ("prt2", protein(2)),
    ("prt3", protein(3)),
    ("prt4", protein(4))
  )

  private def mutagen(easy: Boolean) = {
    val d = new Mutagen(easy)
    (d.schema, d.dump)
  }

  private def protein(num: Int) = {
    val d = new Protein(num)
    (d.schema, d.dump)
  }
}
