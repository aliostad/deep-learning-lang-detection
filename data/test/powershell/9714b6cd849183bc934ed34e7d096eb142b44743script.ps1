This file was edited

$API = Invoke-RestMethod -Uri "https://jira.corp.mulesoft.com/rest/api/2/search?os_username=apiuser&os_password=Mulesoft123123&jql=project%20%3D%20MLC%20AND%20status%20%3D%20PENDING%20AND%20%22Start%20Date%22%20%3C%207d"

$table = New-Object system.Data.DataTable “$tabName”
#Define Columns
$col1 = New-Object system.Data.DataColumn key,([string])
$col2 = New-Object system.Data.DataColumn firstname,([string])
$col3 = New-Object system.Data.DataColumn lastname,([string])
$col4 = New-Object system.Data.DataColumn username,([string])
$col5 = New-Object system.Data.DataColumn mail,([string])
$col6 = New-Object system.Data.DataColumn title,([string])
$col7 = New-Object system.Data.DataColumn department,([string])
$col8 = New-Object system.Data.DataColumn location,([string])
$col9 = New-Object system.Data.DataColumn personalphone,([string])
$col10 = New-Object system.Data.DataColumn personalmail,([string])
$col11 = New-Object system.Data.DataColumn manager,([string])
$col12 = New-Object system.Data.DataColumn startdate,([string])
$col13 = New-Object system.Data.DataColumn assignee,([string])
$col14 = New-Object system.Data.DataColumn standingdesk,([string])
$col15 = New-Object system.Data.DataColumn lock,([string])
$col16 = New-Object system.Data.DataColumn seating,([string])

#Add the Columns
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$table.columns.add($col5)
$table.columns.add($col6)
$table.columns.add($col7)
$table.columns.add($col8)
$table.columns.add($col9)
$table.columns.add($col10)
$table.columns.add($col11)
$table.columns.add($col12)
$table.columns.add($col13)
$table.columns.add($col14)
$table.columns.add($col15)
$table.columns.add($col16)


$test =  $api.issues.key | Measure-Object | Select-Object -Property count -ExpandProperty count

for ($i=0; $i –le $test; $i++)
{
$row = $table.NewRow()
$row.key = $api.issues.key[$i]
$row.firstname = $api.issues.fields.customfield_10002[$i]
$row.lastname = $api.issues.fields.customfield_10110[$i]
$row.username = $api.issues.fields.customfield_10003[$i]
$row.mail = $api.issues.fields.customfield_10108[$i]
$row.title = $api.issues.fields.customfield_10100[$i]
$row.department = $api.issues.fields.customfield_10101.value[$i]
$row.location = $api.issues.fields.customfield_10104.value[$i]
$row.personalphone = $api.issues.fields.customfield_10205[$i]
$row.personalmail = $api.issues.fields.customfield_10112[$i]
$row.manager = $API.issues.fields.customfield_10103.name[$i]
$row.startdate = $api.issues.fields.customfield_10004[$i]
$row.assignee = $api.issues.fields.assignee.name[$i]
$row.standingdesk = $api.issues.fields.customfield_10202.value[$i]
$row.lock = $api.issues.fields.customfield_10200.value[$i]
$row.seating = $API.issues.fields.customfield_10204.name[$i]


$table.Rows.Add($row)
}

$table | Export-Csv -path "C:\scripts\inprogress\Onboard\Data.csv" -NoTypeInformation
