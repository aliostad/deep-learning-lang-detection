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

#include <QtPlugin>
#include <QFileDialog>

#include "libMacGitverCore/App/MacGitver.hpp"
#include "libMacGitverCore/RepoMan/RepoMan.hpp"
#include "libMacGitverCore/RepoMan/Repo.hpp"

#include "RepoTreeRawModule.hpp"
#include "RepoTreeRawView.hpp"

RepoTreeRawModule::RepoTreeRawModule()
{
}

void RepoTreeRawModule::initialize()
{
    MacGitver::self().registerView("RepoTreeRaw",
                                   tr( "Raw Repo Tree" ),
                                   &RepoTreeRawModule::createRepoTreeRawView);
}

void RepoTreeRawModule::deinitialize()
{
    MacGitver::self().unregisterView("RepoTreeRaw");
}

Heaven::View* RepoTreeRawModule::createRepoTreeRawView()
{
    return new RepoTreeRawView();
}

#if QT_VERSION < 0x050000
Q_EXPORT_PLUGIN2(RepoTreeRaw, RepoTreeRawModule)
#endif
