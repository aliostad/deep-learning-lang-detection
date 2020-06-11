#include "class/display/draw/drawObject/DynamicDrawObject.h"
#include "class/display/model/modelBuffer/ModelBuffer.h"
namespace Display{
DynamicDrawObject::DynamicDrawObject() {
	model_updated=false;
	draw=false;
	model=new Model(60,true);
}
DynamicDrawObject::~DynamicDrawObject() {
	delete model;
	clear_model_buffer();
}
void DynamicDrawObject::update_model_buffer(){
	if(!model_buffer){
		set_obj(new ModelBuffer(model));
	}else{
		model_buffer->load_model(model);
	}
	model_updated=false;
}
void DynamicDrawObject::clear_model_buffer(){
	if(model_buffer){
		delete model_buffer;
		model_buffer=0;
	}
}
void DynamicDrawObject::update(){
	if(draw){
		if(model_updated||!model_buffer){
			update_model_buffer();
		}
	}else{
		clear_model_buffer();
	}
	draw=false;
}
}
