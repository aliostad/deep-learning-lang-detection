/**************************************************************************
**
** This file is part of Qt Creator
**
** Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).
**
** Contact: Nokia Corporation (info@qt.nokia.com)
**
**
** GNU Lesser General Public License Usage
**
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this file.
** Please review the following information to ensure the GNU Lesser General
** Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** Other Usage
**
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
** If you have questions regarding the use of this file, please contact
** Nokia at info@qt.nokia.com.
**
**************************************************************************/

#include "debuggerstreamops.h"

#include "breakpoint.h"
#include "watchdata.h"
#include "disassemblerlines.h"

#include <QtCore/QDataStream>

namespace Debugger {
namespace Internal {

QDataStream &operator<<(QDataStream &stream, const ThreadData &d)
{
    stream << (qint64)d.id;
    stream << d.address;
    stream << d.function;
    stream << d.fileName;
    stream << d.state;
    stream << d.lineNumber;
    stream << d.name;
    return stream;
}

QDataStream &operator>>(QDataStream &stream, ThreadData &d)
{
    qint64 id;
    stream >> id;
    d.id = id;
    stream >> d.address;
    stream >> d.function;
    stream >> d.fileName;
    stream >> d.state;
    stream >> d.lineNumber;
    stream >> d.name;
    return stream;
}

QDataStream &operator<<(QDataStream &stream, const Threads &threads)
{
    stream << (quint64)threads.count();
    for (int i = 0; i < threads.count(); i++)
    {
        const ThreadData &d = threads.at(i);
        stream << d;
    }
    return stream;
}

QDataStream &operator>>(QDataStream &stream, Threads &threads)
{
    quint64 count;
    stream >> count;
    threads.clear();
    for (quint64 i = 0; i < count; ++i)
    {
        ThreadData d;
        stream >> d;
        threads.append(d);
    }
    return stream;
}

QDataStream &operator<<(QDataStream &stream, const StackFrame &s)
{
    stream << (quint64)s.level;
    stream << s.function;
    stream << s.file;
    stream << s.from;
    stream << s.to;
    stream << s.line;
    stream << s.address;
    stream << s.usable;
    return stream;
}

QDataStream &operator>>(QDataStream &stream, StackFrame &s)
{
    quint64 level;
    stream >> level;
    s.level = level;
    stream >> s.function;
    stream >> s.file;
    stream >> s.from;
    stream >> s.to;
    stream >> s.line;
    stream >> s.address;
    stream >> s.usable;
    return stream;
}

QDataStream &operator<<(QDataStream &stream, const StackFrames &frames)
{
    stream << (quint64)frames.count();
    for (int i = 0; i < frames.count(); i++)
    {
        const StackFrame &s = frames.at(i);
        stream << s;
    }
    return stream;
}

QDataStream &operator>>(QDataStream &stream, StackFrames &frames)
{
    quint64 count;
    stream >> count;
    frames.clear();
    for (quint64 i = 0; i < count; ++i)
    {
        StackFrame s;
        stream >> s;
        frames.append(s);
    }
    return stream;
}

QDataStream &operator<<(QDataStream &stream, const BreakpointResponse &s)
{
    stream << s.number;
    stream << s.condition;
    stream << s.ignoreCount;
    stream << s.fileName;
    stream << s.fullName;
    stream << s.lineNumber;
    //stream << s.bpCorrectedLineNumber;
    stream << s.threadSpec;
    stream << s.functionName;
    stream << s.address;
    return stream;
}

QDataStream &operator>>(QDataStream &stream, BreakpointResponse &s)
{
    stream >> s.number;
    stream >> s.condition;
    stream >> s.ignoreCount;
    stream >> s.fileName;
    stream >> s.fullName;
    stream >> s.lineNumber;
    //stream >> s.bpCorrectedLineNumber;
    stream >> s.threadSpec;
    stream >> s.functionName;
    stream >> s.address;
    return stream;
}

QDataStream &operator<<(QDataStream &stream, const BreakpointParameters &s)
{
    stream << s.fileName;
    stream << s.condition;
    stream << quint64(s.ignoreCount);
    stream << quint64(s.lineNumber);
    stream << quint64(s.address);
    stream << s.functionName;
    stream << int(s.pathUsage);
    stream << s.tracepoint;
    stream << s.module;
    stream << s.command;
    return stream;
}

QDataStream &operator>>(QDataStream &stream, BreakpointParameters &s)
{
    quint64 t;
    QString str;
    QByteArray ba;
    bool b;
    stream >> str; s.fileName = str;
    stream >> ba; s.condition = ba;
    stream >> t; s.ignoreCount = t;
    stream >> t; s.lineNumber = t;
    stream >> t; s.address = t;
    stream >> str; s.functionName = str;
    stream >> t; s.pathUsage = static_cast<BreakpointPathUsage>(t);
    stream >> b; s.tracepoint = b;
    stream >> str ; s.module = str;
    stream >> str ; s.command = str;
    return stream;
}

QDataStream &operator<<(QDataStream &stream, const WatchData &wd)
{
    stream << wd.id;
    stream << wd.iname;
    stream << wd.exp;
    stream << wd.name;
    stream << wd.value;
    stream << wd.editvalue;
    stream << wd.editformat;
    stream << wd.valuetooltip;
    stream << wd.typeFormats;
    stream << wd.type;
    stream << wd.displayedType;
    stream << wd.variable;
    stream << wd.address;
    stream << wd.size;
    stream << wd.hasChildren;
    stream << wd.generation;
    stream << wd.valueEnabled;
    stream << wd.valueEditable;
    stream << wd.error;
    stream << wd.state;
    stream << wd.changed;
    return stream;
}

QDataStream &operator>>(QDataStream &stream, WatchData &wd)
{
    stream >> wd.id;
    stream >> wd.iname;
    stream >> wd.exp;
    stream >> wd.name;
    stream >> wd.value;
    stream >> wd.editvalue;
    stream >> wd.editformat;
    stream >> wd.valuetooltip;
    stream >> wd.typeFormats;
    stream >> wd.type;
    stream >> wd.displayedType;
    stream >> wd.variable;
    stream >> wd.address;
    stream >> wd.size;
    stream >> wd.hasChildren;
    stream >> wd.generation;
    stream >> wd.valueEnabled;
    stream >> wd.valueEditable;
    stream >> wd.error;
    stream >> wd.state;
    stream >> wd.changed;
    return stream;
}

QDataStream &operator<<(QDataStream& stream, const DisassemblerLine &o)
{
    stream << o.address;
    stream << o.function;
    stream << o.offset;
    stream << o.lineNumber;
    stream << o.data;
    return stream;
}

QDataStream &operator>>(QDataStream& stream, DisassemblerLine &o)
{
    stream >> o.address;
    stream >> o.function;
    stream >> o.offset;
    stream >> o.lineNumber;
    stream >> o.data;
    return stream;
}

QDataStream &operator<<(QDataStream& stream, const DisassemblerLines &o)
{
    stream << quint64(o.size());
    for (int i = 0; i < o.size(); ++i)
    {
        stream << o.at(i);
    }
    return stream;
}

QDataStream &operator>>(QDataStream& stream, DisassemblerLines &o)
{
    DisassemblerLines r;
    quint64 count;
    stream >> count;
    for (quint64 i = 0; i < count; ++i)
    {
        DisassemblerLine line;
        stream >> line;
        r.appendLine(line);
    }
    o = r;
    return stream;
}



} // namespace Internal
} // namespace Debugger


