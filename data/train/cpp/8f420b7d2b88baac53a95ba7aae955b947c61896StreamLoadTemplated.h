#ifndef _STREAM_LOAD_TEMPLATED_H_
#define _STREAM_LOAD_TEMPLATED_H_

#define DECLARE_LOAD_TEMPLATED \
	\
	template <typename T> \
	bool Load(T & value) \
	{ \
		return Load((Serializable &) value); \
	} \
	\
	template <typename T> \
	bool Load(const T & value) \
	{ \
		T& unconsted = const_cast<T&>(value); \
		return Load((T&)unconsted); \
	} \
	\
	template <typename T> \
	bool Load(const T *& value) \
	{ \
		T*& unconsted = const_cast<T*&>(value); \
		return Load((T*&)unconsted); \
	} \
	\
	template <typename T> \
	bool Load(T *& value) \
	{ \
		return Load((Serializable *&) value); \
	}

#endif