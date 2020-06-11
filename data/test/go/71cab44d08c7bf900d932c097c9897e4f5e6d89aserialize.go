package ast

// func (node *Document) WriteTo(w io.Writer) (int64, error) {
// return node.Definitions.WriteTo(w)
// }

// func (node Definitions) WriteTo(w io.Writer) (n int64, err error) {
// for _, v := range node {
// cnt, err := v.WriteTo(w)
// n += cnt
// if err != nil {
// return n, err
// }
// }

// return
// }

// func (node *OperationDefinition) WriteTo(w io.Writer) (n int64, err error) {
// switch node.OpType {
// case QUERY:
// w.Write("query ")
// n += 6
// case MUTATION:
// w.Write("mutation ")
// n += 9
// default:
// panic("Invalid query type")
// }

// var cnt int64

// if len(node.Variables) > 0 {
// cnt, err = node.Variables.WriteTo(w)
// n += cnt
// if err != nil {
// return
// }
// }

// if len(node.Directives) > 0 {
// cnt, err = node.Directives.WriteTo(w)
// n += cnt
// if err != nil {
// return
// }
// }

// cnt, err = node.Directives.WriteTo(w)
// n += cnt
// return
// }

// func (args *Arguments) WriteTo(w io.Writer) (int64, error) {
// w.Write('(')

// for _, arg := range args {
// io.WriteString(w, arg.Key)
// w.Write(':')
// arg.Value.WriteTo(w)
// }

// w.Write('(')
// }

// func (node *Field) WriteTo(w io.Writer) (int64, error) {
// if Alias != "" {
// io.WriteString(w, node.Alias)
// w.Write(": ")
// }

// io.WriteString(w, node.Name)

// for _, v := range node.Directives {
// v.WriteTo(w)
// }
// }

// func (node *FragmentDefinition) WriteTo(w io.Writer) (n int64, err error) {
// // We require a special method for writing an inline fragment
// if node.inline {
// return writeInlineFragment(w)
// }

// var cnt int64

// w.Write("fragment ")
// cnt, err = io.WriteString(w, node.Name)
// w.Write(" on ")
// io.WriteString(node.Type)
// w.Write(' ')

// n += len("fragment ") + len(node.Name) + len()

// if len(node.Directives) > 0 {
// for _, v := range node.Directives {
// v.WriteTo(w)
// }
// w.Write(' ')
// }

// w.Write('{')
// for _, v := range node.SelectionSet {
// v.WriteTo(w)
// }
// w.Write('}')
// }
