// 30 july 2012
package main

// nbcd <ea>
func o_nbcd(suffix rune, src Operand, dest Operand) error {
	_, _ = suffix, src		// unused
	WriteBits(0, 1, 0, 0)
	WriteBits(1, 0, 0, 0)
	WriteBits(0, 0)
	WriteEANow(dest)
	return nil
}

// neg <ea>
func o_neg(suffix rune, src Operand, dest Operand) error {
	sizes := map[rune][]byte{
		'b':	{ 0, 0 },
		'w':	{ 0, 1 },
		'l':	{ 1, 0 },
	}

	_ = src		// unused
	WriteBits(0, 1, 0, 0)
	WriteBits(0, 1, 0, 0)
	WriteBits(sizes[suffix]...)
	WriteEANow(dest)
	return nil
}

// negx <ea>
func o_negx(suffix rune, src Operand, dest Operand) error {
	sizes := map[rune][]byte{
		'b':	{ 0, 0 },
		'w':	{ 0, 1 },
		'l':	{ 1, 0 },
	}

	_ = src		// unused
	WriteBits(0, 1, 0, 0)
	WriteBits(0, 0, 0, 0)
	WriteBits(sizes[suffix]...)
	WriteEANow(dest)
	return nil
}

// nop
func o_nop(rune, Operand, Operand) error {
	WriteBits(0, 1, 0, 0)
	WriteBits(1, 1, 1, 0)
	WriteBits(0, 1, 1, 1)
	WriteBits(0, 0, 0, 1)
	return nil
}

// not <ea>
func o_not(suffix rune, src Operand, dest Operand) error {
	sizes := map[rune][]byte{
		'b':	{ 0, 0 },
		'w':	{ 0, 1 },
		'l':	{ 1, 0 },
	}

	_ = src		// unused
	WriteBits(0, 1, 0, 0)
	WriteBits(0, 1, 1, 0)
	WriteBits(sizes[suffix]...)
	WriteEANow(dest)
	return nil
}
