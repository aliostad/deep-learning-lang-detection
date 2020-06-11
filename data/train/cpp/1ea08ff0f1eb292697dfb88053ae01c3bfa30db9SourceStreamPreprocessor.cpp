//
//  SourceStreamPreprocessor.cpp
//  SimpleJsonCpp
//
//  Created by Chen Jiajun on 13-8-23.
//  Copyright (c) 2013 chenjiajun90@gmail.com
//

#include "SourceStreamPreprocessor.h"


SourceStreamPreprocessor::SourceStreamPreprocessor()
    : _next(0)
{
}

bool SourceStreamPreprocessor::peek(SourceStream& stream)
{
    _next = stream.currentChar();
    return true;
}

bool SourceStreamPreprocessor::advance(SourceStream& stream)
{
    stream.consume();
    if (stream.end())
    {
        return false;
    }
    return peek(stream);
}

wchar_t SourceStreamPreprocessor::nextChar() const
{
    return _next;
}