$ShowCharts = $true
.\IterationTrendReport.ps1 -Product Jasper      -Team "System 1" -Closedown "Final Function"     -Group "AppV-PublishingSupport" -Iteration "FF Iteration"  -IgnoreInactiveTCs -ShowChart $ShowCharts -CsvFile C:\projects\CPTSgraphing\JasperAppV1.csv     -CsvFinalFile C:\projects\CPTSgraphing\JasperAppV1Final.csv      -PngFile C:\projects\CPTSgraphing\JasperAppV1.png
.\IterationTrendReport.ps1 -Product PVD-Jasper  -Team "System 1" -Closedown "Excalibur Release"  -Group "Personalization-PVD"    -Iteration "Iteration 1"   -IgnoreInactiveTCs -ShowChart $ShowCharts -CsvFile C:\projects\CPTSgraphing\JasperPVD1.csv      -CsvFinalFile C:\projects\CPTSgraphing\JasperPVD1Final.csv      -PngFile C:\projects\CPTSgraphing\JasperPVD1.png
.\IterationTrendReport.ps1 -Product UPM-Jasper  -Team "System 1" -Closedown "Final"              -Group "UPM"                    -Iteration "Iteration RTM" -IgnoreInactiveTCs -ShowChart $ShowCharts -CsvFile C:\projects\CPTSgraphing\JasperUPM.csv       -CsvFinalFile C:\projects\CPTSgraphing\JasperUPMFinal.csv       -PngFile C:\projects\CPTSgraphing\JasperUPM.png


