#pragma once
#include "Game.h"
#include "Model.h"
#include <string>
using namespace std;

using namespace EDXFramework;

class water : public Game {
public:
	water();
	virtual ~water();
	void Initialize();
	void LoadContent();
	void Update();
	void Draw();
	void UnloadContent();

protected:
	Model* wa01;
	Model* wa02;
	Model* wa03;
	Model* wa04;
	Model* wa05;
	Model* wa06;
	Model* wa07;
	Model* wa08;
	Model* wa09;
	Model* wa10;
	Model* wa11;
	Model* wa12;
	Model* wa13;
	Model* wa14;
	Model* wa15;
	Model* wa16;
	Model* wa17;
	Model* wa18;
	Model* wa19;
	Model* wa20;
	Model* wa21;
};