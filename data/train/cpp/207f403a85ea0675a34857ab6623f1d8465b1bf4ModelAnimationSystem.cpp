#include "ModelAnimationSystem.h"
#include "../../core/Space.h"
#include "../../components/Model.h"

namespace saturn {
	
	bool ModelAnimationSystem::animating = true;

	ModelAnimationSystem::ModelAnimationSystem() : time(0.0f) {
		name = "ModelAnimationSystem";
	}
	
	void ModelAnimationSystem::update(Space *space, float dt) {
		time += dt;
		bool shouldAnimate = false;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		float interval = 1.0f / 45.0f;
#else
		float interval = 1.0f / 60.0f;
#endif
		if (time > interval - .00000001f) {
			shouldAnimate = true;
			time -= interval;
		}

		if (!ModelAnimationSystem::animating) {
			shouldAnimate = false;
		}

		for (std::size_t i = 0; i < space->entities.size(); ++i) {
			Entity& entity = *space->entities[i];

			if (entity.hasComponent("Model")) {
				std::vector<Component*> models = entity.getComponents("Model");
				
				for (std::size_t j = 0; j < models.size(); ++j) {
					Model* model = (Model*)models[j];
					
					if (model->animating) {
						ModelAnimation* animation = model->getCurrentAnimation();
						
						if (model->transitioning || (!animation->stillFrame && model->animationDelay < .0001f)) {
							model->time += dt * animation->multiplier;
						}
						else if (model->animationDelay > 0.0f) {
							model->animationDelay -= dt;
						}

						if (!model->transitioning && animation && model->time > animation->end) {
							model->time = animation->start + model->time - animation->end;
							
							if (--model->loops == 0) {
								model->animating = false;
								model->time = animation->end;
							}
						}
						else if (model->transitioning && model->time > model->transitionDuration && animation) {
							model->time = animation->start;
							model->transitioning = false;
						}
						
						if (shouldAnimate) {
							if (!model->transitioning) {
								model->advanceAnimation(model->time);
							}
							else {
								model->transitionAnimation(model->transitionFrom, model->transitionTo, model->time / model->transitionDuration);
							}
							
#ifndef GPU_SKINNING
							// This is currently very very very slow
							model->cpuSkin(NULL);
							
							model->updateVertexBuffers();
#endif
						}
					}
				}
			}
		}
	}
}