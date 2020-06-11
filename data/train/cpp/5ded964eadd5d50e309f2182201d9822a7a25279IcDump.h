#pragma once

#include "IntermediateObject.h"

class IcDump
{
public:
    IcDump(std::ostream &output)
        : _output(output), _nextLabel(1)
    { }

    void DumpFunction(std::string &name, IcFunctionObject *object);
    void DumpBlock(IcBlock *block);
    void DumpOperation(IcOperation &op);
    void DumpRegister(IcRegister r);
    void DumpImmediateValue(IcImmediateValue &immediate);
    void DumpLabel(IcBlock *block);
    char *DumpBaseType(IcBaseType baseType);

private:
    std::ostream &_output;
    int _nextLabel;
    std::map<IcBlock *, std::string> _labels;
};
