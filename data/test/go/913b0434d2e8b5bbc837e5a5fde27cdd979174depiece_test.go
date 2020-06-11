package piece

import (
	c "github.com/zaramme/gogo-shogi/color"
	"testing"
)

func Test_inverse(t *testing.T) {

	testCase := func(input Piece, expect Piece) {

		output := input.Inverse()
		if output != expect {
			t.Errorf("変換に失敗しました input = %d output = %d", input, output)
		}
	}

	testCase(BPawn, WPawn)
	testCase(BLance, WLance)
	testCase(BKnight, WKnight)
	testCase(BSilver, WSilver)
	testCase(BBishop, WBishop)
	testCase(BRook, WRook)
	testCase(BGold, WGold)
	testCase(BKing, WKing)
	testCase(BProPawn, WProPawn)
	testCase(BProLance, WProLance)
	testCase(BProKnight, WProKnight)
	testCase(BProSilver, WProSilver)
	testCase(BHorse, WHorse)
	testCase(BDragon, WDragon)
	testCase(WPawn, BPawn)
	testCase(WLance, BLance)
	testCase(WKnight, BKnight)
	testCase(WSilver, BSilver)
	testCase(WBishop, BBishop)
	testCase(WRook, BRook)
	testCase(WGold, BGold)
	testCase(WKing, BKing)
	testCase(WProPawn, BProPawn)
	testCase(WProLance, BProLance)
	testCase(WProKnight, BProKnight)
	testCase(WProSilver, BProSilver)
	testCase(WHorse, BHorse)
	testCase(WDragon, BDragon)

}

func Test_PieceToPieceType(T *testing.T) {
	testCase := func(input Piece, expect PieceType) {
		output := input.PieceType()
		if output != expect {
			T.Errorf("変換に失敗しました input = %d output = %d", input, output)
		}
	}

	testCase(BPawn, Pawn)
	testCase(BLance, Lance)
	testCase(BKnight, Knight)
	testCase(BSilver, Silver)
	testCase(BBishop, Bishop)
	testCase(BRook, Rook)
	testCase(BGold, Gold)
	testCase(BKing, King)
	testCase(BProPawn, ProPawn)
	testCase(BProLance, ProLance)
	testCase(BProKnight, ProKnight)
	testCase(BProSilver, ProSilver)
	testCase(BHorse, Horse)
	testCase(BDragon, Dragon)
	testCase(WPawn, Pawn)
	testCase(WLance, Lance)
	testCase(WKnight, Knight)
	testCase(WSilver, Silver)
	testCase(WBishop, Bishop)
	testCase(WRook, Rook)
	testCase(WGold, Gold)
	testCase(WKing, King)
	testCase(WProPawn, ProPawn)
	testCase(WProLance, ProLance)
	testCase(WProKnight, ProKnight)
	testCase(WProSilver, ProSilver)
	testCase(WHorse, Horse)
	testCase(WDragon, Dragon)

}

func Test_PieceToColor(t *testing.T) {
	testCase := func(input Piece, expect c.Color) {
		output := input.Color()
		if output != expect {
			t.Errorf("変換に失敗しました input = %d output = %d", input, output)
		}
	}

	testCase(BPawn, c.Black)
	testCase(BLance, c.Black)
	testCase(BKnight, c.Black)
	testCase(BSilver, c.Black)
	testCase(BBishop, c.Black)
	testCase(BRook, c.Black)
	testCase(BGold, c.Black)
	testCase(BKing, c.Black)
	testCase(BProPawn, c.Black)
	testCase(BProLance, c.Black)
	testCase(BProKnight, c.Black)
	testCase(BProSilver, c.Black)
	testCase(BHorse, c.Black)
	testCase(BDragon, c.Black)
	testCase(WPawn, c.White)
	testCase(WLance, c.White)
	testCase(WKnight, c.White)
	testCase(WSilver, c.White)
	testCase(WBishop, c.White)
	testCase(WRook, c.White)
	testCase(WGold, c.White)
	testCase(WKing, c.White)
	testCase(WProPawn, c.White)
	testCase(WProLance, c.White)
	testCase(WProKnight, c.White)
	testCase(WProSilver, c.White)
	testCase(WHorse, c.White)
	testCase(WDragon, c.White)

}

