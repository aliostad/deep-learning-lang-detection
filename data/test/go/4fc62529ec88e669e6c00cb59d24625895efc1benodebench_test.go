package cast

import "testing"

func benchmarkDispatch(b *testing.B, parent bool, childCount int) {
	if childCount > 500 && testing.Short() {
		b.Skip()
	}

	n, p, _, children := createTestNode(0, 0, parent, childCount)

	if parent {
		go receiveAll(p)
	}

	for _, c := range children {
		go receiveAll(c)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		n.Send() <- Message{}
	}

	b.StopTimer()
	close(n.Send())
}

func benchmarkChain(b *testing.B, n int) {
	if n > 200 && testing.Short() {
		b.Skip()
	}

	nodes := createChain(n)
	for _, n := range nodes[1:] {
		go receiveAll(n)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		nodes[0].Send() <- Message{}
	}

	b.StopTimer()
	for _, n := range nodes {
		close(n.Send())
	}
}

func benchmarkTree(b *testing.B, n int) {
	if n > 200 && testing.Short() {
		b.Skip()
	}

	nodes := createTree(n)
	for _, n := range nodes[1:] {
		go receiveAll(n)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		nodes[0].Send() <- Message{}
	}

	b.StopTimer()
	for _, n := range nodes {
		close(n.Send())
	}
}

func BenchmarkNoParentNoChildren(b *testing.B)  { benchmarkDispatch(b, false, 0) }
func BenchmarkParentOnly(b *testing.B)          { benchmarkDispatch(b, true, 0) }
func BenchmarkParentChildren1(b *testing.B)     { benchmarkDispatch(b, true, 1) }
func BenchmarkParentChildren2(b *testing.B)     { benchmarkDispatch(b, true, 2) }
func BenchmarkParentChildren5(b *testing.B)     { benchmarkDispatch(b, true, 5) }
func BenchmarkParentChildren10(b *testing.B)    { benchmarkDispatch(b, true, 10) }
func BenchmarkParentChildren20(b *testing.B)    { benchmarkDispatch(b, true, 20) }
func BenchmarkParentChildren50(b *testing.B)    { benchmarkDispatch(b, true, 50) }
func BenchmarkParentChildren100(b *testing.B)   { benchmarkDispatch(b, true, 100) }
func BenchmarkParentChildren200(b *testing.B)   { benchmarkDispatch(b, true, 200) }
func BenchmarkParentChildren500(b *testing.B)   { benchmarkDispatch(b, true, 500) }
func BenchmarkParentChildren1000(b *testing.B)  { benchmarkDispatch(b, true, 1000) }
func BenchmarkParentChildren2000(b *testing.B)  { benchmarkDispatch(b, true, 2000) }
func BenchmarkParentChildren5000(b *testing.B)  { benchmarkDispatch(b, true, 5000) }
func BenchmarkParentChildren10000(b *testing.B) { benchmarkDispatch(b, true, 10000) }
func BenchmarkParentChildren20000(b *testing.B) { benchmarkDispatch(b, true, 20000) }
func BenchmarkParentChildren50000(b *testing.B) { benchmarkDispatch(b, true, 50000) }

func BenchmarkChain1(b *testing.B)    { benchmarkChain(b, 1) }
func BenchmarkChain2(b *testing.B)    { benchmarkChain(b, 2) }
func BenchmarkChain5(b *testing.B)    { benchmarkChain(b, 5) }
func BenchmarkChain10(b *testing.B)   { benchmarkChain(b, 10) }
func BenchmarkChain20(b *testing.B)   { benchmarkChain(b, 20) }
func BenchmarkChain50(b *testing.B)   { benchmarkChain(b, 50) }
func BenchmarkChain100(b *testing.B)  { benchmarkChain(b, 100) }
func BenchmarkChain200(b *testing.B)  { benchmarkChain(b, 200) }
func BenchmarkChain500(b *testing.B)  { benchmarkChain(b, 500) }
func BenchmarkChain1000(b *testing.B) { benchmarkChain(b, 1000) }

func BenchmarkTree1(b *testing.B)    { benchmarkTree(b, 1) }
func BenchmarkTree2(b *testing.B)    { benchmarkTree(b, 2) }
func BenchmarkTree5(b *testing.B)    { benchmarkTree(b, 5) }
func BenchmarkTree10(b *testing.B)   { benchmarkTree(b, 10) }
func BenchmarkTree20(b *testing.B)   { benchmarkTree(b, 20) }
func BenchmarkTree50(b *testing.B)   { benchmarkTree(b, 50) }
func BenchmarkTree100(b *testing.B)  { benchmarkTree(b, 100) }
func BenchmarkTree200(b *testing.B)  { benchmarkTree(b, 200) }
func BenchmarkTree500(b *testing.B)  { benchmarkTree(b, 500) }
func BenchmarkTree1000(b *testing.B) { benchmarkTree(b, 1000) }
