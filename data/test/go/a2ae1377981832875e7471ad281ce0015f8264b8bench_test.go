package go_map_vs_switch

import (
	"math/rand"
	"os"
	"testing"
)

var randInputs []int
var ascInputs []int

func TestMain(m *testing.M) {
	for i := 0; i < 4096; i++ {
		randInputs = append(randInputs, rand.Int())
	}

	for i := 0; i < 4096; i++ {
		ascInputs = append(ascInputs, i)
	}

	os.Exit(m.Run())
}

func BenchmarkPredictableComputedSwitchInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 4 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[i%4](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 4 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[ascInputs[i%len(ascInputs)]%4](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 4 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[randInputs[i%len(randInputs)]%4](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchNoInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 4 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapNoInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[i%4](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchNoInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 4 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapNoInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[ascInputs[i%len(ascInputs)]%4](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchNoInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 4 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapNoInlineFunc4(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[randInputs[i%len(randInputs)]%4](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 8 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[i%8](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 8 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[ascInputs[i%len(ascInputs)]%8](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 8 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[randInputs[i%len(randInputs)]%8](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchNoInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 8 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapNoInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[i%8](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchNoInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 8 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapNoInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[ascInputs[i%len(ascInputs)]%8](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchNoInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 8 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapNoInlineFunc8(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[randInputs[i%len(randInputs)]%8](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 16 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[i%16](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 16 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[ascInputs[i%len(ascInputs)]%16](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 16 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[randInputs[i%len(randInputs)]%16](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchNoInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 16 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapNoInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[i%16](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchNoInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 16 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapNoInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[ascInputs[i%len(ascInputs)]%16](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchNoInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 16 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapNoInlineFunc16(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[randInputs[i%len(randInputs)]%16](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 32 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[i%32](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 32 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[ascInputs[i%len(ascInputs)]%32](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 32 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[randInputs[i%len(randInputs)]%32](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchNoInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 32 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapNoInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[i%32](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchNoInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 32 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapNoInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[ascInputs[i%len(ascInputs)]%32](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchNoInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 32 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapNoInlineFunc32(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[randInputs[i%len(randInputs)]%32](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 64 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[i%64](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 64 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[ascInputs[i%len(ascInputs)]%64](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 64 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[randInputs[i%len(randInputs)]%64](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchNoInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 64 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapNoInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[i%64](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchNoInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 64 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapNoInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[ascInputs[i%len(ascInputs)]%64](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchNoInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 64 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapNoInlineFunc64(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[randInputs[i%len(randInputs)]%64](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 128 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[i%128](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 128 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[ascInputs[i%len(ascInputs)]%128](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 128 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[randInputs[i%len(randInputs)]%128](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchNoInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 128 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapNoInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[i%128](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchNoInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 128 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapNoInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[ascInputs[i%len(ascInputs)]%128](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchNoInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 128 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapNoInlineFunc128(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[randInputs[i%len(randInputs)]%128](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 256 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		case 128:
			n += Inline128(i)
		case 129:
			n += Inline129(i)
		case 130:
			n += Inline130(i)
		case 131:
			n += Inline131(i)
		case 132:
			n += Inline132(i)
		case 133:
			n += Inline133(i)
		case 134:
			n += Inline134(i)
		case 135:
			n += Inline135(i)
		case 136:
			n += Inline136(i)
		case 137:
			n += Inline137(i)
		case 138:
			n += Inline138(i)
		case 139:
			n += Inline139(i)
		case 140:
			n += Inline140(i)
		case 141:
			n += Inline141(i)
		case 142:
			n += Inline142(i)
		case 143:
			n += Inline143(i)
		case 144:
			n += Inline144(i)
		case 145:
			n += Inline145(i)
		case 146:
			n += Inline146(i)
		case 147:
			n += Inline147(i)
		case 148:
			n += Inline148(i)
		case 149:
			n += Inline149(i)
		case 150:
			n += Inline150(i)
		case 151:
			n += Inline151(i)
		case 152:
			n += Inline152(i)
		case 153:
			n += Inline153(i)
		case 154:
			n += Inline154(i)
		case 155:
			n += Inline155(i)
		case 156:
			n += Inline156(i)
		case 157:
			n += Inline157(i)
		case 158:
			n += Inline158(i)
		case 159:
			n += Inline159(i)
		case 160:
			n += Inline160(i)
		case 161:
			n += Inline161(i)
		case 162:
			n += Inline162(i)
		case 163:
			n += Inline163(i)
		case 164:
			n += Inline164(i)
		case 165:
			n += Inline165(i)
		case 166:
			n += Inline166(i)
		case 167:
			n += Inline167(i)
		case 168:
			n += Inline168(i)
		case 169:
			n += Inline169(i)
		case 170:
			n += Inline170(i)
		case 171:
			n += Inline171(i)
		case 172:
			n += Inline172(i)
		case 173:
			n += Inline173(i)
		case 174:
			n += Inline174(i)
		case 175:
			n += Inline175(i)
		case 176:
			n += Inline176(i)
		case 177:
			n += Inline177(i)
		case 178:
			n += Inline178(i)
		case 179:
			n += Inline179(i)
		case 180:
			n += Inline180(i)
		case 181:
			n += Inline181(i)
		case 182:
			n += Inline182(i)
		case 183:
			n += Inline183(i)
		case 184:
			n += Inline184(i)
		case 185:
			n += Inline185(i)
		case 186:
			n += Inline186(i)
		case 187:
			n += Inline187(i)
		case 188:
			n += Inline188(i)
		case 189:
			n += Inline189(i)
		case 190:
			n += Inline190(i)
		case 191:
			n += Inline191(i)
		case 192:
			n += Inline192(i)
		case 193:
			n += Inline193(i)
		case 194:
			n += Inline194(i)
		case 195:
			n += Inline195(i)
		case 196:
			n += Inline196(i)
		case 197:
			n += Inline197(i)
		case 198:
			n += Inline198(i)
		case 199:
			n += Inline199(i)
		case 200:
			n += Inline200(i)
		case 201:
			n += Inline201(i)
		case 202:
			n += Inline202(i)
		case 203:
			n += Inline203(i)
		case 204:
			n += Inline204(i)
		case 205:
			n += Inline205(i)
		case 206:
			n += Inline206(i)
		case 207:
			n += Inline207(i)
		case 208:
			n += Inline208(i)
		case 209:
			n += Inline209(i)
		case 210:
			n += Inline210(i)
		case 211:
			n += Inline211(i)
		case 212:
			n += Inline212(i)
		case 213:
			n += Inline213(i)
		case 214:
			n += Inline214(i)
		case 215:
			n += Inline215(i)
		case 216:
			n += Inline216(i)
		case 217:
			n += Inline217(i)
		case 218:
			n += Inline218(i)
		case 219:
			n += Inline219(i)
		case 220:
			n += Inline220(i)
		case 221:
			n += Inline221(i)
		case 222:
			n += Inline222(i)
		case 223:
			n += Inline223(i)
		case 224:
			n += Inline224(i)
		case 225:
			n += Inline225(i)
		case 226:
			n += Inline226(i)
		case 227:
			n += Inline227(i)
		case 228:
			n += Inline228(i)
		case 229:
			n += Inline229(i)
		case 230:
			n += Inline230(i)
		case 231:
			n += Inline231(i)
		case 232:
			n += Inline232(i)
		case 233:
			n += Inline233(i)
		case 234:
			n += Inline234(i)
		case 235:
			n += Inline235(i)
		case 236:
			n += Inline236(i)
		case 237:
			n += Inline237(i)
		case 238:
			n += Inline238(i)
		case 239:
			n += Inline239(i)
		case 240:
			n += Inline240(i)
		case 241:
			n += Inline241(i)
		case 242:
			n += Inline242(i)
		case 243:
			n += Inline243(i)
		case 244:
			n += Inline244(i)
		case 245:
			n += Inline245(i)
		case 246:
			n += Inline246(i)
		case 247:
			n += Inline247(i)
		case 248:
			n += Inline248(i)
		case 249:
			n += Inline249(i)
		case 250:
			n += Inline250(i)
		case 251:
			n += Inline251(i)
		case 252:
			n += Inline252(i)
		case 253:
			n += Inline253(i)
		case 254:
			n += Inline254(i)
		case 255:
			n += Inline255(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[i%256](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 256 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		case 128:
			n += Inline128(i)
		case 129:
			n += Inline129(i)
		case 130:
			n += Inline130(i)
		case 131:
			n += Inline131(i)
		case 132:
			n += Inline132(i)
		case 133:
			n += Inline133(i)
		case 134:
			n += Inline134(i)
		case 135:
			n += Inline135(i)
		case 136:
			n += Inline136(i)
		case 137:
			n += Inline137(i)
		case 138:
			n += Inline138(i)
		case 139:
			n += Inline139(i)
		case 140:
			n += Inline140(i)
		case 141:
			n += Inline141(i)
		case 142:
			n += Inline142(i)
		case 143:
			n += Inline143(i)
		case 144:
			n += Inline144(i)
		case 145:
			n += Inline145(i)
		case 146:
			n += Inline146(i)
		case 147:
			n += Inline147(i)
		case 148:
			n += Inline148(i)
		case 149:
			n += Inline149(i)
		case 150:
			n += Inline150(i)
		case 151:
			n += Inline151(i)
		case 152:
			n += Inline152(i)
		case 153:
			n += Inline153(i)
		case 154:
			n += Inline154(i)
		case 155:
			n += Inline155(i)
		case 156:
			n += Inline156(i)
		case 157:
			n += Inline157(i)
		case 158:
			n += Inline158(i)
		case 159:
			n += Inline159(i)
		case 160:
			n += Inline160(i)
		case 161:
			n += Inline161(i)
		case 162:
			n += Inline162(i)
		case 163:
			n += Inline163(i)
		case 164:
			n += Inline164(i)
		case 165:
			n += Inline165(i)
		case 166:
			n += Inline166(i)
		case 167:
			n += Inline167(i)
		case 168:
			n += Inline168(i)
		case 169:
			n += Inline169(i)
		case 170:
			n += Inline170(i)
		case 171:
			n += Inline171(i)
		case 172:
			n += Inline172(i)
		case 173:
			n += Inline173(i)
		case 174:
			n += Inline174(i)
		case 175:
			n += Inline175(i)
		case 176:
			n += Inline176(i)
		case 177:
			n += Inline177(i)
		case 178:
			n += Inline178(i)
		case 179:
			n += Inline179(i)
		case 180:
			n += Inline180(i)
		case 181:
			n += Inline181(i)
		case 182:
			n += Inline182(i)
		case 183:
			n += Inline183(i)
		case 184:
			n += Inline184(i)
		case 185:
			n += Inline185(i)
		case 186:
			n += Inline186(i)
		case 187:
			n += Inline187(i)
		case 188:
			n += Inline188(i)
		case 189:
			n += Inline189(i)
		case 190:
			n += Inline190(i)
		case 191:
			n += Inline191(i)
		case 192:
			n += Inline192(i)
		case 193:
			n += Inline193(i)
		case 194:
			n += Inline194(i)
		case 195:
			n += Inline195(i)
		case 196:
			n += Inline196(i)
		case 197:
			n += Inline197(i)
		case 198:
			n += Inline198(i)
		case 199:
			n += Inline199(i)
		case 200:
			n += Inline200(i)
		case 201:
			n += Inline201(i)
		case 202:
			n += Inline202(i)
		case 203:
			n += Inline203(i)
		case 204:
			n += Inline204(i)
		case 205:
			n += Inline205(i)
		case 206:
			n += Inline206(i)
		case 207:
			n += Inline207(i)
		case 208:
			n += Inline208(i)
		case 209:
			n += Inline209(i)
		case 210:
			n += Inline210(i)
		case 211:
			n += Inline211(i)
		case 212:
			n += Inline212(i)
		case 213:
			n += Inline213(i)
		case 214:
			n += Inline214(i)
		case 215:
			n += Inline215(i)
		case 216:
			n += Inline216(i)
		case 217:
			n += Inline217(i)
		case 218:
			n += Inline218(i)
		case 219:
			n += Inline219(i)
		case 220:
			n += Inline220(i)
		case 221:
			n += Inline221(i)
		case 222:
			n += Inline222(i)
		case 223:
			n += Inline223(i)
		case 224:
			n += Inline224(i)
		case 225:
			n += Inline225(i)
		case 226:
			n += Inline226(i)
		case 227:
			n += Inline227(i)
		case 228:
			n += Inline228(i)
		case 229:
			n += Inline229(i)
		case 230:
			n += Inline230(i)
		case 231:
			n += Inline231(i)
		case 232:
			n += Inline232(i)
		case 233:
			n += Inline233(i)
		case 234:
			n += Inline234(i)
		case 235:
			n += Inline235(i)
		case 236:
			n += Inline236(i)
		case 237:
			n += Inline237(i)
		case 238:
			n += Inline238(i)
		case 239:
			n += Inline239(i)
		case 240:
			n += Inline240(i)
		case 241:
			n += Inline241(i)
		case 242:
			n += Inline242(i)
		case 243:
			n += Inline243(i)
		case 244:
			n += Inline244(i)
		case 245:
			n += Inline245(i)
		case 246:
			n += Inline246(i)
		case 247:
			n += Inline247(i)
		case 248:
			n += Inline248(i)
		case 249:
			n += Inline249(i)
		case 250:
			n += Inline250(i)
		case 251:
			n += Inline251(i)
		case 252:
			n += Inline252(i)
		case 253:
			n += Inline253(i)
		case 254:
			n += Inline254(i)
		case 255:
			n += Inline255(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[ascInputs[i%len(ascInputs)]%256](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 256 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		case 128:
			n += Inline128(i)
		case 129:
			n += Inline129(i)
		case 130:
			n += Inline130(i)
		case 131:
			n += Inline131(i)
		case 132:
			n += Inline132(i)
		case 133:
			n += Inline133(i)
		case 134:
			n += Inline134(i)
		case 135:
			n += Inline135(i)
		case 136:
			n += Inline136(i)
		case 137:
			n += Inline137(i)
		case 138:
			n += Inline138(i)
		case 139:
			n += Inline139(i)
		case 140:
			n += Inline140(i)
		case 141:
			n += Inline141(i)
		case 142:
			n += Inline142(i)
		case 143:
			n += Inline143(i)
		case 144:
			n += Inline144(i)
		case 145:
			n += Inline145(i)
		case 146:
			n += Inline146(i)
		case 147:
			n += Inline147(i)
		case 148:
			n += Inline148(i)
		case 149:
			n += Inline149(i)
		case 150:
			n += Inline150(i)
		case 151:
			n += Inline151(i)
		case 152:
			n += Inline152(i)
		case 153:
			n += Inline153(i)
		case 154:
			n += Inline154(i)
		case 155:
			n += Inline155(i)
		case 156:
			n += Inline156(i)
		case 157:
			n += Inline157(i)
		case 158:
			n += Inline158(i)
		case 159:
			n += Inline159(i)
		case 160:
			n += Inline160(i)
		case 161:
			n += Inline161(i)
		case 162:
			n += Inline162(i)
		case 163:
			n += Inline163(i)
		case 164:
			n += Inline164(i)
		case 165:
			n += Inline165(i)
		case 166:
			n += Inline166(i)
		case 167:
			n += Inline167(i)
		case 168:
			n += Inline168(i)
		case 169:
			n += Inline169(i)
		case 170:
			n += Inline170(i)
		case 171:
			n += Inline171(i)
		case 172:
			n += Inline172(i)
		case 173:
			n += Inline173(i)
		case 174:
			n += Inline174(i)
		case 175:
			n += Inline175(i)
		case 176:
			n += Inline176(i)
		case 177:
			n += Inline177(i)
		case 178:
			n += Inline178(i)
		case 179:
			n += Inline179(i)
		case 180:
			n += Inline180(i)
		case 181:
			n += Inline181(i)
		case 182:
			n += Inline182(i)
		case 183:
			n += Inline183(i)
		case 184:
			n += Inline184(i)
		case 185:
			n += Inline185(i)
		case 186:
			n += Inline186(i)
		case 187:
			n += Inline187(i)
		case 188:
			n += Inline188(i)
		case 189:
			n += Inline189(i)
		case 190:
			n += Inline190(i)
		case 191:
			n += Inline191(i)
		case 192:
			n += Inline192(i)
		case 193:
			n += Inline193(i)
		case 194:
			n += Inline194(i)
		case 195:
			n += Inline195(i)
		case 196:
			n += Inline196(i)
		case 197:
			n += Inline197(i)
		case 198:
			n += Inline198(i)
		case 199:
			n += Inline199(i)
		case 200:
			n += Inline200(i)
		case 201:
			n += Inline201(i)
		case 202:
			n += Inline202(i)
		case 203:
			n += Inline203(i)
		case 204:
			n += Inline204(i)
		case 205:
			n += Inline205(i)
		case 206:
			n += Inline206(i)
		case 207:
			n += Inline207(i)
		case 208:
			n += Inline208(i)
		case 209:
			n += Inline209(i)
		case 210:
			n += Inline210(i)
		case 211:
			n += Inline211(i)
		case 212:
			n += Inline212(i)
		case 213:
			n += Inline213(i)
		case 214:
			n += Inline214(i)
		case 215:
			n += Inline215(i)
		case 216:
			n += Inline216(i)
		case 217:
			n += Inline217(i)
		case 218:
			n += Inline218(i)
		case 219:
			n += Inline219(i)
		case 220:
			n += Inline220(i)
		case 221:
			n += Inline221(i)
		case 222:
			n += Inline222(i)
		case 223:
			n += Inline223(i)
		case 224:
			n += Inline224(i)
		case 225:
			n += Inline225(i)
		case 226:
			n += Inline226(i)
		case 227:
			n += Inline227(i)
		case 228:
			n += Inline228(i)
		case 229:
			n += Inline229(i)
		case 230:
			n += Inline230(i)
		case 231:
			n += Inline231(i)
		case 232:
			n += Inline232(i)
		case 233:
			n += Inline233(i)
		case 234:
			n += Inline234(i)
		case 235:
			n += Inline235(i)
		case 236:
			n += Inline236(i)
		case 237:
			n += Inline237(i)
		case 238:
			n += Inline238(i)
		case 239:
			n += Inline239(i)
		case 240:
			n += Inline240(i)
		case 241:
			n += Inline241(i)
		case 242:
			n += Inline242(i)
		case 243:
			n += Inline243(i)
		case 244:
			n += Inline244(i)
		case 245:
			n += Inline245(i)
		case 246:
			n += Inline246(i)
		case 247:
			n += Inline247(i)
		case 248:
			n += Inline248(i)
		case 249:
			n += Inline249(i)
		case 250:
			n += Inline250(i)
		case 251:
			n += Inline251(i)
		case 252:
			n += Inline252(i)
		case 253:
			n += Inline253(i)
		case 254:
			n += Inline254(i)
		case 255:
			n += Inline255(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[randInputs[i%len(randInputs)]%256](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchNoInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 256 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		case 128:
			n += NoInline128(i)
		case 129:
			n += NoInline129(i)
		case 130:
			n += NoInline130(i)
		case 131:
			n += NoInline131(i)
		case 132:
			n += NoInline132(i)
		case 133:
			n += NoInline133(i)
		case 134:
			n += NoInline134(i)
		case 135:
			n += NoInline135(i)
		case 136:
			n += NoInline136(i)
		case 137:
			n += NoInline137(i)
		case 138:
			n += NoInline138(i)
		case 139:
			n += NoInline139(i)
		case 140:
			n += NoInline140(i)
		case 141:
			n += NoInline141(i)
		case 142:
			n += NoInline142(i)
		case 143:
			n += NoInline143(i)
		case 144:
			n += NoInline144(i)
		case 145:
			n += NoInline145(i)
		case 146:
			n += NoInline146(i)
		case 147:
			n += NoInline147(i)
		case 148:
			n += NoInline148(i)
		case 149:
			n += NoInline149(i)
		case 150:
			n += NoInline150(i)
		case 151:
			n += NoInline151(i)
		case 152:
			n += NoInline152(i)
		case 153:
			n += NoInline153(i)
		case 154:
			n += NoInline154(i)
		case 155:
			n += NoInline155(i)
		case 156:
			n += NoInline156(i)
		case 157:
			n += NoInline157(i)
		case 158:
			n += NoInline158(i)
		case 159:
			n += NoInline159(i)
		case 160:
			n += NoInline160(i)
		case 161:
			n += NoInline161(i)
		case 162:
			n += NoInline162(i)
		case 163:
			n += NoInline163(i)
		case 164:
			n += NoInline164(i)
		case 165:
			n += NoInline165(i)
		case 166:
			n += NoInline166(i)
		case 167:
			n += NoInline167(i)
		case 168:
			n += NoInline168(i)
		case 169:
			n += NoInline169(i)
		case 170:
			n += NoInline170(i)
		case 171:
			n += NoInline171(i)
		case 172:
			n += NoInline172(i)
		case 173:
			n += NoInline173(i)
		case 174:
			n += NoInline174(i)
		case 175:
			n += NoInline175(i)
		case 176:
			n += NoInline176(i)
		case 177:
			n += NoInline177(i)
		case 178:
			n += NoInline178(i)
		case 179:
			n += NoInline179(i)
		case 180:
			n += NoInline180(i)
		case 181:
			n += NoInline181(i)
		case 182:
			n += NoInline182(i)
		case 183:
			n += NoInline183(i)
		case 184:
			n += NoInline184(i)
		case 185:
			n += NoInline185(i)
		case 186:
			n += NoInline186(i)
		case 187:
			n += NoInline187(i)
		case 188:
			n += NoInline188(i)
		case 189:
			n += NoInline189(i)
		case 190:
			n += NoInline190(i)
		case 191:
			n += NoInline191(i)
		case 192:
			n += NoInline192(i)
		case 193:
			n += NoInline193(i)
		case 194:
			n += NoInline194(i)
		case 195:
			n += NoInline195(i)
		case 196:
			n += NoInline196(i)
		case 197:
			n += NoInline197(i)
		case 198:
			n += NoInline198(i)
		case 199:
			n += NoInline199(i)
		case 200:
			n += NoInline200(i)
		case 201:
			n += NoInline201(i)
		case 202:
			n += NoInline202(i)
		case 203:
			n += NoInline203(i)
		case 204:
			n += NoInline204(i)
		case 205:
			n += NoInline205(i)
		case 206:
			n += NoInline206(i)
		case 207:
			n += NoInline207(i)
		case 208:
			n += NoInline208(i)
		case 209:
			n += NoInline209(i)
		case 210:
			n += NoInline210(i)
		case 211:
			n += NoInline211(i)
		case 212:
			n += NoInline212(i)
		case 213:
			n += NoInline213(i)
		case 214:
			n += NoInline214(i)
		case 215:
			n += NoInline215(i)
		case 216:
			n += NoInline216(i)
		case 217:
			n += NoInline217(i)
		case 218:
			n += NoInline218(i)
		case 219:
			n += NoInline219(i)
		case 220:
			n += NoInline220(i)
		case 221:
			n += NoInline221(i)
		case 222:
			n += NoInline222(i)
		case 223:
			n += NoInline223(i)
		case 224:
			n += NoInline224(i)
		case 225:
			n += NoInline225(i)
		case 226:
			n += NoInline226(i)
		case 227:
			n += NoInline227(i)
		case 228:
			n += NoInline228(i)
		case 229:
			n += NoInline229(i)
		case 230:
			n += NoInline230(i)
		case 231:
			n += NoInline231(i)
		case 232:
			n += NoInline232(i)
		case 233:
			n += NoInline233(i)
		case 234:
			n += NoInline234(i)
		case 235:
			n += NoInline235(i)
		case 236:
			n += NoInline236(i)
		case 237:
			n += NoInline237(i)
		case 238:
			n += NoInline238(i)
		case 239:
			n += NoInline239(i)
		case 240:
			n += NoInline240(i)
		case 241:
			n += NoInline241(i)
		case 242:
			n += NoInline242(i)
		case 243:
			n += NoInline243(i)
		case 244:
			n += NoInline244(i)
		case 245:
			n += NoInline245(i)
		case 246:
			n += NoInline246(i)
		case 247:
			n += NoInline247(i)
		case 248:
			n += NoInline248(i)
		case 249:
			n += NoInline249(i)
		case 250:
			n += NoInline250(i)
		case 251:
			n += NoInline251(i)
		case 252:
			n += NoInline252(i)
		case 253:
			n += NoInline253(i)
		case 254:
			n += NoInline254(i)
		case 255:
			n += NoInline255(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapNoInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[i%256](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchNoInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 256 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		case 128:
			n += NoInline128(i)
		case 129:
			n += NoInline129(i)
		case 130:
			n += NoInline130(i)
		case 131:
			n += NoInline131(i)
		case 132:
			n += NoInline132(i)
		case 133:
			n += NoInline133(i)
		case 134:
			n += NoInline134(i)
		case 135:
			n += NoInline135(i)
		case 136:
			n += NoInline136(i)
		case 137:
			n += NoInline137(i)
		case 138:
			n += NoInline138(i)
		case 139:
			n += NoInline139(i)
		case 140:
			n += NoInline140(i)
		case 141:
			n += NoInline141(i)
		case 142:
			n += NoInline142(i)
		case 143:
			n += NoInline143(i)
		case 144:
			n += NoInline144(i)
		case 145:
			n += NoInline145(i)
		case 146:
			n += NoInline146(i)
		case 147:
			n += NoInline147(i)
		case 148:
			n += NoInline148(i)
		case 149:
			n += NoInline149(i)
		case 150:
			n += NoInline150(i)
		case 151:
			n += NoInline151(i)
		case 152:
			n += NoInline152(i)
		case 153:
			n += NoInline153(i)
		case 154:
			n += NoInline154(i)
		case 155:
			n += NoInline155(i)
		case 156:
			n += NoInline156(i)
		case 157:
			n += NoInline157(i)
		case 158:
			n += NoInline158(i)
		case 159:
			n += NoInline159(i)
		case 160:
			n += NoInline160(i)
		case 161:
			n += NoInline161(i)
		case 162:
			n += NoInline162(i)
		case 163:
			n += NoInline163(i)
		case 164:
			n += NoInline164(i)
		case 165:
			n += NoInline165(i)
		case 166:
			n += NoInline166(i)
		case 167:
			n += NoInline167(i)
		case 168:
			n += NoInline168(i)
		case 169:
			n += NoInline169(i)
		case 170:
			n += NoInline170(i)
		case 171:
			n += NoInline171(i)
		case 172:
			n += NoInline172(i)
		case 173:
			n += NoInline173(i)
		case 174:
			n += NoInline174(i)
		case 175:
			n += NoInline175(i)
		case 176:
			n += NoInline176(i)
		case 177:
			n += NoInline177(i)
		case 178:
			n += NoInline178(i)
		case 179:
			n += NoInline179(i)
		case 180:
			n += NoInline180(i)
		case 181:
			n += NoInline181(i)
		case 182:
			n += NoInline182(i)
		case 183:
			n += NoInline183(i)
		case 184:
			n += NoInline184(i)
		case 185:
			n += NoInline185(i)
		case 186:
			n += NoInline186(i)
		case 187:
			n += NoInline187(i)
		case 188:
			n += NoInline188(i)
		case 189:
			n += NoInline189(i)
		case 190:
			n += NoInline190(i)
		case 191:
			n += NoInline191(i)
		case 192:
			n += NoInline192(i)
		case 193:
			n += NoInline193(i)
		case 194:
			n += NoInline194(i)
		case 195:
			n += NoInline195(i)
		case 196:
			n += NoInline196(i)
		case 197:
			n += NoInline197(i)
		case 198:
			n += NoInline198(i)
		case 199:
			n += NoInline199(i)
		case 200:
			n += NoInline200(i)
		case 201:
			n += NoInline201(i)
		case 202:
			n += NoInline202(i)
		case 203:
			n += NoInline203(i)
		case 204:
			n += NoInline204(i)
		case 205:
			n += NoInline205(i)
		case 206:
			n += NoInline206(i)
		case 207:
			n += NoInline207(i)
		case 208:
			n += NoInline208(i)
		case 209:
			n += NoInline209(i)
		case 210:
			n += NoInline210(i)
		case 211:
			n += NoInline211(i)
		case 212:
			n += NoInline212(i)
		case 213:
			n += NoInline213(i)
		case 214:
			n += NoInline214(i)
		case 215:
			n += NoInline215(i)
		case 216:
			n += NoInline216(i)
		case 217:
			n += NoInline217(i)
		case 218:
			n += NoInline218(i)
		case 219:
			n += NoInline219(i)
		case 220:
			n += NoInline220(i)
		case 221:
			n += NoInline221(i)
		case 222:
			n += NoInline222(i)
		case 223:
			n += NoInline223(i)
		case 224:
			n += NoInline224(i)
		case 225:
			n += NoInline225(i)
		case 226:
			n += NoInline226(i)
		case 227:
			n += NoInline227(i)
		case 228:
			n += NoInline228(i)
		case 229:
			n += NoInline229(i)
		case 230:
			n += NoInline230(i)
		case 231:
			n += NoInline231(i)
		case 232:
			n += NoInline232(i)
		case 233:
			n += NoInline233(i)
		case 234:
			n += NoInline234(i)
		case 235:
			n += NoInline235(i)
		case 236:
			n += NoInline236(i)
		case 237:
			n += NoInline237(i)
		case 238:
			n += NoInline238(i)
		case 239:
			n += NoInline239(i)
		case 240:
			n += NoInline240(i)
		case 241:
			n += NoInline241(i)
		case 242:
			n += NoInline242(i)
		case 243:
			n += NoInline243(i)
		case 244:
			n += NoInline244(i)
		case 245:
			n += NoInline245(i)
		case 246:
			n += NoInline246(i)
		case 247:
			n += NoInline247(i)
		case 248:
			n += NoInline248(i)
		case 249:
			n += NoInline249(i)
		case 250:
			n += NoInline250(i)
		case 251:
			n += NoInline251(i)
		case 252:
			n += NoInline252(i)
		case 253:
			n += NoInline253(i)
		case 254:
			n += NoInline254(i)
		case 255:
			n += NoInline255(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapNoInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[ascInputs[i%len(ascInputs)]%256](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchNoInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 256 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		case 128:
			n += NoInline128(i)
		case 129:
			n += NoInline129(i)
		case 130:
			n += NoInline130(i)
		case 131:
			n += NoInline131(i)
		case 132:
			n += NoInline132(i)
		case 133:
			n += NoInline133(i)
		case 134:
			n += NoInline134(i)
		case 135:
			n += NoInline135(i)
		case 136:
			n += NoInline136(i)
		case 137:
			n += NoInline137(i)
		case 138:
			n += NoInline138(i)
		case 139:
			n += NoInline139(i)
		case 140:
			n += NoInline140(i)
		case 141:
			n += NoInline141(i)
		case 142:
			n += NoInline142(i)
		case 143:
			n += NoInline143(i)
		case 144:
			n += NoInline144(i)
		case 145:
			n += NoInline145(i)
		case 146:
			n += NoInline146(i)
		case 147:
			n += NoInline147(i)
		case 148:
			n += NoInline148(i)
		case 149:
			n += NoInline149(i)
		case 150:
			n += NoInline150(i)
		case 151:
			n += NoInline151(i)
		case 152:
			n += NoInline152(i)
		case 153:
			n += NoInline153(i)
		case 154:
			n += NoInline154(i)
		case 155:
			n += NoInline155(i)
		case 156:
			n += NoInline156(i)
		case 157:
			n += NoInline157(i)
		case 158:
			n += NoInline158(i)
		case 159:
			n += NoInline159(i)
		case 160:
			n += NoInline160(i)
		case 161:
			n += NoInline161(i)
		case 162:
			n += NoInline162(i)
		case 163:
			n += NoInline163(i)
		case 164:
			n += NoInline164(i)
		case 165:
			n += NoInline165(i)
		case 166:
			n += NoInline166(i)
		case 167:
			n += NoInline167(i)
		case 168:
			n += NoInline168(i)
		case 169:
			n += NoInline169(i)
		case 170:
			n += NoInline170(i)
		case 171:
			n += NoInline171(i)
		case 172:
			n += NoInline172(i)
		case 173:
			n += NoInline173(i)
		case 174:
			n += NoInline174(i)
		case 175:
			n += NoInline175(i)
		case 176:
			n += NoInline176(i)
		case 177:
			n += NoInline177(i)
		case 178:
			n += NoInline178(i)
		case 179:
			n += NoInline179(i)
		case 180:
			n += NoInline180(i)
		case 181:
			n += NoInline181(i)
		case 182:
			n += NoInline182(i)
		case 183:
			n += NoInline183(i)
		case 184:
			n += NoInline184(i)
		case 185:
			n += NoInline185(i)
		case 186:
			n += NoInline186(i)
		case 187:
			n += NoInline187(i)
		case 188:
			n += NoInline188(i)
		case 189:
			n += NoInline189(i)
		case 190:
			n += NoInline190(i)
		case 191:
			n += NoInline191(i)
		case 192:
			n += NoInline192(i)
		case 193:
			n += NoInline193(i)
		case 194:
			n += NoInline194(i)
		case 195:
			n += NoInline195(i)
		case 196:
			n += NoInline196(i)
		case 197:
			n += NoInline197(i)
		case 198:
			n += NoInline198(i)
		case 199:
			n += NoInline199(i)
		case 200:
			n += NoInline200(i)
		case 201:
			n += NoInline201(i)
		case 202:
			n += NoInline202(i)
		case 203:
			n += NoInline203(i)
		case 204:
			n += NoInline204(i)
		case 205:
			n += NoInline205(i)
		case 206:
			n += NoInline206(i)
		case 207:
			n += NoInline207(i)
		case 208:
			n += NoInline208(i)
		case 209:
			n += NoInline209(i)
		case 210:
			n += NoInline210(i)
		case 211:
			n += NoInline211(i)
		case 212:
			n += NoInline212(i)
		case 213:
			n += NoInline213(i)
		case 214:
			n += NoInline214(i)
		case 215:
			n += NoInline215(i)
		case 216:
			n += NoInline216(i)
		case 217:
			n += NoInline217(i)
		case 218:
			n += NoInline218(i)
		case 219:
			n += NoInline219(i)
		case 220:
			n += NoInline220(i)
		case 221:
			n += NoInline221(i)
		case 222:
			n += NoInline222(i)
		case 223:
			n += NoInline223(i)
		case 224:
			n += NoInline224(i)
		case 225:
			n += NoInline225(i)
		case 226:
			n += NoInline226(i)
		case 227:
			n += NoInline227(i)
		case 228:
			n += NoInline228(i)
		case 229:
			n += NoInline229(i)
		case 230:
			n += NoInline230(i)
		case 231:
			n += NoInline231(i)
		case 232:
			n += NoInline232(i)
		case 233:
			n += NoInline233(i)
		case 234:
			n += NoInline234(i)
		case 235:
			n += NoInline235(i)
		case 236:
			n += NoInline236(i)
		case 237:
			n += NoInline237(i)
		case 238:
			n += NoInline238(i)
		case 239:
			n += NoInline239(i)
		case 240:
			n += NoInline240(i)
		case 241:
			n += NoInline241(i)
		case 242:
			n += NoInline242(i)
		case 243:
			n += NoInline243(i)
		case 244:
			n += NoInline244(i)
		case 245:
			n += NoInline245(i)
		case 246:
			n += NoInline246(i)
		case 247:
			n += NoInline247(i)
		case 248:
			n += NoInline248(i)
		case 249:
			n += NoInline249(i)
		case 250:
			n += NoInline250(i)
		case 251:
			n += NoInline251(i)
		case 252:
			n += NoInline252(i)
		case 253:
			n += NoInline253(i)
		case 254:
			n += NoInline254(i)
		case 255:
			n += NoInline255(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapNoInlineFunc256(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[randInputs[i%len(randInputs)]%256](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 512 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		case 128:
			n += Inline128(i)
		case 129:
			n += Inline129(i)
		case 130:
			n += Inline130(i)
		case 131:
			n += Inline131(i)
		case 132:
			n += Inline132(i)
		case 133:
			n += Inline133(i)
		case 134:
			n += Inline134(i)
		case 135:
			n += Inline135(i)
		case 136:
			n += Inline136(i)
		case 137:
			n += Inline137(i)
		case 138:
			n += Inline138(i)
		case 139:
			n += Inline139(i)
		case 140:
			n += Inline140(i)
		case 141:
			n += Inline141(i)
		case 142:
			n += Inline142(i)
		case 143:
			n += Inline143(i)
		case 144:
			n += Inline144(i)
		case 145:
			n += Inline145(i)
		case 146:
			n += Inline146(i)
		case 147:
			n += Inline147(i)
		case 148:
			n += Inline148(i)
		case 149:
			n += Inline149(i)
		case 150:
			n += Inline150(i)
		case 151:
			n += Inline151(i)
		case 152:
			n += Inline152(i)
		case 153:
			n += Inline153(i)
		case 154:
			n += Inline154(i)
		case 155:
			n += Inline155(i)
		case 156:
			n += Inline156(i)
		case 157:
			n += Inline157(i)
		case 158:
			n += Inline158(i)
		case 159:
			n += Inline159(i)
		case 160:
			n += Inline160(i)
		case 161:
			n += Inline161(i)
		case 162:
			n += Inline162(i)
		case 163:
			n += Inline163(i)
		case 164:
			n += Inline164(i)
		case 165:
			n += Inline165(i)
		case 166:
			n += Inline166(i)
		case 167:
			n += Inline167(i)
		case 168:
			n += Inline168(i)
		case 169:
			n += Inline169(i)
		case 170:
			n += Inline170(i)
		case 171:
			n += Inline171(i)
		case 172:
			n += Inline172(i)
		case 173:
			n += Inline173(i)
		case 174:
			n += Inline174(i)
		case 175:
			n += Inline175(i)
		case 176:
			n += Inline176(i)
		case 177:
			n += Inline177(i)
		case 178:
			n += Inline178(i)
		case 179:
			n += Inline179(i)
		case 180:
			n += Inline180(i)
		case 181:
			n += Inline181(i)
		case 182:
			n += Inline182(i)
		case 183:
			n += Inline183(i)
		case 184:
			n += Inline184(i)
		case 185:
			n += Inline185(i)
		case 186:
			n += Inline186(i)
		case 187:
			n += Inline187(i)
		case 188:
			n += Inline188(i)
		case 189:
			n += Inline189(i)
		case 190:
			n += Inline190(i)
		case 191:
			n += Inline191(i)
		case 192:
			n += Inline192(i)
		case 193:
			n += Inline193(i)
		case 194:
			n += Inline194(i)
		case 195:
			n += Inline195(i)
		case 196:
			n += Inline196(i)
		case 197:
			n += Inline197(i)
		case 198:
			n += Inline198(i)
		case 199:
			n += Inline199(i)
		case 200:
			n += Inline200(i)
		case 201:
			n += Inline201(i)
		case 202:
			n += Inline202(i)
		case 203:
			n += Inline203(i)
		case 204:
			n += Inline204(i)
		case 205:
			n += Inline205(i)
		case 206:
			n += Inline206(i)
		case 207:
			n += Inline207(i)
		case 208:
			n += Inline208(i)
		case 209:
			n += Inline209(i)
		case 210:
			n += Inline210(i)
		case 211:
			n += Inline211(i)
		case 212:
			n += Inline212(i)
		case 213:
			n += Inline213(i)
		case 214:
			n += Inline214(i)
		case 215:
			n += Inline215(i)
		case 216:
			n += Inline216(i)
		case 217:
			n += Inline217(i)
		case 218:
			n += Inline218(i)
		case 219:
			n += Inline219(i)
		case 220:
			n += Inline220(i)
		case 221:
			n += Inline221(i)
		case 222:
			n += Inline222(i)
		case 223:
			n += Inline223(i)
		case 224:
			n += Inline224(i)
		case 225:
			n += Inline225(i)
		case 226:
			n += Inline226(i)
		case 227:
			n += Inline227(i)
		case 228:
			n += Inline228(i)
		case 229:
			n += Inline229(i)
		case 230:
			n += Inline230(i)
		case 231:
			n += Inline231(i)
		case 232:
			n += Inline232(i)
		case 233:
			n += Inline233(i)
		case 234:
			n += Inline234(i)
		case 235:
			n += Inline235(i)
		case 236:
			n += Inline236(i)
		case 237:
			n += Inline237(i)
		case 238:
			n += Inline238(i)
		case 239:
			n += Inline239(i)
		case 240:
			n += Inline240(i)
		case 241:
			n += Inline241(i)
		case 242:
			n += Inline242(i)
		case 243:
			n += Inline243(i)
		case 244:
			n += Inline244(i)
		case 245:
			n += Inline245(i)
		case 246:
			n += Inline246(i)
		case 247:
			n += Inline247(i)
		case 248:
			n += Inline248(i)
		case 249:
			n += Inline249(i)
		case 250:
			n += Inline250(i)
		case 251:
			n += Inline251(i)
		case 252:
			n += Inline252(i)
		case 253:
			n += Inline253(i)
		case 254:
			n += Inline254(i)
		case 255:
			n += Inline255(i)
		case 256:
			n += Inline256(i)
		case 257:
			n += Inline257(i)
		case 258:
			n += Inline258(i)
		case 259:
			n += Inline259(i)
		case 260:
			n += Inline260(i)
		case 261:
			n += Inline261(i)
		case 262:
			n += Inline262(i)
		case 263:
			n += Inline263(i)
		case 264:
			n += Inline264(i)
		case 265:
			n += Inline265(i)
		case 266:
			n += Inline266(i)
		case 267:
			n += Inline267(i)
		case 268:
			n += Inline268(i)
		case 269:
			n += Inline269(i)
		case 270:
			n += Inline270(i)
		case 271:
			n += Inline271(i)
		case 272:
			n += Inline272(i)
		case 273:
			n += Inline273(i)
		case 274:
			n += Inline274(i)
		case 275:
			n += Inline275(i)
		case 276:
			n += Inline276(i)
		case 277:
			n += Inline277(i)
		case 278:
			n += Inline278(i)
		case 279:
			n += Inline279(i)
		case 280:
			n += Inline280(i)
		case 281:
			n += Inline281(i)
		case 282:
			n += Inline282(i)
		case 283:
			n += Inline283(i)
		case 284:
			n += Inline284(i)
		case 285:
			n += Inline285(i)
		case 286:
			n += Inline286(i)
		case 287:
			n += Inline287(i)
		case 288:
			n += Inline288(i)
		case 289:
			n += Inline289(i)
		case 290:
			n += Inline290(i)
		case 291:
			n += Inline291(i)
		case 292:
			n += Inline292(i)
		case 293:
			n += Inline293(i)
		case 294:
			n += Inline294(i)
		case 295:
			n += Inline295(i)
		case 296:
			n += Inline296(i)
		case 297:
			n += Inline297(i)
		case 298:
			n += Inline298(i)
		case 299:
			n += Inline299(i)
		case 300:
			n += Inline300(i)
		case 301:
			n += Inline301(i)
		case 302:
			n += Inline302(i)
		case 303:
			n += Inline303(i)
		case 304:
			n += Inline304(i)
		case 305:
			n += Inline305(i)
		case 306:
			n += Inline306(i)
		case 307:
			n += Inline307(i)
		case 308:
			n += Inline308(i)
		case 309:
			n += Inline309(i)
		case 310:
			n += Inline310(i)
		case 311:
			n += Inline311(i)
		case 312:
			n += Inline312(i)
		case 313:
			n += Inline313(i)
		case 314:
			n += Inline314(i)
		case 315:
			n += Inline315(i)
		case 316:
			n += Inline316(i)
		case 317:
			n += Inline317(i)
		case 318:
			n += Inline318(i)
		case 319:
			n += Inline319(i)
		case 320:
			n += Inline320(i)
		case 321:
			n += Inline321(i)
		case 322:
			n += Inline322(i)
		case 323:
			n += Inline323(i)
		case 324:
			n += Inline324(i)
		case 325:
			n += Inline325(i)
		case 326:
			n += Inline326(i)
		case 327:
			n += Inline327(i)
		case 328:
			n += Inline328(i)
		case 329:
			n += Inline329(i)
		case 330:
			n += Inline330(i)
		case 331:
			n += Inline331(i)
		case 332:
			n += Inline332(i)
		case 333:
			n += Inline333(i)
		case 334:
			n += Inline334(i)
		case 335:
			n += Inline335(i)
		case 336:
			n += Inline336(i)
		case 337:
			n += Inline337(i)
		case 338:
			n += Inline338(i)
		case 339:
			n += Inline339(i)
		case 340:
			n += Inline340(i)
		case 341:
			n += Inline341(i)
		case 342:
			n += Inline342(i)
		case 343:
			n += Inline343(i)
		case 344:
			n += Inline344(i)
		case 345:
			n += Inline345(i)
		case 346:
			n += Inline346(i)
		case 347:
			n += Inline347(i)
		case 348:
			n += Inline348(i)
		case 349:
			n += Inline349(i)
		case 350:
			n += Inline350(i)
		case 351:
			n += Inline351(i)
		case 352:
			n += Inline352(i)
		case 353:
			n += Inline353(i)
		case 354:
			n += Inline354(i)
		case 355:
			n += Inline355(i)
		case 356:
			n += Inline356(i)
		case 357:
			n += Inline357(i)
		case 358:
			n += Inline358(i)
		case 359:
			n += Inline359(i)
		case 360:
			n += Inline360(i)
		case 361:
			n += Inline361(i)
		case 362:
			n += Inline362(i)
		case 363:
			n += Inline363(i)
		case 364:
			n += Inline364(i)
		case 365:
			n += Inline365(i)
		case 366:
			n += Inline366(i)
		case 367:
			n += Inline367(i)
		case 368:
			n += Inline368(i)
		case 369:
			n += Inline369(i)
		case 370:
			n += Inline370(i)
		case 371:
			n += Inline371(i)
		case 372:
			n += Inline372(i)
		case 373:
			n += Inline373(i)
		case 374:
			n += Inline374(i)
		case 375:
			n += Inline375(i)
		case 376:
			n += Inline376(i)
		case 377:
			n += Inline377(i)
		case 378:
			n += Inline378(i)
		case 379:
			n += Inline379(i)
		case 380:
			n += Inline380(i)
		case 381:
			n += Inline381(i)
		case 382:
			n += Inline382(i)
		case 383:
			n += Inline383(i)
		case 384:
			n += Inline384(i)
		case 385:
			n += Inline385(i)
		case 386:
			n += Inline386(i)
		case 387:
			n += Inline387(i)
		case 388:
			n += Inline388(i)
		case 389:
			n += Inline389(i)
		case 390:
			n += Inline390(i)
		case 391:
			n += Inline391(i)
		case 392:
			n += Inline392(i)
		case 393:
			n += Inline393(i)
		case 394:
			n += Inline394(i)
		case 395:
			n += Inline395(i)
		case 396:
			n += Inline396(i)
		case 397:
			n += Inline397(i)
		case 398:
			n += Inline398(i)
		case 399:
			n += Inline399(i)
		case 400:
			n += Inline400(i)
		case 401:
			n += Inline401(i)
		case 402:
			n += Inline402(i)
		case 403:
			n += Inline403(i)
		case 404:
			n += Inline404(i)
		case 405:
			n += Inline405(i)
		case 406:
			n += Inline406(i)
		case 407:
			n += Inline407(i)
		case 408:
			n += Inline408(i)
		case 409:
			n += Inline409(i)
		case 410:
			n += Inline410(i)
		case 411:
			n += Inline411(i)
		case 412:
			n += Inline412(i)
		case 413:
			n += Inline413(i)
		case 414:
			n += Inline414(i)
		case 415:
			n += Inline415(i)
		case 416:
			n += Inline416(i)
		case 417:
			n += Inline417(i)
		case 418:
			n += Inline418(i)
		case 419:
			n += Inline419(i)
		case 420:
			n += Inline420(i)
		case 421:
			n += Inline421(i)
		case 422:
			n += Inline422(i)
		case 423:
			n += Inline423(i)
		case 424:
			n += Inline424(i)
		case 425:
			n += Inline425(i)
		case 426:
			n += Inline426(i)
		case 427:
			n += Inline427(i)
		case 428:
			n += Inline428(i)
		case 429:
			n += Inline429(i)
		case 430:
			n += Inline430(i)
		case 431:
			n += Inline431(i)
		case 432:
			n += Inline432(i)
		case 433:
			n += Inline433(i)
		case 434:
			n += Inline434(i)
		case 435:
			n += Inline435(i)
		case 436:
			n += Inline436(i)
		case 437:
			n += Inline437(i)
		case 438:
			n += Inline438(i)
		case 439:
			n += Inline439(i)
		case 440:
			n += Inline440(i)
		case 441:
			n += Inline441(i)
		case 442:
			n += Inline442(i)
		case 443:
			n += Inline443(i)
		case 444:
			n += Inline444(i)
		case 445:
			n += Inline445(i)
		case 446:
			n += Inline446(i)
		case 447:
			n += Inline447(i)
		case 448:
			n += Inline448(i)
		case 449:
			n += Inline449(i)
		case 450:
			n += Inline450(i)
		case 451:
			n += Inline451(i)
		case 452:
			n += Inline452(i)
		case 453:
			n += Inline453(i)
		case 454:
			n += Inline454(i)
		case 455:
			n += Inline455(i)
		case 456:
			n += Inline456(i)
		case 457:
			n += Inline457(i)
		case 458:
			n += Inline458(i)
		case 459:
			n += Inline459(i)
		case 460:
			n += Inline460(i)
		case 461:
			n += Inline461(i)
		case 462:
			n += Inline462(i)
		case 463:
			n += Inline463(i)
		case 464:
			n += Inline464(i)
		case 465:
			n += Inline465(i)
		case 466:
			n += Inline466(i)
		case 467:
			n += Inline467(i)
		case 468:
			n += Inline468(i)
		case 469:
			n += Inline469(i)
		case 470:
			n += Inline470(i)
		case 471:
			n += Inline471(i)
		case 472:
			n += Inline472(i)
		case 473:
			n += Inline473(i)
		case 474:
			n += Inline474(i)
		case 475:
			n += Inline475(i)
		case 476:
			n += Inline476(i)
		case 477:
			n += Inline477(i)
		case 478:
			n += Inline478(i)
		case 479:
			n += Inline479(i)
		case 480:
			n += Inline480(i)
		case 481:
			n += Inline481(i)
		case 482:
			n += Inline482(i)
		case 483:
			n += Inline483(i)
		case 484:
			n += Inline484(i)
		case 485:
			n += Inline485(i)
		case 486:
			n += Inline486(i)
		case 487:
			n += Inline487(i)
		case 488:
			n += Inline488(i)
		case 489:
			n += Inline489(i)
		case 490:
			n += Inline490(i)
		case 491:
			n += Inline491(i)
		case 492:
			n += Inline492(i)
		case 493:
			n += Inline493(i)
		case 494:
			n += Inline494(i)
		case 495:
			n += Inline495(i)
		case 496:
			n += Inline496(i)
		case 497:
			n += Inline497(i)
		case 498:
			n += Inline498(i)
		case 499:
			n += Inline499(i)
		case 500:
			n += Inline500(i)
		case 501:
			n += Inline501(i)
		case 502:
			n += Inline502(i)
		case 503:
			n += Inline503(i)
		case 504:
			n += Inline504(i)
		case 505:
			n += Inline505(i)
		case 506:
			n += Inline506(i)
		case 507:
			n += Inline507(i)
		case 508:
			n += Inline508(i)
		case 509:
			n += Inline509(i)
		case 510:
			n += Inline510(i)
		case 511:
			n += Inline511(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[i%512](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 512 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		case 128:
			n += Inline128(i)
		case 129:
			n += Inline129(i)
		case 130:
			n += Inline130(i)
		case 131:
			n += Inline131(i)
		case 132:
			n += Inline132(i)
		case 133:
			n += Inline133(i)
		case 134:
			n += Inline134(i)
		case 135:
			n += Inline135(i)
		case 136:
			n += Inline136(i)
		case 137:
			n += Inline137(i)
		case 138:
			n += Inline138(i)
		case 139:
			n += Inline139(i)
		case 140:
			n += Inline140(i)
		case 141:
			n += Inline141(i)
		case 142:
			n += Inline142(i)
		case 143:
			n += Inline143(i)
		case 144:
			n += Inline144(i)
		case 145:
			n += Inline145(i)
		case 146:
			n += Inline146(i)
		case 147:
			n += Inline147(i)
		case 148:
			n += Inline148(i)
		case 149:
			n += Inline149(i)
		case 150:
			n += Inline150(i)
		case 151:
			n += Inline151(i)
		case 152:
			n += Inline152(i)
		case 153:
			n += Inline153(i)
		case 154:
			n += Inline154(i)
		case 155:
			n += Inline155(i)
		case 156:
			n += Inline156(i)
		case 157:
			n += Inline157(i)
		case 158:
			n += Inline158(i)
		case 159:
			n += Inline159(i)
		case 160:
			n += Inline160(i)
		case 161:
			n += Inline161(i)
		case 162:
			n += Inline162(i)
		case 163:
			n += Inline163(i)
		case 164:
			n += Inline164(i)
		case 165:
			n += Inline165(i)
		case 166:
			n += Inline166(i)
		case 167:
			n += Inline167(i)
		case 168:
			n += Inline168(i)
		case 169:
			n += Inline169(i)
		case 170:
			n += Inline170(i)
		case 171:
			n += Inline171(i)
		case 172:
			n += Inline172(i)
		case 173:
			n += Inline173(i)
		case 174:
			n += Inline174(i)
		case 175:
			n += Inline175(i)
		case 176:
			n += Inline176(i)
		case 177:
			n += Inline177(i)
		case 178:
			n += Inline178(i)
		case 179:
			n += Inline179(i)
		case 180:
			n += Inline180(i)
		case 181:
			n += Inline181(i)
		case 182:
			n += Inline182(i)
		case 183:
			n += Inline183(i)
		case 184:
			n += Inline184(i)
		case 185:
			n += Inline185(i)
		case 186:
			n += Inline186(i)
		case 187:
			n += Inline187(i)
		case 188:
			n += Inline188(i)
		case 189:
			n += Inline189(i)
		case 190:
			n += Inline190(i)
		case 191:
			n += Inline191(i)
		case 192:
			n += Inline192(i)
		case 193:
			n += Inline193(i)
		case 194:
			n += Inline194(i)
		case 195:
			n += Inline195(i)
		case 196:
			n += Inline196(i)
		case 197:
			n += Inline197(i)
		case 198:
			n += Inline198(i)
		case 199:
			n += Inline199(i)
		case 200:
			n += Inline200(i)
		case 201:
			n += Inline201(i)
		case 202:
			n += Inline202(i)
		case 203:
			n += Inline203(i)
		case 204:
			n += Inline204(i)
		case 205:
			n += Inline205(i)
		case 206:
			n += Inline206(i)
		case 207:
			n += Inline207(i)
		case 208:
			n += Inline208(i)
		case 209:
			n += Inline209(i)
		case 210:
			n += Inline210(i)
		case 211:
			n += Inline211(i)
		case 212:
			n += Inline212(i)
		case 213:
			n += Inline213(i)
		case 214:
			n += Inline214(i)
		case 215:
			n += Inline215(i)
		case 216:
			n += Inline216(i)
		case 217:
			n += Inline217(i)
		case 218:
			n += Inline218(i)
		case 219:
			n += Inline219(i)
		case 220:
			n += Inline220(i)
		case 221:
			n += Inline221(i)
		case 222:
			n += Inline222(i)
		case 223:
			n += Inline223(i)
		case 224:
			n += Inline224(i)
		case 225:
			n += Inline225(i)
		case 226:
			n += Inline226(i)
		case 227:
			n += Inline227(i)
		case 228:
			n += Inline228(i)
		case 229:
			n += Inline229(i)
		case 230:
			n += Inline230(i)
		case 231:
			n += Inline231(i)
		case 232:
			n += Inline232(i)
		case 233:
			n += Inline233(i)
		case 234:
			n += Inline234(i)
		case 235:
			n += Inline235(i)
		case 236:
			n += Inline236(i)
		case 237:
			n += Inline237(i)
		case 238:
			n += Inline238(i)
		case 239:
			n += Inline239(i)
		case 240:
			n += Inline240(i)
		case 241:
			n += Inline241(i)
		case 242:
			n += Inline242(i)
		case 243:
			n += Inline243(i)
		case 244:
			n += Inline244(i)
		case 245:
			n += Inline245(i)
		case 246:
			n += Inline246(i)
		case 247:
			n += Inline247(i)
		case 248:
			n += Inline248(i)
		case 249:
			n += Inline249(i)
		case 250:
			n += Inline250(i)
		case 251:
			n += Inline251(i)
		case 252:
			n += Inline252(i)
		case 253:
			n += Inline253(i)
		case 254:
			n += Inline254(i)
		case 255:
			n += Inline255(i)
		case 256:
			n += Inline256(i)
		case 257:
			n += Inline257(i)
		case 258:
			n += Inline258(i)
		case 259:
			n += Inline259(i)
		case 260:
			n += Inline260(i)
		case 261:
			n += Inline261(i)
		case 262:
			n += Inline262(i)
		case 263:
			n += Inline263(i)
		case 264:
			n += Inline264(i)
		case 265:
			n += Inline265(i)
		case 266:
			n += Inline266(i)
		case 267:
			n += Inline267(i)
		case 268:
			n += Inline268(i)
		case 269:
			n += Inline269(i)
		case 270:
			n += Inline270(i)
		case 271:
			n += Inline271(i)
		case 272:
			n += Inline272(i)
		case 273:
			n += Inline273(i)
		case 274:
			n += Inline274(i)
		case 275:
			n += Inline275(i)
		case 276:
			n += Inline276(i)
		case 277:
			n += Inline277(i)
		case 278:
			n += Inline278(i)
		case 279:
			n += Inline279(i)
		case 280:
			n += Inline280(i)
		case 281:
			n += Inline281(i)
		case 282:
			n += Inline282(i)
		case 283:
			n += Inline283(i)
		case 284:
			n += Inline284(i)
		case 285:
			n += Inline285(i)
		case 286:
			n += Inline286(i)
		case 287:
			n += Inline287(i)
		case 288:
			n += Inline288(i)
		case 289:
			n += Inline289(i)
		case 290:
			n += Inline290(i)
		case 291:
			n += Inline291(i)
		case 292:
			n += Inline292(i)
		case 293:
			n += Inline293(i)
		case 294:
			n += Inline294(i)
		case 295:
			n += Inline295(i)
		case 296:
			n += Inline296(i)
		case 297:
			n += Inline297(i)
		case 298:
			n += Inline298(i)
		case 299:
			n += Inline299(i)
		case 300:
			n += Inline300(i)
		case 301:
			n += Inline301(i)
		case 302:
			n += Inline302(i)
		case 303:
			n += Inline303(i)
		case 304:
			n += Inline304(i)
		case 305:
			n += Inline305(i)
		case 306:
			n += Inline306(i)
		case 307:
			n += Inline307(i)
		case 308:
			n += Inline308(i)
		case 309:
			n += Inline309(i)
		case 310:
			n += Inline310(i)
		case 311:
			n += Inline311(i)
		case 312:
			n += Inline312(i)
		case 313:
			n += Inline313(i)
		case 314:
			n += Inline314(i)
		case 315:
			n += Inline315(i)
		case 316:
			n += Inline316(i)
		case 317:
			n += Inline317(i)
		case 318:
			n += Inline318(i)
		case 319:
			n += Inline319(i)
		case 320:
			n += Inline320(i)
		case 321:
			n += Inline321(i)
		case 322:
			n += Inline322(i)
		case 323:
			n += Inline323(i)
		case 324:
			n += Inline324(i)
		case 325:
			n += Inline325(i)
		case 326:
			n += Inline326(i)
		case 327:
			n += Inline327(i)
		case 328:
			n += Inline328(i)
		case 329:
			n += Inline329(i)
		case 330:
			n += Inline330(i)
		case 331:
			n += Inline331(i)
		case 332:
			n += Inline332(i)
		case 333:
			n += Inline333(i)
		case 334:
			n += Inline334(i)
		case 335:
			n += Inline335(i)
		case 336:
			n += Inline336(i)
		case 337:
			n += Inline337(i)
		case 338:
			n += Inline338(i)
		case 339:
			n += Inline339(i)
		case 340:
			n += Inline340(i)
		case 341:
			n += Inline341(i)
		case 342:
			n += Inline342(i)
		case 343:
			n += Inline343(i)
		case 344:
			n += Inline344(i)
		case 345:
			n += Inline345(i)
		case 346:
			n += Inline346(i)
		case 347:
			n += Inline347(i)
		case 348:
			n += Inline348(i)
		case 349:
			n += Inline349(i)
		case 350:
			n += Inline350(i)
		case 351:
			n += Inline351(i)
		case 352:
			n += Inline352(i)
		case 353:
			n += Inline353(i)
		case 354:
			n += Inline354(i)
		case 355:
			n += Inline355(i)
		case 356:
			n += Inline356(i)
		case 357:
			n += Inline357(i)
		case 358:
			n += Inline358(i)
		case 359:
			n += Inline359(i)
		case 360:
			n += Inline360(i)
		case 361:
			n += Inline361(i)
		case 362:
			n += Inline362(i)
		case 363:
			n += Inline363(i)
		case 364:
			n += Inline364(i)
		case 365:
			n += Inline365(i)
		case 366:
			n += Inline366(i)
		case 367:
			n += Inline367(i)
		case 368:
			n += Inline368(i)
		case 369:
			n += Inline369(i)
		case 370:
			n += Inline370(i)
		case 371:
			n += Inline371(i)
		case 372:
			n += Inline372(i)
		case 373:
			n += Inline373(i)
		case 374:
			n += Inline374(i)
		case 375:
			n += Inline375(i)
		case 376:
			n += Inline376(i)
		case 377:
			n += Inline377(i)
		case 378:
			n += Inline378(i)
		case 379:
			n += Inline379(i)
		case 380:
			n += Inline380(i)
		case 381:
			n += Inline381(i)
		case 382:
			n += Inline382(i)
		case 383:
			n += Inline383(i)
		case 384:
			n += Inline384(i)
		case 385:
			n += Inline385(i)
		case 386:
			n += Inline386(i)
		case 387:
			n += Inline387(i)
		case 388:
			n += Inline388(i)
		case 389:
			n += Inline389(i)
		case 390:
			n += Inline390(i)
		case 391:
			n += Inline391(i)
		case 392:
			n += Inline392(i)
		case 393:
			n += Inline393(i)
		case 394:
			n += Inline394(i)
		case 395:
			n += Inline395(i)
		case 396:
			n += Inline396(i)
		case 397:
			n += Inline397(i)
		case 398:
			n += Inline398(i)
		case 399:
			n += Inline399(i)
		case 400:
			n += Inline400(i)
		case 401:
			n += Inline401(i)
		case 402:
			n += Inline402(i)
		case 403:
			n += Inline403(i)
		case 404:
			n += Inline404(i)
		case 405:
			n += Inline405(i)
		case 406:
			n += Inline406(i)
		case 407:
			n += Inline407(i)
		case 408:
			n += Inline408(i)
		case 409:
			n += Inline409(i)
		case 410:
			n += Inline410(i)
		case 411:
			n += Inline411(i)
		case 412:
			n += Inline412(i)
		case 413:
			n += Inline413(i)
		case 414:
			n += Inline414(i)
		case 415:
			n += Inline415(i)
		case 416:
			n += Inline416(i)
		case 417:
			n += Inline417(i)
		case 418:
			n += Inline418(i)
		case 419:
			n += Inline419(i)
		case 420:
			n += Inline420(i)
		case 421:
			n += Inline421(i)
		case 422:
			n += Inline422(i)
		case 423:
			n += Inline423(i)
		case 424:
			n += Inline424(i)
		case 425:
			n += Inline425(i)
		case 426:
			n += Inline426(i)
		case 427:
			n += Inline427(i)
		case 428:
			n += Inline428(i)
		case 429:
			n += Inline429(i)
		case 430:
			n += Inline430(i)
		case 431:
			n += Inline431(i)
		case 432:
			n += Inline432(i)
		case 433:
			n += Inline433(i)
		case 434:
			n += Inline434(i)
		case 435:
			n += Inline435(i)
		case 436:
			n += Inline436(i)
		case 437:
			n += Inline437(i)
		case 438:
			n += Inline438(i)
		case 439:
			n += Inline439(i)
		case 440:
			n += Inline440(i)
		case 441:
			n += Inline441(i)
		case 442:
			n += Inline442(i)
		case 443:
			n += Inline443(i)
		case 444:
			n += Inline444(i)
		case 445:
			n += Inline445(i)
		case 446:
			n += Inline446(i)
		case 447:
			n += Inline447(i)
		case 448:
			n += Inline448(i)
		case 449:
			n += Inline449(i)
		case 450:
			n += Inline450(i)
		case 451:
			n += Inline451(i)
		case 452:
			n += Inline452(i)
		case 453:
			n += Inline453(i)
		case 454:
			n += Inline454(i)
		case 455:
			n += Inline455(i)
		case 456:
			n += Inline456(i)
		case 457:
			n += Inline457(i)
		case 458:
			n += Inline458(i)
		case 459:
			n += Inline459(i)
		case 460:
			n += Inline460(i)
		case 461:
			n += Inline461(i)
		case 462:
			n += Inline462(i)
		case 463:
			n += Inline463(i)
		case 464:
			n += Inline464(i)
		case 465:
			n += Inline465(i)
		case 466:
			n += Inline466(i)
		case 467:
			n += Inline467(i)
		case 468:
			n += Inline468(i)
		case 469:
			n += Inline469(i)
		case 470:
			n += Inline470(i)
		case 471:
			n += Inline471(i)
		case 472:
			n += Inline472(i)
		case 473:
			n += Inline473(i)
		case 474:
			n += Inline474(i)
		case 475:
			n += Inline475(i)
		case 476:
			n += Inline476(i)
		case 477:
			n += Inline477(i)
		case 478:
			n += Inline478(i)
		case 479:
			n += Inline479(i)
		case 480:
			n += Inline480(i)
		case 481:
			n += Inline481(i)
		case 482:
			n += Inline482(i)
		case 483:
			n += Inline483(i)
		case 484:
			n += Inline484(i)
		case 485:
			n += Inline485(i)
		case 486:
			n += Inline486(i)
		case 487:
			n += Inline487(i)
		case 488:
			n += Inline488(i)
		case 489:
			n += Inline489(i)
		case 490:
			n += Inline490(i)
		case 491:
			n += Inline491(i)
		case 492:
			n += Inline492(i)
		case 493:
			n += Inline493(i)
		case 494:
			n += Inline494(i)
		case 495:
			n += Inline495(i)
		case 496:
			n += Inline496(i)
		case 497:
			n += Inline497(i)
		case 498:
			n += Inline498(i)
		case 499:
			n += Inline499(i)
		case 500:
			n += Inline500(i)
		case 501:
			n += Inline501(i)
		case 502:
			n += Inline502(i)
		case 503:
			n += Inline503(i)
		case 504:
			n += Inline504(i)
		case 505:
			n += Inline505(i)
		case 506:
			n += Inline506(i)
		case 507:
			n += Inline507(i)
		case 508:
			n += Inline508(i)
		case 509:
			n += Inline509(i)
		case 510:
			n += Inline510(i)
		case 511:
			n += Inline511(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[ascInputs[i%len(ascInputs)]%512](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 512 {
		case 0:
			n += Inline0(i)
		case 1:
			n += Inline1(i)
		case 2:
			n += Inline2(i)
		case 3:
			n += Inline3(i)
		case 4:
			n += Inline4(i)
		case 5:
			n += Inline5(i)
		case 6:
			n += Inline6(i)
		case 7:
			n += Inline7(i)
		case 8:
			n += Inline8(i)
		case 9:
			n += Inline9(i)
		case 10:
			n += Inline10(i)
		case 11:
			n += Inline11(i)
		case 12:
			n += Inline12(i)
		case 13:
			n += Inline13(i)
		case 14:
			n += Inline14(i)
		case 15:
			n += Inline15(i)
		case 16:
			n += Inline16(i)
		case 17:
			n += Inline17(i)
		case 18:
			n += Inline18(i)
		case 19:
			n += Inline19(i)
		case 20:
			n += Inline20(i)
		case 21:
			n += Inline21(i)
		case 22:
			n += Inline22(i)
		case 23:
			n += Inline23(i)
		case 24:
			n += Inline24(i)
		case 25:
			n += Inline25(i)
		case 26:
			n += Inline26(i)
		case 27:
			n += Inline27(i)
		case 28:
			n += Inline28(i)
		case 29:
			n += Inline29(i)
		case 30:
			n += Inline30(i)
		case 31:
			n += Inline31(i)
		case 32:
			n += Inline32(i)
		case 33:
			n += Inline33(i)
		case 34:
			n += Inline34(i)
		case 35:
			n += Inline35(i)
		case 36:
			n += Inline36(i)
		case 37:
			n += Inline37(i)
		case 38:
			n += Inline38(i)
		case 39:
			n += Inline39(i)
		case 40:
			n += Inline40(i)
		case 41:
			n += Inline41(i)
		case 42:
			n += Inline42(i)
		case 43:
			n += Inline43(i)
		case 44:
			n += Inline44(i)
		case 45:
			n += Inline45(i)
		case 46:
			n += Inline46(i)
		case 47:
			n += Inline47(i)
		case 48:
			n += Inline48(i)
		case 49:
			n += Inline49(i)
		case 50:
			n += Inline50(i)
		case 51:
			n += Inline51(i)
		case 52:
			n += Inline52(i)
		case 53:
			n += Inline53(i)
		case 54:
			n += Inline54(i)
		case 55:
			n += Inline55(i)
		case 56:
			n += Inline56(i)
		case 57:
			n += Inline57(i)
		case 58:
			n += Inline58(i)
		case 59:
			n += Inline59(i)
		case 60:
			n += Inline60(i)
		case 61:
			n += Inline61(i)
		case 62:
			n += Inline62(i)
		case 63:
			n += Inline63(i)
		case 64:
			n += Inline64(i)
		case 65:
			n += Inline65(i)
		case 66:
			n += Inline66(i)
		case 67:
			n += Inline67(i)
		case 68:
			n += Inline68(i)
		case 69:
			n += Inline69(i)
		case 70:
			n += Inline70(i)
		case 71:
			n += Inline71(i)
		case 72:
			n += Inline72(i)
		case 73:
			n += Inline73(i)
		case 74:
			n += Inline74(i)
		case 75:
			n += Inline75(i)
		case 76:
			n += Inline76(i)
		case 77:
			n += Inline77(i)
		case 78:
			n += Inline78(i)
		case 79:
			n += Inline79(i)
		case 80:
			n += Inline80(i)
		case 81:
			n += Inline81(i)
		case 82:
			n += Inline82(i)
		case 83:
			n += Inline83(i)
		case 84:
			n += Inline84(i)
		case 85:
			n += Inline85(i)
		case 86:
			n += Inline86(i)
		case 87:
			n += Inline87(i)
		case 88:
			n += Inline88(i)
		case 89:
			n += Inline89(i)
		case 90:
			n += Inline90(i)
		case 91:
			n += Inline91(i)
		case 92:
			n += Inline92(i)
		case 93:
			n += Inline93(i)
		case 94:
			n += Inline94(i)
		case 95:
			n += Inline95(i)
		case 96:
			n += Inline96(i)
		case 97:
			n += Inline97(i)
		case 98:
			n += Inline98(i)
		case 99:
			n += Inline99(i)
		case 100:
			n += Inline100(i)
		case 101:
			n += Inline101(i)
		case 102:
			n += Inline102(i)
		case 103:
			n += Inline103(i)
		case 104:
			n += Inline104(i)
		case 105:
			n += Inline105(i)
		case 106:
			n += Inline106(i)
		case 107:
			n += Inline107(i)
		case 108:
			n += Inline108(i)
		case 109:
			n += Inline109(i)
		case 110:
			n += Inline110(i)
		case 111:
			n += Inline111(i)
		case 112:
			n += Inline112(i)
		case 113:
			n += Inline113(i)
		case 114:
			n += Inline114(i)
		case 115:
			n += Inline115(i)
		case 116:
			n += Inline116(i)
		case 117:
			n += Inline117(i)
		case 118:
			n += Inline118(i)
		case 119:
			n += Inline119(i)
		case 120:
			n += Inline120(i)
		case 121:
			n += Inline121(i)
		case 122:
			n += Inline122(i)
		case 123:
			n += Inline123(i)
		case 124:
			n += Inline124(i)
		case 125:
			n += Inline125(i)
		case 126:
			n += Inline126(i)
		case 127:
			n += Inline127(i)
		case 128:
			n += Inline128(i)
		case 129:
			n += Inline129(i)
		case 130:
			n += Inline130(i)
		case 131:
			n += Inline131(i)
		case 132:
			n += Inline132(i)
		case 133:
			n += Inline133(i)
		case 134:
			n += Inline134(i)
		case 135:
			n += Inline135(i)
		case 136:
			n += Inline136(i)
		case 137:
			n += Inline137(i)
		case 138:
			n += Inline138(i)
		case 139:
			n += Inline139(i)
		case 140:
			n += Inline140(i)
		case 141:
			n += Inline141(i)
		case 142:
			n += Inline142(i)
		case 143:
			n += Inline143(i)
		case 144:
			n += Inline144(i)
		case 145:
			n += Inline145(i)
		case 146:
			n += Inline146(i)
		case 147:
			n += Inline147(i)
		case 148:
			n += Inline148(i)
		case 149:
			n += Inline149(i)
		case 150:
			n += Inline150(i)
		case 151:
			n += Inline151(i)
		case 152:
			n += Inline152(i)
		case 153:
			n += Inline153(i)
		case 154:
			n += Inline154(i)
		case 155:
			n += Inline155(i)
		case 156:
			n += Inline156(i)
		case 157:
			n += Inline157(i)
		case 158:
			n += Inline158(i)
		case 159:
			n += Inline159(i)
		case 160:
			n += Inline160(i)
		case 161:
			n += Inline161(i)
		case 162:
			n += Inline162(i)
		case 163:
			n += Inline163(i)
		case 164:
			n += Inline164(i)
		case 165:
			n += Inline165(i)
		case 166:
			n += Inline166(i)
		case 167:
			n += Inline167(i)
		case 168:
			n += Inline168(i)
		case 169:
			n += Inline169(i)
		case 170:
			n += Inline170(i)
		case 171:
			n += Inline171(i)
		case 172:
			n += Inline172(i)
		case 173:
			n += Inline173(i)
		case 174:
			n += Inline174(i)
		case 175:
			n += Inline175(i)
		case 176:
			n += Inline176(i)
		case 177:
			n += Inline177(i)
		case 178:
			n += Inline178(i)
		case 179:
			n += Inline179(i)
		case 180:
			n += Inline180(i)
		case 181:
			n += Inline181(i)
		case 182:
			n += Inline182(i)
		case 183:
			n += Inline183(i)
		case 184:
			n += Inline184(i)
		case 185:
			n += Inline185(i)
		case 186:
			n += Inline186(i)
		case 187:
			n += Inline187(i)
		case 188:
			n += Inline188(i)
		case 189:
			n += Inline189(i)
		case 190:
			n += Inline190(i)
		case 191:
			n += Inline191(i)
		case 192:
			n += Inline192(i)
		case 193:
			n += Inline193(i)
		case 194:
			n += Inline194(i)
		case 195:
			n += Inline195(i)
		case 196:
			n += Inline196(i)
		case 197:
			n += Inline197(i)
		case 198:
			n += Inline198(i)
		case 199:
			n += Inline199(i)
		case 200:
			n += Inline200(i)
		case 201:
			n += Inline201(i)
		case 202:
			n += Inline202(i)
		case 203:
			n += Inline203(i)
		case 204:
			n += Inline204(i)
		case 205:
			n += Inline205(i)
		case 206:
			n += Inline206(i)
		case 207:
			n += Inline207(i)
		case 208:
			n += Inline208(i)
		case 209:
			n += Inline209(i)
		case 210:
			n += Inline210(i)
		case 211:
			n += Inline211(i)
		case 212:
			n += Inline212(i)
		case 213:
			n += Inline213(i)
		case 214:
			n += Inline214(i)
		case 215:
			n += Inline215(i)
		case 216:
			n += Inline216(i)
		case 217:
			n += Inline217(i)
		case 218:
			n += Inline218(i)
		case 219:
			n += Inline219(i)
		case 220:
			n += Inline220(i)
		case 221:
			n += Inline221(i)
		case 222:
			n += Inline222(i)
		case 223:
			n += Inline223(i)
		case 224:
			n += Inline224(i)
		case 225:
			n += Inline225(i)
		case 226:
			n += Inline226(i)
		case 227:
			n += Inline227(i)
		case 228:
			n += Inline228(i)
		case 229:
			n += Inline229(i)
		case 230:
			n += Inline230(i)
		case 231:
			n += Inline231(i)
		case 232:
			n += Inline232(i)
		case 233:
			n += Inline233(i)
		case 234:
			n += Inline234(i)
		case 235:
			n += Inline235(i)
		case 236:
			n += Inline236(i)
		case 237:
			n += Inline237(i)
		case 238:
			n += Inline238(i)
		case 239:
			n += Inline239(i)
		case 240:
			n += Inline240(i)
		case 241:
			n += Inline241(i)
		case 242:
			n += Inline242(i)
		case 243:
			n += Inline243(i)
		case 244:
			n += Inline244(i)
		case 245:
			n += Inline245(i)
		case 246:
			n += Inline246(i)
		case 247:
			n += Inline247(i)
		case 248:
			n += Inline248(i)
		case 249:
			n += Inline249(i)
		case 250:
			n += Inline250(i)
		case 251:
			n += Inline251(i)
		case 252:
			n += Inline252(i)
		case 253:
			n += Inline253(i)
		case 254:
			n += Inline254(i)
		case 255:
			n += Inline255(i)
		case 256:
			n += Inline256(i)
		case 257:
			n += Inline257(i)
		case 258:
			n += Inline258(i)
		case 259:
			n += Inline259(i)
		case 260:
			n += Inline260(i)
		case 261:
			n += Inline261(i)
		case 262:
			n += Inline262(i)
		case 263:
			n += Inline263(i)
		case 264:
			n += Inline264(i)
		case 265:
			n += Inline265(i)
		case 266:
			n += Inline266(i)
		case 267:
			n += Inline267(i)
		case 268:
			n += Inline268(i)
		case 269:
			n += Inline269(i)
		case 270:
			n += Inline270(i)
		case 271:
			n += Inline271(i)
		case 272:
			n += Inline272(i)
		case 273:
			n += Inline273(i)
		case 274:
			n += Inline274(i)
		case 275:
			n += Inline275(i)
		case 276:
			n += Inline276(i)
		case 277:
			n += Inline277(i)
		case 278:
			n += Inline278(i)
		case 279:
			n += Inline279(i)
		case 280:
			n += Inline280(i)
		case 281:
			n += Inline281(i)
		case 282:
			n += Inline282(i)
		case 283:
			n += Inline283(i)
		case 284:
			n += Inline284(i)
		case 285:
			n += Inline285(i)
		case 286:
			n += Inline286(i)
		case 287:
			n += Inline287(i)
		case 288:
			n += Inline288(i)
		case 289:
			n += Inline289(i)
		case 290:
			n += Inline290(i)
		case 291:
			n += Inline291(i)
		case 292:
			n += Inline292(i)
		case 293:
			n += Inline293(i)
		case 294:
			n += Inline294(i)
		case 295:
			n += Inline295(i)
		case 296:
			n += Inline296(i)
		case 297:
			n += Inline297(i)
		case 298:
			n += Inline298(i)
		case 299:
			n += Inline299(i)
		case 300:
			n += Inline300(i)
		case 301:
			n += Inline301(i)
		case 302:
			n += Inline302(i)
		case 303:
			n += Inline303(i)
		case 304:
			n += Inline304(i)
		case 305:
			n += Inline305(i)
		case 306:
			n += Inline306(i)
		case 307:
			n += Inline307(i)
		case 308:
			n += Inline308(i)
		case 309:
			n += Inline309(i)
		case 310:
			n += Inline310(i)
		case 311:
			n += Inline311(i)
		case 312:
			n += Inline312(i)
		case 313:
			n += Inline313(i)
		case 314:
			n += Inline314(i)
		case 315:
			n += Inline315(i)
		case 316:
			n += Inline316(i)
		case 317:
			n += Inline317(i)
		case 318:
			n += Inline318(i)
		case 319:
			n += Inline319(i)
		case 320:
			n += Inline320(i)
		case 321:
			n += Inline321(i)
		case 322:
			n += Inline322(i)
		case 323:
			n += Inline323(i)
		case 324:
			n += Inline324(i)
		case 325:
			n += Inline325(i)
		case 326:
			n += Inline326(i)
		case 327:
			n += Inline327(i)
		case 328:
			n += Inline328(i)
		case 329:
			n += Inline329(i)
		case 330:
			n += Inline330(i)
		case 331:
			n += Inline331(i)
		case 332:
			n += Inline332(i)
		case 333:
			n += Inline333(i)
		case 334:
			n += Inline334(i)
		case 335:
			n += Inline335(i)
		case 336:
			n += Inline336(i)
		case 337:
			n += Inline337(i)
		case 338:
			n += Inline338(i)
		case 339:
			n += Inline339(i)
		case 340:
			n += Inline340(i)
		case 341:
			n += Inline341(i)
		case 342:
			n += Inline342(i)
		case 343:
			n += Inline343(i)
		case 344:
			n += Inline344(i)
		case 345:
			n += Inline345(i)
		case 346:
			n += Inline346(i)
		case 347:
			n += Inline347(i)
		case 348:
			n += Inline348(i)
		case 349:
			n += Inline349(i)
		case 350:
			n += Inline350(i)
		case 351:
			n += Inline351(i)
		case 352:
			n += Inline352(i)
		case 353:
			n += Inline353(i)
		case 354:
			n += Inline354(i)
		case 355:
			n += Inline355(i)
		case 356:
			n += Inline356(i)
		case 357:
			n += Inline357(i)
		case 358:
			n += Inline358(i)
		case 359:
			n += Inline359(i)
		case 360:
			n += Inline360(i)
		case 361:
			n += Inline361(i)
		case 362:
			n += Inline362(i)
		case 363:
			n += Inline363(i)
		case 364:
			n += Inline364(i)
		case 365:
			n += Inline365(i)
		case 366:
			n += Inline366(i)
		case 367:
			n += Inline367(i)
		case 368:
			n += Inline368(i)
		case 369:
			n += Inline369(i)
		case 370:
			n += Inline370(i)
		case 371:
			n += Inline371(i)
		case 372:
			n += Inline372(i)
		case 373:
			n += Inline373(i)
		case 374:
			n += Inline374(i)
		case 375:
			n += Inline375(i)
		case 376:
			n += Inline376(i)
		case 377:
			n += Inline377(i)
		case 378:
			n += Inline378(i)
		case 379:
			n += Inline379(i)
		case 380:
			n += Inline380(i)
		case 381:
			n += Inline381(i)
		case 382:
			n += Inline382(i)
		case 383:
			n += Inline383(i)
		case 384:
			n += Inline384(i)
		case 385:
			n += Inline385(i)
		case 386:
			n += Inline386(i)
		case 387:
			n += Inline387(i)
		case 388:
			n += Inline388(i)
		case 389:
			n += Inline389(i)
		case 390:
			n += Inline390(i)
		case 391:
			n += Inline391(i)
		case 392:
			n += Inline392(i)
		case 393:
			n += Inline393(i)
		case 394:
			n += Inline394(i)
		case 395:
			n += Inline395(i)
		case 396:
			n += Inline396(i)
		case 397:
			n += Inline397(i)
		case 398:
			n += Inline398(i)
		case 399:
			n += Inline399(i)
		case 400:
			n += Inline400(i)
		case 401:
			n += Inline401(i)
		case 402:
			n += Inline402(i)
		case 403:
			n += Inline403(i)
		case 404:
			n += Inline404(i)
		case 405:
			n += Inline405(i)
		case 406:
			n += Inline406(i)
		case 407:
			n += Inline407(i)
		case 408:
			n += Inline408(i)
		case 409:
			n += Inline409(i)
		case 410:
			n += Inline410(i)
		case 411:
			n += Inline411(i)
		case 412:
			n += Inline412(i)
		case 413:
			n += Inline413(i)
		case 414:
			n += Inline414(i)
		case 415:
			n += Inline415(i)
		case 416:
			n += Inline416(i)
		case 417:
			n += Inline417(i)
		case 418:
			n += Inline418(i)
		case 419:
			n += Inline419(i)
		case 420:
			n += Inline420(i)
		case 421:
			n += Inline421(i)
		case 422:
			n += Inline422(i)
		case 423:
			n += Inline423(i)
		case 424:
			n += Inline424(i)
		case 425:
			n += Inline425(i)
		case 426:
			n += Inline426(i)
		case 427:
			n += Inline427(i)
		case 428:
			n += Inline428(i)
		case 429:
			n += Inline429(i)
		case 430:
			n += Inline430(i)
		case 431:
			n += Inline431(i)
		case 432:
			n += Inline432(i)
		case 433:
			n += Inline433(i)
		case 434:
			n += Inline434(i)
		case 435:
			n += Inline435(i)
		case 436:
			n += Inline436(i)
		case 437:
			n += Inline437(i)
		case 438:
			n += Inline438(i)
		case 439:
			n += Inline439(i)
		case 440:
			n += Inline440(i)
		case 441:
			n += Inline441(i)
		case 442:
			n += Inline442(i)
		case 443:
			n += Inline443(i)
		case 444:
			n += Inline444(i)
		case 445:
			n += Inline445(i)
		case 446:
			n += Inline446(i)
		case 447:
			n += Inline447(i)
		case 448:
			n += Inline448(i)
		case 449:
			n += Inline449(i)
		case 450:
			n += Inline450(i)
		case 451:
			n += Inline451(i)
		case 452:
			n += Inline452(i)
		case 453:
			n += Inline453(i)
		case 454:
			n += Inline454(i)
		case 455:
			n += Inline455(i)
		case 456:
			n += Inline456(i)
		case 457:
			n += Inline457(i)
		case 458:
			n += Inline458(i)
		case 459:
			n += Inline459(i)
		case 460:
			n += Inline460(i)
		case 461:
			n += Inline461(i)
		case 462:
			n += Inline462(i)
		case 463:
			n += Inline463(i)
		case 464:
			n += Inline464(i)
		case 465:
			n += Inline465(i)
		case 466:
			n += Inline466(i)
		case 467:
			n += Inline467(i)
		case 468:
			n += Inline468(i)
		case 469:
			n += Inline469(i)
		case 470:
			n += Inline470(i)
		case 471:
			n += Inline471(i)
		case 472:
			n += Inline472(i)
		case 473:
			n += Inline473(i)
		case 474:
			n += Inline474(i)
		case 475:
			n += Inline475(i)
		case 476:
			n += Inline476(i)
		case 477:
			n += Inline477(i)
		case 478:
			n += Inline478(i)
		case 479:
			n += Inline479(i)
		case 480:
			n += Inline480(i)
		case 481:
			n += Inline481(i)
		case 482:
			n += Inline482(i)
		case 483:
			n += Inline483(i)
		case 484:
			n += Inline484(i)
		case 485:
			n += Inline485(i)
		case 486:
			n += Inline486(i)
		case 487:
			n += Inline487(i)
		case 488:
			n += Inline488(i)
		case 489:
			n += Inline489(i)
		case 490:
			n += Inline490(i)
		case 491:
			n += Inline491(i)
		case 492:
			n += Inline492(i)
		case 493:
			n += Inline493(i)
		case 494:
			n += Inline494(i)
		case 495:
			n += Inline495(i)
		case 496:
			n += Inline496(i)
		case 497:
			n += Inline497(i)
		case 498:
			n += Inline498(i)
		case 499:
			n += Inline499(i)
		case 500:
			n += Inline500(i)
		case 501:
			n += Inline501(i)
		case 502:
			n += Inline502(i)
		case 503:
			n += Inline503(i)
		case 504:
			n += Inline504(i)
		case 505:
			n += Inline505(i)
		case 506:
			n += Inline506(i)
		case 507:
			n += Inline507(i)
		case 508:
			n += Inline508(i)
		case 509:
			n += Inline509(i)
		case 510:
			n += Inline510(i)
		case 511:
			n += Inline511(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += InlineFuncs[randInputs[i%len(randInputs)]%512](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedSwitchNoInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch i % 512 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		case 128:
			n += NoInline128(i)
		case 129:
			n += NoInline129(i)
		case 130:
			n += NoInline130(i)
		case 131:
			n += NoInline131(i)
		case 132:
			n += NoInline132(i)
		case 133:
			n += NoInline133(i)
		case 134:
			n += NoInline134(i)
		case 135:
			n += NoInline135(i)
		case 136:
			n += NoInline136(i)
		case 137:
			n += NoInline137(i)
		case 138:
			n += NoInline138(i)
		case 139:
			n += NoInline139(i)
		case 140:
			n += NoInline140(i)
		case 141:
			n += NoInline141(i)
		case 142:
			n += NoInline142(i)
		case 143:
			n += NoInline143(i)
		case 144:
			n += NoInline144(i)
		case 145:
			n += NoInline145(i)
		case 146:
			n += NoInline146(i)
		case 147:
			n += NoInline147(i)
		case 148:
			n += NoInline148(i)
		case 149:
			n += NoInline149(i)
		case 150:
			n += NoInline150(i)
		case 151:
			n += NoInline151(i)
		case 152:
			n += NoInline152(i)
		case 153:
			n += NoInline153(i)
		case 154:
			n += NoInline154(i)
		case 155:
			n += NoInline155(i)
		case 156:
			n += NoInline156(i)
		case 157:
			n += NoInline157(i)
		case 158:
			n += NoInline158(i)
		case 159:
			n += NoInline159(i)
		case 160:
			n += NoInline160(i)
		case 161:
			n += NoInline161(i)
		case 162:
			n += NoInline162(i)
		case 163:
			n += NoInline163(i)
		case 164:
			n += NoInline164(i)
		case 165:
			n += NoInline165(i)
		case 166:
			n += NoInline166(i)
		case 167:
			n += NoInline167(i)
		case 168:
			n += NoInline168(i)
		case 169:
			n += NoInline169(i)
		case 170:
			n += NoInline170(i)
		case 171:
			n += NoInline171(i)
		case 172:
			n += NoInline172(i)
		case 173:
			n += NoInline173(i)
		case 174:
			n += NoInline174(i)
		case 175:
			n += NoInline175(i)
		case 176:
			n += NoInline176(i)
		case 177:
			n += NoInline177(i)
		case 178:
			n += NoInline178(i)
		case 179:
			n += NoInline179(i)
		case 180:
			n += NoInline180(i)
		case 181:
			n += NoInline181(i)
		case 182:
			n += NoInline182(i)
		case 183:
			n += NoInline183(i)
		case 184:
			n += NoInline184(i)
		case 185:
			n += NoInline185(i)
		case 186:
			n += NoInline186(i)
		case 187:
			n += NoInline187(i)
		case 188:
			n += NoInline188(i)
		case 189:
			n += NoInline189(i)
		case 190:
			n += NoInline190(i)
		case 191:
			n += NoInline191(i)
		case 192:
			n += NoInline192(i)
		case 193:
			n += NoInline193(i)
		case 194:
			n += NoInline194(i)
		case 195:
			n += NoInline195(i)
		case 196:
			n += NoInline196(i)
		case 197:
			n += NoInline197(i)
		case 198:
			n += NoInline198(i)
		case 199:
			n += NoInline199(i)
		case 200:
			n += NoInline200(i)
		case 201:
			n += NoInline201(i)
		case 202:
			n += NoInline202(i)
		case 203:
			n += NoInline203(i)
		case 204:
			n += NoInline204(i)
		case 205:
			n += NoInline205(i)
		case 206:
			n += NoInline206(i)
		case 207:
			n += NoInline207(i)
		case 208:
			n += NoInline208(i)
		case 209:
			n += NoInline209(i)
		case 210:
			n += NoInline210(i)
		case 211:
			n += NoInline211(i)
		case 212:
			n += NoInline212(i)
		case 213:
			n += NoInline213(i)
		case 214:
			n += NoInline214(i)
		case 215:
			n += NoInline215(i)
		case 216:
			n += NoInline216(i)
		case 217:
			n += NoInline217(i)
		case 218:
			n += NoInline218(i)
		case 219:
			n += NoInline219(i)
		case 220:
			n += NoInline220(i)
		case 221:
			n += NoInline221(i)
		case 222:
			n += NoInline222(i)
		case 223:
			n += NoInline223(i)
		case 224:
			n += NoInline224(i)
		case 225:
			n += NoInline225(i)
		case 226:
			n += NoInline226(i)
		case 227:
			n += NoInline227(i)
		case 228:
			n += NoInline228(i)
		case 229:
			n += NoInline229(i)
		case 230:
			n += NoInline230(i)
		case 231:
			n += NoInline231(i)
		case 232:
			n += NoInline232(i)
		case 233:
			n += NoInline233(i)
		case 234:
			n += NoInline234(i)
		case 235:
			n += NoInline235(i)
		case 236:
			n += NoInline236(i)
		case 237:
			n += NoInline237(i)
		case 238:
			n += NoInline238(i)
		case 239:
			n += NoInline239(i)
		case 240:
			n += NoInline240(i)
		case 241:
			n += NoInline241(i)
		case 242:
			n += NoInline242(i)
		case 243:
			n += NoInline243(i)
		case 244:
			n += NoInline244(i)
		case 245:
			n += NoInline245(i)
		case 246:
			n += NoInline246(i)
		case 247:
			n += NoInline247(i)
		case 248:
			n += NoInline248(i)
		case 249:
			n += NoInline249(i)
		case 250:
			n += NoInline250(i)
		case 251:
			n += NoInline251(i)
		case 252:
			n += NoInline252(i)
		case 253:
			n += NoInline253(i)
		case 254:
			n += NoInline254(i)
		case 255:
			n += NoInline255(i)
		case 256:
			n += NoInline256(i)
		case 257:
			n += NoInline257(i)
		case 258:
			n += NoInline258(i)
		case 259:
			n += NoInline259(i)
		case 260:
			n += NoInline260(i)
		case 261:
			n += NoInline261(i)
		case 262:
			n += NoInline262(i)
		case 263:
			n += NoInline263(i)
		case 264:
			n += NoInline264(i)
		case 265:
			n += NoInline265(i)
		case 266:
			n += NoInline266(i)
		case 267:
			n += NoInline267(i)
		case 268:
			n += NoInline268(i)
		case 269:
			n += NoInline269(i)
		case 270:
			n += NoInline270(i)
		case 271:
			n += NoInline271(i)
		case 272:
			n += NoInline272(i)
		case 273:
			n += NoInline273(i)
		case 274:
			n += NoInline274(i)
		case 275:
			n += NoInline275(i)
		case 276:
			n += NoInline276(i)
		case 277:
			n += NoInline277(i)
		case 278:
			n += NoInline278(i)
		case 279:
			n += NoInline279(i)
		case 280:
			n += NoInline280(i)
		case 281:
			n += NoInline281(i)
		case 282:
			n += NoInline282(i)
		case 283:
			n += NoInline283(i)
		case 284:
			n += NoInline284(i)
		case 285:
			n += NoInline285(i)
		case 286:
			n += NoInline286(i)
		case 287:
			n += NoInline287(i)
		case 288:
			n += NoInline288(i)
		case 289:
			n += NoInline289(i)
		case 290:
			n += NoInline290(i)
		case 291:
			n += NoInline291(i)
		case 292:
			n += NoInline292(i)
		case 293:
			n += NoInline293(i)
		case 294:
			n += NoInline294(i)
		case 295:
			n += NoInline295(i)
		case 296:
			n += NoInline296(i)
		case 297:
			n += NoInline297(i)
		case 298:
			n += NoInline298(i)
		case 299:
			n += NoInline299(i)
		case 300:
			n += NoInline300(i)
		case 301:
			n += NoInline301(i)
		case 302:
			n += NoInline302(i)
		case 303:
			n += NoInline303(i)
		case 304:
			n += NoInline304(i)
		case 305:
			n += NoInline305(i)
		case 306:
			n += NoInline306(i)
		case 307:
			n += NoInline307(i)
		case 308:
			n += NoInline308(i)
		case 309:
			n += NoInline309(i)
		case 310:
			n += NoInline310(i)
		case 311:
			n += NoInline311(i)
		case 312:
			n += NoInline312(i)
		case 313:
			n += NoInline313(i)
		case 314:
			n += NoInline314(i)
		case 315:
			n += NoInline315(i)
		case 316:
			n += NoInline316(i)
		case 317:
			n += NoInline317(i)
		case 318:
			n += NoInline318(i)
		case 319:
			n += NoInline319(i)
		case 320:
			n += NoInline320(i)
		case 321:
			n += NoInline321(i)
		case 322:
			n += NoInline322(i)
		case 323:
			n += NoInline323(i)
		case 324:
			n += NoInline324(i)
		case 325:
			n += NoInline325(i)
		case 326:
			n += NoInline326(i)
		case 327:
			n += NoInline327(i)
		case 328:
			n += NoInline328(i)
		case 329:
			n += NoInline329(i)
		case 330:
			n += NoInline330(i)
		case 331:
			n += NoInline331(i)
		case 332:
			n += NoInline332(i)
		case 333:
			n += NoInline333(i)
		case 334:
			n += NoInline334(i)
		case 335:
			n += NoInline335(i)
		case 336:
			n += NoInline336(i)
		case 337:
			n += NoInline337(i)
		case 338:
			n += NoInline338(i)
		case 339:
			n += NoInline339(i)
		case 340:
			n += NoInline340(i)
		case 341:
			n += NoInline341(i)
		case 342:
			n += NoInline342(i)
		case 343:
			n += NoInline343(i)
		case 344:
			n += NoInline344(i)
		case 345:
			n += NoInline345(i)
		case 346:
			n += NoInline346(i)
		case 347:
			n += NoInline347(i)
		case 348:
			n += NoInline348(i)
		case 349:
			n += NoInline349(i)
		case 350:
			n += NoInline350(i)
		case 351:
			n += NoInline351(i)
		case 352:
			n += NoInline352(i)
		case 353:
			n += NoInline353(i)
		case 354:
			n += NoInline354(i)
		case 355:
			n += NoInline355(i)
		case 356:
			n += NoInline356(i)
		case 357:
			n += NoInline357(i)
		case 358:
			n += NoInline358(i)
		case 359:
			n += NoInline359(i)
		case 360:
			n += NoInline360(i)
		case 361:
			n += NoInline361(i)
		case 362:
			n += NoInline362(i)
		case 363:
			n += NoInline363(i)
		case 364:
			n += NoInline364(i)
		case 365:
			n += NoInline365(i)
		case 366:
			n += NoInline366(i)
		case 367:
			n += NoInline367(i)
		case 368:
			n += NoInline368(i)
		case 369:
			n += NoInline369(i)
		case 370:
			n += NoInline370(i)
		case 371:
			n += NoInline371(i)
		case 372:
			n += NoInline372(i)
		case 373:
			n += NoInline373(i)
		case 374:
			n += NoInline374(i)
		case 375:
			n += NoInline375(i)
		case 376:
			n += NoInline376(i)
		case 377:
			n += NoInline377(i)
		case 378:
			n += NoInline378(i)
		case 379:
			n += NoInline379(i)
		case 380:
			n += NoInline380(i)
		case 381:
			n += NoInline381(i)
		case 382:
			n += NoInline382(i)
		case 383:
			n += NoInline383(i)
		case 384:
			n += NoInline384(i)
		case 385:
			n += NoInline385(i)
		case 386:
			n += NoInline386(i)
		case 387:
			n += NoInline387(i)
		case 388:
			n += NoInline388(i)
		case 389:
			n += NoInline389(i)
		case 390:
			n += NoInline390(i)
		case 391:
			n += NoInline391(i)
		case 392:
			n += NoInline392(i)
		case 393:
			n += NoInline393(i)
		case 394:
			n += NoInline394(i)
		case 395:
			n += NoInline395(i)
		case 396:
			n += NoInline396(i)
		case 397:
			n += NoInline397(i)
		case 398:
			n += NoInline398(i)
		case 399:
			n += NoInline399(i)
		case 400:
			n += NoInline400(i)
		case 401:
			n += NoInline401(i)
		case 402:
			n += NoInline402(i)
		case 403:
			n += NoInline403(i)
		case 404:
			n += NoInline404(i)
		case 405:
			n += NoInline405(i)
		case 406:
			n += NoInline406(i)
		case 407:
			n += NoInline407(i)
		case 408:
			n += NoInline408(i)
		case 409:
			n += NoInline409(i)
		case 410:
			n += NoInline410(i)
		case 411:
			n += NoInline411(i)
		case 412:
			n += NoInline412(i)
		case 413:
			n += NoInline413(i)
		case 414:
			n += NoInline414(i)
		case 415:
			n += NoInline415(i)
		case 416:
			n += NoInline416(i)
		case 417:
			n += NoInline417(i)
		case 418:
			n += NoInline418(i)
		case 419:
			n += NoInline419(i)
		case 420:
			n += NoInline420(i)
		case 421:
			n += NoInline421(i)
		case 422:
			n += NoInline422(i)
		case 423:
			n += NoInline423(i)
		case 424:
			n += NoInline424(i)
		case 425:
			n += NoInline425(i)
		case 426:
			n += NoInline426(i)
		case 427:
			n += NoInline427(i)
		case 428:
			n += NoInline428(i)
		case 429:
			n += NoInline429(i)
		case 430:
			n += NoInline430(i)
		case 431:
			n += NoInline431(i)
		case 432:
			n += NoInline432(i)
		case 433:
			n += NoInline433(i)
		case 434:
			n += NoInline434(i)
		case 435:
			n += NoInline435(i)
		case 436:
			n += NoInline436(i)
		case 437:
			n += NoInline437(i)
		case 438:
			n += NoInline438(i)
		case 439:
			n += NoInline439(i)
		case 440:
			n += NoInline440(i)
		case 441:
			n += NoInline441(i)
		case 442:
			n += NoInline442(i)
		case 443:
			n += NoInline443(i)
		case 444:
			n += NoInline444(i)
		case 445:
			n += NoInline445(i)
		case 446:
			n += NoInline446(i)
		case 447:
			n += NoInline447(i)
		case 448:
			n += NoInline448(i)
		case 449:
			n += NoInline449(i)
		case 450:
			n += NoInline450(i)
		case 451:
			n += NoInline451(i)
		case 452:
			n += NoInline452(i)
		case 453:
			n += NoInline453(i)
		case 454:
			n += NoInline454(i)
		case 455:
			n += NoInline455(i)
		case 456:
			n += NoInline456(i)
		case 457:
			n += NoInline457(i)
		case 458:
			n += NoInline458(i)
		case 459:
			n += NoInline459(i)
		case 460:
			n += NoInline460(i)
		case 461:
			n += NoInline461(i)
		case 462:
			n += NoInline462(i)
		case 463:
			n += NoInline463(i)
		case 464:
			n += NoInline464(i)
		case 465:
			n += NoInline465(i)
		case 466:
			n += NoInline466(i)
		case 467:
			n += NoInline467(i)
		case 468:
			n += NoInline468(i)
		case 469:
			n += NoInline469(i)
		case 470:
			n += NoInline470(i)
		case 471:
			n += NoInline471(i)
		case 472:
			n += NoInline472(i)
		case 473:
			n += NoInline473(i)
		case 474:
			n += NoInline474(i)
		case 475:
			n += NoInline475(i)
		case 476:
			n += NoInline476(i)
		case 477:
			n += NoInline477(i)
		case 478:
			n += NoInline478(i)
		case 479:
			n += NoInline479(i)
		case 480:
			n += NoInline480(i)
		case 481:
			n += NoInline481(i)
		case 482:
			n += NoInline482(i)
		case 483:
			n += NoInline483(i)
		case 484:
			n += NoInline484(i)
		case 485:
			n += NoInline485(i)
		case 486:
			n += NoInline486(i)
		case 487:
			n += NoInline487(i)
		case 488:
			n += NoInline488(i)
		case 489:
			n += NoInline489(i)
		case 490:
			n += NoInline490(i)
		case 491:
			n += NoInline491(i)
		case 492:
			n += NoInline492(i)
		case 493:
			n += NoInline493(i)
		case 494:
			n += NoInline494(i)
		case 495:
			n += NoInline495(i)
		case 496:
			n += NoInline496(i)
		case 497:
			n += NoInline497(i)
		case 498:
			n += NoInline498(i)
		case 499:
			n += NoInline499(i)
		case 500:
			n += NoInline500(i)
		case 501:
			n += NoInline501(i)
		case 502:
			n += NoInline502(i)
		case 503:
			n += NoInline503(i)
		case 504:
			n += NoInline504(i)
		case 505:
			n += NoInline505(i)
		case 506:
			n += NoInline506(i)
		case 507:
			n += NoInline507(i)
		case 508:
			n += NoInline508(i)
		case 509:
			n += NoInline509(i)
		case 510:
			n += NoInline510(i)
		case 511:
			n += NoInline511(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableComputedMapNoInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[i%512](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupSwitchNoInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch ascInputs[i%len(ascInputs)] % 512 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		case 128:
			n += NoInline128(i)
		case 129:
			n += NoInline129(i)
		case 130:
			n += NoInline130(i)
		case 131:
			n += NoInline131(i)
		case 132:
			n += NoInline132(i)
		case 133:
			n += NoInline133(i)
		case 134:
			n += NoInline134(i)
		case 135:
			n += NoInline135(i)
		case 136:
			n += NoInline136(i)
		case 137:
			n += NoInline137(i)
		case 138:
			n += NoInline138(i)
		case 139:
			n += NoInline139(i)
		case 140:
			n += NoInline140(i)
		case 141:
			n += NoInline141(i)
		case 142:
			n += NoInline142(i)
		case 143:
			n += NoInline143(i)
		case 144:
			n += NoInline144(i)
		case 145:
			n += NoInline145(i)
		case 146:
			n += NoInline146(i)
		case 147:
			n += NoInline147(i)
		case 148:
			n += NoInline148(i)
		case 149:
			n += NoInline149(i)
		case 150:
			n += NoInline150(i)
		case 151:
			n += NoInline151(i)
		case 152:
			n += NoInline152(i)
		case 153:
			n += NoInline153(i)
		case 154:
			n += NoInline154(i)
		case 155:
			n += NoInline155(i)
		case 156:
			n += NoInline156(i)
		case 157:
			n += NoInline157(i)
		case 158:
			n += NoInline158(i)
		case 159:
			n += NoInline159(i)
		case 160:
			n += NoInline160(i)
		case 161:
			n += NoInline161(i)
		case 162:
			n += NoInline162(i)
		case 163:
			n += NoInline163(i)
		case 164:
			n += NoInline164(i)
		case 165:
			n += NoInline165(i)
		case 166:
			n += NoInline166(i)
		case 167:
			n += NoInline167(i)
		case 168:
			n += NoInline168(i)
		case 169:
			n += NoInline169(i)
		case 170:
			n += NoInline170(i)
		case 171:
			n += NoInline171(i)
		case 172:
			n += NoInline172(i)
		case 173:
			n += NoInline173(i)
		case 174:
			n += NoInline174(i)
		case 175:
			n += NoInline175(i)
		case 176:
			n += NoInline176(i)
		case 177:
			n += NoInline177(i)
		case 178:
			n += NoInline178(i)
		case 179:
			n += NoInline179(i)
		case 180:
			n += NoInline180(i)
		case 181:
			n += NoInline181(i)
		case 182:
			n += NoInline182(i)
		case 183:
			n += NoInline183(i)
		case 184:
			n += NoInline184(i)
		case 185:
			n += NoInline185(i)
		case 186:
			n += NoInline186(i)
		case 187:
			n += NoInline187(i)
		case 188:
			n += NoInline188(i)
		case 189:
			n += NoInline189(i)
		case 190:
			n += NoInline190(i)
		case 191:
			n += NoInline191(i)
		case 192:
			n += NoInline192(i)
		case 193:
			n += NoInline193(i)
		case 194:
			n += NoInline194(i)
		case 195:
			n += NoInline195(i)
		case 196:
			n += NoInline196(i)
		case 197:
			n += NoInline197(i)
		case 198:
			n += NoInline198(i)
		case 199:
			n += NoInline199(i)
		case 200:
			n += NoInline200(i)
		case 201:
			n += NoInline201(i)
		case 202:
			n += NoInline202(i)
		case 203:
			n += NoInline203(i)
		case 204:
			n += NoInline204(i)
		case 205:
			n += NoInline205(i)
		case 206:
			n += NoInline206(i)
		case 207:
			n += NoInline207(i)
		case 208:
			n += NoInline208(i)
		case 209:
			n += NoInline209(i)
		case 210:
			n += NoInline210(i)
		case 211:
			n += NoInline211(i)
		case 212:
			n += NoInline212(i)
		case 213:
			n += NoInline213(i)
		case 214:
			n += NoInline214(i)
		case 215:
			n += NoInline215(i)
		case 216:
			n += NoInline216(i)
		case 217:
			n += NoInline217(i)
		case 218:
			n += NoInline218(i)
		case 219:
			n += NoInline219(i)
		case 220:
			n += NoInline220(i)
		case 221:
			n += NoInline221(i)
		case 222:
			n += NoInline222(i)
		case 223:
			n += NoInline223(i)
		case 224:
			n += NoInline224(i)
		case 225:
			n += NoInline225(i)
		case 226:
			n += NoInline226(i)
		case 227:
			n += NoInline227(i)
		case 228:
			n += NoInline228(i)
		case 229:
			n += NoInline229(i)
		case 230:
			n += NoInline230(i)
		case 231:
			n += NoInline231(i)
		case 232:
			n += NoInline232(i)
		case 233:
			n += NoInline233(i)
		case 234:
			n += NoInline234(i)
		case 235:
			n += NoInline235(i)
		case 236:
			n += NoInline236(i)
		case 237:
			n += NoInline237(i)
		case 238:
			n += NoInline238(i)
		case 239:
			n += NoInline239(i)
		case 240:
			n += NoInline240(i)
		case 241:
			n += NoInline241(i)
		case 242:
			n += NoInline242(i)
		case 243:
			n += NoInline243(i)
		case 244:
			n += NoInline244(i)
		case 245:
			n += NoInline245(i)
		case 246:
			n += NoInline246(i)
		case 247:
			n += NoInline247(i)
		case 248:
			n += NoInline248(i)
		case 249:
			n += NoInline249(i)
		case 250:
			n += NoInline250(i)
		case 251:
			n += NoInline251(i)
		case 252:
			n += NoInline252(i)
		case 253:
			n += NoInline253(i)
		case 254:
			n += NoInline254(i)
		case 255:
			n += NoInline255(i)
		case 256:
			n += NoInline256(i)
		case 257:
			n += NoInline257(i)
		case 258:
			n += NoInline258(i)
		case 259:
			n += NoInline259(i)
		case 260:
			n += NoInline260(i)
		case 261:
			n += NoInline261(i)
		case 262:
			n += NoInline262(i)
		case 263:
			n += NoInline263(i)
		case 264:
			n += NoInline264(i)
		case 265:
			n += NoInline265(i)
		case 266:
			n += NoInline266(i)
		case 267:
			n += NoInline267(i)
		case 268:
			n += NoInline268(i)
		case 269:
			n += NoInline269(i)
		case 270:
			n += NoInline270(i)
		case 271:
			n += NoInline271(i)
		case 272:
			n += NoInline272(i)
		case 273:
			n += NoInline273(i)
		case 274:
			n += NoInline274(i)
		case 275:
			n += NoInline275(i)
		case 276:
			n += NoInline276(i)
		case 277:
			n += NoInline277(i)
		case 278:
			n += NoInline278(i)
		case 279:
			n += NoInline279(i)
		case 280:
			n += NoInline280(i)
		case 281:
			n += NoInline281(i)
		case 282:
			n += NoInline282(i)
		case 283:
			n += NoInline283(i)
		case 284:
			n += NoInline284(i)
		case 285:
			n += NoInline285(i)
		case 286:
			n += NoInline286(i)
		case 287:
			n += NoInline287(i)
		case 288:
			n += NoInline288(i)
		case 289:
			n += NoInline289(i)
		case 290:
			n += NoInline290(i)
		case 291:
			n += NoInline291(i)
		case 292:
			n += NoInline292(i)
		case 293:
			n += NoInline293(i)
		case 294:
			n += NoInline294(i)
		case 295:
			n += NoInline295(i)
		case 296:
			n += NoInline296(i)
		case 297:
			n += NoInline297(i)
		case 298:
			n += NoInline298(i)
		case 299:
			n += NoInline299(i)
		case 300:
			n += NoInline300(i)
		case 301:
			n += NoInline301(i)
		case 302:
			n += NoInline302(i)
		case 303:
			n += NoInline303(i)
		case 304:
			n += NoInline304(i)
		case 305:
			n += NoInline305(i)
		case 306:
			n += NoInline306(i)
		case 307:
			n += NoInline307(i)
		case 308:
			n += NoInline308(i)
		case 309:
			n += NoInline309(i)
		case 310:
			n += NoInline310(i)
		case 311:
			n += NoInline311(i)
		case 312:
			n += NoInline312(i)
		case 313:
			n += NoInline313(i)
		case 314:
			n += NoInline314(i)
		case 315:
			n += NoInline315(i)
		case 316:
			n += NoInline316(i)
		case 317:
			n += NoInline317(i)
		case 318:
			n += NoInline318(i)
		case 319:
			n += NoInline319(i)
		case 320:
			n += NoInline320(i)
		case 321:
			n += NoInline321(i)
		case 322:
			n += NoInline322(i)
		case 323:
			n += NoInline323(i)
		case 324:
			n += NoInline324(i)
		case 325:
			n += NoInline325(i)
		case 326:
			n += NoInline326(i)
		case 327:
			n += NoInline327(i)
		case 328:
			n += NoInline328(i)
		case 329:
			n += NoInline329(i)
		case 330:
			n += NoInline330(i)
		case 331:
			n += NoInline331(i)
		case 332:
			n += NoInline332(i)
		case 333:
			n += NoInline333(i)
		case 334:
			n += NoInline334(i)
		case 335:
			n += NoInline335(i)
		case 336:
			n += NoInline336(i)
		case 337:
			n += NoInline337(i)
		case 338:
			n += NoInline338(i)
		case 339:
			n += NoInline339(i)
		case 340:
			n += NoInline340(i)
		case 341:
			n += NoInline341(i)
		case 342:
			n += NoInline342(i)
		case 343:
			n += NoInline343(i)
		case 344:
			n += NoInline344(i)
		case 345:
			n += NoInline345(i)
		case 346:
			n += NoInline346(i)
		case 347:
			n += NoInline347(i)
		case 348:
			n += NoInline348(i)
		case 349:
			n += NoInline349(i)
		case 350:
			n += NoInline350(i)
		case 351:
			n += NoInline351(i)
		case 352:
			n += NoInline352(i)
		case 353:
			n += NoInline353(i)
		case 354:
			n += NoInline354(i)
		case 355:
			n += NoInline355(i)
		case 356:
			n += NoInline356(i)
		case 357:
			n += NoInline357(i)
		case 358:
			n += NoInline358(i)
		case 359:
			n += NoInline359(i)
		case 360:
			n += NoInline360(i)
		case 361:
			n += NoInline361(i)
		case 362:
			n += NoInline362(i)
		case 363:
			n += NoInline363(i)
		case 364:
			n += NoInline364(i)
		case 365:
			n += NoInline365(i)
		case 366:
			n += NoInline366(i)
		case 367:
			n += NoInline367(i)
		case 368:
			n += NoInline368(i)
		case 369:
			n += NoInline369(i)
		case 370:
			n += NoInline370(i)
		case 371:
			n += NoInline371(i)
		case 372:
			n += NoInline372(i)
		case 373:
			n += NoInline373(i)
		case 374:
			n += NoInline374(i)
		case 375:
			n += NoInline375(i)
		case 376:
			n += NoInline376(i)
		case 377:
			n += NoInline377(i)
		case 378:
			n += NoInline378(i)
		case 379:
			n += NoInline379(i)
		case 380:
			n += NoInline380(i)
		case 381:
			n += NoInline381(i)
		case 382:
			n += NoInline382(i)
		case 383:
			n += NoInline383(i)
		case 384:
			n += NoInline384(i)
		case 385:
			n += NoInline385(i)
		case 386:
			n += NoInline386(i)
		case 387:
			n += NoInline387(i)
		case 388:
			n += NoInline388(i)
		case 389:
			n += NoInline389(i)
		case 390:
			n += NoInline390(i)
		case 391:
			n += NoInline391(i)
		case 392:
			n += NoInline392(i)
		case 393:
			n += NoInline393(i)
		case 394:
			n += NoInline394(i)
		case 395:
			n += NoInline395(i)
		case 396:
			n += NoInline396(i)
		case 397:
			n += NoInline397(i)
		case 398:
			n += NoInline398(i)
		case 399:
			n += NoInline399(i)
		case 400:
			n += NoInline400(i)
		case 401:
			n += NoInline401(i)
		case 402:
			n += NoInline402(i)
		case 403:
			n += NoInline403(i)
		case 404:
			n += NoInline404(i)
		case 405:
			n += NoInline405(i)
		case 406:
			n += NoInline406(i)
		case 407:
			n += NoInline407(i)
		case 408:
			n += NoInline408(i)
		case 409:
			n += NoInline409(i)
		case 410:
			n += NoInline410(i)
		case 411:
			n += NoInline411(i)
		case 412:
			n += NoInline412(i)
		case 413:
			n += NoInline413(i)
		case 414:
			n += NoInline414(i)
		case 415:
			n += NoInline415(i)
		case 416:
			n += NoInline416(i)
		case 417:
			n += NoInline417(i)
		case 418:
			n += NoInline418(i)
		case 419:
			n += NoInline419(i)
		case 420:
			n += NoInline420(i)
		case 421:
			n += NoInline421(i)
		case 422:
			n += NoInline422(i)
		case 423:
			n += NoInline423(i)
		case 424:
			n += NoInline424(i)
		case 425:
			n += NoInline425(i)
		case 426:
			n += NoInline426(i)
		case 427:
			n += NoInline427(i)
		case 428:
			n += NoInline428(i)
		case 429:
			n += NoInline429(i)
		case 430:
			n += NoInline430(i)
		case 431:
			n += NoInline431(i)
		case 432:
			n += NoInline432(i)
		case 433:
			n += NoInline433(i)
		case 434:
			n += NoInline434(i)
		case 435:
			n += NoInline435(i)
		case 436:
			n += NoInline436(i)
		case 437:
			n += NoInline437(i)
		case 438:
			n += NoInline438(i)
		case 439:
			n += NoInline439(i)
		case 440:
			n += NoInline440(i)
		case 441:
			n += NoInline441(i)
		case 442:
			n += NoInline442(i)
		case 443:
			n += NoInline443(i)
		case 444:
			n += NoInline444(i)
		case 445:
			n += NoInline445(i)
		case 446:
			n += NoInline446(i)
		case 447:
			n += NoInline447(i)
		case 448:
			n += NoInline448(i)
		case 449:
			n += NoInline449(i)
		case 450:
			n += NoInline450(i)
		case 451:
			n += NoInline451(i)
		case 452:
			n += NoInline452(i)
		case 453:
			n += NoInline453(i)
		case 454:
			n += NoInline454(i)
		case 455:
			n += NoInline455(i)
		case 456:
			n += NoInline456(i)
		case 457:
			n += NoInline457(i)
		case 458:
			n += NoInline458(i)
		case 459:
			n += NoInline459(i)
		case 460:
			n += NoInline460(i)
		case 461:
			n += NoInline461(i)
		case 462:
			n += NoInline462(i)
		case 463:
			n += NoInline463(i)
		case 464:
			n += NoInline464(i)
		case 465:
			n += NoInline465(i)
		case 466:
			n += NoInline466(i)
		case 467:
			n += NoInline467(i)
		case 468:
			n += NoInline468(i)
		case 469:
			n += NoInline469(i)
		case 470:
			n += NoInline470(i)
		case 471:
			n += NoInline471(i)
		case 472:
			n += NoInline472(i)
		case 473:
			n += NoInline473(i)
		case 474:
			n += NoInline474(i)
		case 475:
			n += NoInline475(i)
		case 476:
			n += NoInline476(i)
		case 477:
			n += NoInline477(i)
		case 478:
			n += NoInline478(i)
		case 479:
			n += NoInline479(i)
		case 480:
			n += NoInline480(i)
		case 481:
			n += NoInline481(i)
		case 482:
			n += NoInline482(i)
		case 483:
			n += NoInline483(i)
		case 484:
			n += NoInline484(i)
		case 485:
			n += NoInline485(i)
		case 486:
			n += NoInline486(i)
		case 487:
			n += NoInline487(i)
		case 488:
			n += NoInline488(i)
		case 489:
			n += NoInline489(i)
		case 490:
			n += NoInline490(i)
		case 491:
			n += NoInline491(i)
		case 492:
			n += NoInline492(i)
		case 493:
			n += NoInline493(i)
		case 494:
			n += NoInline494(i)
		case 495:
			n += NoInline495(i)
		case 496:
			n += NoInline496(i)
		case 497:
			n += NoInline497(i)
		case 498:
			n += NoInline498(i)
		case 499:
			n += NoInline499(i)
		case 500:
			n += NoInline500(i)
		case 501:
			n += NoInline501(i)
		case 502:
			n += NoInline502(i)
		case 503:
			n += NoInline503(i)
		case 504:
			n += NoInline504(i)
		case 505:
			n += NoInline505(i)
		case 506:
			n += NoInline506(i)
		case 507:
			n += NoInline507(i)
		case 508:
			n += NoInline508(i)
		case 509:
			n += NoInline509(i)
		case 510:
			n += NoInline510(i)
		case 511:
			n += NoInline511(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkPredictableLookupMapNoInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[ascInputs[i%len(ascInputs)]%512](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupSwitchNoInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		switch randInputs[i%len(randInputs)] % 512 {
		case 0:
			n += NoInline0(i)
		case 1:
			n += NoInline1(i)
		case 2:
			n += NoInline2(i)
		case 3:
			n += NoInline3(i)
		case 4:
			n += NoInline4(i)
		case 5:
			n += NoInline5(i)
		case 6:
			n += NoInline6(i)
		case 7:
			n += NoInline7(i)
		case 8:
			n += NoInline8(i)
		case 9:
			n += NoInline9(i)
		case 10:
			n += NoInline10(i)
		case 11:
			n += NoInline11(i)
		case 12:
			n += NoInline12(i)
		case 13:
			n += NoInline13(i)
		case 14:
			n += NoInline14(i)
		case 15:
			n += NoInline15(i)
		case 16:
			n += NoInline16(i)
		case 17:
			n += NoInline17(i)
		case 18:
			n += NoInline18(i)
		case 19:
			n += NoInline19(i)
		case 20:
			n += NoInline20(i)
		case 21:
			n += NoInline21(i)
		case 22:
			n += NoInline22(i)
		case 23:
			n += NoInline23(i)
		case 24:
			n += NoInline24(i)
		case 25:
			n += NoInline25(i)
		case 26:
			n += NoInline26(i)
		case 27:
			n += NoInline27(i)
		case 28:
			n += NoInline28(i)
		case 29:
			n += NoInline29(i)
		case 30:
			n += NoInline30(i)
		case 31:
			n += NoInline31(i)
		case 32:
			n += NoInline32(i)
		case 33:
			n += NoInline33(i)
		case 34:
			n += NoInline34(i)
		case 35:
			n += NoInline35(i)
		case 36:
			n += NoInline36(i)
		case 37:
			n += NoInline37(i)
		case 38:
			n += NoInline38(i)
		case 39:
			n += NoInline39(i)
		case 40:
			n += NoInline40(i)
		case 41:
			n += NoInline41(i)
		case 42:
			n += NoInline42(i)
		case 43:
			n += NoInline43(i)
		case 44:
			n += NoInline44(i)
		case 45:
			n += NoInline45(i)
		case 46:
			n += NoInline46(i)
		case 47:
			n += NoInline47(i)
		case 48:
			n += NoInline48(i)
		case 49:
			n += NoInline49(i)
		case 50:
			n += NoInline50(i)
		case 51:
			n += NoInline51(i)
		case 52:
			n += NoInline52(i)
		case 53:
			n += NoInline53(i)
		case 54:
			n += NoInline54(i)
		case 55:
			n += NoInline55(i)
		case 56:
			n += NoInline56(i)
		case 57:
			n += NoInline57(i)
		case 58:
			n += NoInline58(i)
		case 59:
			n += NoInline59(i)
		case 60:
			n += NoInline60(i)
		case 61:
			n += NoInline61(i)
		case 62:
			n += NoInline62(i)
		case 63:
			n += NoInline63(i)
		case 64:
			n += NoInline64(i)
		case 65:
			n += NoInline65(i)
		case 66:
			n += NoInline66(i)
		case 67:
			n += NoInline67(i)
		case 68:
			n += NoInline68(i)
		case 69:
			n += NoInline69(i)
		case 70:
			n += NoInline70(i)
		case 71:
			n += NoInline71(i)
		case 72:
			n += NoInline72(i)
		case 73:
			n += NoInline73(i)
		case 74:
			n += NoInline74(i)
		case 75:
			n += NoInline75(i)
		case 76:
			n += NoInline76(i)
		case 77:
			n += NoInline77(i)
		case 78:
			n += NoInline78(i)
		case 79:
			n += NoInline79(i)
		case 80:
			n += NoInline80(i)
		case 81:
			n += NoInline81(i)
		case 82:
			n += NoInline82(i)
		case 83:
			n += NoInline83(i)
		case 84:
			n += NoInline84(i)
		case 85:
			n += NoInline85(i)
		case 86:
			n += NoInline86(i)
		case 87:
			n += NoInline87(i)
		case 88:
			n += NoInline88(i)
		case 89:
			n += NoInline89(i)
		case 90:
			n += NoInline90(i)
		case 91:
			n += NoInline91(i)
		case 92:
			n += NoInline92(i)
		case 93:
			n += NoInline93(i)
		case 94:
			n += NoInline94(i)
		case 95:
			n += NoInline95(i)
		case 96:
			n += NoInline96(i)
		case 97:
			n += NoInline97(i)
		case 98:
			n += NoInline98(i)
		case 99:
			n += NoInline99(i)
		case 100:
			n += NoInline100(i)
		case 101:
			n += NoInline101(i)
		case 102:
			n += NoInline102(i)
		case 103:
			n += NoInline103(i)
		case 104:
			n += NoInline104(i)
		case 105:
			n += NoInline105(i)
		case 106:
			n += NoInline106(i)
		case 107:
			n += NoInline107(i)
		case 108:
			n += NoInline108(i)
		case 109:
			n += NoInline109(i)
		case 110:
			n += NoInline110(i)
		case 111:
			n += NoInline111(i)
		case 112:
			n += NoInline112(i)
		case 113:
			n += NoInline113(i)
		case 114:
			n += NoInline114(i)
		case 115:
			n += NoInline115(i)
		case 116:
			n += NoInline116(i)
		case 117:
			n += NoInline117(i)
		case 118:
			n += NoInline118(i)
		case 119:
			n += NoInline119(i)
		case 120:
			n += NoInline120(i)
		case 121:
			n += NoInline121(i)
		case 122:
			n += NoInline122(i)
		case 123:
			n += NoInline123(i)
		case 124:
			n += NoInline124(i)
		case 125:
			n += NoInline125(i)
		case 126:
			n += NoInline126(i)
		case 127:
			n += NoInline127(i)
		case 128:
			n += NoInline128(i)
		case 129:
			n += NoInline129(i)
		case 130:
			n += NoInline130(i)
		case 131:
			n += NoInline131(i)
		case 132:
			n += NoInline132(i)
		case 133:
			n += NoInline133(i)
		case 134:
			n += NoInline134(i)
		case 135:
			n += NoInline135(i)
		case 136:
			n += NoInline136(i)
		case 137:
			n += NoInline137(i)
		case 138:
			n += NoInline138(i)
		case 139:
			n += NoInline139(i)
		case 140:
			n += NoInline140(i)
		case 141:
			n += NoInline141(i)
		case 142:
			n += NoInline142(i)
		case 143:
			n += NoInline143(i)
		case 144:
			n += NoInline144(i)
		case 145:
			n += NoInline145(i)
		case 146:
			n += NoInline146(i)
		case 147:
			n += NoInline147(i)
		case 148:
			n += NoInline148(i)
		case 149:
			n += NoInline149(i)
		case 150:
			n += NoInline150(i)
		case 151:
			n += NoInline151(i)
		case 152:
			n += NoInline152(i)
		case 153:
			n += NoInline153(i)
		case 154:
			n += NoInline154(i)
		case 155:
			n += NoInline155(i)
		case 156:
			n += NoInline156(i)
		case 157:
			n += NoInline157(i)
		case 158:
			n += NoInline158(i)
		case 159:
			n += NoInline159(i)
		case 160:
			n += NoInline160(i)
		case 161:
			n += NoInline161(i)
		case 162:
			n += NoInline162(i)
		case 163:
			n += NoInline163(i)
		case 164:
			n += NoInline164(i)
		case 165:
			n += NoInline165(i)
		case 166:
			n += NoInline166(i)
		case 167:
			n += NoInline167(i)
		case 168:
			n += NoInline168(i)
		case 169:
			n += NoInline169(i)
		case 170:
			n += NoInline170(i)
		case 171:
			n += NoInline171(i)
		case 172:
			n += NoInline172(i)
		case 173:
			n += NoInline173(i)
		case 174:
			n += NoInline174(i)
		case 175:
			n += NoInline175(i)
		case 176:
			n += NoInline176(i)
		case 177:
			n += NoInline177(i)
		case 178:
			n += NoInline178(i)
		case 179:
			n += NoInline179(i)
		case 180:
			n += NoInline180(i)
		case 181:
			n += NoInline181(i)
		case 182:
			n += NoInline182(i)
		case 183:
			n += NoInline183(i)
		case 184:
			n += NoInline184(i)
		case 185:
			n += NoInline185(i)
		case 186:
			n += NoInline186(i)
		case 187:
			n += NoInline187(i)
		case 188:
			n += NoInline188(i)
		case 189:
			n += NoInline189(i)
		case 190:
			n += NoInline190(i)
		case 191:
			n += NoInline191(i)
		case 192:
			n += NoInline192(i)
		case 193:
			n += NoInline193(i)
		case 194:
			n += NoInline194(i)
		case 195:
			n += NoInline195(i)
		case 196:
			n += NoInline196(i)
		case 197:
			n += NoInline197(i)
		case 198:
			n += NoInline198(i)
		case 199:
			n += NoInline199(i)
		case 200:
			n += NoInline200(i)
		case 201:
			n += NoInline201(i)
		case 202:
			n += NoInline202(i)
		case 203:
			n += NoInline203(i)
		case 204:
			n += NoInline204(i)
		case 205:
			n += NoInline205(i)
		case 206:
			n += NoInline206(i)
		case 207:
			n += NoInline207(i)
		case 208:
			n += NoInline208(i)
		case 209:
			n += NoInline209(i)
		case 210:
			n += NoInline210(i)
		case 211:
			n += NoInline211(i)
		case 212:
			n += NoInline212(i)
		case 213:
			n += NoInline213(i)
		case 214:
			n += NoInline214(i)
		case 215:
			n += NoInline215(i)
		case 216:
			n += NoInline216(i)
		case 217:
			n += NoInline217(i)
		case 218:
			n += NoInline218(i)
		case 219:
			n += NoInline219(i)
		case 220:
			n += NoInline220(i)
		case 221:
			n += NoInline221(i)
		case 222:
			n += NoInline222(i)
		case 223:
			n += NoInline223(i)
		case 224:
			n += NoInline224(i)
		case 225:
			n += NoInline225(i)
		case 226:
			n += NoInline226(i)
		case 227:
			n += NoInline227(i)
		case 228:
			n += NoInline228(i)
		case 229:
			n += NoInline229(i)
		case 230:
			n += NoInline230(i)
		case 231:
			n += NoInline231(i)
		case 232:
			n += NoInline232(i)
		case 233:
			n += NoInline233(i)
		case 234:
			n += NoInline234(i)
		case 235:
			n += NoInline235(i)
		case 236:
			n += NoInline236(i)
		case 237:
			n += NoInline237(i)
		case 238:
			n += NoInline238(i)
		case 239:
			n += NoInline239(i)
		case 240:
			n += NoInline240(i)
		case 241:
			n += NoInline241(i)
		case 242:
			n += NoInline242(i)
		case 243:
			n += NoInline243(i)
		case 244:
			n += NoInline244(i)
		case 245:
			n += NoInline245(i)
		case 246:
			n += NoInline246(i)
		case 247:
			n += NoInline247(i)
		case 248:
			n += NoInline248(i)
		case 249:
			n += NoInline249(i)
		case 250:
			n += NoInline250(i)
		case 251:
			n += NoInline251(i)
		case 252:
			n += NoInline252(i)
		case 253:
			n += NoInline253(i)
		case 254:
			n += NoInline254(i)
		case 255:
			n += NoInline255(i)
		case 256:
			n += NoInline256(i)
		case 257:
			n += NoInline257(i)
		case 258:
			n += NoInline258(i)
		case 259:
			n += NoInline259(i)
		case 260:
			n += NoInline260(i)
		case 261:
			n += NoInline261(i)
		case 262:
			n += NoInline262(i)
		case 263:
			n += NoInline263(i)
		case 264:
			n += NoInline264(i)
		case 265:
			n += NoInline265(i)
		case 266:
			n += NoInline266(i)
		case 267:
			n += NoInline267(i)
		case 268:
			n += NoInline268(i)
		case 269:
			n += NoInline269(i)
		case 270:
			n += NoInline270(i)
		case 271:
			n += NoInline271(i)
		case 272:
			n += NoInline272(i)
		case 273:
			n += NoInline273(i)
		case 274:
			n += NoInline274(i)
		case 275:
			n += NoInline275(i)
		case 276:
			n += NoInline276(i)
		case 277:
			n += NoInline277(i)
		case 278:
			n += NoInline278(i)
		case 279:
			n += NoInline279(i)
		case 280:
			n += NoInline280(i)
		case 281:
			n += NoInline281(i)
		case 282:
			n += NoInline282(i)
		case 283:
			n += NoInline283(i)
		case 284:
			n += NoInline284(i)
		case 285:
			n += NoInline285(i)
		case 286:
			n += NoInline286(i)
		case 287:
			n += NoInline287(i)
		case 288:
			n += NoInline288(i)
		case 289:
			n += NoInline289(i)
		case 290:
			n += NoInline290(i)
		case 291:
			n += NoInline291(i)
		case 292:
			n += NoInline292(i)
		case 293:
			n += NoInline293(i)
		case 294:
			n += NoInline294(i)
		case 295:
			n += NoInline295(i)
		case 296:
			n += NoInline296(i)
		case 297:
			n += NoInline297(i)
		case 298:
			n += NoInline298(i)
		case 299:
			n += NoInline299(i)
		case 300:
			n += NoInline300(i)
		case 301:
			n += NoInline301(i)
		case 302:
			n += NoInline302(i)
		case 303:
			n += NoInline303(i)
		case 304:
			n += NoInline304(i)
		case 305:
			n += NoInline305(i)
		case 306:
			n += NoInline306(i)
		case 307:
			n += NoInline307(i)
		case 308:
			n += NoInline308(i)
		case 309:
			n += NoInline309(i)
		case 310:
			n += NoInline310(i)
		case 311:
			n += NoInline311(i)
		case 312:
			n += NoInline312(i)
		case 313:
			n += NoInline313(i)
		case 314:
			n += NoInline314(i)
		case 315:
			n += NoInline315(i)
		case 316:
			n += NoInline316(i)
		case 317:
			n += NoInline317(i)
		case 318:
			n += NoInline318(i)
		case 319:
			n += NoInline319(i)
		case 320:
			n += NoInline320(i)
		case 321:
			n += NoInline321(i)
		case 322:
			n += NoInline322(i)
		case 323:
			n += NoInline323(i)
		case 324:
			n += NoInline324(i)
		case 325:
			n += NoInline325(i)
		case 326:
			n += NoInline326(i)
		case 327:
			n += NoInline327(i)
		case 328:
			n += NoInline328(i)
		case 329:
			n += NoInline329(i)
		case 330:
			n += NoInline330(i)
		case 331:
			n += NoInline331(i)
		case 332:
			n += NoInline332(i)
		case 333:
			n += NoInline333(i)
		case 334:
			n += NoInline334(i)
		case 335:
			n += NoInline335(i)
		case 336:
			n += NoInline336(i)
		case 337:
			n += NoInline337(i)
		case 338:
			n += NoInline338(i)
		case 339:
			n += NoInline339(i)
		case 340:
			n += NoInline340(i)
		case 341:
			n += NoInline341(i)
		case 342:
			n += NoInline342(i)
		case 343:
			n += NoInline343(i)
		case 344:
			n += NoInline344(i)
		case 345:
			n += NoInline345(i)
		case 346:
			n += NoInline346(i)
		case 347:
			n += NoInline347(i)
		case 348:
			n += NoInline348(i)
		case 349:
			n += NoInline349(i)
		case 350:
			n += NoInline350(i)
		case 351:
			n += NoInline351(i)
		case 352:
			n += NoInline352(i)
		case 353:
			n += NoInline353(i)
		case 354:
			n += NoInline354(i)
		case 355:
			n += NoInline355(i)
		case 356:
			n += NoInline356(i)
		case 357:
			n += NoInline357(i)
		case 358:
			n += NoInline358(i)
		case 359:
			n += NoInline359(i)
		case 360:
			n += NoInline360(i)
		case 361:
			n += NoInline361(i)
		case 362:
			n += NoInline362(i)
		case 363:
			n += NoInline363(i)
		case 364:
			n += NoInline364(i)
		case 365:
			n += NoInline365(i)
		case 366:
			n += NoInline366(i)
		case 367:
			n += NoInline367(i)
		case 368:
			n += NoInline368(i)
		case 369:
			n += NoInline369(i)
		case 370:
			n += NoInline370(i)
		case 371:
			n += NoInline371(i)
		case 372:
			n += NoInline372(i)
		case 373:
			n += NoInline373(i)
		case 374:
			n += NoInline374(i)
		case 375:
			n += NoInline375(i)
		case 376:
			n += NoInline376(i)
		case 377:
			n += NoInline377(i)
		case 378:
			n += NoInline378(i)
		case 379:
			n += NoInline379(i)
		case 380:
			n += NoInline380(i)
		case 381:
			n += NoInline381(i)
		case 382:
			n += NoInline382(i)
		case 383:
			n += NoInline383(i)
		case 384:
			n += NoInline384(i)
		case 385:
			n += NoInline385(i)
		case 386:
			n += NoInline386(i)
		case 387:
			n += NoInline387(i)
		case 388:
			n += NoInline388(i)
		case 389:
			n += NoInline389(i)
		case 390:
			n += NoInline390(i)
		case 391:
			n += NoInline391(i)
		case 392:
			n += NoInline392(i)
		case 393:
			n += NoInline393(i)
		case 394:
			n += NoInline394(i)
		case 395:
			n += NoInline395(i)
		case 396:
			n += NoInline396(i)
		case 397:
			n += NoInline397(i)
		case 398:
			n += NoInline398(i)
		case 399:
			n += NoInline399(i)
		case 400:
			n += NoInline400(i)
		case 401:
			n += NoInline401(i)
		case 402:
			n += NoInline402(i)
		case 403:
			n += NoInline403(i)
		case 404:
			n += NoInline404(i)
		case 405:
			n += NoInline405(i)
		case 406:
			n += NoInline406(i)
		case 407:
			n += NoInline407(i)
		case 408:
			n += NoInline408(i)
		case 409:
			n += NoInline409(i)
		case 410:
			n += NoInline410(i)
		case 411:
			n += NoInline411(i)
		case 412:
			n += NoInline412(i)
		case 413:
			n += NoInline413(i)
		case 414:
			n += NoInline414(i)
		case 415:
			n += NoInline415(i)
		case 416:
			n += NoInline416(i)
		case 417:
			n += NoInline417(i)
		case 418:
			n += NoInline418(i)
		case 419:
			n += NoInline419(i)
		case 420:
			n += NoInline420(i)
		case 421:
			n += NoInline421(i)
		case 422:
			n += NoInline422(i)
		case 423:
			n += NoInline423(i)
		case 424:
			n += NoInline424(i)
		case 425:
			n += NoInline425(i)
		case 426:
			n += NoInline426(i)
		case 427:
			n += NoInline427(i)
		case 428:
			n += NoInline428(i)
		case 429:
			n += NoInline429(i)
		case 430:
			n += NoInline430(i)
		case 431:
			n += NoInline431(i)
		case 432:
			n += NoInline432(i)
		case 433:
			n += NoInline433(i)
		case 434:
			n += NoInline434(i)
		case 435:
			n += NoInline435(i)
		case 436:
			n += NoInline436(i)
		case 437:
			n += NoInline437(i)
		case 438:
			n += NoInline438(i)
		case 439:
			n += NoInline439(i)
		case 440:
			n += NoInline440(i)
		case 441:
			n += NoInline441(i)
		case 442:
			n += NoInline442(i)
		case 443:
			n += NoInline443(i)
		case 444:
			n += NoInline444(i)
		case 445:
			n += NoInline445(i)
		case 446:
			n += NoInline446(i)
		case 447:
			n += NoInline447(i)
		case 448:
			n += NoInline448(i)
		case 449:
			n += NoInline449(i)
		case 450:
			n += NoInline450(i)
		case 451:
			n += NoInline451(i)
		case 452:
			n += NoInline452(i)
		case 453:
			n += NoInline453(i)
		case 454:
			n += NoInline454(i)
		case 455:
			n += NoInline455(i)
		case 456:
			n += NoInline456(i)
		case 457:
			n += NoInline457(i)
		case 458:
			n += NoInline458(i)
		case 459:
			n += NoInline459(i)
		case 460:
			n += NoInline460(i)
		case 461:
			n += NoInline461(i)
		case 462:
			n += NoInline462(i)
		case 463:
			n += NoInline463(i)
		case 464:
			n += NoInline464(i)
		case 465:
			n += NoInline465(i)
		case 466:
			n += NoInline466(i)
		case 467:
			n += NoInline467(i)
		case 468:
			n += NoInline468(i)
		case 469:
			n += NoInline469(i)
		case 470:
			n += NoInline470(i)
		case 471:
			n += NoInline471(i)
		case 472:
			n += NoInline472(i)
		case 473:
			n += NoInline473(i)
		case 474:
			n += NoInline474(i)
		case 475:
			n += NoInline475(i)
		case 476:
			n += NoInline476(i)
		case 477:
			n += NoInline477(i)
		case 478:
			n += NoInline478(i)
		case 479:
			n += NoInline479(i)
		case 480:
			n += NoInline480(i)
		case 481:
			n += NoInline481(i)
		case 482:
			n += NoInline482(i)
		case 483:
			n += NoInline483(i)
		case 484:
			n += NoInline484(i)
		case 485:
			n += NoInline485(i)
		case 486:
			n += NoInline486(i)
		case 487:
			n += NoInline487(i)
		case 488:
			n += NoInline488(i)
		case 489:
			n += NoInline489(i)
		case 490:
			n += NoInline490(i)
		case 491:
			n += NoInline491(i)
		case 492:
			n += NoInline492(i)
		case 493:
			n += NoInline493(i)
		case 494:
			n += NoInline494(i)
		case 495:
			n += NoInline495(i)
		case 496:
			n += NoInline496(i)
		case 497:
			n += NoInline497(i)
		case 498:
			n += NoInline498(i)
		case 499:
			n += NoInline499(i)
		case 500:
			n += NoInline500(i)
		case 501:
			n += NoInline501(i)
		case 502:
			n += NoInline502(i)
		case 503:
			n += NoInline503(i)
		case 504:
			n += NoInline504(i)
		case 505:
			n += NoInline505(i)
		case 506:
			n += NoInline506(i)
		case 507:
			n += NoInline507(i)
		case 508:
			n += NoInline508(i)
		case 509:
			n += NoInline509(i)
		case 510:
			n += NoInline510(i)
		case 511:
			n += NoInline511(i)
		}
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}

func BenchmarkUnpredictableLookupMapNoInlineFunc512(b *testing.B) {
	var n int

	for i := 0; i < b.N; i++ {
		n += NoInlineFuncs[randInputs[i%len(randInputs)]%512](i)
	}

	// n will never be < 0, but checking n should ensure that the entire benchmark loop can't be optimized away.
	if n < 0 {
		b.Fatal("can't happen")
	}
}
