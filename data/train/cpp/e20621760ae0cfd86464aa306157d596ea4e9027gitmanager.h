#ifndef GITMANAGER_H
#define GITMANAGER_H

#include <QString>
#include <QStringList>

class GitManager
{
    QString repo;
    QString startPath;
    static const QString cleanRepoString;
public:
    explicit GitManager(const QString &repoPath);
    void goToRepo(void);
    void goToStartPath(void);
    bool isRepoClean(void);
    QStringList getBranches(void);
    QString getCurrentBranch(void);
    bool goToBranch(const QString& brName);
    static void createInfoFile(const QString &repoPath, const QString &fileName);
};

#endif // GITMANAGER_H
