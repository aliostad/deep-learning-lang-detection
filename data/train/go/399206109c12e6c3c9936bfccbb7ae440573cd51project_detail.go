package razor

import (
	"bytes"
	"fmt"

	"../../viewmodel"
)

func Project_detail(headers []*viewmodel.HeaderRow, columnBuilderSlave []string, buildSlaveRow [][]string, rows [][]*viewmodel.BuildInfo) string {
	var _buffer bytes.Buffer
	_buffer.WriteString("\n<div class=\"BuildTable\" >\n  <table>\n      <tr>\n          <td class=\"commit\">\n            Commit Hash\n          </td>\n          ")
	for _, header := range headers {

		numHeader := fmt.Sprint(header.NumSlaves)

		_buffer.WriteString("<td colspan=\"")
		_buffer.WriteString((numHeader))
		_buffer.WriteString("\">\n            ")
		_buffer.WriteString((header.Name))
		_buffer.WriteString("\n          </td>")

		_buffer.WriteString("<td>\n            Author &amp; Email\n          </td>")

	}
	_buffer.WriteString("\n      </tr>\n      ")
	for _, row := range buildSlaveRow {

		_buffer.WriteString("<tr>\n          <td class=\"slaves commit\"></td>\n          ")
		for _, field := range row {

			_buffer.WriteString("<td class=\"slaves\">")
			_buffer.WriteString((field))
			_buffer.WriteString("</td>")

		}
		_buffer.WriteString("\n          <td class=\"slaves\"></td>\n      </tr>")

	}
	_buffer.WriteString("\n\n      ")
	for _, row := range rows {

		_buffer.WriteString("<tr>\n          ")
		if len(row) > 0 {

			_buffer.WriteString("<td class=\"commit\" data-commit=\"")
			_buffer.WriteString((row[0].Commit))
			_buffer.WriteString("\"><span class=\"short-commit\"><b>")
			_buffer.WriteString((row[0].ShortCommit))
			_buffer.WriteString("</b></span>\n              <span style=\"display:none;\" class=\"long-commit\"><b>")
			_buffer.WriteString((row[0].Commit))
			_buffer.WriteString("</b></span> #")
			_buffer.WriteString((row[0].Branch))
			_buffer.WriteString("</td>")

		}
		_buffer.WriteString("\n          ")
		for _, build := range row {

			_buffer.WriteString("<td class=\"")
			_buffer.WriteString((build.StatusClass))
			_buffer.WriteString("\"><a class=\"output\" href=\"/project/output/")
			_buffer.WriteString((build.Project))
			_buffer.WriteString("/")
			_buffer.WriteString((build.Builder))
			_buffer.WriteString("/")
			_buffer.WriteString((build.Commit))
			_buffer.WriteString("/")
			_buffer.WriteString((build.Slave))
			_buffer.WriteString("\">")
			_buffer.WriteString((build.Status))
			_buffer.WriteString("</a></td>")

		}
		_buffer.WriteString("\n          ")
		if len(row) > 0 {

			_buffer.WriteString("<td class=\"author\"><a href=\"mailto:")
			_buffer.WriteString((row[0].Email))
			_buffer.WriteString("\" style=\"color: #000;\">")
			_buffer.WriteString((row[0].Author))
			_buffer.WriteString(" &lt;")
			_buffer.WriteString((row[0].Email))
			_buffer.WriteString("&gt;</a></td>")

		}
		_buffer.WriteString("\n      </tr>")

		numRows := fmt.Sprint(len(rows))

		_buffer.WriteString("<tr style=\"display:none; text-align:left;\" class=\"files commit-")
		_buffer.WriteString((row[0].Commit))
		_buffer.WriteString("\">\n        <td colspan=\"")
		_buffer.WriteString((numRows))
		_buffer.WriteString("\" style=\"text-align:left;\">\n          <b>Files:</b>\n          <ul>\n            ")
		for _, file := range row[0].Files {

			_buffer.WriteString("<li>")
			_buffer.WriteString((file))
			_buffer.WriteString("</li>")

		}
		_buffer.WriteString("\n          </ul>\n        </td>\n      <tr>\n      ")
	}
	_buffer.WriteString("\n  </table>\n</div>")

	return _buffer.String()
}
