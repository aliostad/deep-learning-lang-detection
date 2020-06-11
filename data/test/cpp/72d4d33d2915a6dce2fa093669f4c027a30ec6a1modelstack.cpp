/* This file is part of Zanshin Todo.

   Copyright 2008-2010 Kevin Ottens <ervin@kde.org>
   Copyright 2008, 2009 Mario Bensi <nef@ipsquad.net>

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

#include "modelstack.h"

#include "gui/itemeditor/combomodel.h"
#include "gui/sidebar/sidebarmodel.h"
#include "gui/shared/selectionproxymodel.h"
#include "todometadatamodel.h"

#include "kdescendantsproxymodel.h"
#include "reparentingmodel/reparentingmodel.h"
#include "core/projectstrategy.h"
#include "core/structurecachestrategy.h"
#include "core/datastoreinterface.h"
#include <qitemselectionmodel.h>

ModelStack::ModelStack(QObject *parent)
    : QObject(parent),
      m_baseModel(0),
      m_collectionsModel(0),
      m_treeModel(0),
      m_treeSideBarModel(0),
      m_treeSelectionModel(0),
      m_treeComboModel(0),
      m_treeSelection(0),
      m_knowledgeSelectionModel(0),
      m_topicsTreeModel(0),
      m_knowledgeSidebarModel(0),
      m_knowledgeCollectionsModel(0),
      m_topicSelection(0),
      m_contextsModel(0),
      m_contextsSideBarModel(0),
      m_contextsSelectionModel(0),
      m_contextsComboModel(0),
      m_contextSelection(0)
{
}

QAbstractItemModel *ModelStack::pimitemModel()
{
    return DataStoreInterface::instance().todoBaseModel();
}

QAbstractItemModel *ModelStack::baseModel()
{
    if (!m_baseModel) {
        TodoMetadataModel *metadataModel = new TodoMetadataModel(this);
        metadataModel->setSourceModel(pimitemModel());
        m_baseModel = metadataModel;
    }
    return m_baseModel;
}

QAbstractItemModel *ModelStack::collectionsModel()
{
    return DataStoreInterface::instance().todoCollectionModel();
}

QAbstractItemModel *ModelStack::treeModel()
{
    if (!m_treeModel) {
        ReparentingModel *treeModel = new ReparentingModel(new ProjectStrategy());
        treeModel->setSourceModel(baseModel());
        m_treeModel = treeModel;
    }
    return m_treeModel;
}

QAbstractItemModel *ModelStack::treeSideBarModel()
{
    if (!m_treeSideBarModel) {
        SideBarModel *treeSideBarModel = new SideBarModel(this);
        treeSideBarModel->setSourceModel(treeModel());
        m_treeSideBarModel = treeSideBarModel;
    }
    return m_treeSideBarModel;
}

QItemSelectionModel *ModelStack::treeSelection()
{
    if (!m_treeSelection) {
        QItemSelectionModel *selection = new QItemSelectionModel(treeSideBarModel(), this);
        m_treeSelection = selection;
    }
    return m_treeSelection;
}

QAbstractItemModel *ModelStack::treeSelectionModel()
{
    if (!m_treeSelectionModel) {
        SelectionProxyModel *treeSelectionModel = new SelectionProxyModel(this);
        treeSelectionModel->setSelectionModel(treeSelection());
        treeSelectionModel->setSourceModel(treeModel());
        m_treeSelectionModel = treeSelectionModel;
    }
    return m_treeSelectionModel;
}

QAbstractItemModel *ModelStack::treeComboModel()
{
    if (!m_treeComboModel) {
        ComboModel *treeComboModel = new ComboModel(this);

        KDescendantsProxyModel *descendantProxyModel = new KDescendantsProxyModel(treeComboModel);
        descendantProxyModel->setSourceModel(treeSideBarModel());
        descendantProxyModel->setDisplayAncestorData(true);

        treeComboModel->setSourceModel(descendantProxyModel);
        m_treeComboModel = treeComboModel;
    }
    return m_treeComboModel;
}

QAbstractItemModel *ModelStack::contextsModel()
{
    if (!m_contextsModel) {
        ReparentingModel *contextsModel = new ReparentingModel(new StructureCacheStrategy(PimItemRelation::Context), this);
        contextsModel->setSourceModel(baseModel());
        m_contextsModel = contextsModel;
    }
    return m_contextsModel;
}

QAbstractItemModel *ModelStack::contextsSideBarModel()
{
    if (!m_contextsSideBarModel) {
        SideBarModel *contextsSideBarModel = new SideBarModel(this);
        contextsSideBarModel->setSourceModel(contextsModel());
        m_contextsSideBarModel = contextsSideBarModel;
    }
    return m_contextsSideBarModel;
}

QItemSelectionModel *ModelStack::contextsSelection()
{
    if (!m_contextSelection) {
        QItemSelectionModel *selection = new QItemSelectionModel(contextsSideBarModel());
        m_contextSelection = selection;
    }
    return m_contextSelection;
}

QAbstractItemModel *ModelStack::contextsSelectionModel()
{
    if (!m_contextsSelectionModel) {
        SelectionProxyModel *contextsSelectionModel = new SelectionProxyModel(this);
        contextsSelectionModel->setSelectionModel(contextsSelection());
        contextsSelectionModel->setSourceModel(contextsModel());
        m_contextsSelectionModel = contextsSelectionModel;
    }
    return m_contextsSelectionModel;
}

QAbstractItemModel *ModelStack::contextsComboModel()
{
    if (!m_contextsComboModel) {
        ComboModel *contextsComboModel = new ComboModel(this);

        KDescendantsProxyModel *descendantProxyModel = new KDescendantsProxyModel(contextsComboModel);
        descendantProxyModel->setSourceModel(contextsSideBarModel());
        descendantProxyModel->setDisplayAncestorData(true);

        contextsComboModel->setSourceModel(descendantProxyModel);
        m_contextsComboModel = contextsComboModel;
    }
    return m_contextsComboModel;
}

QAbstractItemModel* ModelStack::knowledgeBaseModel()
{
    return DataStoreInterface::instance().noteBaseModel();
}

QAbstractItemModel *ModelStack::topicsTreeModel()
{
    if (!m_topicsTreeModel) {
        ReparentingModel *treeModel = new ReparentingModel(new StructureCacheStrategy(PimItemRelation::Topic), this);
        treeModel->setSourceModel(knowledgeBaseModel());
        m_topicsTreeModel = treeModel;
    }
    return m_topicsTreeModel;
}

QAbstractItemModel *ModelStack::knowledgeSideBarModel()
{
    if (!m_knowledgeSidebarModel) {
        SideBarModel *sideBarModel = new SideBarModel(this);
        sideBarModel->setSourceModel(topicsTreeModel());
        m_knowledgeSidebarModel = sideBarModel;
    }
    return m_knowledgeSidebarModel;
}

QItemSelectionModel* ModelStack::knowledgeSelection()
{
    if (!m_topicSelection) {
        QItemSelectionModel *selection = new QItemSelectionModel(knowledgeSideBarModel());
        m_topicSelection = selection;
    }
    return m_topicSelection;
}


QAbstractItemModel* ModelStack::knowledgeSelectionModel()
{
    if (!m_knowledgeSelectionModel) {
        SelectionProxyModel *contextsSelectionModel = new SelectionProxyModel(this);
        contextsSelectionModel->setSelectionModel(knowledgeSelection());
        contextsSelectionModel->setSourceModel(topicsTreeModel());
        m_knowledgeSelectionModel = contextsSelectionModel;
    }
    return m_knowledgeSelectionModel;
}

QAbstractItemModel *ModelStack::knowledgeCollectionsModel()
{
    return DataStoreInterface::instance().noteCollectionModel();
}
