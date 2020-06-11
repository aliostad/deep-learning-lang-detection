// Copyright 2017 The SRKL Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package key

import (
	"time"
)

type Key struct {
	Code int
	TS   int64
}

func FromCode(kci int) *Key {
	return &Key{
		Code: kci,
		TS:   time.Now().UnixNano(),
	}
}

func CodeToString(i int) string {
	switch i {
	case 0:
		return "a"
	case 1:
		return "s"
	case 2:
		return "d"
	case 3:
		return "f"
	case 4:
		return "h"
	case 5:
		return "g"
	case 6:
		return "z"
	case 7:
		return "x"
	case 8:
		return "c"
	case 9:
		return "v"
	case 11:
		return "b"
	case 12:
		return "q"
	case 13:
		return "w"
	case 14:
		return "e"
	case 15:
		return "r"
	case 16:
		return "y"
	case 17:
		return "t"
	case 18:
		return "1"
	case 19:
		return "2"
	case 20:
		return "3"
	case 21:
		return "4"
	case 22:
		return "6"
	case 23:
		return "5"
	case 24:
		return "="
	case 25:
		return "9"
	case 26:
		return "7"
	case 27:
		return "-"
	case 28:
		return "8"
	case 29:
		return "0"
	case 30:
		return "]"
	case 31:
		return "o"
	case 32:
		return "u"
	case 33:
		return "["
	case 34:
		return "i"
	case 35:
		return "p"
	case 36:
		return "\n"
	case 37:
		return "l"
	case 38:
		return "j"
	case 39:
		return "'"
	case 40:
		return "k"
	case 41:
		return ";"
	case 42:
		return "\\"
	case 43:
		return ","
	case 44:
		return "/"
	case 45:
		return "n"
	case 46:
		return "m"
	case 47:
		return "."
	case 49:
		return " "
	case 50:
		return "`"
	case 65:
		return "."
	case 67:
		return "*"
	case 69:
		return "+"
	case 75:
		return "/"
	case 76:
		return "\n"
	case 78:
		return "-"
	case 81:
		return "="
	case 82:
		return "0"
	case 83:
		return "1"
	case 84:
		return "2"
	case 85:
		return "3"
	case 86:
		return "4"
	case 87:
		return "5"
	case 88:
		return "6"
	case 89:
		return "7"
	case 91:
		return "8"
	case 92:
		return "9"
	default:
		return ""
	}
}

func CodeToKeySymbol(i int) string {
	switch i {
	case 48:
		return "[TAB]"
	case 51:
		return "[DEL]"
	case 53:
		return "[ESC]"
	case 54:
		return "[COMMAND(right)]"
	case 55:
		return "[COMMAND(left)]"
	case 56:
		return "[SHIFT(left)]"
	case 57:
		return "[CAPS-LOCK]"
	case 58:
		return "[OPTION(left)]"
	case 59:
		return "[CONTROL(left)]"
	case 60:
		return "[SHIFT(right)]"
	case 61:
		return "[OPTION(right)]"
	case 62:
		return "[CONTROL(right)"
	case 63:
		return "[FN]"
	case 64:
		return "[F17]"
	case 71:
		return "[CLEAR]"
	case 72:
		return "[VOLUME-UP]"
	case 73:
		return "[VOLUME-DOWN]"
	case 74:
		return "[MUTE]"
	case 79:
		return "[F18]"
	case 80:
		return "[F19]"
	case 90:
		return "[F20]"
	case 96:
		return "[F5]"
	case 97:
		return "[F6]"
	case 98:
		return "[F7]"
	case 99:
		return "[F3]"
	case 100:
		return "[F8]"
	case 101:
		return "[F9]"
	case 103:
		return "[F11]"
	case 105:
		return "[F13]"
	case 106:
		return "[F16]"
	case 107:
		return "[F14]"
	case 109:
		return "[F10]"
	case 111:
		return "[F12]"
	case 113:
		return "[F15]"
	case 114:
		return "[HELP]"
	case 115:
		return "[HOME]"
	case 116:
		return "[PAGE-UP]"
	case 117:
		return "[FORWARD-DELETE]"
	case 118:
		return "[F4]"
	case 119:
		return "[END]"
	case 120:
		return "[F2]"
	case 121:
		return "[PAGE-DOWN]"
	case 122:
		return "[F1]"
	case 123:
		return "[LEFT]"
	case 124:
		return "[RIGHT]"
	case 125:
		return "[DOWN]"
	case 126:
		return "[UP]"
	case 131:
		return "[-F4]"
	case 160:
		return "[-F3]"
	default:
		return ""
	}
}

// TODO: solve / should be test only
var (
	Samples = []struct {
		K    int
		Want string
	}{
		{
			0,
			"a",
		},
		{
			26,
			"7",
		},
		{
			89,
			"7",
		},
		{
			1000000,
			"",
		},
	}
)
