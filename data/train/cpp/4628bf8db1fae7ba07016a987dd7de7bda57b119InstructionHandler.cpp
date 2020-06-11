//
// InstructionHandler.cpp for abstractvm in /home/baezse_s/CPP/projects/AbstractVM/abstractvm
//
// Made by sergioandres baezserrano
// Login   <baezse_s@epitech.net>
//
// Started on  Tue Feb 19 13:22:43 2013 sergioandres baezserrano
// Last update Sat Feb 23 14:31:24 2013 Sergio Baez
//

#include "InstructionHandler.hh"

InstructionHandler::AInstructionHandler::AInstructionHandler(const std::string & IName)
  :InstructionName(IName)
{
}

InstructionHandler::AInstructionHandler::~AInstructionHandler()
{
}

const std::string & InstructionHandler::AInstructionHandler::getInstructionName() const
{
  return (this->InstructionName);
}

Instruction::IInstruction * InstructionHandler::AInstructionHandler::create() const
{
  Instruction::IInstruction  *instruct = createInstruction();
  return (instruct);
}

InstructionHandler::AddHandler::AddHandler()
  : AInstructionHandler("add")
{
}

InstructionHandler::AddHandler::~AddHandler()
{
}

Instruction::IInstruction * InstructionHandler::AddHandler::createInstruction() const
{
  return (new Instruction::Add());
}

InstructionHandler::SubHandler::SubHandler()
  : AInstructionHandler("sub")
{
}

InstructionHandler::SubHandler::~SubHandler()
{
}

Instruction::IInstruction * InstructionHandler::SubHandler::createInstruction() const
{
  return (new Instruction::Sub());
}

InstructionHandler::MulHandler::MulHandler()
  : AInstructionHandler("mul")
{
}

InstructionHandler::MulHandler::~MulHandler()
{
}

Instruction::IInstruction * InstructionHandler::MulHandler::createInstruction() const
{
  return (new Instruction::Mul());
}

InstructionHandler::DivHandler::DivHandler()
  : AInstructionHandler("div")
{
}

InstructionHandler::DivHandler::~DivHandler()
{
}

Instruction::IInstruction * InstructionHandler::DivHandler::createInstruction() const
{
  return (new Instruction::Div());
}

InstructionHandler::ModHandler::ModHandler()
  : AInstructionHandler("mod")
{
}

InstructionHandler::ModHandler::~ModHandler()
{
}

Instruction::IInstruction * InstructionHandler::ModHandler::createInstruction() const
{
  return (new Instruction::Mod());
}

InstructionHandler::DumpHandler::DumpHandler()
  : AInstructionHandler("dump")
{
}

InstructionHandler::DumpHandler::~DumpHandler()
{
}

Instruction::IInstruction * InstructionHandler::DumpHandler::createInstruction() const
{
  return (new Instruction::Dump());
}

InstructionHandler::PopHandler::PopHandler()
  : AInstructionHandler("pop")
{
}

InstructionHandler::PopHandler::~PopHandler()
{
}

Instruction::IInstruction * InstructionHandler::PopHandler::createInstruction() const
{
  return (new Instruction::Pop());
}

InstructionHandler::PrintHandler::PrintHandler()
  : AInstructionHandler("print")
{
}

InstructionHandler::PrintHandler::~PrintHandler()
{
}

Instruction::IInstruction * InstructionHandler::PrintHandler::createInstruction() const
{
  return (new Instruction::Print());
}

InstructionHandler::ExitHandler::ExitHandler()
  : AInstructionHandler("exit")
{
}

InstructionHandler::ExitHandler::~ExitHandler()
{
}

Instruction::IInstruction * InstructionHandler::ExitHandler::createInstruction() const
{
  return (new Instruction::Exit());
}

InstructionHandler::PushHandler::PushHandler()
  : AInstructionHandler("push")
{
}

InstructionHandler::PushHandler::~PushHandler()
{
}

Instruction::IInstruction * InstructionHandler::PushHandler::createInstruction() const
{
  return (new Instruction::Push());
}

InstructionHandler::AssertHandler::AssertHandler()
  : AInstructionHandler("assert")
{
}

InstructionHandler::AssertHandler::~AssertHandler()
{
}

Instruction::IInstruction * InstructionHandler::AssertHandler::createInstruction() const
{
  return (new Instruction::Assert());
}
