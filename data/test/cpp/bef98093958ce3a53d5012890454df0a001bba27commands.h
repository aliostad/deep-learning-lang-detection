#ifndef COMMANDS_H
#define COMMANDS_H

#include <QUndoCommand>
#include "model-manager.h"
#include "model.h"

class AddModelCommand : public QUndoCommand
{
public:
    AddModelCommand(Model *model);
    void undo();
    void redo();
private:
    int modelIndex;
    Model *model;
};

class DeleteModelsCommand : public QUndoCommand
{
public:
    DeleteModelsCommand(QList<int> *modelsIndices);
    void undo();
    void redo();
private:
    QList<int> *modelsIndices;
    QList<Model *> modelList;
};

class MoveModelCommand : public QUndoCommand
{
public:
    MoveModelCommand(Model *model, float xMovement, float yMovement);
    void undo();
    void redo();
private:
    Model *model;
    float xMovement;
    float yMovement;
    float zMovement;
};
//
//class MoveVertexCommand : public QUndoCommand
//{
//
//};

class RotateModelCommand : public QUndoCommand
{
public:
    RotateModelCommand(Model *model, float angle);
    void undo();
    void redo();
private:
    Model *model;
    float angle;
};

class ScaleModelCommand : public QUndoCommand
{
public:
    ScaleModelCommand(Model *model, float xScale, float yScale);
    void undo();
    void redo();
private:
    Model *model;
    float xScale;
    float yScale;
};

#endif // COMMANDS_H
