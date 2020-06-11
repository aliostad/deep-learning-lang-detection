/*
 * Model.h
 *
 *  Created on: 14 août 2014
 *      Author: chevassu
 */

#ifndef MODEL_H_
#define MODEL_H_

#include <map>
#include <memory>
#include <vector>
#include <algorithm>


#include "cppming/model/Class.h"
#include "cppming/model/Namespace.h"
#include "cppming/model/Function.h"
#include "cppming/model/ModelItem.h"

namespace cppming {
	namespace model {

		class Model {
		public:
			Model() : m_model(*this) {
			}

			virtual ~Model() {
			}

			DECLARE_GET_METHOD(Namespace)
			DECLARE_GET_METHOD(Class)

			std::map <std::string, std::shared_ptr<ModelItem>>& getItemMap() {
				return m_itemMap;
			}

		private:
			std::vector <std::shared_ptr<ModelItem>> m_subItems;

			std::map <std::string, std::shared_ptr<ModelItem>> m_itemMap;

			Model& m_model;
		};

	} /* namespace model */
} /* namespace cppming */

#endif /* MODEL_H_ */
