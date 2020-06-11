/**
 *  Copyright (C) 2015 3D Repo Ltd
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#ifndef REPO_GRAPH_OPTIMIZER_H
#define REPO_GRAPH_OPTIMIZER_H

#include "../repocoreglobal.h"
#include "../graph/repo_graph_scene.h"
#include "../graph/repo_node_mesh.h"
#include "../graph/repo_node_metadata.h"
#include "../graph/repo_node_transformation.h"

//------------------------------------------------------------------------------

namespace repo {
namespace core {

class REPO_CORE_EXPORT RepoGraphOptimizer
{

public:

    RepoGraphOptimizer(RepoGraphScene* scene);

    ~RepoGraphOptimizer() {}

    //! Collapses all single mesh transformations in a scene graph.
    void collapseSingleMeshTransformations();

    //! Recursive collapse until not more possible.
    void collapseSingleMeshTransformations(RepoNodeMesh* mesh);

    //! Resursive collapse of transformations that have no meshes as children. Disregards
    void collapseZeroMeshTransformations();

    //! Returns processed scene.
    RepoGraphScene* getScene() const { return scene; }

    //! Returns a transformation if it is a single parent, NULL otherwise.
    static RepoNodeTransformation* getSingleParentTransformation(RepoNodeAbstract *node);

private :

    RepoGraphScene* scene;

}; // end class

} // end namespace core
} // end namespace repo

#endif // REPOGRAPHOPTIMIZER_H
