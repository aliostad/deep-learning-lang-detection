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


#include "repocsv.h"


istream& repo::core::RepoCSV::readLine(
        istream& stream,
        std::list<std::string>& tokenizedLine)
{
    tokenizedLine.clear();
    std::string line;
    getline(stream, line);
    std::stringstream ss(line);
    std::string field;
    while (std::getline(ss, field, delimiter))
        tokenizedLine.push_back(field);
    return stream;
}

istream& repo::core::RepoCSV::readFile(istream& stream,
        std::list<std::list<string> >& data)
{
    data.clear();
    std::list<std::string> tokenizedLine;
    while(readLine(stream, tokenizedLine))
        data.push_back(tokenizedLine);
    return stream;
}

repo::core::RepoNodeAbstractSet repo::core::RepoCSV::readMetadata(
        const std::string& path,
        std::list<string>& headers,
		const char delimeter)
{
    RepoNodeAbstractSet metadata;
    ifstream file(path);

	setDelimiter(delimeter);

    std::list<std::string> tokens;
    while(file.good() && readLine(file, tokens))
    {
        if (headers.empty())
            headers = tokens;
        else if (!tokens.empty())
            metadata.insert(new RepoNodeMetadata(headers, tokens, *tokens.begin()));
    }
    file.close();
    return metadata;
}

void repo::core::RepoCSV::print(std::list<std::list<string> > &matrix)
{
    for (std::list<string> line : matrix)
    {
        for (std::string token : line)
            std::cerr << token << ", ";
        std::cerr << std::endl;
    }
}

void repo::core::RepoCSV::print(RepoNodeAbstractSet& set)
{
    for (const RepoNodeAbstract* node : set)
    {
        const RepoNodeMetadata* meta = dynamic_cast<const RepoNodeMetadata*>(node);
        std::cerr << (meta ? meta->toString(", ") : node->toString()) << std::endl;
    }
}
