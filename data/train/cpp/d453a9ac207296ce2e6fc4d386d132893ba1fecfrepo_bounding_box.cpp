/**
 *  Copyright (C) 2014 3D Repo Ltd
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

#include "repo_bounding_box.h"

#include <iostream>

repo::core::RepoBoundingBox::RepoBoundingBox(const aiMesh * mesh)
{
	if (mesh->mNumVertices)
	{
        min = RepoVertex(mesh->mVertices[0]);
        max = RepoVertex(mesh->mVertices[0]);
	}

	for (unsigned int i = 0; i < mesh->mNumVertices; ++i)
	{
        RepoVertex tmp = RepoVertex(mesh->mVertices[i]);

		min.x = std::min(min.x,tmp.x);
		min.y = std::min(min.y,tmp.y);
		min.z = std::min(min.z,tmp.z);

		max.x = std::max(max.x,tmp.x);
		max.y = std::max(max.y,tmp.y);
		max.z = std::max(max.z,tmp.z);
	}
}

repo::core::RepoBoundingBox::RepoBoundingBox(const std::vector<RepoVertex> &vertices)
{
    if (vertices.size())
    {
        min = vertices[0];
        max = vertices[0];
    }

    for (unsigned int i = 0; i < vertices.size(); ++i)
    {
        aiVector3D tmp = vertices[i];

        min.x = std::min(min.x,tmp.x);
        min.y = std::min(min.y,tmp.y);
        min.z = std::min(min.z,tmp.z);

        max.x = std::max(max.x,tmp.x);
        max.y = std::max(max.y,tmp.y);
        max.z = std::max(max.z,tmp.z);
    }
}

bool repo::core::RepoBoundingBox::operator==(const RepoBoundingBox& other) const
{
    return this->getMin() == other.getMin() &&
            this->getMax() == other.getMax();
}

std::vector<aiVector3D> repo::core::RepoBoundingBox::toVector() const
{
    std::vector<aiVector3D> vec;
	vec.push_back(min);
	vec.push_back(max);
	return vec;
}


void repo::core::RepoBoundingBox::toOutline(
	std::vector<aiVector2t<float>> * vec) const
{
	vec->push_back(aiVector2t<float>(min.x, min.y));
	vec->push_back(aiVector2t<float>(max.x, min.y));
	vec->push_back(aiVector2t<float>(max.x, max.y));
	vec->push_back(aiVector2t<float>(min.x, max.y));
}


std::vector<double> repo::core::RepoBoundingBox::getTransformationMatrix() const
{
    std::vector<double> transformation(16);

    RepoVertex centroid = RepoVertex(max+min);

    transformation[0] = 1;
    transformation[1] = 0;
    transformation[2] = 0;
    transformation[3] = 0;

    transformation[4] = 0;
    transformation[5] = 1;
    transformation[6] = 0;
    transformation[7] = 0;

    transformation[8] = 0;
    transformation[9] = 0;
    transformation[10] = 1;
    transformation[11] = 0;

    transformation[12] = centroid.x/2;
    transformation[13] = centroid.y/2;
    transformation[14] = centroid.z/2;
    transformation[15] = 1;

    return transformation;
}

aiMatrix4x4 repo::core::RepoBoundingBox::getTranslationMatrix() const
{
    RepoVertex centroid = RepoVertex(max+min);
	aiMatrix4x4 tmp;

    return aiMatrix4x4::Translation(aiVector3D(centroid.x/2, centroid.y/2, centroid.z/2), tmp);
}
