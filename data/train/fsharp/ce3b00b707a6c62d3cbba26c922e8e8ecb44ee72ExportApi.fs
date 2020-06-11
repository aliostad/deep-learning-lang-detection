module DevRT.ExportApi

open System
open Common
open ConsoleOutput
open DevRT.DataTypes
open FileUtil
open IOWrapper

let createAgent' handle =
    Agent.createAgent
        (AgentRecoverableError >> Error >> Logging.log)
        (AgentFatalError >> Error >> Logging.log)
        handle

let runProcess =
    ProcessRunner.run
        (ProcessRunnerStartInfo >> Info >> Logging.log)

let composeNUnitHandle (nUnitConfig: NUnitConfig) =
    let cleanDirectory'() =
        cleanDirectory
            (deleteAllFiles exists deleteRecursive)
            createDirectory
            nUnitConfig.NUnitDeploymentDir
    let run' getStartInfo =
        runProcess
            getStartInfo
            (NUnit.handleRunning
                NUnit.getUpdatedStatus
                (NUnit.handleOutput
                    writelineDarkCyan
                    writelineYellow
                    (NUnit.writeFailureLineNumberInfo
                        writelineYellow)))
    let prepareAndRunTests () =
        NUnit.prepareAndRunTests
            (NUnit.getTestDirectoryName
            >> combine nUnitConfig.NUnitDeploymentDir)
            (ProcessRunner.getProcessStartInfo
                nUnitConfig.NUnitConsole)
            cleanDirectory'
            (NUnit.copyBuildOutput
                (NUnitCopyBuildOutput >> Info >> Logging.log))
            (NUnit.runTestProject run')
            nUnitConfig.TestProjects
    NUnit.run prepareAndRunTests

let composeMsBuildHandle (msBuildConfig: MsBuildConfig) =
    let getMsBuildStartInfo () =
        ProcessRunner.getProcessStartInfo
            msBuildConfig.MsBuildPath
            (MsBuild.getRunArgsString
                msBuildConfig.OptionArgs
                msBuildConfig.SolutionOrProjectFile)
            msBuildConfig.MsBuildWorkingDir
    let update, getStatus = createStatus Starting
    let updateStatus =
        (MsBuild.getUpdatedStatus
            (getStatus >> MsBuild.getContinuationStatus))
        >> update
    MsBuild.handle
        (MsBuild.processOutput
            (MsBuild.handleStarting
                writelineDarkGreen getNow updateStatus)
            writelinePurple
            writelineRed
            updateStatus)
        (runProcess getMsBuildStartInfo)
        getStatus

let composeFileWatchHandle (config: FileWatchConfig) =
    let getFiles () =
         FileWatch.getFiles
            (FileWatch.isBaseCase
                config.ExcludedDirectories)
             config.FileChangeWatchDir
    let getTimeLine' () =
        FileWatch.getTimeLine
            getNow config.SleepMilliseconds
    FileWatch.handle
        getFiles
        (FileWatch.isNewModification
            getTimeLine'
            FileWatch.getLastWriteTime)

let composeRefactorHandle refactorConfig =
    Refactor.handle
        (Refactor.refactor
            (Refactor.processFile
                (RefactorLine.processLine
                    (RefactorLine.getRules
                        IOWrapper.readAllLines
                        refactorConfig.DevRTDeploymentDir))
                IOWrapper.readAllLines
                Refactor.processLines)
            IOWrapper.writeAllLines)
        (Refactor.fileFilter IOWrapper.fileExists)
        refactorConfig.IsRefactorOn

let getPostToFileWatchAgent
    fileWatchConfig nUnitConfig msBuildConfig refactorConfig =
    let nUnitAgent =
        createAgent' (composeNUnitHandle nUnitConfig)
    let msBuildHandle () =
        composeMsBuildHandle msBuildConfig nUnitAgent.Post
    let msBuildAgent = createAgent' msBuildHandle
    let refactorAgent =
        createAgent' (composeRefactorHandle refactorConfig)
    let fileWatchAgent =
        createAgent'
            (composeFileWatchHandle
                fileWatchConfig
                (FileWatch.publishAboutModification
                    (FileWatchModificationFound
                        >> Info
                        >> Logging.log)
                    msBuildAgent.Post
                    refactorAgent.Post))
    let run () =
        Run.run
            fileWatchConfig.SleepMilliseconds
            fileWatchAgent.Post
        |> Seq.toList
    run
