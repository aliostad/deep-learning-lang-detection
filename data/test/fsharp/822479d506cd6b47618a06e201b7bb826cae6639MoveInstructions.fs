module Fs8080.MoveInstructions

open Fs8080.Types
open Fs8080.Memory
open Fs8080.Registers

// Loads 16bit value into register BC, DE, HL, or SP
let lxi register value cpu =
    set16 register value cpu
    |> incPC 3us, 10


// Loads 16bit value from HL into memory
let shld (address: DWord) cpu memory =
    let memory = 
        store address.Value cpu.L memory
        |> store (address+1us).Value cpu.H

    incPC 3us cpu, memory, 16


// Loads 16bit value from memory into HL
let lhld (address: DWord) cpu memory =
    { cpu with 
        L = (fetch address.Value memory); 
        H = (fetch (address + 1us).Value memory) }
    |> incPC 3us, 16


// Copy 8bit value from A into address in BC or DE
let stax register cpu memory =
    let address = get16 register cpu
    let memory = store address.Value cpu.A memory

    incPC 1us cpu, memory, 7


// Load 8bit value into register
let mvi register value cpu  =
    set8 register value cpu
    |> incPC 2us, 7


// Load value from address in 16bit register to A
let ldax register cpu memory =
    let address = get16 register cpu
    let value = fetch address.Value memory

    { cpu with A = value }
    |> incPC 1us, 7


// Copy value from A to memory address
let sta (address: DWord) cpu memory =
    store address.Value cpu.A memory
    |> fun memory -> incPC 3us cpu, memory, 13


// Copy 8bit value into memory address in HL
let mvi_m value (cpu: Cpu) memory =
    store cpu.HL.Value value memory
    |> fun memory -> incPC 2us cpu, memory, 10


// Copy contents of memory address into A
let lda (address: DWord) cpu memory =
    fetch address.Value memory
    |> fun value -> { cpu with A = value }
    |> incPC 3us, 13


// Copy 8bit value from register to register
let mov_r_r dest src cpu =
    copy8 src dest cpu
    |> incPC 1us, 5


// Copy 8bit value from address HL to register
let mov_r_m dest (cpu: Cpu) memory =
    fetch cpu.HL.Value memory
    |> fun value -> set8 dest value cpu
    |> incPC 1us, 7


// Copy 8bit value from register into address HL
let mov_m_r register cpu memory =
    get8 register cpu
    |> fun value -> store cpu.HL.Value value memory
    |> fun memory -> incPC 1us cpu, memory, 7


// Copy value pointed by SP to register and increment SP
let pop register cpu memory =
    fetch16 cpu.SP.Value memory
    |> fun value -> set16 register value cpu
    |> fun cpu -> { cpu with SP = cpu.SP + 2us }
    |> incPC 1us, 10


// Copy value in register onto stack
let push register cpu memory =
    let memory =
        get16 register cpu
        |> fun value -> store16 (cpu.SP - 2us).Value value memory

    { cpu with SP = cpu.SP - 2us }
    |> incPC 1us
    |> fun cpu -> cpu, memory, 11


// Exchange Stack and HL
let xthl cpu memory =
    let stack = fetch16 cpu.SP.Value memory
    let memory = store16 cpu.SP.Value cpu.HL memory

    { cpu with H = stack.High; L = stack.Low }
    |> incPC 1us
    |> fun cpu -> cpu, memory, 18


// Exchange HL and DE
let xchg (cpu: Cpu) =
    set16 RegHL cpu.DE cpu
    |> set16 RegDE cpu.HL
    |> incPC 1us, 5


// POP the stack back onto A and FLAGS
let pop_psw cpu memory =
    fetch16 cpu.SP.Value memory
    |> fun value ->
        { cpu with 
            A = value.High; 
            FLAGS = value.Low; 
            SP = (cpu.SP + 2us) }
    |> incPC 1us, 10


// PUSH A and FLAGS to stack
let push_psw cpu memory =
    let memory = 
        store (cpu.SP - 2us).Value cpu.FLAGS memory
        |> store (cpu.SP - 1us).Value cpu.A

    { cpu with SP = cpu.SP - 2us }
    |> incPC 1us
    |> fun cpu -> cpu, memory, 11


// SP = HL
let sphl (cpu: Cpu) =
    set16 RegSP cpu.HL cpu
    |> fun cpu -> incPC 1us cpu, 5