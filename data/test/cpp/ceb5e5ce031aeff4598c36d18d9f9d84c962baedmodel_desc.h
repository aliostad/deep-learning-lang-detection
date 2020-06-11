
#pragma once

#include <vector>
#include "model_desc_animation.h"
#include "model_desc_attachment_point.h"
#include "model_desc_particle_emitter.h"
#include "model_desc_material.h"
#include "model_desc_bone.h"

class ModelDesc
{
public:
	ModelDesc();

	std::string fbx_filename;
	std::vector<ModelDescAnimation> animations;
	std::vector<ModelDescAttachmentPoint> attachment_points;
	std::vector<ModelDescParticleEmitter> emitters;
	std::vector<ModelDescMaterial> materials;
	std::vector<ModelDescBone> bones;

	static ModelDesc load(const std::string &filename);
	void save(const std::string &filename);
};
