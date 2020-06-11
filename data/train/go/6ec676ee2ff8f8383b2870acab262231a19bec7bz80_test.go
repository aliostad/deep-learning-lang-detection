package z80

import (
	"encoding/binary"
	"testing"
)

type mockMemory struct {
	buff []byte
}

func newMockMemory(len uint16) Memory {
	var m mockMemory
	m.buff = make([]byte, len, len)
	return &m
}

func (m *mockMemory) ReadByte(addr uint16) byte {
	return m.buff[addr]
}

func (m *mockMemory) WriteByte(addr uint16, val byte) {
	m.buff[addr] = val
}

func (m *mockMemory) ReadWord(addr uint16) uint16 {
	return binary.LittleEndian.Uint16(m.buff[addr:addr+2])
}

func (m *mockMemory) WriteWord(addr uint16, val uint16) {
	binary.LittleEndian.PutUint16(m.buff[addr:addr+2], val)
}

func TestNew(t *testing.T) {
	z := New(nil)
	if z.A != 0 {
		t.Errorf("A = %02X", z.A)
	}
	if z.F != 0 {
		t.Errorf("F = %02X", z.F)
	}
	if z.B != 0 {
		t.Errorf("B = %02X", z.B)
	}
	if z.C != 0 {
		t.Errorf("C = %02X", z.C)
	}
	if z.D != 0 {
		t.Errorf("D = %02X", z.D)
	}
	if z.E != 0 {
		t.Errorf("E = %02X", z.E)
	}
	if z.H != 0 {
		t.Errorf("H = %02X", z.H)
	}
	if z.L != 0 {
		t.Errorf("L = %02X", z.L)
	}
	if z.PC != 0 {
		t.Errorf("PC = %02X", z.PC)
	}
	if z.SP != 0 {
		t.Errorf("SP = %02X", z.SP)
	}
}

func TestGetBC(t *testing.T) {
	z := New(nil)
	z.B = 0xAA
	z.C = 0x55
	bc := z.getBC()
	if bc != 0xAA55 {
		t.Errorf("BC = %04X", bc)
	}
}

func TestSetBC(t *testing.T) {
	z := New(nil)
	z.setBC(0xAA55)
	if z.B != 0xAA {
		t.Errorf("B = %02X", z.B)
	}
	if z.C != 0x55 {
		t.Errorf("C = %02X", z.C)
	}
}

func TestGetDE(t *testing.T) {
	z := New(nil)
	z.D = 0xAA
	z.E = 0x55
	bc := z.getDE()
	if bc != 0xAA55 {
		t.Errorf("DE = %04X", bc)
	}
}

func TestSetDE(t *testing.T) {
	z := New(nil)
	z.setDE(0xAA55)
	if z.D != 0xAA {
		t.Errorf("D = %02X", z.D)
	}
	if z.E != 0x55 {
		t.Errorf("E = %02X", z.E)
	}
}

func TestGetHL(t *testing.T) {
	z := New(nil)
	z.H = 0xAA
	z.L = 0x55
	bc := z.getHL()
	if bc != 0xAA55 {
		t.Errorf("HL = %04X", bc)
	}
}

func TestSetHL(t *testing.T) {
	z := New(nil)
	z.setHL(0xAA55)
	if z.H != 0xAA {
		t.Errorf("H = %02X", z.H)
	}
	if z.L != 0x55 {
		t.Errorf("L = %02X", z.L)
	}
}

func TestGetAF(t *testing.T) {
	z := New(nil)
	z.A = 0xAA
	z.F = 0x55
	bc := z.getAF()
	if bc != 0xAA55 {
		t.Errorf("AF = %04X", bc)
	}
}

func TestSetAF(t *testing.T) {
	z := New(nil)
	z.setAF(0xAA55)
	if z.A != 0xAA {
		t.Errorf("A = %02X", z.A)
	}
	if z.F != 0x55 {
		t.Errorf("F = %02X", z.F)
	}
}

