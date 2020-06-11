 #include "InvokeInstruction.h"

using namespace std;

InvokeInstruction::InvokeInstruction(string label,string ident):Instruction(label),ident(ident)
{

}

string InvokeInstruction::getLabel() const
{
    return label;
}
void InvokeInstruction::setLabel(std::string label)
{
    label = label;
}

string InvokeInstruction::getIdent() const
{
    return ident;
}
void InvokeInstruction::setIdent(string ident)
{
    ident = ident;
}

void InvokeInstruction::interpret (Memory* mem, int* address){
    int result = Interpreter::val(this->ident, mem);
    Quadruplet* quadruplet = new Quadruplet ("",*address+1,CST,T_OMEGA);
    mem->getStack()->push(quadruplet);
    *address = result;
}
