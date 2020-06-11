#include "ModelRule.hpp"
#include "ModelManager.hpp"
#include "ModelRenderable.hpp"
#include "TextureManager.hpp"
#include "Grammar.hpp"

ModelRule::ModelRule(int i, Symbol const *predecessor, float scale, const char *modelName, const char *textureName) : 
Rule(i, predecessor), modelName(modelName), textureName(textureName), scale(scale)
{
	// load model & texture
	model = ModelManager::Instance().loadModel(modelName);
	texture = TextureManager::Instance().loadTexture(textureName);
}

void ModelRule::execute(Grammar &grammar, Context &context, Shape &shape)
{
	// ignore successors
	// create new model renderable
	CoordSystem const &cs = shape.getCoordSystem();

	ModelRenderable *mr = new ModelRenderable(cs, scale, model, texture);
	context.renderables.push_back(mr);
}
