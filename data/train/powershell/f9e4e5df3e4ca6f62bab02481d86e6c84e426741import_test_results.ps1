if (Test-Path "$($env:APPVEYOR_BUILD_FOLDER)\*.junit.xml") {
  [xml]$testResults = Get-Content "$($env:APPVEYOR_BUILD_FOLDER)\*.junit.xml"

  foreach ($testCase in $testResults.testsuites.testsuite.testcase) {
    echo $testCase.classname
    echo $testCase.name
    $status = "Passed"
    if ($testCase.failure) {
      echo $testCase.failure.message
      $status = "Failed"
    }
    Add-AppveyorTest -Name "$($testCase.classname).$($testCase.name)" -Framework "tSQLt" -Outcome $status -ErrorMessage $testCase.failure.message
  }
}
