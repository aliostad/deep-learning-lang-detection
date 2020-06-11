import-module "$PSScriptRoot\IronSpec-assert.psm1" -force

function Feature {
param(
    [Parameter(Mandatory = $true, Position = 0)] $name,
    $tags=@(),
    [Parameter(Mandatory = $true, Position = 1)]
    [ScriptBlock] $fixture
)
	& $fixture 
}

function Scenario {
param(
    $name,
    [ScriptBlock] $fixture
)
    begin {
        $scenario = @{}
        $scenario.steps = New-Object System.Collections.Queue
    }
    
    process {
        & $fixture
        Save-Scenario $scenario
    }
    
    end {
        . $IronSpecRunScript
        try{
            test
        } catch {
            Write-Host $_.Exception.Message
        }
    }
}

function Scenario_ex {
param(
    $name,
    [ScriptBlock] $fixture
)
    begin {
        $scenario = @{}
        $scenario.steps = New-Object System.Collections.Queue
    }
    
    process {
        & $fixture
    }
    
    end {
        $scenario_text = Scenario-To-Text $scenario
        [ScriptBlock] $test = [scriptblock]::Create($scenario_text)
        
        try{
            & $test
        } catch {
            Write-Host $_.Exception.Message
        }
    }
}

function Step {
param(
    $name, 
    [ScriptBlock] $test = $(Throw "No test script block is provided. (Have you put the open curly brace on the next line?)")
)
    $scenario.steps.Enqueue(@{$name=$test})
}

function Given {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function And {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function When {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function Then {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function Save-Scenario {
param(
    $scenario
)
    $scenario_text = Scenario-To-Text $scenario
    Save-As-File $scenario_text
}

function Scenario-To-Text {
param(
    $scenario
)
    $scenario_text = ""
    foreach($step in $scenario.steps) {
        $step.Keys | % {
            Write-Host -ForegroundColor green $_
            Write-Host -ForegroundColor green $step[$_]
            $scenario_text += $step[$_].ToString()
        }
    }
    
    return $scenario_text
}

function Save-As-File($content) {
@"
function test {
$content
}
"@ | Microsoft.Powershell.Utility\Out-File $IronSpecRunScript
}

export-moduleMember -function `
    Then,
    When,
    And,
    Given,
    Feature,
    Scenario