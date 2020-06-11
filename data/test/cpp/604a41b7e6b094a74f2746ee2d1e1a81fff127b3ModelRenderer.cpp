#include <QtQuick/QQuickWindow>

#include "Model/VolumeModel.h"
#include "Model/StlModel.h"

#include "Render/ModelRenderer.h"

namespace Render {
    ModelRenderer::ModelRenderer(QOpenGLContext * context, const QSize & size) :
        AbstractRenderer(context, size) {

    }

    ModelRenderer::~ModelRenderer() {
        cleanUp();
    }

    void ModelRenderer::addModel(const ModelInfo::Model & model) {
        QMutexLocker locker(&renderMutex);

        if (Scene::ModelScene * currentModelScene = qobject_cast<Scene::ModelScene *>(currentScene())) {
            activateContext();

            currentModelScene->addModel(model);

            locker.unlock();
            emit redraw();
        }
    }

    void ModelRenderer::render() {
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClearStencil(0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

        if (currentScene()) {
            if (!currentScene()->isInitialized()) {
                currentScene()->initializeScene();
            }

            currentScene()->renderScene(surfaceSize());
        }
    }

    void ModelRenderer::recieve(const Message::SettingsMessage & message) {
        if (message.isReliable()) {
            if (Scene::ModelScene * currentModelScene = qobject_cast<Scene::ModelScene *>(currentScene())) {
                currentModelScene->recieve(message);
            }
        }

        emit redraw();
    }
}
