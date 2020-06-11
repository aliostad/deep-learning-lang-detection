/* This file is part of Zanshin Todo.

   Copyright 2008-2010 Kevin Ottens <ervin@kde.org>

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License or (at your option) version 3 or any later version
   accepted by the membership of KDE e.V. (or its successor approved
   by the membership of KDE e.V.), which shall act as a proxy
   defined in Section 14 of version 3 of the license.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
   USA.
*/

#ifndef ZANSHIN_MODELSTACK_H
#define ZANSHIN_MODELSTACK_H

#include <QtCore/QObject>

class QItemSelectionModel;
class QAbstractItemModel;

class ModelStack : public QObject
{
    Q_OBJECT

public:
    explicit ModelStack(QObject *parent = 0);

    QAbstractItemModel *pimitemModel();
    QAbstractItemModel *baseModel();

    QAbstractItemModel *collectionsModel();

    QAbstractItemModel *treeModel();
    QAbstractItemModel *treeSideBarModel();
    QItemSelectionModel *treeSelection();
    QAbstractItemModel *treeSelectionModel();
    QAbstractItemModel *treeComboModel();

    QAbstractItemModel *contextsModel();
    QAbstractItemModel *contextsSideBarModel();
    QItemSelectionModel *contextsSelection();
    QAbstractItemModel *contextsSelectionModel();
    QAbstractItemModel *contextsComboModel();
    
    QAbstractItemModel *knowledgeBaseModel();
    QAbstractItemModel *topicsTreeModel();
    QAbstractItemModel *knowledgeSideBarModel();
    QAbstractItemModel *knowledgeSelectionModel(); //Filter model
    QItemSelectionModel *knowledgeSelection();
    QAbstractItemModel *knowledgeCollectionsModel();
    
private:
    QAbstractItemModel *m_baseModel;
    QAbstractItemModel *m_collectionsModel;

    QAbstractItemModel *m_treeModel;
    QAbstractItemModel *m_treeSideBarModel;
    QAbstractItemModel *m_treeSelectionModel;
    QAbstractItemModel *m_treeComboModel;
    QItemSelectionModel *m_treeSelection;
    
    QAbstractItemModel *m_knowledgeSelectionModel;
    QAbstractItemModel *m_topicsTreeModel;
    QAbstractItemModel *m_knowledgeSidebarModel;
    QAbstractItemModel *m_knowledgeCollectionsModel;
    QItemSelectionModel *m_topicSelection;

    QAbstractItemModel *m_contextsModel;
    QAbstractItemModel *m_contextsSideBarModel;
    QAbstractItemModel *m_contextsSelectionModel;
    QAbstractItemModel *m_contextsComboModel;
    QItemSelectionModel *m_contextSelection;
};

#endif

