

#riddler ps module needs to be loaded before executing this

function Show-RiddlerPSHelp{
    [cmdletbinding()]
    param()
    process{

        $prompts = @(
                New-PromptObject `
                -promptType PickOne `
                -text "`r`nHi, I am the Riddler. How can I help?" `
                    -options ([ordered]@{
                    'what-is'='What is RiddlerPS?'
                    'show-ex'='Show me how to use RidderPS'
                    'show-docs'='Take me to the docs!'
                    'report-issue'='Report an issue'; 'quit'='Quit'})            
        )
        
        $continueLoop = $true
        while($continueLoop){
            $promptResult = Invoke-Prompts $prompts 
            # execute the result
            switch ($promptResult['userprompt']){
                'what-is' {what-is}
                'show-ex' {show-examples}
                'show-docs' { start 'https://github.com/sayedihashimi/riddlerps' }
                'report-issue' { start 'https://github.com/sayedihashimi/riddlerps/issues' }            
                'quit' { 'Goodbye'; $continueLoop = $false  }
                default{ throw  ('Unknown choice: [{0}]' -f  $selectedOption) }
            }
        }        
    }
}

function what-is{
    [cmdletbinding()]
    param()
    process{
        'RiddlerPS is a PowerShell module that simplifies user interaction in PowerShell.' | Write-Example
    }
}

function show-examples{
    [cmdletbinding()]
    param()
    process{
        $prompts = @(
            New-PromptObject -text "`r`nWhat kind of example are you looking for?" `
                -promptType PickOne `
                -options ([ordered]@{
                    'question'='How can I ask the user a question?'
                    'pickone'='How can I show a list where one value can be selected?'
                    'pickmany'='How can I show a list where more than one value can be selected'
                    'multiquestions'='How can I ask more than one question?'
                    'customprompt'='How to handle custom actions'
                    'goback'='Go back'
                    'quit'='Quit'
                }))

        $continueLoop = $true
        while($continueLoop){
            $promptResult = Invoke-Prompts $prompts

            switch($promptResult['userprompt']){
                'question' { Show-Question }
                'pickone' {Show-PickOne}
                'pickmany' {Show-PickMany}
                'multiquestions' { Show-MultiQuestions  }
                'customprompt' {Show-CustomPromptAction}
                'goback' { $continueLoop = $false}
                'quit' { exit }
            }
        }
    }
}

function Write-Example{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $message
    )
    process{
        '----------------------------------------------------' | Write-Host -ForegroundColor Green
        $message | Write-Host
        '----------------------------------------------------' | Write-Host -ForegroundColor Green
    }
}

function Show-Question{
    [cmdletbinding()]
    param()
    process{
        $str = @'
        $prompt = New-PromptObject -text 'What is your name?'

        $promptResult = Invoke-Prompts $prompt
'@
        
        'Asking the user a question is simple. Here is how you do it.' | Write-Host
        $str | Write-Example

        Invoke-Expression $str
        "Your reply: '{0}'`r`n" -f $promptResult['userprompt'] | Write-Host
    }
}

function Show-PickOne{
    [cmdletbinding()]
    param()
    process{
        'To show a list of options where the user can select one value you will use the
PickOne method. Let''s try it' | Write-Host
        $str = @'
        $prompt = New-PromptObject -name 'action' -text 'What type of project do you want to create?' `
                    -promptType PickOne `
                    -options ([ordered]@{
                                'mvc'='ASP.NET MVC'
                                'webforms'='ASP.NET Web Forms'
                                'webapi'='ASP.NET Web API'
                                'goback'='Go back'
                                'quit' = 'Quit'
                            })

        $promptResult = Invoke-Prompts $prompt
'@
        $str | Write-Example

        Invoke-Expression $str

       "Your reply: '{0}'`r`n" -f $promptResult['action'] | Write-Host
    }
}

function Show-PickMany{
    [cmdletbinding()]
    param()
    process{
        'To show a list of options where the user can select more than one value 
you will use the PickMany method. With PickMany the result may have multiple results.
The respons will be returned as a hashtable with all selected values
set to true. All other values will be omitted from the result.' | Write-Host
        $str = @'
        $prompt = New-PromptObject -name 'action' `
            -text 'Pick the frameworks you would like to include in your poject?' `
            -promptType PickMany `
            -options ([ordered]@{
                'Type'='PickMany'
                'mvc'='ASP.NET MVC'
                'webforms'='ASP.NET Web Forms'
                'webapi'='ASP.NET Web API'
            })


        $promptResult = Invoke-Prompts $prompt
'@
        $str | Write-Example

        Invoke-Expression $str
        
       "Your reply:" -f $promptResult | Write-Host
       $promptResult
       "`r`n" | Write-Host
    }
}

function Show-MultiQuestions{
    [cmdletbinding()]
    param()
    process{

    'When asking more than one question you can supply a list of prompts.
I will take care of prompting the user and returning all values back to you
in a hashtable. Selected values will be incldued. Let''s see this in action.' | Write-Host

    $prompts = @(
        (New-PromptObject -name 'projname' -text 'Project name' -defaultValue 'webapp'),

        (New-PromptObject -name 'projtype' 'Project type?' -promptType PickOne `
            -options ([ordered]@{'Empty'='Empty';'WebForms'='WebForms';'MVC'='MVC';'Web API'='Web API';'SPA'='SPA';'Facebook'='Facebook'})),

        (New-PromptObject -name 'fxlist' -text 'Select Frameworks' `
            -promptType PickMany `
            -options ([ordered]@{
                'addmvc' = 'Add mvc'
                'addwebapi' = 'Add Web API'
                'addwebforms' = 'Add Web Forms'
            })))

    $str =
@'
        $prompts = @(
        (New-PromptObject -name 'projname' -text 'Project name' -defaultValue 'webapp'),

        (New-PromptObject -name 'projtype' 'Project type?' -promptType PickOne `
            -options ([ordered]@{'Empty'='Empty';'WebForms'='WebForms';'MVC'='MVC';'Web API'='Web API';'SPA'='SPA';'Facebook'='Facebook'})),

        (New-PromptObject -name 'fxlist' -text 'Select Frameworks' `
            -promptType PickMany `
            -options ([ordered]@{
                'addmvc' = 'Add mvc'
                'addwebapi' = 'Add Web API'
                'addwebforms' = 'Add Web Forms'
            })))

        $promptResult = Invoke-Prompts $prompts

'@
        $str | Write-Example
        Invoke-Expression $str
        "Your reply:" -f $promptResult | Write-Host
           $promptResult
           "`r`n" | Write-Host
    }
}

function Show-CustomPromptAction{
    [cmdletbinding()]
    param()
    process{
        'In some cases you will need more control when the user is prompted for a value. For example
if you prompt the user for a yes/no value you may need to convert that to a boolean value. For these cases
you can use a PromptAction. When a PromptAction is proved I will take care of prompting the user, and then
the PromptAction is invoked. You can use the Get-TextFromUser function to read keys. Here is an example.' | Write-Host
        
        $str = 
@'
        $prompts = New-PromptObject -name 'unittest' -text 'Do you want to add a unit test project?' `
            -defaultValue $false `
            -promptAction {
                # here we receive the input and then convert it to a boolean
                ConvertTo-Bool(Get-TextFromUser)
            }

        $promptResult = Invoke-Prompts $prompts
'@
        $str | Write-Example
        Invoke-Expression $str
        "Your reply {0}`r`n" -f $promptResult['unittest'] | Write-Host
    }
}

Show-RiddlerPSHelp


