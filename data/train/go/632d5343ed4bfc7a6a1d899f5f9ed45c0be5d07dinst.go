package vm

import (
	. "p8/opcode"
)

func (vm *VM) inst(i uint64) {
	op := Opcode(i)
	r := vm.r
	if (op & J) != 0 {
		if (op & Jal) != 0 {
			r[15] = vm.pc
		}
		vm.pc = i << 3
	} else {
		switch op >> 12 {
		case 0:
			vm.inst0(i)
		}
	}
}

func (vm *VM) inst0(i uint64) {
	r := vm.r

	op, x, y, p, q, im := OpDec(i)
	imu := uint64(im)
	ims := sew(uint32(imu))
	ad := r[y] + uint64(ims)

	switch op {
	// system
	case Halt:
		vm.except(ExcepHalt)
	case Rdtsc:
		r[x] = vm.TSC
	case Rdttl:
		r[x] = vm.TTL

	// calculation
	case Add:
		r[x] = r[p] + r[q]
	case Addi:
		r[x] = r[y] + uint64(ims)
	case Sub:
		r[x] = r[p] - r[q]
	case Lui:
		r[x] = (imu << 32) + (r[x] & 0xffffffff)
	case And:
		r[x] = r[p] & r[q]
	case Andi:
		r[x] = r[y] & imu
	case Or:
		r[x] = r[p] | r[q]
	case Ori:
		r[x] = r[y] | imu
	case Xor:
		r[x] = r[p] ^ r[q]
	case Nor:
		r[x] = ^(r[p] | r[q])
	case Slt:
		r[x] = _slt(r[p], r[q])
	case Slti:
		r[x] = _slt(r[y], imu)
	case Slli:
		r[x] = r[y] << imu
	case Srli:
		r[x] = r[y] >> imu
	case Srai:
		r[x] = uint64(int64(r[y]) >> imu)
	case Sll:
		r[x] = r[p] << r[q]
	case Srl:
		r[x] = r[p] >> r[q]
	case Sra:
		r[x] = uint64(int64(r[p]) >> r[q])

	// control flow
	case Jr:
		vm.pc = r[p]
	case Beq:
		if r[x] == r[y] {
			vm.pc += uint64(ims) << 3
		}
	case Bne:
		if r[x] != r[y] {
			vm.pc += uint64(ims) << 3
		}

	// mul and div
	case Mul:
		r[x] = uint64(int64(r[p]) * int64(r[q]))
	case Mulu:
		r[x] = r[p] * r[q]
	case Div:
		if r[q] == 0 {
			r[x], r[y] = 0, 0
		} else {
			r[x] = r[p] / r[q]
			r[x] = r[p] % r[q]
		}
	case Divu:
		_p := int64(r[p])
		_q := int64(r[q])
		if _q == 0 {
			r[x], r[y] = 0, 0
		} else {
			r[x] = uint64(_p / _q)
			r[y] = uint64(_p % _q)
		}

	// memory
	case Ld:
		r[x] = vm.rdd(ad)
	case Lw:
		r[x] = uint64(sew(vm.rdw(ad)))
	case Lwu:
		r[x] = uint64(vm.rdh(ad))
	case Lh:
		r[x] = uint64(seh(vm.rdh(ad)))
	case Lhu:
		r[x] = uint64(vm.rdh(ad))
	case Lb:
		r[x] = uint64(seb(vm.rdb(ad)))
	case Lbu:
		r[x] = uint64(vm.rdb(ad))
	case Sd:
		vm.wrd(ad, r[x])
	case Sw:
		vm.wrw(ad, uint32(r[x]))
	case Sh:
		vm.wrh(ad, uint16(r[x]))
	case Sb:
		vm.wrb(ad, uint8(r[x]))
	}
}
