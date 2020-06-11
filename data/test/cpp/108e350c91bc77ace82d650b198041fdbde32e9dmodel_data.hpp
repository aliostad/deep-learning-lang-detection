
#ifndef MODEL_DATA_HPP
#define MODEL_DATA_HPP

#include <stdlib.h>

class ModelData {
public:
    ModelData() = default;
    virtual ~ModelData() = default;

private:
    ModelData(const ModelData& that);
};

template <typename T>
class TypedModelData : public ModelData {
public:
    TypedModelData() = delete;
    explicit TypedModelData(const T& payload_in) : payload(payload_in) {}
    virtual ~TypedModelData() = default;

    T& getPayload() { return payload; };
    T* getPayloadReference() { return &payload; };

private:
    T payload;

    TypedModelData(const TypedModelData& that);
};

#endif // MODEL_DATA_HPP
