    /*

    Copyright (C) 2000 Stefan Westerfeld
                       stefan@space.twc.de

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.
  
    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.
   
    You should have received a copy of the GNU Library General Public License
    along with this library; see the file COPYING.LIB.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
    Boston, MA 02111-1307, USA.

    */

#include "kwidgetrepo.h"
#include "kwidget_impl.h"
#include <startupmanager.h>

using namespace Arts;

class KWidgetRepoShutdown : public StartupClass {
public:
	void startup() {};
	void shutdown()
	{
		KWidgetRepo::shutdown();
	}
};

KWidgetRepo *KWidgetRepo::instance = 0;

KWidgetRepo *KWidgetRepo::the()
{
	if(!instance)
		instance = new KWidgetRepo();
	return instance;
}

void KWidgetRepo::shutdown()
{
	if(instance)
	{
		delete instance;
		instance = 0;
	}
}

KWidgetRepo::KWidgetRepo()
	: nextID(1)
{
}

KWidgetRepo::~KWidgetRepo()
{
}


long KWidgetRepo::add(KWidget_impl *widget, QWidget *qwidget)
{
	long ID = nextID++;
	widgets[ID] = widget;
	qwidgets[ID] = qwidget;
	return ID;
}

QWidget *KWidgetRepo::lookupQWidget(long ID)
{
	return qwidgets[ID];
}

Widget KWidgetRepo::lookupWidget(long ID)
{
	if(qwidgets[ID]) /* check existence */
		return Arts::Widget::_from_base(widgets[ID]->_copy());
	return Arts::Widget::null();
}

void KWidgetRepo::remove(long ID)
{
	widgets.erase(ID);
}
