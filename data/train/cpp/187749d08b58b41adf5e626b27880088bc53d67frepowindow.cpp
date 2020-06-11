/**
**    Copyright (c) 2011 by Nils Fenner
**
**    This file is part of MsPiggit.
**
**    MsPiggit is free software: you can redistribute it and/or modify
**    it under the terms of the GNU General Public License as published by
**    the Free Software Foundation, either version 3 of the License, or
**    (at your option) any later version.
**
**    MsPiggit is distributed in the hope that it will be useful,
**    but WITHOUT ANY WARRANTY; without even the implied warranty of
**    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**    GNU General Public License for more details.
**
**    You should have received a copy of the GNU General Public License
**    along with MsPiggit.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "repowindow.h"
#include "ui_repowindow.h"

#include <QtGui/QFileDialog>
#include <QtGui/QMessageBox>
#include <QtGui/QLabel>

#include <QGit2/QGitError>

#include <model/modelaccess.h>

#include <ui/repodelegate.h>
#include <ui/repoview.h>


RepoWindow::RepoWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::RepoWindow)
    , _repoView(new RepoView())
{
    ui->setupUi(this);

    setupMainMenu();

    setCentralWidget(_repoView);

#ifdef Q_OS_MACX
    ui->treeSubmodules->setAttribute(Qt::WA_MacShowFocusRect, 0);
#endif

    ui->treeSubmodules->setModel(&_repoModel);
    ui->treeSubmodules->setItemDelegate(new RepoDelegate());

    connect(ModelAccess::instance().commitModelPtr(), SIGNAL(initialized()), this, SLOT(initializeRepoStatus()));
}

RepoWindow::~RepoWindow()
{
    delete ui;
}

void RepoWindow::setupMainMenu()
{
    QMenu * m = ui->menuBar->addMenu("Repository");
    QAction * a = m->addAction("Open ...", this, SLOT(openRepository()));
    a->setShortcut(QKeySequence(Qt::CTRL + Qt::Key_O));
    a->setShortcutContext(Qt::ApplicationShortcut);
}

void RepoWindow::openRepository()
{
    QFileDialog *fd = new QFileDialog(this);
#ifdef Q_OS_MAC
    fd->setFilter(QDir::Dirs | QDir::NoDotAndDotDot | QDir::Hidden);
#else
    fd->setFileMode(QFileDialog::Directory);
#endif
    fd->setDirectory(QDir::home());
    fd->setWindowTitle( tr("Open a Git repository") );
    fd->open(this, SLOT(onOpenRepository()));
}

void RepoWindow::onOpenRepository()
{
    QFileDialog *fd = dynamic_cast<QFileDialog *>(sender());
    Q_ASSERT(fd != 0);

    if ( fd->selectedFiles().isEmpty() )
        return;

    setupRepoView(fd->selectedFiles().first());
}

void RepoWindow::initializeRepoStatus()
{
    ui->statusBar->showMessage(tr("%1 commits in repository").arg(ModelAccess::instance().commitModel().rowCount()));
}

void RepoWindow::setupRepoView(QString path)
{
    using namespace LibQGit2;

    if (path.isEmpty() || !checkDirExists(path))
        return;

    QGitRepository repo;

    // open git repository and initialize views
    if ( !repo.discoverAndOpen(path) )
    {
        QMessageBox::critical( this, tr("Unable to open repository.")
                               , QString("Unable to open repository:\n%2").arg(QGitError::lastMessage())
                               );
    }

    updateWindowTitle( repo );

    // setup the models
    _repoModel.initialize( repo );
    ModelAccess::instance().reinitialize( repo );
}

void RepoWindow::updateWindowTitle(const LibQGit2::QGitRepository &repo)
{

    QString repoText;
    if (repo.isNull())
    {
        repoText = tr("<< no repository >>");
    }
    else
    {
        repoText = repo.name();
        if (repo.isBare())
            repoText += QString(" (BARE)");
    }

    setWindowTitle( QString("Repository: %1").arg(repoText) );
}

bool RepoWindow::checkDirExists(const QString &path) const
{
    QFileInfo fiRepo(path);
    if (!fiRepo.exists() || !fiRepo.isDir())
    {
        QMessageBox::critical(0, QObject::tr("Repository path not found."),
                              QObject::tr("The repositories path is not valid:\n%1").arg(path));
        return false;
    }

    return true;
}
