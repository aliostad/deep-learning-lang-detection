package mark

import (
	"fmt"
	"io"
	"strconv"
)

//HTMLWriter is ...
type HTMLWriter struct {
	Node Node
}

//WriteTo ...
func (html HTMLWriter) WriteTo(w io.Writer) (n int64, err error) {
	writer := &WriterWrapper{w, 0, nil}
	html.writeTo(html.Node, writer)
	n, err = writer.NumberOfBytes(), writer.Error()
	return
}

func (html HTMLWriter) writeTo(node Node, w io.Writer) {
	switch node.(type) {

	case *MarkDown:
		markdown := node.(*MarkDown)
		w.Write([]byte("<article>"))
		for _, part := range markdown.Parts {
			html.writeTo(part, w)
		}
		w.Write([]byte("</article>"))

	case *Space:

	case *Code:
		code := node.(*Code)
		w.Write([]byte("<pre><code class=\"" + code.Lang + "\">"))
		w.Write([]byte(code.Text))
		w.Write([]byte("</code></pre>"))

	case *Heading:
		heading := node.(*Heading)
		head := "h" + strconv.Itoa(heading.Depth)
		w.Write([]byte("<" + head + ">"))
		html.writeTo(heading.Text, w)
		w.Write([]byte("</" + head + ">"))

	case *Nptable:
		table := node.(*Nptable)
		w.Write([]byte("<table><thead><tr>"))
		for _, head := range table.Header {
			w.Write([]byte("<th>" + head + "</th>"))
		}
		w.Write([]byte("</tr></thead><tbody>"))
		for _, line := range table.Cells {
			w.Write([]byte("<tr>"))
			for index, cell := range line {
				w.Write([]byte("<td style=\"text-align:" + table.Align[index] + "\">"))
				html.writeTo(cell, w)
				w.Write([]byte("</td>"))
			}
			w.Write([]byte("</tr>"))
		}
		w.Write([]byte("</tbody></table>"))

	case *Hr:
		w.Write([]byte("<hr>"))

	case *Blockquote:
		blockquote := node.(*Blockquote)
		w.Write([]byte("<blockquote>"))
		for _, part := range blockquote.Parts {
			html.writeTo(part, w)
		}
		w.Write([]byte("</blockquote>"))

	case *List:
		list := node.(*List)
		if list.Ordered {
			w.Write([]byte("<ol>"))
		} else {
			w.Write([]byte("<ul>"))
		}
		for _, item := range list.Items {
			html.writeTo(item, w)
		}
		if list.Ordered {
			w.Write([]byte("</ol>"))
		} else {
			w.Write([]byte("</ul>"))
		}

	case *Item:
		item := node.(*Item)
		w.Write([]byte("<li>"))
		for _, part := range item.Parts {
			html.writeTo(part, w)
		}
		if item.List != nil {
			html.writeTo(item.List, w)
		}
		w.Write([]byte("</li>"))

	case *HTML:
		w.Write([]byte(node.(*HTML).Text))
	case *Def:

	case *BlockText:
		w.Write([]byte("<p>"))
		html.writeTo(node.(*BlockText).Text, w)
		w.Write([]byte("</p>"))

	case *Text:
		for _, part := range node.(*Text).Parts {
			html.writeTo(part, w)
		}

	case *InlineText:
		w.Write([]byte(node.(*InlineText).Text))

	case *Link:
		link := node.(*Link)
		w.Write([]byte("<a href=\"" + link.Href + "\" title=\"" + link.Title + "\">" + link.Text + "</a>"))

	case *Image:
		image := node.(*Image)
		w.Write([]byte("<img src=\"" + image.Href + "\" alt=\"" + image.Text + "\" title=\"" + image.Title + "\" >"))

	case *Strong:
		w.Write([]byte("<strong>" + node.(*Strong).Text + "</strong>"))

	case *Em:
		w.Write([]byte("<em>" + node.(*Em).Text + "</em>"))

	case *Br:
		w.Write([]byte("<br/>"))
	case *InlineCode:
		w.Write([]byte("<code>" + node.(*InlineCode).Text + "</code>"))
	case *Del:
		w.Write([]byte("<del>" + node.(*Del).Text + "</del>"))
	default:
		fmt.Println("Unkown Node!")
	}
	return
}

//NewHTMLWriter ...
func NewHTMLWriter(node Node) io.WriterTo {
	return &HTMLWriter{node}
}
