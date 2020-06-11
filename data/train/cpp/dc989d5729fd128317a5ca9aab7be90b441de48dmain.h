/******************************************************************************
 * @file     main.h
 * 
 * @brief    
 * 
 * @date     01-12-2010
 * @author   Rafal Kukla
 ******************************************************************************
 *            Copyright (C) 2010 Rafal Kukla  ( rkdevel@gmail.com )
 *        This file is a part of rs232testng project and is released 
 *         under the terms of the license contained in the file LICENSE
 ******************************************************************************
 */

#ifndef MAIN_H_
#define MAIN_H_

#include "HtmlDisplayStreamItem.h"
#include "TextEditStreamItem.h"

#include <QObject>

class QStreamManager: public QObject
{
    Q_OBJECT
private:
    StreamItem*             InStream;
    StreamItem*             InModStream;
    StreamItem*             SourceStream;
    StreamItem*             OutModStream;
    StreamItem*             OutStream;
private:
    void buildStream()
    {
        StreamItem* endStream = OutStream;
        if (OutModStream) { OutModStream->Connect(endStream); endStream = OutModStream; }
        if (SourceStream) { SourceStream->Connect(endStream); endStream = SourceStream; }
        if (InModStream)  { InModStream->Connect(endStream);  endStream = InModStream; }
        if (InStream)     { InStream->Connect( endStream ); }
    }
public:
    QStreamManager():
        InStream(0),InModStream(0),
        SourceStream(0),OutModStream(0),
        OutStream(0)
    {
        buildStream();
    }

public slots:
    void onInStreamChanged(StreamItem* newStream)
    {
        InStream = newStream;
        buildStream();
    }
    void onInModStreamChanged(StreamItem* newStream)
    {
        InModStream = newStream;
        buildStream();
    }
    void onSourceStreamChanged(StreamItem* newStream)
    {
        SourceStream = newStream;
        buildStream();
    }
    void onOutModStreamChanged(StreamItem* newStream)
    {
        OutModStream = newStream;
        buildStream();
    }
    void onOutStreamChanged(StreamItem* newStream)
    {
        OutStream = newStream;
        buildStream();
    }

};

#endif /* MAIN_H_ */
