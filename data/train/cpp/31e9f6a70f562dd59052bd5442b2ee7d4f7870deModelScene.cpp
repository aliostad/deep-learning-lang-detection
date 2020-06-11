#include "Scene/ModelScene.h"

#include "Model/StlModel.h"
#include "Model/VolumeModel.h"
#include "Model/PointsModel.h"
#include "Model/EvaluatorModel.h"
#include "Model/AxesModel.h"

namespace Scene {
    ModelScene::ModelScene() :
        AbstractScene() {
    }

    ModelScene::~ModelScene() {

    }

    Viewport::ViewportArray * ModelScene::viewportArray() const {
        return _viewportArray;
    }

    Model::AbstractModel * ModelScene::selectedModel() const {
        return qobject_cast<Model::AbstractModel *>(_models.selectedObject());
    }

    void ModelScene::setViewportArray(Viewport::ViewportArray * viewportArray) {
        _viewportArray = viewportArray;

        emit viewportArrayChanged();
    }

    void ModelScene::updateScene() {
        while (!_blueprints.isEmpty()) {
            unpackBlueprint(_blueprints.dequeue());
        }

        for (Model::AbstractModel * model : _models.list()) {
            if (model->updateNeeded()) {
                model->update();
            }
        }
    }

    void ModelScene::renderScene(const QSize & surfaceSize) {
        viewportArray()->resize(surfaceSize);

        updateScene();

        render();

        /* some children, like pointsmodel can change its values after rendering -
        * for example depth buffer check affects values of points (z-coordinate)
        */
        if (postProcess()) {
            emit redraw();
        }
    }

    void ModelScene::render(const Model::AbstractModel::RenderState & state) {
        Viewport::ViewportRect boundingRect;

        for (const Viewport::Viewport * viewport : _viewportArray->array()) {
            boundingRect = viewport->boundingRect();

            glViewport(boundingRect.x(), boundingRect.y(), boundingRect.width(), boundingRect.height());

            for (Model::AbstractModel * model : _models.list()) {
                model->drawModel(viewport, state);
            }
        }
    }

    bool ModelScene::postProcess() {
        //render(Model::AbstractModel::RenderState::CONTOUR_RENDER);

        bool redraw = false;

        for (Model::AbstractModel * model : _models.list()) {
            for (const Viewport::Viewport * viewport : _viewportArray->array()) {
                redraw |= model->checkBuffers(viewport);
            }

            if (redraw) {
                model->update();
            }
        }

        return redraw;
    }

    void ModelScene::cleanUp() {
        _models.clear();

        AbstractScene::cleanUp();
    }

    QVariant ModelScene::blueprint() const {
        return _blueprint;
    }

    void ModelScene::setBlueprint(const QVariant & blueprint) {
        _blueprints.enqueue(blueprint.value<Blueprint>());

        _blueprint = blueprint;

        emit blueprintChanged(blueprint);
    }

    void ModelScene::selectModel(Model::AbstractModel * model) {
        Model::AbstractModel * prevSelected = _models.selectedObject();

        if (prevSelected) {
            prevSelected->unselectModel();
        }

        _models.selectObject(model);

        uint selectedID = 0;

        for (const Model::AbstractModel * model : _models.list()) {
            selectedID = std::max(selectedID, model->numberedID());
        }

        // this is for stencil
        model->selectModel(selectedID);

        Message::SettingsMessage message(
                    Message::Sender(_models.selectedObject()->id()),
                    Message::Reciever("sidebar")
                    );

        message.data["action"] = "changeModelID";

        emit post(message);
    }

    Model::AbstractModel *  ModelScene::addModel(const ModelInfo::Model & model) {
        ModelInfo::Params params;

        Model::AbstractModel * modelI = Model::AbstractModel::createModel(model.first, this);

        params = model.second;
        modelI->init(params);

        QVariantList children = params["children"].toList();

        QVariantMap childsMap;

        for (const QVariant & child : children) {
            childsMap = child.toMap();

            modelI->addChild(addModel(ModelInfo::Model(
                                     childsMap["type"].value<ModelInfo::Type>(),
                                     childsMap["params"].value<ModelInfo::Params>()
                                    )
                                )
            );
        }

        QObject::connect(modelI, &Model::AbstractModel::post, this, &ModelScene::post, Qt::DirectConnection);

        return modelI;
    }

    void ModelScene::initScene() {
        unpackBlueprint(_blueprints.dequeue(), true);
    }

    void ModelScene::unpackBlueprint(const Blueprint & blueprint, const bool & resetScene) {
        if (resetScene) {
            cleanUp();
        }

        QVariantMap helper;

        for (const QVariant & lightSource : blueprint["lightSources"].toList()) {
            lightSources.append(new LightSource(lightSource.toMap()));
        }

        for (const QVariant & material : blueprint["materials"].toList()) {
            materials.append(new Material(material.toMap()));
        }

        for (const QVariant & texture : blueprint["textures"].toList()) {
            textures.append(new Texture(texture.toMap()));
        }

        Model::AbstractModel * newModel;

        for (const QVariant & model : blueprint["models"].toList()) {
            helper = model.toMap();

            newModel = addModel(ModelInfo::Model(
                                    helper["type"].value<ModelInfo::Type>(),
                                    helper["params"].value<ModelInfo::Params>()
                    )
            );

            _models.append(newModel);
            selectModel(newModel);
        }
    }

    void ModelScene::recieve(const Message::SettingsMessage & message) {
        if (message.reciever().startsWith("Scene")) {
            if (message.data["action"] == "add") {
                _blueprints.enqueue(message.data["blueprint"].value<Blueprint>());
                return;
            }

            return;
        }

        Model::AbstractModel * model = _models[message.reciever()];

        if (model) {
            model->invoke(
                    message.data["action"].toString(),
                    message.data["params"].value<ModelInfo::Params>()
            );

            return;
        }
    }
}
