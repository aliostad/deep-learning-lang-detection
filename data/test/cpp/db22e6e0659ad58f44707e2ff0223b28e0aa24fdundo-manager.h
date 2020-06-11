#ifndef UNDOMANAGER_H
#define UNDOMANAGER_H

#include <QUndoStack>
#include "commands.h"
#include "model.h"

class UndoManager
{
public:
    static UndoManager * getInstance();
    void addModel(Model *model);
    void deleteModels(QList<int> *modelsIndices);
    void moveModel(Model *model, float x, float y);
    void rotateModel(Model *model, float angle);
    void scaleModel(Model *model, float x, float y);
    void undo();
    void redo();

private:
    UndoManager();
    QUndoStack *m_undoStack;
    static UndoManager * m_undoManager;
};

#endif // UNDOMANAGER_H
