// 31 july 2012
package main

// pea <ea>
func o_pea(suffix rune, src Operand, dest Operand) error {
	_, _ = suffix, src		// unused
	WriteBits(0, 1, 0, 0)
	WriteBits(1, 0, 0, 0)
	WriteBits(0, 1)
	WriteEANow(dest)
	return nil
}

// TODO rol
// TODO ror
// TODO roxl
// TODO roxr

// rtr
func o_rtr(rune, Operand, Operand) error {
	WriteBits(0, 1, 0, 0)
	WriteBits(1, 1, 1, 0)
	WriteBits(0, 1, 1, 1)
	WriteBits(0, 1, 1, 1)
	return nil
}

// rts
func o_rts(rune, Operand, Operand) error {
	WriteBits(0, 1, 0, 0)
	WriteBits(1, 1, 1, 0)
	WriteBits(0, 1, 1, 1)
	WriteBits(0, 1, 0, 1)
	return nil
}
