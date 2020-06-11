#ifndef MODELNODE_HPP_INCLUDED
#define MODELNODE_HPP_INCLUDED

#include "model.hpp"
#include "node.hpp"

namespace gst
{
    class Material;
    class Mesh;
    class Model;

    // The responsibility of this class is to position a model.
    class ModelNode : public Node {
    public:
        ModelNode(Model model);
        void accept(NodeVisitor & visitor) final;
        // Return model mesh.
        Mesh & get_mesh();
        // Return material.
        Material & get_material();
        // Retrun pass.
        Pass & get_pass();
        // Return model.
        Model & get_model();
    private:
        Model model;
    };
}

#endif
