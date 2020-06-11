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

#include <QDir>

#include "libMacGitverCore/RepoMan/Repo.hpp"
#include "libMacGitverCore/RepoMan/RepoMan.hpp"

#include "Infra/Fixture.hpp"
#include "Infra/TempDirProvider.hpp"
#include "Infra/TempRepo.hpp"

TempRepo::TempRepo(Fixture* fixture, const char* name)
{
    mTempRepoDir = fixture->prepareRepo(name);
}

TempRepo::~TempRepo()
{
    QDir(mTempRepoDir).rmpath(QStringLiteral("."));
}

TempRepoOpener::TempRepoOpener(Fixture* fixture, const char* name)
    : mTempRepo(fixture, name)
{
    mRepo = MacGitver::repoMan().open(mTempRepo);
}

TempRepoOpener::~TempRepoOpener()
{
    mRepo->close();
}
