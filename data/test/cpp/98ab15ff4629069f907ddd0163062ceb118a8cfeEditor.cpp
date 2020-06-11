#include "Editor.h"

void onEditorStart(Renderer *renderer, AudioHandler *audioHandler, InputHandler *inputHandler, PhysicsHandler *physicsHandler, ScriptHandler *scriptHandler, Scene *currentScene)
{
	
}

void onEditorTick(Renderer *renderer, AudioHandler *audioHandler, InputHandler *inputHandler, PhysicsHandler *physicsHandler, ScriptHandler *scriptHandler, Scene *currentScene)
{
	if (inputHandler->getMouseButtonPressed(1))
	{
		currentScene->getCamera()->pitchCamera((float)inputHandler->getMouseDeltaY());
		currentScene->getCamera()->yawCamera((float)inputHandler->getMouseDeltaX());
	}
}

void onEditorExit(Renderer *renderer, AudioHandler *audioHandler, InputHandler *inputHandler, PhysicsHandler *physicsHandler, ScriptHandler *scriptHandler, Scene *currentScene)
{

}
