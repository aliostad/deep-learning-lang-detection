package commands

import (
	"github.com/forana/goober/memory"
	"github.com/forana/goober/state"
)

// Command is a thing.
type Command func(*state.State) uint

// Registry maps opcodes to commands.
func Registry() map[uint8]Command {
	reg := make(map[uint8]Command)

	reg[0x00] = nop

	// loads

	reg[0x06] = loadImmediateToRegister(memory.B)
	reg[0x0E] = loadImmediateToRegister(memory.C)
	reg[0x16] = loadImmediateToRegister(memory.D)
	reg[0x1E] = loadImmediateToRegister(memory.E)
	reg[0x26] = loadImmediateToRegister(memory.H)
	reg[0x2E] = loadImmediateToRegister(memory.L)

	reg[0x7F] = loadCopy(memory.A, memory.A)
	reg[0x78] = loadCopy(memory.A, memory.B)
	reg[0x79] = loadCopy(memory.A, memory.C)
	reg[0x7A] = loadCopy(memory.A, memory.D)
	reg[0x7B] = loadCopy(memory.A, memory.E)
	reg[0x7C] = loadCopy(memory.A, memory.H)
	reg[0x7D] = loadCopy(memory.A, memory.L)
	reg[0x7E] = loadCompositeLocationToRegister(memory.A, memory.H, memory.L)
	reg[0x40] = loadCopy(memory.B, memory.B)
	reg[0x41] = loadCopy(memory.B, memory.C)
	reg[0x42] = loadCopy(memory.B, memory.D)
	reg[0x43] = loadCopy(memory.B, memory.E)
	reg[0x44] = loadCopy(memory.B, memory.H)
	reg[0x45] = loadCopy(memory.B, memory.L)
	reg[0x46] = loadCompositeLocationToRegister(memory.B, memory.H, memory.L)
	reg[0x48] = loadCopy(memory.C, memory.B)
	reg[0x49] = loadCopy(memory.C, memory.C)
	reg[0x4A] = loadCopy(memory.C, memory.D)
	reg[0x4B] = loadCopy(memory.C, memory.E)
	reg[0x4C] = loadCopy(memory.C, memory.H)
	reg[0x4D] = loadCopy(memory.C, memory.L)
	reg[0x4E] = loadCompositeLocationToRegister(memory.C, memory.H, memory.L)
	reg[0x50] = loadCopy(memory.D, memory.B)
	reg[0x51] = loadCopy(memory.D, memory.C)
	reg[0x52] = loadCopy(memory.D, memory.D)
	reg[0x53] = loadCopy(memory.D, memory.E)
	reg[0x54] = loadCopy(memory.D, memory.H)
	reg[0x55] = loadCopy(memory.D, memory.L)
	reg[0x56] = loadCompositeLocationToRegister(memory.D, memory.H, memory.L)
	reg[0x58] = loadCopy(memory.E, memory.B)
	reg[0x59] = loadCopy(memory.E, memory.C)
	reg[0x5A] = loadCopy(memory.E, memory.D)
	reg[0x5B] = loadCopy(memory.E, memory.E)
	reg[0x5C] = loadCopy(memory.E, memory.H)
	reg[0x5D] = loadCopy(memory.E, memory.L)
	reg[0x5E] = loadCompositeLocationToRegister(memory.E, memory.H, memory.L)
	reg[0x60] = loadCopy(memory.H, memory.B)
	reg[0x61] = loadCopy(memory.H, memory.C)
	reg[0x62] = loadCopy(memory.H, memory.D)
	reg[0x63] = loadCopy(memory.H, memory.E)
	reg[0x64] = loadCopy(memory.H, memory.H)
	reg[0x65] = loadCopy(memory.H, memory.L)
	reg[0x66] = loadCompositeLocationToRegister(memory.H, memory.H, memory.L)
	reg[0x68] = loadCopy(memory.L, memory.B)
	reg[0x69] = loadCopy(memory.L, memory.C)
	reg[0x6A] = loadCopy(memory.L, memory.D)
	reg[0x6B] = loadCopy(memory.L, memory.E)
	reg[0x6C] = loadCopy(memory.L, memory.H)
	reg[0x6D] = loadCopy(memory.L, memory.L)
	reg[0x6E] = loadCompositeLocationToRegister(memory.L, memory.H, memory.L)
	reg[0x70] = loadRegisterToCompositeLocation(memory.H, memory.L, memory.B)
	reg[0x71] = loadRegisterToCompositeLocation(memory.H, memory.L, memory.C)
	reg[0x72] = loadRegisterToCompositeLocation(memory.H, memory.L, memory.D)
	reg[0x73] = loadRegisterToCompositeLocation(memory.H, memory.L, memory.E)
	reg[0x74] = loadRegisterToCompositeLocation(memory.H, memory.L, memory.H)
	reg[0x75] = loadRegisterToCompositeLocation(memory.H, memory.L, memory.L)
	reg[0x36] = loadImmediateToHLLocation

	reg[0x47] = loadCopy(memory.B, memory.A)
	reg[0x4F] = loadCopy(memory.C, memory.A)
	reg[0x57] = loadCopy(memory.D, memory.A)
	reg[0x5F] = loadCopy(memory.E, memory.A)
	reg[0x67] = loadCopy(memory.H, memory.A)
	reg[0x6F] = loadCopy(memory.L, memory.A)
	reg[0x02] = loadRegisterToCompositeLocation(memory.B, memory.C, memory.A)
	reg[0x12] = loadRegisterToCompositeLocation(memory.D, memory.E, memory.A)
	reg[0x77] = loadRegisterToCompositeLocation(memory.H, memory.L, memory.A)
	reg[0xEA] = loadAToImmediateLocation

	reg[0xF2] = loadOffsetCIntoA
	reg[0xE2] = loadAIntoOffsetC
	reg[0xF0] = loadOffsetImmediateIntoA
	reg[0xE0] = loadAIntoOffsetImmediate
	reg[0x3A] = loadDecrementHLToA
	reg[0x32] = loadAToDecrementHL
	reg[0x2A] = loadIncrementHLToA
	reg[0x22] = loadAToIncrementHL

	reg[0x01] = loadImmediateIntoComposite(memory.B, memory.C)
	reg[0x11] = loadImmediateIntoComposite(memory.D, memory.E)
	reg[0x21] = loadImmediateIntoComposite(memory.H, memory.L)
	reg[0x31] = loadImmediateIntoSP
	reg[0xF9] = loadHLIntoSP
	reg[0xF8] = loadSPSignedImmediateOffsetIntoHL
	reg[0x08] = loadSPToImmediate

	reg[0xF5] = push16(memory.A, memory.F)
	reg[0xC5] = push16(memory.B, memory.C)
	reg[0xD5] = push16(memory.D, memory.E)
	reg[0xE5] = push16(memory.H, memory.L)
	reg[0xF1] = pop16(memory.A, memory.F)
	reg[0xC1] = pop16(memory.B, memory.C)
	reg[0xD1] = pop16(memory.D, memory.E)
	reg[0xE1] = pop16(memory.H, memory.L)

	// alu

	reg[0x87] = addRegisterToA(memory.A)
	reg[0x80] = addRegisterToA(memory.B)
	reg[0x81] = addRegisterToA(memory.C)
	reg[0x82] = addRegisterToA(memory.D)
	reg[0x83] = addRegisterToA(memory.E)
	reg[0x84] = addRegisterToA(memory.H)
	reg[0x85] = addRegisterToA(memory.L)
	reg[0x86] = addHLToA
	reg[0xC6] = addImmediateToA
	reg[0x8F] = addCarryRegisterToA(memory.A)
	reg[0x88] = addCarryRegisterToA(memory.B)
	reg[0x89] = addCarryRegisterToA(memory.C)
	reg[0x8A] = addCarryRegisterToA(memory.D)
	reg[0x8B] = addCarryRegisterToA(memory.E)
	reg[0x8C] = addCarryRegisterToA(memory.H)
	reg[0x8D] = addCarryRegisterToA(memory.L)
	reg[0x8E] = addCarryHLToA
	reg[0xCE] = addCarryImmediateToA

	return reg
}
