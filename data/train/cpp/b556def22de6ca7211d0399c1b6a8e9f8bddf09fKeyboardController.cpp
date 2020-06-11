/*
 *  KeyboardController.cpp
 *  openFrameworks
 *
 *  Created by Peter Uithoven on 5/8/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "KeyboardController.h"

KeyboardController::KeyboardController()
{
	
}

void KeyboardController::keyPressed(int keyCode)
{
	cout << "KeyboardController::keyPressed\n";
	switch (keyCode)
	{
		case ' ':
			model->learnBackground();
			break;
		case '+':
		case '=':
			model->setThreshold(model->threshold+1);
			break;
		case '-':
		case '_':
			model->setThreshold(model->threshold-1);
			break;
		case ']':
			model->setHitThreshold(model->hitThreshold+1);
			break;
		case '[':
			model->setHitThreshold(model->hitThreshold-1);
			break;
		case 'd':
			model->debugDetection = !model->debugDetection;
			break;
		case OF_KEY_RETURN:
			//if(model->state == STATE_DEMO)
				model->setState(STATE_GAME);
			break;
		case 'q':
			model->clip6EmptyCorrection -= 1;
			//model->clip6EmptyCorrectionChange = -5;
			cout << "  model->clip6EmptyCorrection: " << model->clip6EmptyCorrection << "\n";
			break;
		case 'w':
			model->clip6EmptyCorrection += 1;
			//model->clip6EmptyCorrectionChange = +5;			
			cout << "  model->clip6EmptyCorrection: " << model->clip6EmptyCorrection << "\n";
			break;
		case 'p':
			model->setVideoPause(!model->videoPaused);
			break;
		case '1':
			model->overulePlayer1Detected = true;
			model->setDetectedPlayer1(false);
			break;
		case '2':
			model->overulePlayer2Detected = true;
			model->setDetectedPlayer2(false);
			break;
			
		/*case 'i':
			model->setInvert(!model->getInvert());
			break;
		case ',':
			model->setObjectsScale(model->getObjectsScale()-0.1);
			break;
		case '.':
			model->setObjectsScale(model->getObjectsScale()+0.1);
			break;
		*/
	};
}
void KeyboardController::keyReleased(int keyCode)
{
	cout << "KeyboardController::keyReleased\n";
	switch (keyCode)
	{
		case '1':
			model->overulePlayer1Detected = false;
			model->setDetectedPlayer1(true);
			break;
		case '2':
			model->overulePlayer2Detected = false;
			model->setDetectedPlayer1(true);
			break;
	}
}