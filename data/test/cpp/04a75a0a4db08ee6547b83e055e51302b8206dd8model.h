#ifndef __THERMAL_MODEL_H__
#define __THERMAL_MODEL_H__

#include "source/models/model_type.h"
#include "source/misc/common_types.h"
#include "source/misc/config_parser.h"

namespace Thermal
{
    class Model
    {
    public:
        virtual ~Model();

        static Model* createModel(ModelType model_type);

        virtual std::string getModelName() = 0;
        virtual void        startup() = 0;
        virtual void        execute(Time scheduled_time) = 0;

    protected:
        // Child classes must call this constructor
        Model();

        ConfigParser* _config;

        bool            _ready_to_execute;
        Time            _last_execute_time;

    private:


    }; // class Model

} // namespace Thermal

#endif // __THERMAL_MODEL_H__
