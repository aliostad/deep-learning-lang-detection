/**************************************************************************
Copyright (C) 2000 - 2010 Novell, Inc.
All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

**************************************************************************/


/*---------------------------------------------------------------------\
|								       |
|		       __   __	  ____ _____ ____		       |
|		       \ \ / /_ _/ ___|_   _|___ \		       |
|			\ V / _` \___ \ | |   __) |		       |
|			 | | (_| |___) || |  / __/		       |
|			 |_|\__,_|____/ |_| |_____|		       |
|								       |
|				core system			       |
|							 (C) SuSE GmbH |
\----------------------------------------------------------------------/

  File:	      YQPkgRepoList.cc

  Author:     Stefan Hundhammer <sh@suse.de>

  Textdomain "qt-pkg"

/-*/

#include <algorithm>
#include <QDateTime>
#include <QHeaderView>

#define YUILogComponent "qt-pkg"
#include "YUILog.h"
#include <zypp/RepoManager.h>
#include <zypp/PoolQuery.h>

#include <QTreeWidget>
#include "YQPkgRepoList.h"
#include "YQi18n.h"
#include "utf8.h"

using std::string;
using std::list;
using std::endl;
using std::set;
using std::vector;


YQPkgRepoList::YQPkgRepoList( QWidget * parent )
    : QY2ListView( parent )
{
    yuiDebug() << "Creating repository list" << endl;

    _nameCol	= -1;
    _urlCol	= -1;

    int numCol = 0;

    QStringList headers;

    // Column headers for repository list
    headers <<  _( "Name");	_nameCol	= numCol++;
    // headers << _( "URL");	_urlCol		= numCol++;

    setHeaderLabels( headers );
    header()->setSectionResizeMode( _nameCol, QHeaderView::Stretch );

    //setAllColumnsShowFocus( true );
    setSelectionMode( QAbstractItemView::ExtendedSelection );	// allow multi-selection with Ctrl-mouse

    connect( this, 	SIGNAL( itemSelectionChanged() ),
	     this, 	SLOT  ( filterIfVisible()) );
    setIconSize(QSize(32,32));
    fillList();
    setSortingEnabled( true );
    sortByColumn( nameCol(), Qt::AscendingOrder );
    selectSomething();

    yuiDebug() << "Creating repository list done" << endl;
}


YQPkgRepoList::~YQPkgRepoList()
{
    // NOP
}


void
YQPkgRepoList::fillList()
{
    clear();
    yuiDebug() << "Filling repository list" << endl;

    for ( ZyppRepositoryIterator it = ZyppRepositoriesBegin();
	  it != ZyppRepositoriesEnd();
	  ++it )
    {
	addRepo( *it );
    }

    yuiDebug() << "Inst repository filled" << endl;
}


int
YQPkgRepoList::countEnabledRepositories()
{
    return zyppPool().knownRepositoriesSize();
}


void
YQPkgRepoList::filterIfVisible()
{
    if ( isVisible() )
	filter();
}


void
YQPkgRepoList::filter()
{
    emit filterStart();

    yuiMilestone() << "Collecting packages in selected repositories..." << endl;
    QTime stopWatch;
    stopWatch.start();


    //
    // Collect all packages on this repository
    //

    QTreeWidgetItem * item;

    QList<QTreeWidgetItem *> items = selectedItems();
    QListIterator<QTreeWidgetItem *> it(items);

    while ( it.hasNext() )
    {
      item = it.next();
      YQPkgRepoListItem * repoItem = dynamic_cast<YQPkgRepoListItem *> (item);

        if ( repoItem )
        {
            ZyppRepo currentRepo = repoItem->zyppRepo();

	    zypp::PoolQuery query;
	    query.addRepo( currentRepo.info().alias() );
	    query.addKind(zypp::ResKind::package);

    	    for( zypp::PoolQuery::Selectable_iterator it = query.selectableBegin();
	         it != query.selectableEnd(); it++)
    	    {
		emit filterMatch( *it, tryCastToZyppPkg( (*it)->theObj() ) );
    	    }
	}
    }

    yuiDebug() << "Packages sent to package list. Elapsed time: "
	       << stopWatch.elapsed() / 1000.0 << " sec"
	       << endl;

    emit filterFinished();
}


