package de.stner.cv

import xml.{NodeSeq, Text}


class StringTexHelper(str: String) {
    def toTex = str.
        replace("&", "\\&").
        replace("%", "\\%").
        replace(" \\%", "\\,\\%").
        replace("#", "\\#").
        replace("^", "\\textasciicircum{}").
        replace("ü", "{\\\"u}").
        replace("ä", "{\\\"a}").
        replace("ö", "{\\\"o}").
        replace("é", "{\\'e}").
        replace("ß", "{\\ss}").
        replace("ą", "{\\k{a}}").
        replace("á", "{\\'a}")



    def toId = toAscii.replaceAll("\\W", "")

    def toAscii = if (str == null) "" else str.replace("ü", "ue").replace("ä", "ae").replace("ö", "oe").replace("ß", "ss")

    def markdownToTex(mayBold: Boolean = true): String = {
        var r = toTex.replace("[!]", "\\newblock ")
        var oldR: String = null

        //** -> nothing, just remove
        while (r != oldR) {
            oldR = r
            val pieces = r.split("\\*\\*",-1)
            if (pieces.size >= 3)
                r =
                    (if (mayBold) pieces.head + "{\\bfseries " + pieces.tail.head + "}"
                    else pieces.head + pieces.tail.head) + pieces.tail.tail.mkString("**")
        }
        oldR = null
        //* -> \em
        while (r != oldR) {
            oldR = r
            val pieces = r.split("\\*",-1)
            if (pieces.size >= 3)
                r = pieces.head + "{\\em " + pieces.tail.head + "}" + pieces.tail.tail.mkString("*")
        }
        r
    }

    def markdownToPlainText: String = {
        var r = str.replace("[!]", "")
        var oldR: String = null

        // `` '' =>
        r = r.replace("``", "“").replace("''", "”").replace("---", "—").replace("--", "–")
        //** -> nothing, just remove
        while (r != oldR) {
            oldR = r
            val pieces = r.split("\\*\\*",-1)
            if (pieces.size >= 3)
                r =
                    pieces.head + pieces.tail.head + pieces.tail.tail.mkString("**")
        }
        oldR = null
        //* -> \em
        while (r != oldR) {
            oldR = r
            val pieces = r.split("\\*",-1)
            if (pieces.size >= 3)
                r = pieces.head + pieces.tail.head + pieces.tail.tail.mkString("*")
        }
        r
    }

    def markdownToHtml: NodeSeq = {
        var r: NodeSeq = Text(str.replace("[!]", ""))
        var oldR: NodeSeq = null

        // `` '' =>
        r = r.flatMap({
            case t@Text(txt) =>
                Text(txt.replace("``", "“").replace("''", "”").replace("---", "—").replace("--", "–"))
            case x => x
        })
        //** -> <strong>
        while (r != oldR) {
            oldR = r
            r = r.flatMap({
                case t@Text(txt) =>
                    val pieces = txt.split("\\*\\*",-1)
                    if (pieces.size >= 3)
                        Seq(Text(pieces.head), {<strong>{pieces.tail.head}</strong>}, Text(pieces.tail.tail.mkString("**")))
                    else t
                case x => x
            })
        }
        oldR = null
        //* -> <em>
        while (r != oldR) {
            oldR = r
            r = r.flatMap({
                case t@Text(txt) =>
                    val pieces = txt.split("\\*",-1)
                    if (pieces.size >= 3)
                        Seq(Text(pieces.head), {<em>{pieces.tail.head}</em>}, Text(pieces.tail.tail.mkString("*")))
                    else t
                case x => x
            })
        }
        r
    }

    def endDot() = if (Set('.', '!', '?') contains str.last) "" else "."

}

object TextHelper {
    def renderMonth(m: Int): String = m match {
        case 1 => "January"
        case 2 => "February"
        case 3 => "March"
        case 4 => "April"
        case 5 => "May"
        case 6 => "June"
        case 7 => "July"
        case 8 => "August"
        case 9 => "September"
        case 10 => "October"
        case 11 => "November"
        case 12 => "December"
        case e => throw new RuntimeException("Invalid month " + e + " in " + this)
    }
}
