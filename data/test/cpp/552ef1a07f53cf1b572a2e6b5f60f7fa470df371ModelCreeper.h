#ifndef MODELCREEPER_H
#define MODELCREEPER_H
#include <includes.h>

#include <Model\ModelBase.h>
#include <Model\ModelCreeper.h>
#include <Model\ModelRenderer.h>
#include <Render\Render.h>
#include <MathHelper.h>
#include <Model\ModelBase.h>



class ModelCreeper : public ModelBase
{
public:
	ModelCreeper();
	ModelCreeper(float f);
	void render(float f, float f1, float f2, float f3, float f4, float f5);
	void setRotationAngles(float f, float f1, float f2, float f3, float f4, float f5);
ModelRenderer head;
ModelRenderer field_1270_b;
ModelRenderer body;
ModelRenderer leg1;
ModelRenderer leg2;
ModelRenderer leg3;
ModelRenderer leg4;
protected:
private:
};

#endif //MODELCREEPER_H
