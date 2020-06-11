package standardLibrary

object StandardLibrary {

  val standardLibrary = Map(
// void printInt(int x)
"printInt" -> """
printInt:
  load #0 R3
  load #10 R1
  load SP #-1 R0
printIntLoop:
  mod R0 R1 R2
  div R0 R1 R0
  push R2
  add ONE R3 R3
  jumpnz R0 printIntLoop
  load #'0' R0
printIntLoop2:
  pop R1
  add R0 R1 R1
  store R1 0xFFF0
  sub R3 ONE R3
  jumpnz R3 printIntLoop2
  return
  """,

// void putsInt(int x)
"putsInt" -> """
putsInt:
  load #0 R3
  load #10 R1
  load SP #-1 R0
putsIntLoop:
  mod R0 R1 R2
  div R0 R1 R0
  push R2
  add ONE R3 R3
  jumpnz R0 putsIntLoop
  load #'0' R0
putsIntLoop2:
  pop R1
  add R0 R1 R1
  store R1 0xFFF0
  sub R3 ONE R3
  jumpnz R3 putsIntLoop2
  load #' ' R0
  store R0 0xFFF0
  return
  """,

// void printChar(char x)
"printChar" -> """
printChar:
  load SP #-1 R0
  store R0 0xFFF0
  return
""",

// char getChar()
"getChar" -> """
; this can probably be done more efficiently
getChar:
  store ONE 0xFFF2
  load #getCharHandler R1
  load 0x0001 R0
  load #0xFFFF R2
  and R2 R0 R0
  or R0 R1 R1
  store R1 0x0001
loop:
  jump loop
getCharHandler:
  load 0xFFF0 R0
  pop ZERO; because
  store R0 #-1 SP
  store ZERO 0xFFF2
  return
  """,

// void putsString(*char string)
"puts" -> """
puts :
  load SP #-1 R0; load location of string
  load R0 R1
putsLoop:
  store R1 0xFFF0
  add R0 ONE R0
  load R0 R1
  jumpnz R1 putsLoop
  load #'\n' R1
  store R1 0xFFF0
  return
  """,

// int malloc()
"malloc" -> """
malloc:
  load next R0
  load R0 R1 ; heap[next]

  store R0 #-1 SP; return the mallocd location

  jumpn R1 malloc_move_frontier ; if next >= 0

  store R1 next;

  return

malloc_move_frontier:
  load frontier R2; R2 = frontier
  load #0x7000 R3

  sub R3 R2 R3
  jumpz R3 memory_overflow

  store R2 next; next = frontier
  store MONE R2; heap[next] = -1;
  add R2 ONE R2; frontier ++
  store R2 frontier;

  return;


; print "error: memory overflow" and exit
memory_overflow:
  load #'m' R0
  store R0 0xFFF0
  load #'e' R0
  store R0 0xFFF0
  load #'m' R0
  store R0 0xFFF0
  load #'o' R0
  store R0 0xFFF0
  load #'r' R0
  store R0 0xFFF0
  load #'y' R0
  store R0 0xFFF0
  load #' ' R0
  store R0 0xFFF0
  load #'o' R0
  store R0 0xFFF0
  load #'v' R0
  store R0 0xFFF0
  load #'e' R0
  store R0 0xFFF0
  load #'r' R0
  store R0 0xFFF0
  load #'f' R0
  store R0 0xFFF0
  load #'l' R0
  store R0 0xFFF0
  load #'o' R0
  store R0 0xFFF0
  load #'w' R0
  store R0 0xFFF0
  load #'\n' R0
  store R0 0xFFF0
  halt
""",

"free" -> """
free:
  load SP #-1 R0
  load next R1; R1 = next
  store R1 R0; heap[pos] = net;
  store R0 next;
  return
""",

"fst" -> """
fst:
  load SP #-1 R0
  load R0 R0
  load #0xFF00 R1
  and R0 R1 R0
  store R0 #-1 SP
  return
""",

// void setFst(pair p, char c)
"setFst" -> """
setFst:
  load SP #-2 R0; *p
  load SP #-1 R1; c
  load R0 R0; p
  rotate #4 R1 R1
  load #0xFF00 R2
  and R1 R2 R1; rotated, filtered c
  load #0x00FF R2;
  and R2 R0 R2;
  or R1 R2 R2;
  store R2 R0;
  return
""")
}