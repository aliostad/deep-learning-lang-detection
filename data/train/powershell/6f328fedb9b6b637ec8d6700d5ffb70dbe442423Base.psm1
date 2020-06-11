function Get-ShouldProcess {
    param (
        $MessageBody
    )
    $MessageBody | Out-File -FilePath C:\TransportAgentSamples\test.txt -Force | Out-Null
    if ( $MessageBody -like '*<a href="http://www.mylearningplan.com">Login</a>&nbsp;to MyLearningPlan.com*')
    {
        $true
    }
}

function Get-ProcessedMessage {
        param (
        $MessageBody
    )
    $MessageBody = $MessageBody -replace('<a href="http://www.mylearningplan.com">Login</a>&nbsp;to MyLearningPlan.com','<a href="http://mlp.bucksiu.org">Login</a>&nbsp;to MyLearningPlan.com')
    
    $MessageBody

}
