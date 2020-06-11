package gorenderer

import (
	"bytes"
	"github.com/romanoff/hyper-ui/template/ast"
	"strings"
)

type Renderer struct {
	Tree   *ast.Tree
	buffer *bytes.Buffer
}

func (self *Renderer) Init() {
	self.buffer = new(bytes.Buffer)
}

func (self *Renderer) write(parts ...[]byte) *Renderer {
	for _, v := range parts {
		self.buffer.Write(v)
	}
	return self
}

func (self *Renderer) writeLine(parts ...[]byte) *Renderer {
	self.write(parts...)
	self.buffer.WriteByte('\n')
	return self
}

func (self *Renderer) writeNode(node ast.Node) error {
	switch n := node.(type) {
	case *ast.TextNode:
		self.write([]byte("buffer.Write([]byte{"))
		for i, v := range n.Content {
			if i != 0 {
				self.write([]byte{','})
			}
			self.write([]byte{'\'', v, '\''})
		}
		self.write([]byte("})\n"))
		return nil
	case *ast.VariableNode:
		return nil
	case *ast.TagNode:
		self.write([]byte("buffer.Write([]byte{'<'"))
		for _, v := range n.Name {
			self.write([]byte{',', '\'', byte(v), '\''})
		}
		self.write([]byte("})\n"))
		if len(n.Classes) > 0 {
			self.write([]byte("buffer.Write([]byte{' ', 'c', 'l', 'a', 's', 's', '=', '\\''})\n"))
			self.write([]byte("buffer.Write([]byte{"))
			self.write([]byte("'" + strings.Join(n.Classes, "', ' ', '") + "'"))
			self.write([]byte("})\n"))
			self.write([]byte("buffer.Write([]byte{'\\''})\n"))
		}
		if len(n.Attributes) > 0 {
			for attrName, value := range n.Attributes {
				self.write([]byte("buffer.Write([]byte{' '"))
				for _, v := range attrName {
					self.write([]byte{',', '\'', byte(v), '\''})
				}
				self.write([]byte(", '=', '\\''})\n"))
				self.write([]byte("buffer.Write([]byte{"))
				for i, v := range value {
					if i != 0 {
						self.write([]byte{','})
					}
					self.write([]byte{'\'', byte(v), '\''})
				}
				self.write([]byte(", '\\''})\n"))
			}
		}
		self.write([]byte("buffer.Write([]byte{'>'})\n"))
		self.writeNode(n.ListNode)
		self.write([]byte("buffer.Write([]byte{'<', '/'"))
		for _, v := range n.Name {
			self.write([]byte{',', '\'', byte(v), '\''})
		}
		self.write([]byte(", '>'})\n"))
		return nil
	case *ast.ListNode:
		for _, node := range n.Nodes {
			err := self.writeNode(node)
			if err != nil {
				return err
			}
		}
		return nil
	}
	panic("unreachable")
}

func (self *Renderer) Render() ([]byte, error) {
	self.write([]byte("buffer := new(bytes.Buffer)\n"))
	err := self.writeNode(self.Tree.Root)
	if err != nil {
		return nil, err
	}
	self.write([]byte("return buffer.Bytes(), nil\n"))
	return self.buffer.Bytes(), nil
}
