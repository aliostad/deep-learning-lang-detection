/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/**
 * Copyright (c) 2014,  Regents of the University of California.
 *
 * This file is part of NDN repo-ng (Next generation of NDN repository).
 * See AUTHORS.md for complete list of repo-ng authors and contributors.
 *
 * repo-ng is free software: you can redistribute it and/or modify it under the terms
 * of the GNU General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * repo-ng is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * repo-ng, e.g., in COPYING.md file.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef REPO_TESTS_REPO_STORAGE_FIXTURE_HPP
#define REPO_TESTS_REPO_STORAGE_FIXTURE_HPP

#include "storage/repo-storage.hpp"
#include "storage/sqlite-storage.hpp"
#include <boost/filesystem.hpp>
#include <boost/test/unit_test.hpp>

namespace repo {
namespace tests {

class RepoStorageFixture
{
public:
  RepoStorageFixture()
    : store(make_shared<SqliteStorage>("unittestdb"))
    , handle(new RepoStorage(static_cast<int64_t>(65535), *store))
  {
  }

  ~RepoStorageFixture()
  {
    boost::filesystem::remove_all(boost::filesystem::path("unittestdb"));
  }


public:
  shared_ptr<Storage> store;
  shared_ptr<RepoStorage> handle;
};

} // namespace tests
} // namespace repo

#endif // REPO_TESTS_REPO_STORAGE_FIXTURE_HPP
