#include "core.h"
core::core()
{
    mcu=new memory_controller;
    pc=0;
    sp=0;
}
core::~core()
{
    delete mcu;
}
void core::execute_opcode()
{
    opcode=mcu->load(pc);
    switch(opcode){
        case 0x00: ///load register 0 with next byte
            registers[0]=mcu->load(pc+1);
            pc+=2;
            break;
        case 0x01: ///load register 1 with next byte
            registers[1]=mcu->load(pc+1);
            pc+=2;
            break;
        case 0x02: ///load register 2 with next byte
            registers[2]=mcu->load(pc+1);
            pc+=2;
            break;
        case 0x03: ///load register 3 with next byte
            registers[3]=mcu->load(pc+1);
            pc+=2;
            break;
        case 0x04: ///load register 4 with next byte
            registers[4]=mcu->load(pc+1);
            pc+=2;
            break;
        case 0x05: ///load register 5 with next byte
            registers[5]=mcu->load(pc+1);
            pc+=2;
            break;
        case 0x06: ///load register 6 with next byte
            registers[6]=mcu->load(pc+1);
            pc+=2;
            break;
        case 0x07: ///load register 7 with next byte
            registers[7]=mcu->load(pc+1);
            pc+=2;
            break;
        case 0x08: ///load register 0 with memory
                   ///addres in next byte next byte
            registers[0]=mcu->load(mcu->load(pc+1));
            pc+=2;
            break;
        case 0x09: ///load register 1 with memory
                   ///addres in next byte next byte
            registers[1]=mcu->load(mcu->load(pc+1));
            pc+=2;
            break;
        case 0x0a: ///load register 2 with memory
                   ///addres in next byte next byte
            registers[2]=mcu->load(mcu->load(pc+1));
            pc+=2;
            break;
        case 0x0b: ///load register 3 with memory
                   ///addres in next byte next byte
            registers[3]=mcu->load(mcu->load(pc+1));
            pc+=2;
            break;
        case 0x0c: ///load register 4 with memory
                   ///addres in next byte next byte
            registers[4]=mcu->load(mcu->load(pc+1));
            pc+=2;
            break;
        case 0x0d: ///load register 5 with memory
                   ///addres in next byte next byte
            registers[0]=mcu->load(mcu->load(pc+1));
            pc+=2;
            break;
        case 0x0e: ///load register 6 with memory
                   ///addres in next byte next byte
            registers[0]=mcu->load(mcu->load(pc+1));
            pc+=2;
            break;
        case 0x0f: ///load register 7 with memory
                   ///addres in next byte next byte
            registers[0]=mcu->load(mcu->load(pc+1));
            pc+=2;
            break;
        case 0x10: ///add registers in next 2 bytes
                   ///save in first register
            registers[mcu->load(pc+1)]+=mcu->load(mcu->load(pc+2));
            pc+=3;
            break;
        case 0x11: ///subtract registers in next 2 bytes
                   ///save in first register
            registers[mcu->load(pc+1)]-=mcu->load(mcu->load(pc+2));
            pc+=3;
            break;
        case 0x12: ///divide registers in next 2 bytes
                   ///save in first register
            registers[mcu->load(pc+1)]/=mcu->load(mcu->load(pc+2));
            pc+=3;
            break;
        case 0x13: ///multiply registers in next 2 bytes
                   ///save in first register
            registers[mcu->load(pc+1)]*=mcu->load(mcu->load(pc+2));
            pc+=3;
            break;
        case 0x14: ///multiply registers in next 2 bytes
                   ///save in first register
            registers[mcu->load(pc+1)]=mcu->load(mcu->load(pc+2));
            pc+=3;
            break;
    }
}
