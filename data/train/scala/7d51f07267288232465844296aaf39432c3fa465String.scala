package org.sugarj.sweettooth.stratego.lib

import org.sugarj.sweettooth.stratego.Syntax._

/**
 * Created by seba on 30/07/14.
 */
object String extends Library {
  def buildString(s: String) = Build(makeString(s))
  def makeString(s: String) = '_String@@(makeCharList(s))
  def makeCharList(s: String): Pat =
    if (s.isEmpty)
      '_Nil@@()
    else
      '_Cons@@(Pat.Lit(s.head), makeCharList(s.tail))

  val empty_string = 'empty_string_0 -> Def(!!('_String@@('_Nil@@())))

  val conc_strings = 'conc_strings_0_0 -> Def(
    If(??('_@@('_String@@('xs), '_String@@('ys))),
      !!('_@@('xs,'ys)),
      If(??('_@@('_String@@('xs), '_String@@('ys), '_String@@('zs))),
        !!('_@@('xs, 'ys, 'zs)),
        Call('fail_0_0)
      )
    ),
    Call('conc_0_0),
    ??('chars),
    !!('_String@@('chars))
  )

  val string_replace = 'string_replace_0_2 -> Def(scala.List(), scala.List('old, 'new),
    ??('_String@@('xs)),
    !!('old),
    ??('_String@@('old_chars)),
    !!('new),
    ??('_String@@('new_chars)),
    !!('xs),
    Call('replace_0_2, scala.List(), scala.List('old_chars, 'new_chars)),
    ??('ys),
    !!('_String@@('ys))
  )

  val DEFS = Generic.DEFS ++ List.DEFS ++ Map(
    empty_string,
    conc_strings,
    string_replace
  )
}
