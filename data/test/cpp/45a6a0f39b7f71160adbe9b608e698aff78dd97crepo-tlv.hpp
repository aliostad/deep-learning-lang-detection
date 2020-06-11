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

#ifndef REPO_REPO_TLV_HPP
#define REPO_REPO_TLV_HPP

#include <ndn-cxx/encoding/tlv.hpp>

namespace repo {
namespace tlv {

using namespace ndn::tlv;

enum {
  RepoCommandParameter = 201,
  StartBlockId         = 204,
  EndBlockId           = 205,
  ProcessId            = 206,
  RepoCommandResponse  = 207,
  StatusCode           = 208,
  InsertNum            = 209,
  DeleteNum            = 210,
  MaxInterestNum       = 211,
  WatchTimeout         = 212
};

} // tlv
} // repo

#endif // REPO_REPO_TLV_HPP
