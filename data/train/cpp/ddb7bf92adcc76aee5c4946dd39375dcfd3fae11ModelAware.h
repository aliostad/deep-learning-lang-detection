#pragma once

template <typename ModelT> class ModelAware {
public:
	ModelAware() : model(nullptr) { }

	virtual ~ModelAware() { }

	void setModel(ModelT* model) {
		this->model = model;
	}

	ModelT* getModel() const {
		return model;
	}

private:
	ModelT* model;
};

template <typename ModelT, typename ObserverT> class ModelAwareObserver : public ObserverT {
public:
	ModelAwareObserver() : model(nullptr) { }

	virtual ~ModelAwareObserver() {
		this->model->unregister(this);
	}

	void setModel(ModelT* model) {
		this->model = model;
		this->model->regist(this);
	}

	ModelT* getModel() const {
		return model;
	}

private:
	ModelT* model;
};