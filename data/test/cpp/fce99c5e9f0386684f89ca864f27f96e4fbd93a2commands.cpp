#include "commands.h"

AddModelCommand::AddModelCommand(Model *model)
{
    this->modelIndex = ModelManager::getInstance ()->size();
    this->model = model;
}

void AddModelCommand::undo()
{
    ModelManager::getInstance ()->removeAt(this->modelIndex);
}

void AddModelCommand::redo()
{
    ModelManager::getInstance ()->insert(this->modelIndex, this->model);
}

DeleteModelsCommand::DeleteModelsCommand(QList<int> *modelsIndices)
{
    this->modelsIndices = modelsIndices;
    for(int i = 0; i < modelsIndices->size(); i++)
        this->modelList.append(ModelManager::getInstance ()->at(modelsIndices->at(i)));
}

void DeleteModelsCommand::undo()
{
    for(int i = 0; i < modelsIndices->size(); i++)
    {
        ModelManager::getInstance ()->insert(modelsIndices->at(i), modelList.at(i));
    }
}

void DeleteModelsCommand::redo()
{
    int iterator = modelsIndices->size();
    for(int i = 0; i < iterator; i++)
    {
        ModelManager::getInstance ()->removeAt(modelsIndices->at(i));
        iterator--;
        i--;
    }
}

MoveModelCommand::MoveModelCommand(Model *model, float xMovement, float yMovement)
{
    this->model = model;
    this->xMovement = xMovement;
    this->yMovement = yMovement;
}

void MoveModelCommand::undo()
{
    this->model->move(-this->xMovement, -this->yMovement, -this->zMovement);
}

void MoveModelCommand::redo()
{
    this->model->move(this->xMovement, this->yMovement, this->zMovement);
}

RotateModelCommand::RotateModelCommand(Model *model, float angle)
{
    this->model = model;
    this->angle = angle;
}

void RotateModelCommand::undo()
{
//    this->model->rotate(-this->angle);
}

void RotateModelCommand::redo()
{
//    this->model->rotate(this->angle);
}

ScaleModelCommand::ScaleModelCommand(Model *model, float xScale, float yScale)
{
    this->model = model;
    this->xScale = xScale;
    this->yScale = yScale;
}

void ScaleModelCommand::undo()
{
//    this->model->scale(1 / this->xScale, 1 / this->yScale);
}

void ScaleModelCommand::redo()
{
//    this->model->scale(this->xScale, this->yScale);
}
