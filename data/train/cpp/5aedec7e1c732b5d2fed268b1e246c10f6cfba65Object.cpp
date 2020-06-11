#include "Object.h"
#include "Engine.h"

extern bool SortObjectsPredicate(const Object* o1, const Object* o2);
extern Engine* engine;

Object::Object() {
	gridSize=engine->editorGridSize;
	grabbed=false;
	visible=true;
	depth=0;
	chunk.x=0;
	chunk.y=0;
	objectIndex=0;
};

Object::~Object() {

};

bool Object::SetBBox(int left, int top, int width, int height) {
	bBox.left=left;
	bBox.top=top;
	bBox.width=width;
	bBox.height=height;
	return true;
};

sf::Rect<sf::Int16> Object::GetBBox() {
	return bBox;
};

void Object::SetPosition(float xx, float yy) {
	x=xx;
	y=yy;
	xPrev=x;
	yPrev=y;
};

void Object::MoveToChunk() {
	int chunkX = floor(x/engine->objectsManager->chunkSize.x);
	int chunkY = floor(y/engine->objectsManager->chunkSize.y);
	chunkX = std::max(0,chunkX);
	chunkY = std::max(0,chunkY);
	chunkX = std::min(chunkX,engine->objectsManager->chunksNumber.x);
	chunkY = std::min(chunkY,engine->objectsManager->chunksNumber.y);
	sf::Vector2i temp(chunkX,chunkY);
	if (chunk.x!=temp.x || chunk.y!=temp.y) {
		int size=engine->objectsManager->chunks->at(chunk.x)->at(chunk.y)->list->size();
		for(int k=0;k<size;k++) {
			if(engine->objectsManager->chunks->at(chunk.x)->at(chunk.y)->list->at(k)==this) {
				engine->objectsManager->chunks->at(chunk.x)->at(chunk.y)->list->erase(engine->objectsManager->chunks->at(chunk.x)->at(chunk.y)->list->begin()+k);
				engine->objectsManager->chunks->at(chunkX)->at(chunkY)->list->push_back(this);
				break;
			};
		};
		chunk=temp;
	};
};

void Object::Grab(bool gr) {
	grabbed=gr;
};