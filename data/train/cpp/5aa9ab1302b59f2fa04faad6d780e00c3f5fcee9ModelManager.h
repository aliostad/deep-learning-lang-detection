#pragma once

#include <Drawable.h>

#include <memory>
#include <algorithm>

class ModelManager {
public:
    ModelManager(EngineContext& game) : game(game) {}

    template<class T, class... Args>
    Model *make_model(Args&&... args);

    void remove_model(Model *model);

    void update();
    void draw();

private:
    EngineContext &game;
    std::vector<std::unique_ptr<Model>> models;
};

template<class T, class... Args>
Model *ModelManager::make_model(Args&&... args) {
    auto model = std::unique_ptr<Model>(new T(std::forward<Args>(args)...));

    auto end_shader = *(model->shader_order().end()-1);

    auto pos = std::find_if(models.begin(), models.end(), [&](const std::unique_ptr<Model> &i) {
        return (*i->shader_order().begin() == end_shader);
    });

    model->create();
    auto ret = model.get();
    models.insert(pos, std::move(model));
    return ret;
};