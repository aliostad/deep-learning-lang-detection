package main

import (
	"SmallVM/classfile"
	"SmallVM/classfile/attribute"
	"SmallVM/instructions/common"
	"SmallVM/instructions/comparison"
	"SmallVM/instructions/constant"
	"SmallVM/instructions/control"
	"SmallVM/instructions/conversion"
	"SmallVM/instructions/extended"
	"SmallVM/instructions/load"
	"SmallVM/instructions/math"
	"SmallVM/instructions/stack"
	"SmallVM/instructions/store"
	"SmallVM/rtarea"
	"fmt"
)

func Interpret(method *classfile.MethodInfo) {
	code := FetchCode(method)
	if code == nil {
		panic("code is not found!")
	}

	thread := rtarea.NewThread()
	maxLocals := uint(code.MaxLocals())
	maxStack := uint(code.MaxStack())
	frame := rtarea.NewFrame(thread, maxLocals, maxStack, code.Code())
	thread.PushFrame(frame)

	Execute(thread)
}

func FetchCode(method *classfile.MethodInfo) *attribute.Code {
	attributes := method.Attributes()
	for _, attr := range attributes {
		switch attr.(type) {
		case *attribute.Code:
			return attr.(*attribute.Code)
		}
	}
	return nil
}

func Execute(thread *rtarea.Thread) {
	// Only one frame in thread's stack now
	frame := thread.PopFrame()
	reader := common.NewByteCodeReader(frame.Code(), thread)
	fmt.Println(reader)

	for {
		bytecode := reader.ReadUInt8()
		fmt.Printf("bytecode = %x\n", bytecode)
		inst := NewInstruction(bytecode)
		inst.FetchOperands(reader)
		inst.Execute(frame)

		fmt.Println("Local Variables:")
		fmt.Println(*frame.LocalVariables())
		fmt.Println("OperandStack: ")
		fmt.Println(*frame.OperandStack())
		fmt.Println("---------------------------")
	}
}

