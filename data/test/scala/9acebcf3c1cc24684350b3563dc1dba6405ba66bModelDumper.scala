package ru.yandex.mysqlDiff
package model

import java.io.PrintWriter

class ModelDumper(context: Context) {
    import context._
    
    private class IndentWriter(w: PrintWriter, currentIndent: String) {
        def println(o: Any) {
            w.println(currentIndent + o)
            w.flush()
        }
        def indent(i: String = "  ") = new IndentWriter(w, currentIndent + i)
    }
    
    def dumpDatabaseDecl(decl: DatabaseDecl, w: IndentWriter) = decl match {
        case TableModel(name, columns, extras, options) =>
            w.println("TableModel(")
            for (c <- Seq(columns, extras, options.ps).flatten)
                w.indent().println(c)
            w.println(")")
        case _ => w.println(decl)
    }
    
    def dumpDatabase(db: DatabaseModel, w: IndentWriter) {
        w.println("DatabaseModel(")
        for (decl <- db.decls)
            dumpDatabaseDecl(decl, w.indent())
        w.println(")")
    }
    
    def dumpDatabase(db: DatabaseModel, out: PrintWriter = new PrintWriter(Console.out), indent: String = ""): Unit =
        dumpDatabase(db, new IndentWriter(out, indent))

}

// vim: set ts=4 sw=4 et:
