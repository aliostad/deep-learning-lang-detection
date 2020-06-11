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

#include "repocollstats.h"

repo::core::RepoCollStats::~RepoCollStats() {}

long long repo::core::RepoCollStats::getActualSizeOnDisk() const
{
    return getSize() + 16 * getCount() + getTotalIndexSize();
}

std::string repo::core::RepoCollStats::getDatabase() const
{
    return getDatabase(getNs());
}

std::string repo::core::RepoCollStats::getDatabase(const std::string& ns)
{
    std::string database = ns;
    const char *str = ns.c_str();
    const char *p;
    if (ns.find('.') != std::string::npos && (p = strchr(str, '.')))
        database = std::string(str, p - str);
    return database;
}

long long repo::core::RepoCollStats::getCount() const
{
    return getSize("count");
}

std::string repo::core::RepoCollStats::getCollection() const
{
    return getCollection(getNs());
}

std::string repo::core::RepoCollStats::getCollection(const std::string& ns)
{
    std::string collection = ns;
    const char *p;
    if (ns.find('.') != std::string::npos && (p = strchr(ns.c_str(), '.')))
        collection = p + 1;
    return collection;
}

std::string repo::core::RepoCollStats::getNs() const
{
    std::string ns;
    if(isOk())
        ns = getField("ns").String();
    return ns;
}

long long repo::core::RepoCollStats::getSize(const std::string& name) const
{
    long long size = 0;
    if (isOk())
        size = getField(name).safeNumberLong();
    return size;
}

long long repo::core::RepoCollStats::getSize() const
{
    return getSize("size");
}

long long repo::core::RepoCollStats::getStorageSize() const
{
    return getSize("storageSize");
}

long long repo::core::RepoCollStats::getTotalIndexSize() const
{
    return getSize("totalIndexSize");
}