void
YQPkgRepoList::addRepo( ZyppRepo repo )
{
    new YQPkgRepoListItem( this, repo );
}


YQPkgRepoListItem *
YQPkgRepoList::selection() const
{
    QTreeWidgetItem * item = currentItem();

    if ( ! item )
	return 0;

    return dynamic_cast<YQPkgRepoListItem *> (item);
}






YQPkgRepoListItem::YQPkgRepoListItem( YQPkgRepoList *	repoList,
				      ZyppRepo		repo	)
    : QY2ListViewItem( repoList )
    , _repoList( repoList )
    , _zyppRepo( repo )
{
    if ( nameCol() >= 0 )
    {
        string name = repo.info().name();
        if ( ! name.empty() )
        {
            setText( nameCol(), fromUTF8( name ));
        }
    }

    std::string infoToolTip;
    infoToolTip += ("<b>" + repo.info().name() + "</b>");

    ZyppProduct product = singleProduct( _zyppRepo );
    if ( product )
    {
        infoToolTip += ("<p>" + product->summary() + "</p>");
    }

    if ( ! repo.info().baseUrlsEmpty() )
    {
        zypp::RepoInfo::urls_const_iterator it;
        infoToolTip += "<ul>";

        for ( it = repo.info().baseUrlsBegin();
              it != repo.info().baseUrlsEnd();
              ++it )
        {
            infoToolTip += ("<li>" + (*it).asString() + "</li>");
        }
        infoToolTip += "</ul>";
     }
    setToolTip( nameCol(), fromUTF8(infoToolTip) );

    QString iconPath;
    QString iconName = "yast-sw_source";

    if ( ! repo.info().baseUrlsEmpty() )
    {
        zypp::Url repoUrl = *repo.info().baseUrlsBegin();

        if ( urlCol() >= 0 )
        {
            setText( urlCol(), repoUrl.asString().c_str() );
        }

        if (QString(repoUrl.asString().c_str()).contains("KDE") )
            iconName = "pattern-kde";
        if (QString(repoUrl.asString().c_str()).contains("GNOME") )
            iconName = "pattern-gnome";
        if (QString(repoUrl.asString().c_str()).contains("KDE") )
            iconName = "pattern-kde";
        if (QString(repoUrl.asString().c_str()).contains("update") )
            iconName = "yast-update";
        if (QString(repoUrl.asString().c_str()).contains("home:") )
            iconName = "yast-users";
    }

    if ( repo.isSystemRepo() )
        iconName = "yast-host";


    setIcon( 0, QIcon( iconPath.sprintf("/usr/share/icons/hicolor/48x48/apps/%s.png", iconName.toUtf8().data()) ));
}



YQPkgRepoListItem::~YQPkgRepoListItem()
{
    // NOP
}


ZyppProduct
YQPkgRepoListItem::singleProduct( ZyppRepo zyppRepo )
{
    ZyppProduct product;

    zypp::ResPool::byKind_iterator it = zypp::ResPool::instance().byKindBegin( zypp::ResKind::product );
    zypp::ResPool::byKind_iterator end = zypp::ResPool::instance().byKindEnd( zypp::ResKind::product );

    //
    // Find the first product on this repository
    //

    while ( it != end && ! product )
    {
        if ( it->resolvable()->repoInfo().alias() == zyppRepo.info().alias() )
            product = zypp::asKind<zypp::Product>( it->resolvable() );
	++it;
    }

    //
    // Check if there is another product on this repository
    //

    while ( it != end )
    {
	if ( it->resolvable()->repoInfo().alias() == zyppRepo.info().alias() )
	{
	    yuiMilestone() << "Multiple products in repository "
			   << zyppRepo.info().alias()
			   << endl;
	    ZyppProduct null;
	    return null;
	}

	++it;
    }

    if ( ! product )
	yuiMilestone() << "No product in repository "
		       << zyppRepo.info().alias()
		       << endl;

    return product;
}

bool
YQPkgRepoListItem::operator< ( const QTreeWidgetItem & other ) const
{
    const YQPkgRepoListItem * otherItem = dynamic_cast<const YQPkgRepoListItem *>(&other);

    return zyppRepo().info().name() < otherItem->zyppRepo().info().name();
}

#include "YQPkgRepoList.moc"
