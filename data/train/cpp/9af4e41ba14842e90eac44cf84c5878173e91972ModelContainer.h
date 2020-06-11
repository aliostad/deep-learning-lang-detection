/*
 * ModelContainer.h
 * 
 * Läd alle Models einmal und bündelt diese in einem Container.
 *
 * Erstellt während des VR-Praktikums an der FH-Wedel WS10/11
 *      Authoren: minf6731, minf6917, minf6922, minf7089
 */

#ifndef MODELCONTAINER_H_
#define MODELCONTAINER_H_

#include "Model3DS.h"
#include <btBulletDynamicsCommon.h>
#include <btBulletCollisionCommon.h>
#include <map>


/** Status */
enum Model
	{ modelZero, modelOne, modelTwo, modelThree, modelFour, modelFive, modelSix,
	modelSeven, modelEight, modelNine,
	modelMelone, modelSword, modelBomb, modelMeloneHalf, modelApple, modelAppleHalf, modelJetty,
	modelSky, modelOrange, modelOrangeHalf, modelCoconut, modelCoconutHalf, modelCitrone, modelCitroneHalf,
	modelStrawberry, modelStrawberryHalf, modelX


, modelMenuClassic, modelMenuArcade, modelMenuTraining, modelMenuSign, modelChili };

typedef enum
	{ zero, one, two, three, four, five, six, seven, eight, nine,
	melone, sword, bomb, meloneHalf1, meloneHalf2, apple, appleHalf1, appleHalf2, jetty,
	sky, orange, orangeHalf1, orangeHalf2, coconut, coconutHalf1, coconutHalf2, citrone, citroneHalf1, citroneHalf2,
	strawberry, strawberryHalf1, strawberryHalf2, x,
	menuClassic, menuArcade, menuTraining, sign, chili } ModelNames;


class ModelContainer {
public:
	virtual ~ModelContainer();
	static ModelContainer * getContainer();
	static btConvexHullShape * getShape(Model model);
	void drawModel(Model model);
	void drawModel(Model model, int tex);
	void addModel(ModelNames modelName, Model3DS * model);
private:
	static ModelContainer * container;
	std::map<ModelNames, Model3DS*> models;

protected:
	ModelContainer();
};

#endif /* MODELCONTAINER_H_ */
