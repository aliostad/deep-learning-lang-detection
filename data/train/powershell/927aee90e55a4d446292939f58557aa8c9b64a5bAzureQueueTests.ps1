################################################################################
#                                                                              #
# C O M M O N   T E S T   S C R I P T   H E A D E R                            #
#                                                                              #
# There's a lot of set-up done from AzurePowerShellToolsTests.ps1
# that we don't want to skip...
if ([string]::IsNullOrEmpty($MyInvocation.ScriptName)) {
    throw 'This script is expecting to be run from AzurePowerShellToolsTests.ps1'
}

Write-HostHeading "$($MyInvocation.MyCommand)" -BackgroundColor DarkMagenta -ForegroundColor White
#                                                                              #
#                                                                              #
################################################################################

$result = $azureConnectionString -match 'AccountName=([a-z0-9]+);'

if (!$result) {
    throw 'Invalid AzureConnectionString parameter.'
}

$accountName = $Matches[1]
$testQueue = 'test-queue-' + (Get-RandomString 6)

Write-HostHeading "Using Azure AccountName [$accountName]" -BackgroundColor Cyan -ForegroundColor Black -BreakBefore
Write-HostHeading "Using Queue Name [$testQueue]" -BackgroundColor Cyan -ForegroundColor Black

Write-HostHeading "SETUP" -BackgroundColor DarkCyan -ForegroundColor White

################################################################################
#                                                                              #
# T E S T   S E T U P                                                          #
#                                                                              #
################################################################################
$exists = Test-AzureName -Storage "$accountName"

if (!$exists) {
    Write-HostHeading "Unable to proceed; Azure Storage AccountName [$accountName] does not exist or credentials are invalid." -BackgroundColor Red -ForegroundColor White
    return
}

$result = New-AzureStorageQueue -Name "$testQueue"

if (!$result) {
    Write-HostHeading "Unable to proceed; Unable to create test queue [$testQueue]." -BackgroundColor Red -ForegroundColor White
    return
}

Remove-AzureStorageConfigurationFiles
Set-AzureStorageConfiguration -AzureConnectionString "$azureConnectionString" | Out-Null

################################################################################
#                                                                              #
# T E S T S                                                                    #
#                                                                              #
################################################################################
Write-HostHeading "TESTS" -BackgroundColor DarkCyan -ForegroundColor White -BreakBefore

(New-Test 'queue should be empty' {
    # arrange / act
    $count = Get-QueueMessageCount $testQueue
    
    # assert
    $Assert::That($count, $Is::EqualTo(0))
}),

(New-Test 'New-QueueMessage & Get-QueueMessageCount: add one message and verify' {
    # arrange
    $message = (Get-RandomString 12)
    # act
    New-QueueMessage $testQueue "$message"
    $count = Get-QueueMessageCount $testQueue
    
    # assert
    $Assert::That($count, $Is::EqualTo(1))
}),

(New-Test 'New-QueueMessage & Get-QueueMessageCount: add another message and verify' {
    # arrange
    $message = (Get-RandomString 12)
    # act
    New-QueueMessage $testQueue "$message"
    $count = Get-QueueMessageCount $testQueue
    
    # assert
    $Assert::That($count, $Is::EqualTo(2))
}),

(New-Test 'Clear-QueueMessages & Get-QueueMessageCount: clear all messages and verify' {
    # arrange / act
    Clear-QueueMessages $testQueue
    $count = Get-QueueMessageCount $testQueue
    
    # assert
    $Assert::That($count, $Is::EqualTo(0))
}),

(New-Test 'Get-QueueMessage & friends: peek functionality' {
    # arrange
    $expected = (Get-RandomString 12)
    Clear-QueueMessages $testQueue

    # act
    New-QueueMessage $testQueue "$expected"
    Get-QueueMessage $testQueue
    $actual = (Get-QueueMessage $testQueue).AsString

    # assert
    $Assert::That($actual, $Is::EqualTo($expected))
}),

(New-Test 'Get-QueueMessage & friends: peek the same message twice' {
    # arrange
    $expected = (Get-RandomString 12)
    Clear-QueueMessages $testQueue

    # act
    New-QueueMessage $testQueue "$expected"

    $actual1 = (Get-QueueMessage $testQueue).Id
    $actual2 = (Get-QueueMessage $testQueue).Id

    # assert
    $Assert::That($actual1, $Is::EqualTo($actual2))
}),

(New-Test 'Get-QueueMessage & friends: remove a message' {
    # arrange
    $expected = (Get-RandomString 12)
    Clear-QueueMessages $testQueue

    # act
    New-QueueMessage $testQueue "$expected"
    Get-QueueMessage $testQueue -Remove
    $count = Get-QueueMessageCount $testQueue

    # assert
    $Assert::That($count, $Is::EqualTo(0))
}),

(New-Test 'Get-QueueMessage & friends: attempt to remove a message from an empty queue' {
    # arrange
    Clear-QueueMessages $testQueue

    # act
    $message = Get-QueueMessage $testQueue -Remove

    # assert
    $Assert::That($message, $Is::Null)
}) |
    
Invoke-Test |

Format-TestResult -All

################################################################################
#                                                                              #
# T E S T   T E A R D O W N                                                    #
#                                                                              #
################################################################################

Write-HostHeading "TEAR DOWN" -BackgroundColor DarkCyan -ForegroundColor White -BreakBefore

# Remove-AzureStorageQueue has no return
Remove-AzureStorageQueue -Name "$testQueue" -Force