func NewInstruction(bytecode uint8) common.Instruction {
	var inst common.Instruction
	switch bytecode {
	case 0x00:
		inst = &constant.NOP{}
	case 0x01:
		inst = &constant.ACONST_NULL{}
	case 0x02:
		inst = &constant.ICONST_M1{}
	case 0x03:
		inst = &constant.ICONST_0{}
	case 0x04:
		inst = &constant.ICONST_1{}
	case 0x05:
		inst = &constant.ICONST_2{}
	case 0x06:
		inst = &constant.ICONST_3{}
	case 0x07:
		inst = &constant.ICONST_4{}
	case 0x08:
		inst = &constant.ICONST_5{}
	case 0x09:
		inst = &constant.LCONST_0{}
	case 0x0a:
		inst = &constant.LCONST_1{}
	case 0x0b:
		inst = &constant.FCONST_0{}
	case 0x0c:
		inst = &constant.FCONST_1{}
	case 0x0d:
		inst = &constant.FCONST_2{}
	case 0x0e:
		inst = &constant.DCONST_0{}
	case 0x0f:
		inst = &constant.DCONST_1{}
	case 0x10:
		inst = &constant.BIPUSH{}
	case 0x11:
		inst = &constant.SIPUSH{}

	// TODO

	case 0x15:
		inst = &load.ILOAD{}
	case 0x16:
		inst = &load.LLOAD{}
	case 0x17:
		inst = &load.FLOAD{}
	case 0x18:
		inst = &load.DLOAD{}
	case 0x19:
		inst = &load.ALOAD{}
	case 0x1a:
		inst = &load.ILOAD_0{}
	case 0x1b:
		inst = &load.ILOAD_1{}
	case 0x1c:
		inst = &load.ILOAD_2{}
	case 0x1d:
		inst = &load.ILOAD_3{}
	case 0x1e:
		inst = &load.LLOAD_0{}
	case 0x1f:
		inst = &load.LLOAD_1{}
	case 0x20:
		inst = &load.LLOAD_2{}
	case 0x21:
		inst = &load.LLOAD_3{}
	case 0x22:
		inst = &load.FLOAD_0{}
	case 0x23:
		inst = &load.FLOAD_1{}
	case 0x24:
		inst = &load.FLOAD_2{}
	case 0x25:
		inst = &load.FLOAD_3{}
	case 0x26:
		inst = &load.DLOAD_0{}
	case 0x27:
		inst = &load.DLOAD_1{}
	case 0x28:
		inst = &load.DLOAD_2{}
	case 0x29:
		inst = &load.DLOAD_3{}
	case 0x2a:
		inst = &load.ALOAD_0{}
	case 0x2b:
		inst = &load.ALOAD_1{}
	case 0x2c:
		inst = &load.ALOAD_2{}
	case 0x2d:
		inst = &load.ALOAD_3{}

	// TODO

	case 0x36:
		inst = &store.ISTORE{}
	case 0x37:
		inst = &store.LSTORE{}
	case 0x38:
		inst = &store.FSTORE{}
	case 0x39:
		inst = &store.DSTORE{}
	case 0x3a:
		inst = &store.ASTORE{}
	case 0x3b:
		inst = &store.ISTORE_0{}
	case 0x3c:
		inst = &store.ISTORE_1{}
	case 0x3d:
		inst = &store.ISTORE_2{}
	case 0x3e:
		inst = &store.ISTORE_3{}
	case 0x3f:
		inst = &store.LSTORE_0{}
	case 0x40:
		inst = &store.LSTORE_1{}
	case 0x41:
		inst = &store.LSTORE_2{}
	case 0x42:
		inst = &store.LSTORE_3{}
	case 0x43:
		inst = &store.FSTORE_0{}
	case 0x44:
		inst = &store.FSTORE_1{}
	case 0x45:
		inst = &store.FSTORE_2{}
	case 0x46:
		inst = &store.FSTORE_3{}
	case 0x47:
		inst = &store.DSTORE_0{}
	case 0x48:
		inst = &store.DSTORE_1{}
	case 0x49:
		inst = &store.DSTORE_2{}
	case 0x4a:
		inst = &store.DSTORE_3{}
	case 0x4b:
		inst = &store.ASTORE_0{}
	case 0x4c:
		inst = &store.ASTORE_1{}
	case 0x4d:
		inst = &store.ASTORE_2{}
	case 0x4e:
		inst = &store.ASTORE_3{}

	// TODO

	case 0x57:
		inst = &stack.POP{}
	case 0x58:
		inst = &stack.POP2{}
	case 0x59:
		inst = &stack.DUP{}
	case 0x5a:
		inst = &stack.DUP_X1{}
	case 0x5b:
		inst = &stack.DUP_X2{}
	case 0x5c:
		inst = &stack.DUP2{}
	case 0x5d:
		inst = &stack.DUP2_X1{}
	case 0x5e:
		inst = &stack.DUP2_X2{}
	case 0x5f:
		inst = &stack.SWAP{}
	case 0x60:
		inst = &math.IADD{}
	case 0x61:
		inst = &math.LADD{}
	case 0x62:
		inst = &math.FADD{}
	case 0x63:
		inst = &math.DADD{}
	case 0x64:
		inst = &math.ISUB{}
	case 0x65:
		inst = &math.LSUB{}
	case 0x66:
		inst = &math.FSUB{}
	case 0x67:
		inst = &math.DSUB{}
	case 0x68:
		inst = &math.IMUL{}
	case 0x69:
		inst = &math.LMUL{}
	case 0x6a:
		inst = &math.FMUL{}
	case 0x6b:
		inst = &math.DMUL{}
	case 0x6c:
		inst = &math.IDIV{}
	case 0x6d:
		inst = &math.LDIV{}
	case 0x6e:
		inst = &math.FDIV{}
	case 0x6f:
		inst = &math.DDIV{}
	case 0x70:
		inst = &math.IREM{}
	case 0x71:
		inst = &math.FREM{}
	case 0x72:
		inst = &math.FREM{}
	case 0x73:
		inst = &math.DREM{}
	case 0x74:
		inst = &math.INEG{}
	case 0x75:
		inst = &math.LNEG{}
	case 0x76:
		inst = &math.FNEG{}
	case 0x77:
		inst = &math.DNEG{}
	case 0x78:
		inst = &math.ISHL{}
	case 0x79:
		inst = &math.LSHL{}
	case 0x7a:
		inst = &math.ISHR{}
	case 0x7b:
		inst = &math.LSHR{}
	case 0x7c:
		inst = &math.IUSHR{}
	case 0x7d:
		inst = &math.LUSHR{}
	case 0x7e:
		inst = &math.IAND{}
	case 0x7f:
		inst = &math.LAND{}
	case 0x80:
		inst = &math.IOR{}
	case 0x81:
		inst = &math.LOR{}
	case 0x82:
		inst = &math.IXOR{}
	case 0x83:
		inst = &math.LXOR{}
	case 0x84:
		inst = &math.IINC{}
	case 0x85:
		inst = &conversion.I2L{}
	case 0x86:
		inst = &conversion.I2F{}
	case 0x87:
		inst = &conversion.I2D{}
	case 0x88:
		inst = &conversion.L2I{}
	case 0x89:
		inst = &conversion.L2F{}
	case 0x8a:
		inst = &conversion.L2D{}
	case 0x8b:
		inst = &conversion.F2I{}
	case 0x8c:
		inst = &conversion.F2L{}
	case 0x8d:
		inst = &conversion.F2D{}
	case 0x8e:
		inst = &conversion.D2I{}
	case 0x8f:
		inst = &conversion.D2L{}
	case 0x90:
		inst = &conversion.D2F{}
	case 0x91:
		inst = &conversion.I2B{}
	case 0x92:
		inst = &conversion.I2C{}
	case 0x93:
		inst = &conversion.I2S{}
	case 0x94:
		inst = &comparison.LCMP{}
	case 0x95:
		inst = &comparison.FCMPL{}
	case 0x96:
		inst = &comparison.FCMPG{}
	case 0x97:
		inst = &comparison.DCMPL{}
	case 0x98:
		inst = &comparison.DCMPG{}
	case 0x99:
		inst = &comparison.IFEQ{}
	case 0x9a:
		inst = &comparison.IFNE{}
	case 0x9b:
		inst = &comparison.IFLT{}
	case 0x9c:
		inst = &comparison.IFGE{}
	case 0x9d:
		inst = &comparison.IFGT{}
	case 0x9e:
		inst = &comparison.IFLE{}
	case 0x9f:
		inst = &comparison.IF_ICMPEQ{}
	case 0xa0:
		inst = &comparison.IF_ICMPNE{}
	case 0xa1:
		inst = &comparison.IF_ICMPLT{}
	case 0xa2:
		inst = &comparison.IF_ICMPGE{}
	case 0xa3:
		inst = &comparison.IF_ICMPGT{}
	case 0xa4:
		inst = &comparison.IF_ICMPLE{}
	case 0xa5:
		inst = &comparison.IF_ACMPEQ{}
	case 0xa6:
		inst = &comparison.IF_ACMPNE{}
	case 0xa7:
		inst = &control.GOTO{}

	// TODO

	case 0xaa:
		inst = &control.TABLESWITCH{}
	case 0xab:
		inst = &control.LOOKUPSWITCH{}

	// TODO

	case 0xc4:
		inst = &extended.WIDE{}
	case 0xc6:
		inst = &comparison.IFNULL{}
	case 0xc7:
		inst = &comparison.IFNONNULL{}
	case 0xc8:
		inst = &extended.GOTO_W{}
	default:
		panic(fmt.Errorf("Unsupported bytecode: 0x%x\n!", bytecode))

	}

	return inst
}
