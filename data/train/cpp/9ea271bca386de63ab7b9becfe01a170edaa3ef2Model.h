#ifndef MODEL_H_
#define MODEL_H_

#include <ModelResult.h>
#include <ModelConfiguration.h>

namespace CuEira {
namespace Model {

/**
 * This is ...
 *
 * @author Daniel Berglund daniel.k.berglund@gmail.com
 */
class Model {
public:
  virtual ~Model();

  virtual ModelResult* calculate()=0;

  Model(const Model&) = delete;
  Model(Model&&) = delete;
  Model& operator=(const Model&) = delete;
  Model& operator=(Model&&) = delete;

protected:
  Model(ModelConfiguration* modelConfiguration);

  ModelConfiguration* modelConfiguration;
};

} /* namespace Model */
} /* namespace CuEira */

#endif /* MODEL_H_ */
