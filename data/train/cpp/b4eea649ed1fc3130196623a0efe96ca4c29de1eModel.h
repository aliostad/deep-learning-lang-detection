#ifndef MODEL_H
#define MODEL_H

#include <vector>
#include <string>

struct Vertex {
  float x, y, z;
};

class Model
{
public:
    Model();
    Model(std::vector<Vertex> const& v, std::vector<int> const& i);

    Model& operator = (Model const& m);

    std::vector<Vertex> const& getVertices() const;
    std::vector<int> const& getIndexes() const;

private:
    std::vector<Vertex> vertices_;
    std::vector<int>    indexes_;
};

class ModelLoader
{
public:
    static Model loadModel(std::string const& modelPath);

};

#endif // MODEL_H
