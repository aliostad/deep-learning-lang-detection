#pragma once
#ifndef RAINBOW_MODEL_MODEL_HPP
#define RAINBOW_MODEL_MODEL_HPP

#include <memory>
#include <string>
#include <cstdint>

namespace rb {

enum class Model_format {
    OBJ,
    UNKNOWN,
};

class Model {
public:
    virtual ~Model() = default;
    virtual const float* verts() = 0;
    virtual const float* uv() = 0;
    virtual const int* elements() = 0;
    virtual uint32_t vert_size() = 0;
    virtual uint32_t vert_count() = 0;
    virtual uint32_t element_size() = 0;
    virtual uint32_t element_count() = 0;
    virtual Model_format format() = 0;
};

typedef std::unique_ptr<Model> Model_unique;
Model_unique load_model(const std::string& filename,
                        Model_format fmt = Model_format::UNKNOWN);

Model_format guess_model_format(const std::string& filename);
}

#endif // RAINBOW_MODEL_MODEL_HPP
