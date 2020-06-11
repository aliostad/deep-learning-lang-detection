/*
 * ModelAndView.cpp
 *
 *  Created on: 01.07.2010
 *      Author: fkrauthan
 */

#include "ModelAndView.h"
#include "../exceptions/ModelNotFoundException.h"


ModelAndView::ModelAndView() {
	mView = NULL;
}

ModelAndView::ModelAndView(View* view) {
	mView = view;
}

ModelAndView::ModelAndView(View* view, const std::string& modelName, const boost::any& modelObject) {
	mView = view;
	mModel[modelName] = modelObject;
}

ModelAndView::ModelAndView(View* view, const std::map<std::string, boost::any>& model) {
	mView = view;
	mModel = model;
}

ModelAndView::~ModelAndView() {
	delete mView;
}

View* ModelAndView::getView() {
	return mView;
}

const std::map<std::string, boost::any>& ModelAndView::getModel() const {
	return mModel;
}

void ModelAndView::addModel(const std::string& name, const boost::any& object) {
	mModel[name] = object;
}

const boost::any& ModelAndView::getModel(const std::string& name) const {
	std::map<std::string, boost::any>::const_iterator iter = mModel.find(name);
	if(iter!=mModel.end()) {
		return iter->second;
	}

	throw ModelNotFoundException("The model \""+name+"\" was not found");
}

void ModelAndView::removeModel(const std::string& name) {
	std::map<std::string, boost::any>::iterator iter = mModel.find(name);
	if(iter!=mModel.end()) {
		mModel.erase(iter);
	}
}
