/*
 * MacGitver
 * Copyright (C) 2012-2013 The MacGitver-Developers <dev@macgitver.org>
 *
 * (C) Sascha Cunz <sascha@macgitver.org>
 * (C) Cunz RaD Ltd.
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

#include "libMacGitverCore/RepoMan/RepoMan.hpp"
#include "libMacGitverCore/RepoMan/Repo.hpp"

#include "Infra/TempRepo.hpp"

#include "Test_Repo.hpp"

#define RMAN() MacGitver::repoMan()

TEST_F(Repo_Fixture, CanOpenRepo)
{
    TempRepo tempRepo(this, "SimpleRepo1");

    RM::Repo* repo = RMAN().open(tempRepo);
    ASSERT_TRUE(repo != NULL);

    repo->close();
    ASSERT_EQ(0, RMAN().repositories().count());
}

TEST_F(Repo_Fixture, Trivial)
{
    TempRepoOpener repo(this, "SimpleRepo1");

    ASSERT_TRUE(repo->isA<RM::Repo>());

    ASSERT_TRUE(repo->isActive());
    ASSERT_TRUE(repo->isLoaded());
    ASSERT_FALSE(repo->isSubModule());
    ASSERT_FALSE(repo->isBare());

    qDebug("%s", qPrintable(RMAN().dump()));
}