func TestGetZFlag(t *testing.T) {
	z := New(nil)
	z.F = 0x80
	if !z.getZFlag() {
		t.Error("Z flag is false.")
	}
	z.F = 0
	if z.getZFlag() {
		t.Error("Z flag is true.")
	}
}

func TestGetNFlag(t *testing.T) {
	z := New(nil)
	z.F = 0x40
	if !z.getNFlag() {
		t.Error("N flag is false.")
	}
	z.F = 0
	if z.getNFlag() {
		t.Error("N flag is true.")
	}
}

func TestGetHFlag(t *testing.T) {
	z := New(nil)
	z.F = 0x20
	if !z.getHFlag() {
		t.Error("H flag is false.")
	}
	z.F = 0
	if z.getHFlag() {
		t.Error("H flag is true.")
	}
}

func TestGetCFlag(t *testing.T) {
	z := New(nil)
	z.F = 0x10
	if !z.getCFlag() {
		t.Error("C flag is false.")
	}
	z.F = 0
	if z.getCFlag() {
		t.Error("C flag is true.")
	}
}

func TestSetZFlag(t *testing.T) {
	z := New(nil)
	z.setZFlag(true)
	if z.F != 0x80 {
		t.Error("Failed to set Z flag.")
	}
	z.setZFlag(false)
	if z.F != 0 {
		t.Error("Failed to clear Z flag.")
	}
}

func TestSetNFlag(t *testing.T) {
	z := New(nil)
	z.setNFlag(true)
	if z.F != 0x40 {
		t.Error("Failed to set N flag.")
	}
	z.setNFlag(false)
	if z.F != 0 {
		t.Error("Failed to clear N flag.")
	}
}

func TestSetHFlag(t *testing.T) {
	z := New(nil)
	z.setHFlag(true)
	if z.F != 0x20 {
		t.Error("Failed to set H flag.")
	}
	z.setHFlag(false)
	if z.F != 0 {
		t.Error("Failed to clear H flag.")
	}
}

func TestSetCFlag(t *testing.T) {
	z := New(nil)
	z.setCFlag(true)
	if z.F != 0x10 {
		t.Error("Failed to set C flag.")
	}
	z.setCFlag(false)
	if z.F != 0 {
		t.Error("Failed to clear C flag.")
	}
}

func TestDispatchNOP(t *testing.T) {
	z := New(newMockMemory(1))
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling NOP used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
}

func TestDispatchLD_BC_nn(t *testing.T) {
	z := New(newMockMemory(3))
	z.mem.(*mockMemory).buff[0] = 0x1
	z.mem.(*mockMemory).buff[1] = 0xAA
	z.mem.(*mockMemory).buff[2] = 0x55
	tick := z.Dispatch()
	if tick != 12 {
		t.Errorf("Calling LD BC nn used %d cycles, not 12", tick)
	}
	if z.PC != 3 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0003", z.PC)
	}
	if z.getBC() != 0x55AA {
		t.Errorf("BC set to 0x%04X, not 0x55AA", z.getBC())
	}
}

func TestDispatchLD_ind_BC_A(t *testing.T) {
	z := New(newMockMemory(3))
	z.mem.(*mockMemory).buff[0] = 0x2
	z.A = 0xA5
	z.setBC(1)
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling LD (BC) A used %d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}

	if z.mem.ReadByte(1) != 0xA5 {
		t.Errorf("Loaded 0x%02X, not 0xA5", z.mem.ReadByte(1))
	}
}

func TestDispatchINC_BC(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x3
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling INC BC used %d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.getBC() != 0x0001 {
		t.Errorf("BC set to 0x%04X, not 0x0001", z.getBC())
	}
}

func TestDispatchINC_BCOverflow(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x3
	z.setBC(0xFFFF)
	z.Dispatch()
	if z.getBC() != 0x0000 {
		t.Errorf("BC set to 0x%04X, not 0x0000", z.getBC())
	}
}

