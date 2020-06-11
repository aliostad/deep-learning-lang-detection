#ifndef MODELQUADRUPED_H
#define MODELQUADRUPED_H
#include <includes.h>

#include <Model\ModelBase.h>
#include <Model\ModelQuadruped.h>
#include <Model\ModelRenderer.h>
#include <Render\Render.h>
#include <MathHelper.h>
#include <Model\ModelBase.h>



class ModelQuadruped : public ModelBase
{
public:
	ModelQuadruped(int i, float f);
	void render(float f, float f1, float f2, float f3, float f4, float f5);
	void setRotationAngles(float f, float f1, float f2, float f3, float f4, float f5);
ModelRenderer head;;
ModelRenderer body;;
ModelRenderer leg1;;
ModelRenderer leg2;;
ModelRenderer leg3;;
ModelRenderer leg4;;
protected:
private:
};

#endif //MODELQUADRUPED_H
