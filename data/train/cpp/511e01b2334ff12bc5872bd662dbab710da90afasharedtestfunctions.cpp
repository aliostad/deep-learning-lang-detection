class SharedTestFunctions {
    public:
        QStringList m_commands;

    SharedTestFunctions(){

    }
    void setupTestRepo(){
        QStringList commands;
        QString repo_dir = QDir::currentPath()+"/test_repo";
        QString file1_path = repo_dir+"/file1.txt";
        QString file2_path = repo_dir+"/file2.txt";
        QString file3_path = repo_dir+"/file2renamed.txt";

        commands << QString("rm -r %1").arg(repo_dir);
        commands << QString("mkdir %1").arg(repo_dir);
        commands << QString("echo \"something like the contents of a file\" > %1").arg(file1_path);
        commands << QString("echo \"another file with a wonderful message\" > %1").arg(file2_path);
        QString command;
        foreach(command, commands){
            system(command.toAscii().data());
        }
        commands.clear();

        LocalDiskRepo ldr(0, repo_dir, "testrepo");
    }
}
