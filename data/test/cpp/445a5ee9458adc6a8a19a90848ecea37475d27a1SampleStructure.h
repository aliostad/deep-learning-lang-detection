#ifndef SAMPLE_H
#define SAMPLE_H

#include "SEComponent.h"

class SEComSample : public SEComponent {
public:
	SEComSample(std::string name = std::string(),
		std::string tag = std::string(),
		SEGameObject *owner = NULL);
	SEComSample(const SEComSample &rhs);
	~SEComSample();

	SEComSample& operator =(const SEComSample &rhs);

	// Local methods.

	SEComponent *clone() const { return new SEComSample(*this); }

protected:
	// Inherited pure virtuals.
	void onInit() {}
	void onRelease() {}

	// Inherited virtuals.
	void onUpdate();
	void onDraw();
	void onPostUpdate();
	void onPause();
	void onResume();


private:

};

#endif