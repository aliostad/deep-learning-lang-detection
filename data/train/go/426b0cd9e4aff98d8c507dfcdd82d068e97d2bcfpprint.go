package ast

import (
	"fmt"

	"github.com/Diullei/ratel/core/util"
)

func PPrint(writer util.ITextWriter, node interface{}) {
	switch node.(type) {
	case *Symbol:
		writer.WriteC(":", "cyan")
		writer.WriteC((node.(*Symbol)).GetName(), "cyan")

	case *Unit, Unit:
		writer.WriteC("()", "red")

	case *Label:
		writer.WriteC((node.(*Label)).GetName(), "red")
		writer.WriteC(": ", "red")
		PPrint(writer, (node.(*Label)).GetExpr())

	case Label:
		lbl := node.(Label)
		writer.WriteC((&lbl).GetName(), "red")
		writer.WriteC(": ", "red")
		PPrint(writer, (&lbl).GetExpr())

	case Map:
		mapp := node.(Map)
		writer.Write("#{")

		for i, key := range mapp.GetKeys() {
			if i > 0 {
				writer.Write(", ")
			}

			PPrint(writer, key)
			writer.Write(" ")
			PPrint(writer, mapp.GetValue(key))
		}

		writer.Write("}")

	case *Map:
		mapp := node.(*Map)
		writer.Write("#{")

		for i, key := range mapp.GetKeys() {
			if i > 0 {
				writer.Write(", ")
			}

			PPrint(writer, key)
			writer.Write(" ")
			PPrint(writer, mapp.GetValue(key))
		}

		writer.Write("}")

	case List:
		writer.Write("[")
		n := node.(List)
		for i, item := range (&n).GetItens() {
			if i > 0 {
				writer.Write(", ")
			}
			PPrint(writer, item)
		}
		writer.Write("]")

	case *List:
		writer.Write("[")
		for i, item := range (node.(*List)).GetItens() {
			if i > 0 {
				writer.Write(", ")
			}
			PPrint(writer, item)
		}
		writer.Write("]")

	case Tuple:
		writer.Write("{")

		tpl := node.(Tuple)
		for i, item := range (&tpl).GetItens() {
			if i > 0 {
				writer.Write(", ")
			}
			PPrint(writer, item)
		}

		writer.Write("}")

	case *Tuple:
		writer.Write("{")

		for i, item := range (node.(*Tuple)).GetItens() {
			if i > 0 {
				writer.Write(", ")
			}
			PPrint(writer, item)
		}

		writer.Write("}")

	case string:
		writer.WriteC("\"", "green")
		writer.WriteC(fmt.Sprint(node), "green")
		writer.WriteC("\"", "green")

	case int64:
		writer.WriteC(fmt.Sprint(node), "yellow")

	case int32:
		writer.WriteC(fmt.Sprint(node), "yellow")

	case int:
		writer.WriteC(fmt.Sprint(node), "yellow")

	case float32:
		writer.WriteC(fmt.Sprint(node), "yellow")

	case float64:
		writer.WriteC(fmt.Sprint(node), "yellow")

	case bool:
		writer.WriteC(fmt.Sprint(node), "magenta")

	default:
		writer.Write(fmt.Sprint(node))
	}
}
