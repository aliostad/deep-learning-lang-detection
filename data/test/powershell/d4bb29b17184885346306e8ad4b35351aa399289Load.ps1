$PreLoad = {
    Import-OMPModule 'PSGit'
}
$PostLoad = {}
$Config = {
    # customize git prompt display settings
    Set-GitPromptSettings -SeparatorText '' -BeforeText '' -BeforeChangesText '' -AfterChangesText '' -AfterNoChangesText '' `
                        -BranchText "$([PowerLine.Prompt]::Branch) " -BranchForeground White -BranchBackground Cyan `
                        -BehindByText '▼' -BehindByForeground White -BehindByBackground DarkCyan `
                        -AheadByText '▲' -AheadByForeground White -AheadByBackground DarkCyan `
                        -StagedChangesForeground White -StagedChangesBackground DarkBlue `
                        -UnStagedChangesForeground White -UnStagedChangesBackground Blue

}
$Shutdown = {
    Remove-Module 'PSGit' -force
}