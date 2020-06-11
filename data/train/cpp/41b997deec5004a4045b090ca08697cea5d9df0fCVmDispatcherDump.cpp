/*
 * CVmDispatcherDump.cpp
 *
 * Copyright (C) 1999-2014 Parallels IP Holdings GmbH
 *
 * This file is part of Parallels SDK. Parallels SDK is free
 * software; you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License,
 * or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.  If not, see
 * <http://www.gnu.org/licenses/> or write to Free Software Foundation,
 * 51 Franklin Street, Fifth Floor Boston, MA 02110, USA.
 *
 * Our contact details: Parallels IP Holdings GmbH, Vordergasse 59, 8200
 * Schaffhausen, Switzerland; http://www.parallels.com/.
 */


#include <QTextStream>
#include <QDateTime>
#include <QMutexLocker>

#include "CVmDispatcherDump.h"
#include "ParallelsDomModel.h"

#include "Libraries/Logging/Logging.h"

#ifdef Q_OS_WIN32
#include <process.h>
#define getpid _getpid
#endif

#ifndef _WIN_
#include <unistd.h>
#endif

/*****************************************************************************
 * CVmDispatcherDump
 *****************************************************************************/

CVmDispatcherDump::CVmDispatcherDump () :
    mutex( QMutex::Recursive )
{}

CVmDispatcherDump::CVmDispatcherDump ( const QString& dumpFileName ) :
    mutex( QMutex::Recursive )
{ setDumpFile( dumpFileName ); }

CVmDispatcherDump::~CVmDispatcherDump ()
{ dumpFile.remove(); }

bool CVmDispatcherDump::setDumpFile ( const QString& dumpFileName )
{
    if ( dumpFile.isOpen() )
        dumpFile.close();
    dumpFile.setFileName( dumpFileName );
    if ( !dumpFile.open( QIODevice::ReadWrite ) )
        return false;

    parseDumpFile();
    return true;
}

bool CVmDispatcherDump::isOpen () const
{ return dumpFile.isOpen(); }

CVmDispatcherDump::DumpHash CVmDispatcherDump::getDump () const
{
    QMutexLocker locker( &mutex );
    return dumpHash;
}

bool CVmDispatcherDump::contains ( const QString& uuid ) const
{
    if ( !dumpElements.contains( uuid ) )
        return false;

    QDomElement dumpSet = dumpElements[uuid];
    QString pidStr = dumpSet.attribute( XML_VM_DISPATCHER_DUMP_DISP_PID );

    bool ok = false;
    int pid = pidStr.toInt( &ok );
    if ( !ok ) {
        LOG_MESSAGE( DBG_FATAL, ">>> Dump: can't parse pid for uuid: %s",  qPrintable(uuid) );
        return false;
    }

    // Pids should be different
    if ( (qint64)getpid() == pid )
        return false;

    return true;
}

QString CVmDispatcherDump::toString () const
{
    QMutexLocker locker( &mutex );
    return dumpDoc.toString(1);
}

void CVmDispatcherDump::dumpSet ( const QString& uuid,
                                  const CVmDispatcherDump::DumpSet& dumpSet )
{
    QMutexLocker locker( &mutex );

    dumpHash[uuid] = dumpSet;
    QDomElement dumpSetElement;
    QString timestamp = QDateTime::currentDateTime().
                             toString( "dd.MM.yyyyThh:mm:ss.zzz" );

    if ( dumpElements.contains( uuid ) ) {
        dumpSetElement = dumpElements[uuid];
    }
    else {
        dumpSetElement = dumpDoc.createElement( XML_VM_DISPATCHER_DUMP_SET );
        dumpDoc.documentElement().appendChild( dumpSetElement );
        dumpElements[uuid] = dumpSetElement;
        dumpSetElement.setAttribute( XML_VM_DISPATCHER_DUMP_STARTED,
                                     timestamp );
    }

    dumpSetElement.setAttribute( XML_VM_DISPATCHER_DUMP_VM_UUID, uuid );
    dumpSetElement.setAttribute( XML_VM_DISPATCHER_DUMP_OBJ_UUID,
                                 dumpSet.objUuid );
    dumpSetElement.setAttribute( XML_VM_DISPATCHER_DUMP_VM_PID,
                                 dumpSet.vmPid );
    dumpSetElement.setAttribute( XML_VM_DISPATCHER_DUMP_DISP_PID,
                                 getpid() );
    dumpSetElement.setAttribute( XML_VM_DISPATCHER_DUMP_CHANGED, timestamp );

    flush();
}

