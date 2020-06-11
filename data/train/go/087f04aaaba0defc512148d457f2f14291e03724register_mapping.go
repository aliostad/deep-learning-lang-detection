package macho_widgets

import (
	"debug/macho"
	"fmt"
)

// useless, but keep it for future reference
func (f *File) registerString(r uint64) string {
	switch f.Cpu {
	case macho.Cpu386:
		switch {
		case r == 0:
			return "0 (%eax)"
		case r == 1:
			return "1 (%edx)"
		case r == 2:
			return "2 (%ecx)"
		case r == 3:
			return "3 (%ebx)"
		case r == 4:
			return "4 (%esp)"
		case r == 5:
			return "5 (%ebp)"
		case r == 6:
			return "6 (%esi)"
		case r == 7:
			return "7 (%edi)"
		case r == 8:
			return "8 (return address)"
		case r == 9:
			return "9 (%EFLAGS)"
		case 11 <= r && r <= 18:
			return fmt.Sprintf("%d (%%st%d)", r, r-11)
		case 21 <= r && r <= 28:
			return fmt.Sprintf("%d (%%xmm%d)", r, r-21)
		case 29 <= r && r <= 36:
			return fmt.Sprintf("%d (%%mm%d)", r, r-29)
		case r == 39:
			return "39 (%mxcsr)"
		case r == 40:
			return "40 (%es)"
		case r == 41:
			return "41 (%cs)"
		case r == 42:
			return "42 (%ss)"
		case r == 43:
			return "43 (%ds)"
		case r == 44:
			return "44 (%fs)"
		case r == 45:
			return "45 (%gs)"
		case r == 48:
			return "48 (%tr)"
		case r == 49:
			return "49 (%ldtr)"
		}
	case macho.CpuAmd64:
		switch {
		case r == 0:
			return "0 (%rax)"
		case r == 1:
			return "1 (%rdx)"
		case r == 2:
			return "2 (%rcx)"
		case r == 3:
			return "3 (%rbx)"
		case r == 4:
			return "4 (%rsi)"
		case r == 5:
			return "5 (%rdi)"
		case r == 6:
			return "6 (%rbp)"
		case r == 7:
			return "7 (%rsp)"
		case 8 <= r && r <= 15:
			return fmt.Sprintf("%d (%%r%d)", r, r)
		case r == 16:
			return "16 (return address)"
		case 17 <= r && r <= 32:
			return fmt.Sprintf("%d (%%xmm%d)", r, r-17)
		case 33 <= r && r <= 40:
			return fmt.Sprintf("%d (%%st%d)", r, r-33)
		case 41 <= r && r <= 48:
			return fmt.Sprintf("%d (%%mm%d)", r, r-41)
		case r == 49:
			return "49 (%rFLAGS)"
		case r == 50:
			return "50 (%es)"
		case r == 51:
			return "51 (%cs)"
		case r == 52:
			return "52 (%ss)"
		case r == 53:
			return "53 (%ds)"
		case r == 54:
			return "54 (%fs)"
		case r == 55:
			return "55 (%gs)"
		case r == 58:
			return "58 (%fs.base)"
		case r == 59:
			return "59 (%gs.base)"
		case r == 62:
			return "62 (%tr)"
		case r == 63:
			return "62 (%ldtr)"
		case r == 64:
			return "64 (%mxcsr)"
		case r == 65:
			return "65 (%fcw)"
		case r == 66:
			return "66 (%fsw)"
		case 67 <= r && r <= 82:
			return fmt.Sprintf("%d (%%xmm%d)", r, r-51)
		case 118 <= r && r <= 125:
			return fmt.Sprintf("%d (%%k%d)", r, r-118)
		case 126 <= r && r <= 129:
			return fmt.Sprintf("%d (%%bnd%d)", r, r-126)
		}
	case macho.CpuArm:
		// TODO fill the table
		switch {
		case 0 <= r && r <= 15:
			return fmt.Sprintf("%d (r%d)", r, r)
		case 64 <= r && r <= 95:
			return fmt.Sprintf("%d (s%d)", r, r-64)
		case 96 <= r && r <= 103:
		case 104 <= r && r <= 111:
		case 112 <= r && r <= 127:
		case r == 128:
		case r == 129:
		case r == 130:
		case r == 131:
		case r == 132:
		case r == 133:
		case 144 <= r && r <= 150:
		case 151 <= r && r <= 157:
		case 158 <= r && r <= 159:
		case 160 <= r && r <= 161:
		case 162 <= r && r <= 163:
		case 164 <= r && r <= 165:
		case 192 <= r && r <= 199:
		case 256 <= r && r <= 287:
		}
	case macho.CpuArm | 0x01000000:
		switch {
		case 0 <= r && r <= 30:
			return fmt.Sprintf("%d (x%d)", r, r)
		case r == 31:
			return "31 (sp)"
		case r == 33:
			return "33 (ELR_mode)"
		case 64 <= r && r <= 95:
			return fmt.Sprintf("%d (v%d)", r, r-64)
		}
	}

	return fmt.Sprint(r)
}
