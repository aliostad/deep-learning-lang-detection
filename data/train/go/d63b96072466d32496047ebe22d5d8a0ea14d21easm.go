package asm

import (
	"bufio"
	"bytes"
	"encoding/binary"
	"os"
)

var writer *bufio.Writer = bufio.NewWriter(os.Stdout)
var Position int32 = 0
var entryPoint int32

func writeInt32(i int32) {
	buf := new(bytes.Buffer)
	binary.Write(buf, binary.LittleEndian, i)
	writer.Write(buf.Bytes())
	Position += 1
}

func Init() {
	writeInt32(0)
	writeInt32(0)
}

func End() {
	writer.Flush()
}

func NOP() {
	writeInt32(0)
}

func LIT(value int32) {
	writeInt32(1)
	writeInt32(value)
}

func DUP() {
	writeInt32(2)
}

func DROP() {
	writeInt32(3)
}

func SWAP() {
	writeInt32(4)
}

func PUSH() {
	writeInt32(5)
}

func POP() {
	writeInt32(6)
}

func LOOP(adress int32) {
	writeInt32(7)
	writeInt32(adress)
}

func JUMP(adress int32) {
	writeInt32(8)
	writeInt32(adress)
}

func RETURN() {
	writeInt32(9)
}

func GT_JUMP(adress int32) {
	writeInt32(10)
	writeInt32(adress)
}

func LT_JUMP(adress int32) {
	writeInt32(11)
	writeInt32(adress)
}

func NE_JUMP(adress int32) {
	writeInt32(12)
	writeInt32(adress)
}

func EQ_JUMP(adress int32) {
	writeInt32(13)
	writeInt32(adress)
}

func FETCH() {
	writeInt32(14)
}

func STORE() {
	writeInt32(15)
}

func ADD() {
	writeInt32(16)
}

func SUBSTRACT() {
	writeInt32(17)
}

func MULTIPLY() {
	writeInt32(18)
}

func DIVMOD() {
	writeInt32(19)
}

func AND() {
	writeInt32(20)
}

func OR() {
	writeInt32(21)
}

func XOR() {
	writeInt32(22)
}

func SHL() {
	writeInt32(23)
}

func SHR() {
	writeInt32(24)
}

func ZERO_EXIT() {
	writeInt32(25)
}

func INC() {
	writeInt32(26)
}

func DEC() {
	writeInt32(27)
}

func IN() {
	writeInt32(28)
}

func OUT() {
	writeInt32(29)
}

func WAIT() {
	writeInt32(30)
}

func CALL(adress int32) {
	writeInt32(adress)
}
