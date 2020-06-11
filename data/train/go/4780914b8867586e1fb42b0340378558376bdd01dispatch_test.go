package dispatcher

import (
	"testing"
	"github.com/yyquick/page-pipe/parser"
)

func TestDispatch(t *testing.T) {
	results := make(chan string)
	pagelets := make(parser.Pagelets, 3)
	pagelets[0] = &parser.Pagelet{"1", 2, "http://bj.ganji.com/ajax.php?module=suggestion&keyword=a&domain=bj"}
	pagelets[1] = &parser.Pagelet{"2", 1, "http://bj.ganji.com/ajax.php?module=suggestion&keyword=b&domain=bj"}
	pagelets[2] = &parser.Pagelet{"3", 2, "http://bj.ganji.com/ajax.php?module=suggestion&keyword=c&domain=bj"}

	go Dispatch(pagelets, results)

	for i := range results {
		print(i)
	}
}