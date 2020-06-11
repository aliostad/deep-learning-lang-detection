//
// C++ Interface: invokeclass
//
// Description: 
//
//
// Author: Andras Mantia <amantia@kde.org>, (C) 2008
//
// Copyright: See COPYING file that comes with this distribution
//
//

#ifndef INVOKECLASS_H
#define INVOKECLASS_H

#include <qobject.h>
#include <qstringlist.h>

class InvokeClass : public QObject {
Q_OBJECT
public:
  InvokeClass(QObject *parent);
  void invokeSlot(QObject *object,  const QString& slot, QStringList args);

  static QStringList acceptedSlots() 
  {
    static QStringList acceptedSlots;
    acceptedSlots  << "const QString&";
    acceptedSlots << "const QString&,const QString&";
    acceptedSlots << "bool";
    acceptedSlots << "int";
    acceptedSlots << "int,int";
    acceptedSlots << "int,int,int";
    acceptedSlots << "int,int,int,int";
    acceptedSlots  << "const QColor&";

    return acceptedSlots;    
  }

signals:
  void  invoke();
  void  invoke(const QString&);
  void  invoke(const QString&,const QString&);
  void  invoke(bool);
  void  invoke(int);
  void  invoke(int,int);
  void  invoke(int,int,int);
  void  invoke(int,int,int,int);
  void  invoke(const QColor&);

private:
  QStringList m_acceptedSlots;

};

#endif
