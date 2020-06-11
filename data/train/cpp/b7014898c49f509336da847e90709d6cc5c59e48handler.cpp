#include <string>
#include <iostream>
#include <sstream>
#include "sassert.h"
#include "handler.h"

handler::handler()
{

}

handler::~handler()
{

}

symbol_handler::symbol_handler()
{

}

symbol_handler::~symbol_handler()
{

}

std::string symbol_handler::chomp_token(std::istream& stream) const
{
  return "";
}

singlechar_handler::singlechar_handler()
{

}

singlechar_handler::~singlechar_handler()
{

}

std::string singlechar_handler::chomp_token(std::istream& stream) const
{
    assert(stream.peek()!=EOF); // LCOV_EXCL_LINE

    char retval;
    stream.read(&retval,1);
    return std::string(&retval);
}
