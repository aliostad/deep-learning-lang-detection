package regex

func parse(s []byte) []token {
	p := make([]token, 0, 128)
	d, i, j, k := 0, 1, 1, 0
	t, c := token{}, 1
	for ; len(s) != 0; s = s[d:] {
		d, t.dtl, t.typ = 1, 0, int(s[0])
		switch s[0] {
		case '(':
			if len(s) > 2 && s[1] == '?' {
				switch s[2] {
				case ':':
					d, t.dtl = 3, ':'
					j, t.pr1 = j+1, j
				case '>':
					d, t.dtl = 3, '>'
					k, t.pr1 = k+1, k
				case '=':
					d, t.dtl = 3, '='
					k, t.pr1 = k+1, k
				case '!':
					d, t.dtl = 3, '!'
					k, t.pr1 = k+1, k
				case '<':
					if len(s) > 3 {
						switch s[3] {
						case '=':
							d, t.dtl = 4, '+'
							k, t.pr1 = k+1, k
						case '!':
							d, t.dtl = 4, '-'
							k, t.pr1 = k+1, k
						}
					}
				}
			} else {
				i, t.pr1 = i+1, i
			}
		case '|', ')':
			/**/
		case '?', '*', '+':
			if len(s) > 1 && s[1] == '?' {
				d, t.dtl = 2, '?'
			}
		case '{':
			d = limited(&t, s)
		case '@', '#':
			d = certain(&t, s)
		case '^', '$':
			t.typ, t.dtl = 'b', t.typ
		case '\\':
			if len(s) > 1 {
				switch s[1] {
				case 'a', 'A':
					fallthrough
				case 'b', 'B':
					fallthrough
				case 'z', 'Z':
					d, t.typ, t.dtl = 2, 'b', int(s[1])
				default:
					t.typ = 'c'
					d = decode(t.unt.zero(), s, &c)
				}
			}
		case '.':
			t.typ = 'c'
			t.unt.full().cls(0)
		case '[':
			t.typ = 'c'
			d = bracket(t.unt.zero(), s)
		default:
			t.typ = 'c'
			t.unt.zero().set(s[0])
		}
		if d == 0 {
			d, t.typ = 1, 'c'
			t.unt.zero().set(s[0])
		}
		p = append(p, t)
	}
	return p
}