func TestNewPieceWithColorAndPieceType(t *testing.T) {
	testCase := func(inputColor c.Color, inputPieceType PieceType, expect Piece) {
		output := NewPieceWithColorAndPieceType(inputColor, inputPieceType)
		if output != expect {
			t.Errorf("変換に失敗しました input = %d,%d output = %d", inputColor, inputPieceType, output)
		}
	}

	testCase(c.Black, Pawn, BPawn)
	testCase(c.Black, Lance, BLance)
	testCase(c.Black, Knight, BKnight)
	testCase(c.Black, Silver, BSilver)
	testCase(c.Black, Bishop, BBishop)
	testCase(c.Black, Rook, BRook)
	testCase(c.Black, Gold, BGold)
	testCase(c.Black, King, BKing)
	testCase(c.Black, ProPawn, BProPawn)
	testCase(c.Black, ProLance, BProLance)
	testCase(c.Black, ProKnight, BProKnight)
	testCase(c.Black, ProSilver, BProSilver)
	testCase(c.Black, Horse, BHorse)
	testCase(c.Black, Dragon, BDragon)
	testCase(c.White, Pawn, WPawn)
	testCase(c.White, Lance, WLance)
	testCase(c.White, Knight, WKnight)
	testCase(c.White, Silver, WSilver)
	testCase(c.White, Bishop, WBishop)
	testCase(c.White, Rook, WRook)
	testCase(c.White, Gold, WGold)
	testCase(c.White, King, WKing)
	testCase(c.White, ProPawn, WProPawn)
	testCase(c.White, ProLance, WProLance)
	testCase(c.White, ProKnight, WProKnight)
	testCase(c.White, ProSilver, WProSilver)
	testCase(c.White, Horse, WHorse)
	testCase(c.White, Dragon, WDragon)

}

func TestPieceIsSlider(t *testing.T) {
	testCase := func(input Piece, expect bool) {
		output := input.IsSlider()
		if output != expect {
			t.Errorf("変換に失敗しました input = %d output = %d", input, output)
		}
	}

	testCase(BPawn, false)
	testCase(BLance, true)
	testCase(BKnight, false)
	testCase(BSilver, false)
	testCase(BBishop, true)
	testCase(BRook, true)
	testCase(BGold, false)
	testCase(BKing, false)
	testCase(BProPawn, false)
	testCase(BProLance, false)
	testCase(BProKnight, false)
	testCase(BProSilver, false)
	testCase(BHorse, true)
	testCase(BDragon, true)
	testCase(WPawn, false)
	testCase(WLance, true)
	testCase(WKnight, false)
	testCase(WSilver, false)
	testCase(WBishop, true)
	testCase(WRook, true)
	testCase(WGold, false)
	testCase(WKing, false)
	testCase(WProPawn, false)
	testCase(WProLance, false)
	testCase(WProKnight, false)
	testCase(WProSilver, false)
	testCase(WHorse, true)
	testCase(WDragon, true)
}

func TestPieceTypeToHandPiece(t *testing.T) {
	testCase := func(input PieceType, expect HandPiece) {
		output := input.ToHandPiece()
		if output != expect {
			t.Errorf("変換に失敗しました input = %d output = %d", input, output)
		}
	}
	testCase(Pawn, HPawn)
	testCase(Lance, HLance)
	testCase(Knight, HKnight)
	testCase(Silver, HSilver)
	testCase(Bishop, HBishop)
	testCase(Rook, HRook)
	testCase(Gold, HGold)
	testCase(King, HandPieceNum)
	testCase(ProPawn, HPawn)
	testCase(ProLance, HLance)
	testCase(ProKnight, HKnight)
	testCase(ProSilver, HSilver)
	testCase(Horse, HBishop)
	testCase(Dragon, HRook)
}
