/*
 * MacGitver
 * Copyright (C) 2012-2013 The MacGitver-Developers <dev@macgitver.org>
 *
 * (C) Nils Fenner <nils@macgitver.org>
 *
 * This program is free software; you can redistribute it and/or modify it under the terms of the
 * GNU General Public License (Version 2) as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 * even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with this program; if
 * not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "gtest/gtest.h"

#include "libGitWrap/Result.hpp"
#include "libGitWrap/Repository.hpp"
#include "libGitWrap/Index.hpp"

#include "Infra/Fixture.hpp"
#include "Infra/TempRepo.hpp"

typedef Fixture IndexFixture;

TEST_F(IndexFixture, CanRead)
{
    Git::Result r;
    TempRepoOpener tempRepo(this, "SimpleRepo1", r);
    CHECK_GIT_RESULT(r);
    Git::Repository repo(tempRepo);
    ASSERT_TRUE( repo.isValid() );

    Git::Index repoIndex = repo.index( r );
    CHECK_GIT_RESULT( r );
    ASSERT_TRUE( repoIndex.isValid() );

    repoIndex.read( r );
    CHECK_GIT_RESULT( r );
}

TEST_F(IndexFixture, CanResetFiles)
{
    Git::Result r;
    TempRepoOpener tempRepo(this, "SimpleRepo1", r);
    CHECK_GIT_RESULT(r);
    Git::Repository repo(tempRepo);
    ASSERT_TRUE( repo.isValid() );

    Git::Index repoIndex = repo.index( r );
    CHECK_GIT_RESULT( r );
    ASSERT_TRUE( repoIndex.isValid() );

    repoIndex.resetFiles( r, QStringList() << QString::fromUtf8("*.*"));
    CHECK_GIT_RESULT( r );
}
