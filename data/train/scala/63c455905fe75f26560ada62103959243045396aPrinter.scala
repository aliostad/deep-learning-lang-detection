package imogen

object Printer extends org.kiama.output.PrettyPrinter {
  def pretty(t: Formula): String =
    super.pretty(show(t))

  def pretty(t: Intro): String =
    super.pretty(show(t))

  def pretty(t: Elim): String =
    super.pretty(show(t))

  private def show(t: Formula): Doc = t match {
    case Top => "T"
    case And(p, q) => show(p) <+> "&" <+> show(q)
    case Imp(p, q) => show(p) <+> "=>" <+> show(q)
    case Iff(p, q) => show(p) <+> "<=>" <+> show(q)
    case Atom(x) => x.toString
  }

  private def show(t: Intro): Doc = t match {
    case Unit => "<>"
    case Lam(x, t) => "fn" <+> x.toString <+> "=>" <+> show(t)
    case Pair(t1, t2) => parens(show(t1) <> "," <+> show(t2))
    case Cast(t) => show(t)
    case Let(x, v, b) => "let" <+> x.toString <+> "=" <+> show(v) <+> "in" <+> show(b)
  }

  private def show(t: Elim): Doc = t match {
    case Label(x) => x.toString
    case App(f, t) => show(f) <+> show(t)
    case Ascribe(t, f) => parens(show(t) <+> ":" <+> show(f))
    case Fst(t) => "fst" <+> show(t)
    case Snd(t) => "snd" <+> show(t)
  }
}
