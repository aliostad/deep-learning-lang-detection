#include "treeviewercontroller.h"

#include <QJsonArray>

TreeViewerController::TreeViewerController(TreeViewer& view, TreeViewerModel &model):
  m_view(view),
  m_model(model)
{
}

TreeModel* TreeViewerController::getTreeModel(const QString& path){
  qDebug("getTree()");

  TreeModel* treeModel;
  treeModel=m_model.getTreeModel(path);

  return treeModel;
}

/*
 * Unload tree model and tree structure (DirNode/FileNode nested objects) to free the memory 
 * when a new tree is to be built or the TreeViewer window is closed
 */
void TreeViewerController::freeMemory(TreeModel *treeModel){
  m_model.freeMemory(treeModel);
}
