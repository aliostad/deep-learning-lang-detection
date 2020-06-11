#ifndef MODEL_WRITER_H_INCLUDED
#define MODEL_WRITER_H_INCLUDED

#include "qce_agency.h"

namespace qce
{

template<typename T>
class ModelWriter
{
public:
	typedef T data_type;

				ModelWriter(const qce::ModelId &);
				ModelWriter(const ModelWriter<T>& other);
				~ModelWriter();

	T*			operator -> () const;


private:
	ModelWriter&	operator= (const ModelWriter& other);

private:	
	T*			m_model;
};


template<typename T>
ModelWriter<T>::ModelWriter(const qce::ModelId & id)
{
	m_model = qce::Agency<T>::instance().model(id);
}

template<typename T>
ModelWriter<T>::ModelWriter(const ModelWriter<T>& other)
: m_model(other.m_model)
{
	assert(m_model);
	assert(m_model == other.m_model);
}


template<typename T>
ModelWriter<T>::~ModelWriter()
{
	if(m_model)
	{
		// TODO
	}
}

template<typename T>
T* ModelWriter<T>::operator ->() const
{
	assert(m_model);
	return m_model;
}

}


#endif //MODEL_READER_H_INCLUDED
