#include "defines.h"

#include "sceneview.h"

using namespace std;

SceneView::SceneView(){

}

SceneView::~SceneView(){
    //delete this->controller;
}

SceneView::SceneView(SceneModel *model){
    assert(model!=NULL);

    this->model=model;
    //controller=new SceneController();
}

SceneView::SceneView(SceneModel *model, SceneController *controller){
    assert(model!=NULL);
    assert(controller!=NULL);

    this->model=model;
    this->controller=controller;
}

void SceneView::refreshSceneView(){
    /*
    StateModelCommand cmd;
    cmd.CMD=GET_CLIP_COUNT;
    ModelState modelState=this->model->getStateModel(cmd);
    cout<< modelState.intData<<endl;
    */
}

SceneModel* SceneView::getSceneModel(){
    return this->model;
}

void SceneView::setSceneModel(SceneModel* model){
    assert(model!=NULL);

    this->model=model;
}

SceneController* SceneView::getSceneController(){
    return this->controller;
}

void SceneView::setSceneController(SceneController* controller){
    assert(controller!=NULL);

    this->controller=controller;
}