func TestDispatchINC_B(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x4
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling INC B used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.B != 0x01 {
		t.Errorf("B set to 0x%02X, not 0x01", z.B)
	}
	if z.getNFlag() {
		t.Error("N Flag is set after addition.")
	}
}

func TestDispatchINC_BOverflow(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x4
	z.B = 0xFF
	z.Dispatch()
	if z.B != 0x00 {
		t.Errorf("B set to 0x%02X, not 0x00", z.B)
	}
	if !z.getZFlag() {
		t.Error("Z Flag not set after overflow.")
	}
}

func TestDispatchINC_BHalfCarry(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x4
	z.B = 0x0F
	z.Dispatch()
	if z.B != 0x10 {
		t.Errorf("B set to 0x%02X, not 0x10", z.B)
	}
	if !z.getHFlag() {
		t.Error("H Flag not set after half-carry.")
	}
}

func TestDispatchDEC_B(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x5
	z.B = 0x2
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling DEC B used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.B != 0x01 {
		t.Errorf("B set to 0x%02X, not 0x01", z.B)
	}
	if !z.getNFlag() {
		t.Error("N Flag not set after subtraction.")
	}
}

func TestDispatchDEC_BOverflow(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x5
	z.Dispatch()
	if z.B != 0xFF {
		t.Errorf("B set to 0x%02X, not 0xFF", z.B)
	}
}

func TestDispatchDEC_BHalfCarry(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x5
	z.B = 0x0F
	z.Dispatch()
	if z.B != 0xE {
		t.Errorf("B set to 0x%02X, not 0xE", z.B)
	}
	if !z.getHFlag() {
		t.Error("H Flag not set after half-carry.")
	}
}

func TestDispatchLD_B_n(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0x6
	z.mem.(*mockMemory).buff[1] = 0xA5
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling LD B n used %d cycles, not 8", tick)
	}
	if z.PC != 2 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0002", z.PC)
	}
	if z.B != 0xA5 {
		t.Errorf("B set to 0x%02X, not 0xA5", z.B)
	}
}

func TestDispatchRLC_A(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x7
	z.A = 0x01
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling RLC A used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.A != 0x02 {
		t.Errorf("A set to 0x%02X, not 0x02", z.A)
	}
}

func TestDispatchRLC_AOverflow(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x7
	z.A = 0x80
	z.Dispatch()
	if z.A != 0x01 {
		t.Errorf("A set to 0x%02X, not 0x01", z.A)
	}
}

func TestDispatchLD_ind_nn_SP(t *testing.T) {
	z := New(newMockMemory(5))
	z.mem.(*mockMemory).buff[0] = 0x8
	z.mem.(*mockMemory).buff[1] = 0x3
	z.mem.(*mockMemory).buff[2] = 0x0
	z.SP = 0xAA55
	tick := z.Dispatch()
	if tick != 20 {
		t.Errorf("Calling LD (nn) SP used &d cycles, not 20", tick)
	}
	if z.PC != 3 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0003", z.PC)
	}
	if z.mem.ReadWord(0x3) != 0xAA55 {
		t.Errorf("Loaded 0x%04X, not 0xAA55", z.mem.ReadWord(0x3))
	}
}

func TestDispatchADD_HL_BC(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x9
	z.setBC(0x0A05)
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling ADD HL BC used %d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.getHL() != 0x0A05 {
		t.Errorf("B set to 0x%04X, not 0x0A05", z.getHL())
	}
	if z.getNFlag() {
		t.Error("N Flag set after addition.")
	}
}

func TestDispatchADD_HL_BCCarry(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x9
	z.setBC(0xFFFF)
	z.setHL(0x1)
	z.Dispatch()
	if z.getHL() != 0 {
		t.Errorf("HL set to 0x%04X, not 0x0000", z.getHL())
	}
	if !z.getCFlag() {
		t.Error("C Flag not set after overflow.")
	}
}

