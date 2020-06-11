/**************************************************************************
** This file is part of Cangote
** (C)2/24/2013 2013 Bruno Cabral (and other contributing authors)
**
** Cangote is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published
** by the Free Software Foundation; either version 3, or (at your
** option) any later version.
**
** Cangote is distributed in the hope that it will be useful, but
** WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
** General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Cangote; see the file COPYING.  If not, write to the
** Free Software Foundation, Inc., 59 Temple Place - Suite 330,
** Boston, MA 02111-1307, USA.
**************************************************************************/

#ifndef MODELS_H
#define MODELS_H

#include <QObject>

class SearchModel;
class NetworkPeersModel;
class DownloadsModel;
class SharedFilesModel;
class PublishModel;
class Models : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SearchModel * searchModel READ searchModel NOTIFY searchModelChanged)
    Q_PROPERTY(NetworkPeersModel * networkModel READ networkModel NOTIFY networkModelChanged)
    Q_PROPERTY(DownloadsModel * downloadsModel READ downloadsModel NOTIFY downloadsModelChanged)
    Q_PROPERTY(SharedFilesModel * sharedModel READ sharedModel NOTIFY sharedModelChanged)

    Q_PROPERTY(PublishModel * publishModel READ publishModel NOTIFY publishModelChanged)

public:
    explicit Models(QObject *parent = 0);
    ~Models();

    SearchModel* searchModel() const
    { return m_search; }

    NetworkPeersModel* networkModel() const
    { return m_network; }

    DownloadsModel* downloadsModel() const
    { return m_downloads; }
    
    SharedFilesModel* sharedModel() const
    { return m_shared; }

    PublishModel* publishModel() const
    { return m_publish; }

signals:
    void searchModelChanged(SearchModel*);
    void networkModelChanged(NetworkPeersModel*);
    void downloadsModelChanged(DownloadsModel*);
    void sharedModelChanged(SharedFilesModel*);
    void publishModelChanged(PublishModel*);
public slots:

private:
    SearchModel* m_search;
    NetworkPeersModel* m_network;
    DownloadsModel* m_downloads;
    SharedFilesModel* m_shared;
    PublishModel* m_publish;

};

#endif // MODELS_H


