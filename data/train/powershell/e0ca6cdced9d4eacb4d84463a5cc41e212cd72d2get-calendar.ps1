[void][System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")

$form = new-object Windows.Forms.Form 
$form.text = "Calendar" 
$form.Size = new-object Drawing.Size @(656,639) 

# Make "Hidden" SelectButton to handle Enter Key

$btnSelect = new-object System.Windows.Forms.Button
$btnSelect.Size = "1,1"
$btnSelect.add_Click({ 
	$form.close() 
}) 
$form.Controls.Add($btnSelect ) 
$form.AcceptButton =  $btnSelect

# Add Calendar 

$cal = new-object System.Windows.Forms.MonthCalendar 
$cal.ShowWeekNumbers = $true 
$cal.MaxSelectionCount = 356
$cal.Dock = 'Fill' 
$form.Controls.Add($cal) 

# Show Form

$Form.Add_Shown({$form.Activate()})  
[void]$form.showdialog() 

# Return Start and end date 

return $cal.SelectionRange