bool CVmDispatcherDump::removeDumpSet ( const QString& vmUuid )
{
    if ( ! dumpHash.contains( vmUuid ) )
        return false;

    QMutexLocker locker( &mutex );

    dumpHash.remove( vmUuid );
    if ( dumpElements.contains( vmUuid ) ) {
        dumpDoc.documentElement().removeChild( dumpElements[vmUuid] );
        dumpElements.remove( vmUuid );
    }
    flush();
    return true;
}

void CVmDispatcherDump::cleanOldDumpSets ()
{
    QMutexLocker locker( &mutex );

    DumpHash tmpDumpHash = dumpHash;

    DumpHash::Iterator i = tmpDumpHash.begin();
    for ( ; i != tmpDumpHash.end(); ++i ) {
        QString vmUuid = i.key();

        QDomElement dumpSet = dumpElements[vmUuid];
        QString pidStr  = dumpSet.attribute( XML_VM_DISPATCHER_DUMP_DISP_PID );
        bool ok = false;
        int pid = pidStr.toInt( &ok );
        if ( !ok ) {
            LOG_MESSAGE( DBG_FATAL, ">>> Dump: can't parse pid for uuid: %s",
                      qPrintable(vmUuid) );
            continue;
        }

        if ( pid == getpid() )
            continue;
        removeDumpSet( vmUuid );
    }
}

void CVmDispatcherDump::parseDumpFile ()
{
    if ( ! isOpen() )
        return;

    QDomElement rootElement;

    if ( !dumpDoc.setContent( &dumpFile ) ) {
        // Clear all doc
        dumpDoc.clear();
        // Create default header
        QDomNode xmlInstr = dumpDoc.createProcessingInstruction(
                        "xml", QString("version=\"1.0\" encoding=\"UTF-8\"") );
        // First line as XML header
        dumpDoc.insertBefore( xmlInstr, QDomNode() );
        // Create root element
        rootElement = dumpDoc.createElement( XML_VM_DISPATCHER_DUMP_ROOT );
        dumpDoc.appendChild(rootElement);
    } else {
        // Parsed successfully. Take root element.
        rootElement = dumpDoc.documentElement();
    }

    QDomNode n = rootElement.firstChild();

    for ( ; !n.isNull(); n = n.nextSibling()) {
        QDomElement dumpSet = n.toElement();
        if ( dumpSet.isNull() ||
             dumpSet.tagName() != XML_VM_DISPATCHER_DUMP_SET )
            continue;

        QString vmUuid  = dumpSet.attribute( XML_VM_DISPATCHER_DUMP_VM_UUID );
        QString objUuid = dumpSet.attribute( XML_VM_DISPATCHER_DUMP_OBJ_UUID );
        QString pidStr  = dumpSet.attribute( XML_VM_DISPATCHER_DUMP_VM_PID );

        bool ok = false;
        int pid = pidStr.toInt( &ok );
        if ( !ok ) {
            LOG_MESSAGE( DBG_FATAL, ">>> Dump: can't parse pid for uuid: %s",
                      qPrintable(vmUuid) );
            continue;
        }

        dumpHash[vmUuid] = CVmDispatcherDump::DumpSet( objUuid, pid );
        dumpElements[vmUuid] = dumpSet;
    }

}

void CVmDispatcherDump::flush ()
{
    if ( ! isOpen() )
        return;
    dumpFile.resize(0);
    QTextStream stream( &dumpFile );
    dumpDoc.save( stream, 4 );
}

/*****************************************************************************/
