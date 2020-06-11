#ifndef MODELCHICKEN_H
#define MODELCHICKEN_H
#include <includes.h>

#include <Model\ModelBase.h>
#include <Model\ModelChicken.h>
#include <Model\ModelRenderer.h>
#include <Render\Render.h>
#include <MathHelper.h>
#include <Model\ModelBase.h>



class ModelChicken : public ModelBase
{
public:
	ModelChicken();
	void render(float f, float f1, float f2, float f3, float f4, float f5);
	void setRotationAngles(float f, float f1, float f2, float f3, float f4, float f5);
ModelRenderer head;
ModelRenderer body;
ModelRenderer rightLeg;
ModelRenderer leftLeg;
ModelRenderer rightWing;
ModelRenderer leftWing;
ModelRenderer bill;
ModelRenderer chin;
protected:
private:
};

#endif //MODELCHICKEN_H
