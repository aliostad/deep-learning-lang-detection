#include "NodeRepo.h"

NodeRepo::NodeRepo (const NodeRepo::tree_type& tree)
    : _tree(tree)
{
}


NodeRepo::~NodeRepo ()
{
}


NodeRepo& NodeRepo::insert (const Node& node)
{
    (this->_tree).insert(node);
    return *this;
}


NodeRepo& NodeRepo::optimize ()
{
    (this->_tree).optimize();
    return *this;
}


NodeRepo::node_list_type NodeRepo::findWithinSphere (
        NodeRepo::node_type ref, double radius) const
{
    NodeRepo::node_list_type nodes_in_range = this->findWithinRange(
            ref, radius);
    NodeRepo::node_list_type nodes;
    std::copy_if(
            nodes_in_range.begin(),
            nodes_in_range.end(),
            std::back_inserter(nodes),
            [&ref, &radius](const Node& node){
                return node.distanceTo(ref) < radius;
            });
    return nodes;
}


NodeRepo::node_list_type NodeRepo::findWithinRange (
        NodeRepo::node_type ref, double range) const
{
    NodeRepo::node_list_type nodes;
    (this->_tree).find_within_range(ref, range, std::back_inserter(nodes));
    return nodes;
}


NodeRepo::node_list_type NodeRepo::all() const
{
    NodeRepo::node_list_type nodes;
    std::copy((this->_tree).begin(), (this->_tree).end(), std::back_inserter(nodes));
    return nodes;
}


NodeRepo::const_iterator NodeRepo::begin() const
{
    return (this->_tree).begin();
}


NodeRepo::const_iterator NodeRepo::end() const
{
    return (this->_tree).end();
}

