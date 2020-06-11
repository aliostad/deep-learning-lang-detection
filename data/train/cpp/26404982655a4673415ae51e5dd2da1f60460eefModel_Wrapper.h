#ifndef __game__Model_Wrapper_h__
#define __game__Model_Wrapper_h__

#include <zenilib.h>
#include <memory>

class Model_Wrapper {
public:
	Model_Wrapper(const Zeni::String& file_ = "", Zeni::Vector3f scaling = Zeni::Vector3f(1.0, 1.0, 1.0)) : fileName(file_), scalingFactors(scaling), model(nullptr) {};
	Model_Wrapper(Zeni::Model* model_ = nullptr) : fileName(""), model(std::shared_ptr<Zeni::Model>(model_)) {};
    Model_Wrapper(std::shared_ptr<Zeni::Model> model_ = std::shared_ptr<Zeni::Model>(nullptr)) : fileName(""), model(model_) {};
	~Model_Wrapper() {};

    std::shared_ptr<Zeni::Model> getModel() const {
		if(!model)
		{
            if(fileName.length())
            {
                model = std::shared_ptr<Zeni::Model>(new Zeni::Model(fileName));
            }
            else {
                model = std::shared_ptr<Zeni::Model>(nullptr);
            }
		}
		return model;
	};

private:
	Zeni::String fileName;
	Zeni::Vector3f scalingFactors;
    mutable std::shared_ptr<Zeni::Model> model;
};

#endif