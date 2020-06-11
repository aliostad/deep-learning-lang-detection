#ifndef _TWEEDY_MYQMLWRAPPER_HPP_
#define _TWEEDY_MYQMLWRAPPER_HPP_

#include "Animal.hpp"
#include "model.h"

#include <QtCore/QObject>

#include <boost/lexical_cast.hpp>

class MyQmlWrapper : public QObject
{
	Q_OBJECT
public:
    Q_PROPERTY( AnimalModel* animalModel READ getAnimalModel NOTIFY animalModelChanged )
	
	AnimalModel* getAnimalModel() { return &_model; }
	
    Q_INVOKABLE void add()
	{
		static int i = 0;
		_model.addAnimal( Animal( ("AAA"+boost::lexical_cast<std::string>(i++)).c_str(), "BBB") );
	}
//    Q_INVOKABLE void modify()
//	{
//		_model.getAnimals()[1]
//	}
    Q_INVOKABLE void remove()
	{
//		_model.beginRemoveRows( _model., 1, 2);
		_model.removeRow( 1 );
//		_model.endRemoveRows();
	}
	
Q_SIGNALS:
	void animalModelChanged();
	
private:
	AnimalModel _model;
};

#endif
