// 15 july 2012
package main

// illegal
func o_illegal(rune, Operand, Operand) error {
	WriteBits(0, 1, 0, 0)
	WriteBits(1, 0, 1, 0)
	WriteBits(1, 1, 1, 1)
	WriteBits(1, 1, 0, 0)
	return nil
}

// jmp <ea>
func o_jmp(suffix rune, src Operand, dest Operand) error {
	_, _ = suffix, src		// unused
	WriteBits(0, 1, 0, 0)
	WriteBits(1, 1, 1, 0)
	WriteBits(1, 1)
	WriteEANow(dest)
	return nil
}

// jsr <ea>
func o_jsr(suffix rune, src Operand, dest Operand) error {
	_, _ = suffix, src		// unused
	WriteBits(0, 1, 0, 0)
	WriteBits(1, 1, 1, 0)
	WriteBits(1, 0)
	WriteEANow(dest)
	return nil
}
