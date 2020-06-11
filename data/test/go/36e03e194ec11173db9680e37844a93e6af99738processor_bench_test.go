package processor_test

import (
	"testing"

	"github.com/minodisk/resizer/input"
	"github.com/minodisk/resizer/processor"
	"github.com/minodisk/resizer/storage"
)

type NopWriter struct{}

func (w NopWriter) Write(p []byte) (n int, err error) {
	return len(p), nil
}

func process(path string) error {
	p := processor.New()
	input := input.Input{
		URL:   "http://example.com/test.jpg",
		Width: 800,
	}
	input, err := input.Validate([]string{"example.com"})
	i, err := storage.NewImage(input)
	if err != nil {
		return err
	}

	var w NopWriter
	if _, err = p.Process(path, &w, i); err != nil {
		return err
	}
	return nil
}

func BenchmarkProcessHuge1(b *testing.B) {
	if err := process("../fixtures/huge-1.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessHuge2(b *testing.B) {
	if err := process("../fixtures/huge-2.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessHuge3(b *testing.B) {
	if err := process("../fixtures/huge-3.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessHuge4(b *testing.B) {
	if err := process("../fixtures/huge-4.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessHuge5(b *testing.B) {
	if err := process("../fixtures/huge-5.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessHuge6(b *testing.B) {
	if err := process("../fixtures/huge-6.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessHuge7(b *testing.B) {
	if err := process("../fixtures/huge-7.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessHuge8(b *testing.B) {
	if err := process("../fixtures/huge-8.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessLarge1(b *testing.B) {
	if err := process("../fixtures/large-1.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessLarge2(b *testing.B) {
	if err := process("../fixtures/large-2.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessLarge3(b *testing.B) {
	if err := process("../fixtures/large-3.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessLarge4(b *testing.B) {
	if err := process("../fixtures/large-4.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessLarge5(b *testing.B) {
	if err := process("../fixtures/large-5.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessLarge6(b *testing.B) {
	if err := process("../fixtures/large-6.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessLarge7(b *testing.B) {
	if err := process("../fixtures/large-7.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessLarge8(b *testing.B) {
	if err := process("../fixtures/large-8.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessMedium1(b *testing.B) {
	if err := process("../fixtures/medium-1.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessMedium2(b *testing.B) {
	if err := process("../fixtures/medium-2.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessMedium3(b *testing.B) {
	if err := process("../fixtures/medium-3.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessMedium4(b *testing.B) {
	if err := process("../fixtures/medium-4.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessMedium5(b *testing.B) {
	if err := process("../fixtures/medium-5.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessMedium6(b *testing.B) {
	if err := process("../fixtures/medium-6.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessMedium7(b *testing.B) {
	if err := process("../fixtures/medium-7.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessMedium8(b *testing.B) {
	if err := process("../fixtures/medium-8.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessSmall1(b *testing.B) {
	if err := process("../fixtures/small-1.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessSmall2(b *testing.B) {
	if err := process("../fixtures/small-2.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessSmall3(b *testing.B) {
	if err := process("../fixtures/small-3.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessSmall4(b *testing.B) {
	if err := process("../fixtures/small-4.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessSmall5(b *testing.B) {
	if err := process("../fixtures/small-5.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessSmall6(b *testing.B) {
	if err := process("../fixtures/small-6.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessSmall7(b *testing.B) {
	if err := process("../fixtures/small-7.jpg"); err != nil {
		b.Fatal(err)
	}
}

func BenchmarkProcessSmall8(b *testing.B) {
	if err := process("../fixtures/small-8.jpg"); err != nil {
		b.Fatal(err)
	}
}