func TestDispatchADD_HL_BCHalfCarry(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x9
	z.setBC(0x0FFF)
	z.setHL(0x1)
	z.Dispatch()
	if z.getHL() != 0x1000 {
		t.Errorf("HL set to 0x%04X, not 0x1000", z.getHL())
	}
	if !z.getHFlag() {
		t.Error("H Flag not set after half-carry.")
	}
}

func TestDispatchLD_A_BC_ind(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0xA
	z.mem.(*mockMemory).buff[1] = 0xFF
	z.setBC(0x1)
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling LD A (BC) used &d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.A != 0xFF {
		t.Errorf("Loaded 0x%04X, not 0xFF", z.A)
	}
}

func TestDispatchDEC_BC(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0xB
	z.setBC(0xFFFF)
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling DEC BC used %d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.getBC() != 0xFFFE {
		t.Errorf("BC set to 0x%04X, not 0xFFFE", z.getBC())
	}
}

func TestDispatchDEC_BCOverflow(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0xB
	z.setBC(0x0)
	z.Dispatch()
	if z.getBC() != 0xFFFF {
		t.Errorf("BC set to 0x%04X, not 0xFFFF", z.getBC())
	}
}

func TestDispatchINC_C(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0xC
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling INC C used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.C != 0x01 {
		t.Errorf("C set to 0x%02X, not 0x01", z.C)
	}
	if z.getNFlag() {
		t.Error("N Flag is set after addition.")
	}
}

func TestDispatchDEC_C(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0xD
	z.C = 0x2
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling DEC C used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.C != 0x01 {
		t.Errorf("C set to 0x%02X, not 0x01", z.C)
	}
	if !z.getNFlag() {
		t.Error("N Flag not set after subtraction.")
	}
}

func TestDispatchLD_C_n(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0xE
	z.mem.(*mockMemory).buff[1] = 0xA5
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling LD C n used %d cycles, not 8", tick)
	}
	if z.PC != 2 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0002", z.PC)
	}
	if z.C != 0xA5 {
		t.Errorf("C set to 0x%02X, not 0xA5", z.C)
	}
}

func TestDispatchRRC_A(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0xF
	z.A = 0x02
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling RRC A used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.A != 0x01 {
		t.Errorf("A set to 0x%02X, not 0x01", z.A)
	}
}

func TestDispatchRRC_AOverflow(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0xF
	z.A = 0x01
	z.Dispatch()
	if z.A != 0x80 {
		t.Errorf("A set to 0x%02X, not 0x80", z.A)
	}
}

func TestDispatchLD_DE_nn(t *testing.T) {
	z := New(newMockMemory(3))
	z.mem.(*mockMemory).buff[0] = 0x11
	z.mem.(*mockMemory).buff[1] = 0xAA
	z.mem.(*mockMemory).buff[2] = 0x55
	tick := z.Dispatch()
	if tick != 12 {
		t.Errorf("Calling LD DE nn used %d cycles, not 12", tick)
	}
	if z.PC != 3 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0003", z.PC)
	}
	if z.getDE() != 0x55AA {
		t.Errorf("DE set to 0x%04X, not 0x55AA", z.getDE())
	}
}

func TestDispatchLD_ind_DE_A(t *testing.T) {
	z := New(newMockMemory(3))
	z.mem.(*mockMemory).buff[0] = 0x12
	z.A = 0xA5
	z.setDE(1)
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling LD (DE) A used %d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}

	if z.mem.ReadByte(1) != 0xA5 {
		t.Errorf("Loaded 0x%02X, not 0xA5", z.mem.ReadByte(1))
	}
}

func TestDispatchRL_A(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x17
	z.A = 0x01
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling RL A used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.A != 0x02 {
		t.Errorf("A set to 0x%02X, not 0x02", z.A)
	}
}

func TestDispatchRL_AOverflow(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x17
	z.A = 0x01
	z.setCFlag(true)
	z.Dispatch()
	if z.A != 0x03 {
		t.Errorf("A set to 0x%02X, not 0x03", z.A)
	}
}

func TestDispatchLD_B_C(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0x41
	z.C = 0xA5
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling LD B C used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}

	if z.B != 0xA5 {
		t.Errorf("Loaded 0x%02X, not 0xA5", z.B)
	}
}

