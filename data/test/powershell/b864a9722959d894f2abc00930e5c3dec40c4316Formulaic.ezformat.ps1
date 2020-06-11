$moduleRoot = "$home\documents\windowspowershell\modules\Formulaic"
# Get-Module Pipeworks | Split-Path
$formatViews = @()

$formatViews +=  
    Write-FormatView -TypeName formulaic.flashcard -Action {
        $flashcard = $_

        $nextUrl = "$($fullUrl)"
        if ($nextUrl -like "*Get-Flashcard_GradeLevel=*") {
            $nextUrl = $nextUrl.Substring(0, $nextUrl.IndexOf("Get-Flashcard_GradeLevel=") - 1)
            
        } 
        if ($nextUrl.contains("?")) {
            $nextUrl+="&Get-Flashcard_GradeLevel=$($flashcard.Gradelevel)"
        } else {
            $nextUrl+="?Get-Flashcard_GradeLevel=$($flashcard.Gradelevel)"
        }

        "
        <script>
            function checkAnswer() {
                answerField = document.getElementById('flashCardAnswer');
                if (answerField.value == '$($flashcard.Answer)') { showCorrect(); } else { showIncorrect(); } 
            }

            function showCorrect() {
                document.getElementById('isCorrect').style.display = 'inline';
                document.getElementById('isWrong').style.display = 'none';

                setTimeout('nextQuestion();', 2500);
            }

            function showIncorrect() {
                document.getElementById('isCorrect').style.display = 'none';
                document.getElementById('isWrong').style.display = 'inline';
            }

            function nextQuestion() {
                window.location = '$($nextUrl)'
            }
        </script>
        <h1 style='font-size:5em'>$($flashcard.Question -replace "__", "<input type='text' name='answer' id='flashCardAnswer' style='font-size:1em;max-width:250px'></input>" )</h1>
        

        <h1 style='font-size:3em;style;text-align:center'>
            <input type='submit' name='Answer' value='Answer' onclick=`"checkAnswer();`" style='font-size:1em'></input>

            <input type='submit' name='Answer' value='Skip' onclick=`"nextQuestion();`" style='font-size:1em'></input>
        </h1>
        <h2 style='display:none;text-align:center;color:#015624;font-size:3em' id='isCorrect'>
            Right!
        </h2>
        <h2 style='display:none;text-align:center;color:#fa0000;font-size:3em' id='isWrong'>
            Wrong!
        </h2>
        
        
        
        
        
        
        "
    }



$formatPath  = Join-Path $moduleRoot "Formulaic.Format.ps1xml"
$formatViews | 
    Out-FormatData |
    Set-Content $formatPath   
