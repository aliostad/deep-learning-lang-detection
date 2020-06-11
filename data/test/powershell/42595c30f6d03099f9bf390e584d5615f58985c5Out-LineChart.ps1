Function Out-LineChart {
    <#
        .EXAMPLE

            import-csv .\TrendReporting\REST.csv|
            out-linechart  -XAxis Date -YAxis1 TotalUsedGB -YAxis2 CapacityGB  -Title 'Restricted Report' -YAxisTitle SizeGB
    #>
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [Object]$InputObject,
        [parameter(Mandatory=$True)]
        [string]$XAxis,
        [parameter(Mandatory=$True)]
        [string]$YAxis1,
        [parameter()]
        [string]$YAxis2,
        [parameter()]
        [string]$Title,
        [parameter()]
        [string]$YAxisTitle,
        [parameter()]
        [string]$YAxis1Color = 'Red',
        [parameter()]
        $YAxis2Color = 'Blue',
        [parameter()]
        [int]$XAxisInterval = 16,
        [parameter()]
        [string]$XAxisLabelFormat,
        [parameter()]
        [ValidateSet("Auto", "Number", "Years", "Months", "Weeks", "Days", "Hours", "Minutes", "Seconds", "Milliseconds", "NotSet")]
        [string]$XAxisIntervalType = "Days",
        [parameter()]
        [ValidateSet({
            $UsedExt = $_ -replace '.*\.(.*)','$1'
            $Extensions = "Jpeg", "Png", "Bmp", "Tiff", "Gif", "Emf", "EmfDual", "EmfPlus"
            If ($Extensions -contains $UsedExt) {
                $True
            } Else {
                Throw "The extension '$UsedExt' is not valid! Valid extensions are $($Extensions -join ', ')."
            }
        })]
        [string]$ToFile
    )
    Begin {
        #region Helper Functions
        Function ConvertTo-HashTable {
            [cmdletbinding()]
            Param (
                [parameter(ValueFromPipeline=$True)]
                [object]$Object,
                [string[]]$Key
            )
            Begin {
                $HashTable = @{}
            }
            Process {
                ForEach ($Item in $Object) {
                    ForEach ($HKey in $Key) {
                        $HashTable[$Hkey]+=,$Item.$HKey
                    }
                }
            }
            End {
                $HashTable
            }
        } 
        Function Invoke-SaveDialog {
            $FileTypes = [enum]::GetNames('System.Windows.Forms.DataVisualization.Charting.ChartImageFormat')| ForEach {
                $_.Insert(0,'*.')
            }
            $SaveFileDlg = New-Object System.Windows.Forms.SaveFileDialog
            $SaveFileDlg.DefaultExt='PNG'
            $SaveFileDlg.Filter="Image Files ($($FileTypes))|$($FileTypes)|All Files (*.*)|*.*"
            $return = $SaveFileDlg.ShowDialog()
            If ($Return -eq 'OK') {
                [pscustomobject]@{
                    FileName = $SaveFileDlg.FileName
                    Extension = $SaveFileDlg.FileName -replace '.*\.(.*)','$1'
                }
        
            }
        }
        Function Get-ValueType {
            Param ($Object)
            Switch ($Object) {
                {$Object -as [decimal[]]} {
                    [decimal[]]
                    BREAK
                }
                {$Object -as [datetime[]]} {
                    [datetime[]]
                    BREAK
                }
                {$Object -as [string[]]} {
                    [string[]]
                    BREAK
                }
            }
        }                       
        #endregion Helper Functions
        
        #region Data Processing
        If ($PSBoundParameters.ContainsKey('InputObject')) {
            Write-Verbose "[BEGIN]InputObject bound to parameter name" 
            $ToProcess = $InputObject
        } Else {
            $IsPipeline = $True
            $ToProcess = New-Object System.Collections.ArrayList
            Write-Verbose "[BEGIN]InputObject coming from Pipeline"
        }
        #endregion Data Processing

        #region MSChart Build
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Windows.Forms.DataVisualization
        $Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
        $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
        $Chart.ChartAreas.Add($ChartArea)
        #endregion MSChart Build

        #region MSChart Configuration
        $Chart.Width = 750 
        $Chart.Height = 400 
        $Chart.Left = 40 
        $Chart.Top = 30
        $Chart.BackColor = [System.Drawing.Color]::Transparent

        $ChartTitle = New-Object System.Windows.Forms.DataVisualization.Charting.Title
        $ChartTitle.Text = $Title
        $Font = New-Object System.Drawing.Font @('Microsoft Sans Serif','12', [System.Drawing.FontStyle]::Bold)
        $ChartTitle.Font =$Font
        $Chart.Titles.Add($ChartTitle)

        $Chart.ChartAreas.axisy.Title = $YAxisTitle
        $Chart.ChartAreas.axisy.TitleFont = New-Object System.Drawing.Font @('Microsoft Sans Serif','12', [System.Drawing.FontStyle]::Bold)

        $Chart.ChartAreas.axisx.MajorGrid.Enabled=$False
        $Chart.ChartAreas.axisx.MinorTickMark.Enabled=$True
        $Chart.ChartAreas.axisx.MajorTickMark.Enabled=$False

        #endregion MSChart Configuration

        #region Create Legend
        $Legend = New-Object System.Windows.Forms.DataVisualization.Charting.Legend
        $Chart.Legends.Add($Legend)
        #endregion Create Legend
    }
    Process {
        #region Pipeline Data Processing
        If ($IsPipeline) {
            Write-Verbose "[PROCESS]Collecting Pipeline InputObject"
            [void]$ToProcess.Add($InputObject)
        } 
        #endregion Pipeline Data Processing
    }
    End {
        Write-Verbose "[END]Processing InputObject"
        $HashTable = $ToProcess | ConvertTo-HashTable -Key $XAxis,$YAxis1,$YAxis2
        If ($PSBoundParameters.ContainsKey('XAxis')) {
            #Determine Type for conversion of XAxis
            $XType = Get-ValueType -Object $HashTable[$XAxis]
            Write-Verbose "XAxis type is $($Type.fullname)"
            $XAxisData = ($HashTable[$XAxis] -as $XType)

            $Chart.ChartAreas.axisx.LabelStyle.Format = $XAxisLabelFormat
            $Chart.ChartAreas.axisx.LabelStyle.Angle = -45            
            If ($XType.fullname -match 'datetime') {  
                Write-Verbose "DATETIME"              
                $Chart.ChartAreas.axisx.LabelStyle.IntervalOffsetType = [System.Windows.Forms.DataVisualization.Charting.DateTimeIntervalType]::$XAxisIntervalType
                $Chart.ChartAreas.axisx.LabelStyle.IntervalType = [System.Windows.Forms.DataVisualization.Charting.DateTimeIntervalType]::$XAxisIntervalType
            } Else {
                $Measured = $HashTable[$XAxis] | Measure-Object -Minimum -Maximum
                $Chart.ChartAreas.axisx.Maximum = $Measured.Maximum
                $Chart.ChartAreas.axisx.Minimum = $Measured.Minimum            
            }
            $Chart.ChartAreas.axisx.LabelStyle.Interval = $XAxisInterval
        }
        If ($PSBoundParameters.ContainsKey('YAxis1')) {
            [void]$Chart.Series.Add($YAxis1) 

            #Determine Type for conversion of YAxis
            $Y1Type = Get-ValueType -Object $HashTable[$YAxis1]
            Write-Verbose "XAxis type is $($Type.fullname)"
            $Y1AxisData = ($HashTable[$YAxis1] -as $Y1Type)

            $Chart.Series[$YAxis1].Points.DataBindXY($XAxisData, $Y1AxisData)
            $Chart.Series[$YAxis1].BorderWidth = 2
            $Chart.Series[$YAxis1].Color = $YAxis1Color
            $Chart.Series[$YAxis1].ChartType = 'Line'
        }
        If ($PSBoundParameters.ContainsKey('YAxis2')) {
            [void]$Chart.Series.Add($YAxis2) 

            #Determine Type for conversion of YAxis
            $Y2Type = Get-ValueType -Object $HashTable[$YAxis2]
            Write-Verbose "XAxis type is $($Type.fullname)"
            $Y2AxisData = ($HashTable[$YAxis2] -as $Y2Type)

            $Chart.Series[$YAxis2].Points.DataBindXY($XAxisData, $Y2AxisData)
            $Chart.Series[$YAxis2].BorderWidth = 2
            $Chart.Series[$YAxis2].Color = $YAxis2Color
            $Chart.Series[$YAxis2].ChartType = 'Line'
        }
        If ($PSBoundParameters.ContainsKey('ToFile')) {
            $Extension = $ToFile -replace '.*\.(.*)','$1'
            $Chart.SaveImage($ToFile, $Extension)
        } Else {
            #region Windows Form to Display Chart
            $AnchorAll = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor 
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
            $Form = New-Object Windows.Forms.Form  
            $Form.Width = 800 
            $Form.Height = 550 
            $Form.controls.add($Chart) 
            $Chart.Anchor = $AnchorAll

            # add a save button 
            $SaveButton = New-Object Windows.Forms.Button 
            $SaveButton.Text = "Save" 
            $SaveButton.Top = 450 
            $SaveButton.Left = 600 
            $SaveButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
            # [enum]::GetNames('System.Windows.Forms.DataVisualization.Charting.ChartImageFormat') 
            $SaveButton.add_click({
                $Result = Invoke-SaveDialog
                If ($Result) {
                    $Chart.SaveImage($Result.FileName, $Result.Extension)
                }
            }) 

            $Form.controls.add($SaveButton)
            $Form.Add_Shown({$Form.Activate()}) 
            [void]$Form.ShowDialog()
            #endregion Windows Form to Display Chart         
        }
    }
}