func TestDispatchLD_B_ind_HL(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0x46
	z.mem.(*mockMemory).buff[1] = 0xA5
	z.setHL(0x1)
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling LD B (HL) used %d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}

	if z.B != 0xA5 {
		t.Errorf("Loaded 0x%02X, not 0xA5", z.B)
	}
}

func TestDispatchLD_ind_HL_A(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0x77
	z.mem.(*mockMemory).buff[1] = 0
	z.setHL(0x1)
	z.A = 0x5A
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling LD (HL) A used %d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}

	if z.mem.ReadByte(0x1) != 0x5A {
		t.Errorf("Loaded 0x%02X, not 0x5A", z.mem.ReadByte(0x1))
	}
}

func TestDispatchLD_ind_HL_inc_A(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0x22
	z.mem.(*mockMemory).buff[1] = 0
	z.setHL(0x1)
	z.A = 0x5A
	tick := z.Dispatch()
	if tick != 8 {
		t.Errorf("Calling LD (HL) A used %d cycles, not 8", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}

	if z.mem.ReadByte(0x1) != 0x5A {
		t.Errorf("Loaded 0x%02X, not 0x5A", z.mem.ReadByte(0x1))
	}
	if z.getHL() != 0x2 {
		t.Errorf("HL is 0x%04X, not 0x0002", z.getHL())
	}
}

func TestDispatchAdd_A_B(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x80
	z.A = 0xF0
	z.B = 0x0F
	tick := z.Dispatch()
	if tick != 4 {
		t.Errorf("Calling ADD A B used %d cycles, not 4", tick)
	}
	if z.PC != 1 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0001", z.PC)
	}
	if z.A != 0xFF {
		t.Errorf("A is 0x%02X, not 0xFF", z.A)
	}
	if z.getCFlag() {
		t.Error("C Flag is set without overflow")
	}
	if z.getHFlag() {
		t.Error("H Flag is set without half carry")
	}
}

func TestDispatchAdd_A_BOverflow(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x80
	z.A = 0xF0
	z.B = 0x11
	z.Dispatch()
	if z.A != 0x01 {
		t.Errorf("A is 0x%02X, not 0x01", z.A)
	}
	if !z.getCFlag() {
		t.Error("C Flag not set after overflow")
	}
}

func TestDispatchAdd_A_BHalfCarry(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x80
	z.A = 0xF
	z.B = 0xF
	z.Dispatch()
	if z.A != 0x1E {
		t.Errorf("A is 0x%02X, not 0x1E", z.A)
	}
	if !z.getHFlag() {
		t.Error("H Flag not set after half carry")
	}
}

func TestDispatchAdd_A_BZero(t *testing.T) {
	z := New(newMockMemory(1))
	z.mem.(*mockMemory).buff[0] = 0x80
	z.A = 0xFF
	z.B = 0x1
	z.Dispatch()
	if z.A != 0x00 {
		t.Errorf("A is 0x%02X, not 0x00", z.A)
	}
	if !z.getZFlag() {
		t.Error("Z Flag not set after zero")
	}
}

func TestDispatchJR_n(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0x18
	z.mem.(*mockMemory).buff[1] = 0xF
	tick := z.Dispatch()
	if tick != 12 {
		t.Errorf("Calling JR n used %d cycles, not 12", tick)
	}
	if z.PC != 0x11 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0011", z.PC)
	}
}

func TestDispatchJR_n_negativeOffset(t *testing.T) {
	z := New(newMockMemory(2))
	z.mem.(*mockMemory).buff[0] = 0x18
	z.mem.(*mockMemory).buff[1] = 0xFE
	tick := z.Dispatch()
	if tick != 12 {
		t.Errorf("Calling JR n used %d cycles, not 12", tick)
	}
	if z.PC != 0 {
		t.Errorf("Program Counter advanced to 0x%04X, not 0x0000", z.PC)
	}
}
