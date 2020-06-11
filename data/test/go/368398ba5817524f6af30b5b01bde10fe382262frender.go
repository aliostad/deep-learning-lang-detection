package form

import (
	"bytes"
	"html/template"
)

func renderRowHTML(field Field) template.HTML {
	var buffer bytes.Buffer

	name, desc, caption, err := field.GetRenderDetails()

	buffer.WriteString("<div class=\"formrow")
	if err != "" {
		buffer.WriteString(" error")
	}
	buffer.WriteString("\">")
	buffer.WriteString("<label for=\"")
	buffer.WriteString(name)
	buffer.WriteString("\">")
	buffer.WriteString(caption)
	buffer.WriteString("</label>")
	field.Render(&buffer)
	buffer.WriteString("<div class=\"description\">")

	if err != "" {
		buffer.WriteString(err)
	} else {
		buffer.WriteString(desc)
	}

	buffer.WriteString("</div>")
	buffer.WriteString("</div>")

	return template.HTML(buffer.String())
}
