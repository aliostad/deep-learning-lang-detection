<#

.SYNOPSIS
	Script To Query PowerSchool and Update API Data
.DESCRIPTION
	Query Powerschool Database and then make web requests with each record to hit the PSD enrollment api
.NOTES
	File Name	:	push-enrollmentApi.ps1
	Author		:	Kris Hagel - hagelk@psd401.net
	Date		:	March 26, 2015
    Requires    :   AD Cmdlets, Environment Variables for API Token and Powerschool Connection String
.LINK
	https://github.com/psd401
.EXAMPLE
	.\push-enrollmentApi.ps1
	Launches script and will perform all database, then ad, then api calls

#>

function isNumeric ($x) {
    try {
        0 + $x | Out-Null
        return $true
    } catch {
        return $false
    }
}

$apiToken = [Environment]::GetEnvironmentVariable("PSDApiToken","Machine")
$dbConnString = [Environment]::GetEnvironmentVariable("PSchoolConnString","Machine")

$endpoint = "http://psd-api.apps1.psd401.net/api/v1/enrollments"
$authHeader = "Bearer " + $apiToken
$headers = @{"authorization" = $authHeader}

if ($apiToken) {
    if ($dbConnString) {
        $conn = New-Object System.Data.Odbc.OdbcConnection
        $conn.ConnectionString = $dbConnString
        $conn.open()
        $query = "select cc.ID, LPAD(stu.STUDENT_NUMBER, 7, '0'), sec.SECTION_NUMBER, cou.COURSE_NUMBER, sch.SCHOOL_NUMBER
        from students stu
        join cc on stu.ID = cc.STUDENTID
        join sections sec ON cc.SECTIONID = sec.ID
        join courses cou ON sec.COURSE_NUMBER = cou.COURSE_NUMBER
        join schools sch ON sec.SCHOOLID = sch.SCHOOL_NUMBER
        where 
        sec.TERMID IN 
          (select ID from SCHEDULETERMS term
            where CURRENT_DATE BETWEEN term.FIRSTDAY - 10 and term.LASTDAY + 10 and term.SCHOOLID = sec.SCHOOLID )"
        $cmd = New-Object System.Data.Odbc.OdbcCommand($query,$conn)
        $cmd.CommandTimeout = 30
        $ds = New-Object System.Data.DataSet
        $da = New-Object System.Data.Odbc.OdbcDataAdapter($cmd)
        $dbreturn = $da.fill($ds)
        #$ds.Tables[0] | out-gridview
        $conn.close

        foreach ($Row in $ds.Tables[0].Rows)
        {
            $courseLookupUrl = "http://psd-api.apps1.psd401.net/api/v1/sections?bldg=$($Row[4])&cnum=$($Row[3])&snum=$($Row[2])"
            $courseData = Invoke-RestMethod -Uri $courseLookupUrl -ContentType application/json -Method GET -Headers $headers
            $sectionId = $courseData.section.id

            $json = "{
            `"enrollment`": {
                `"psId`": `"$($Row[0])`",
                `"studentNumber`": `"$($Row[1])`",
                `"sectionId`": $sectionId
            }
            }"

            write-host $json
            Invoke-WebRequest -Uri $endpoint -Body $json -ContentType application/json -Method PUT -Headers $headers
        }
        
        #End API Updates & Begin Checking For Sections To Delete 

        #make initial connection to api endpoint to determine total records and limits
        $initial = Invoke-RestMethod -Uri $endpoint -ContentType application/json -Method GET -Headers $headers
        $records = $initial.meta.total
        $limit = $initial.meta.limit
 
        #loop through all records returned to us by initial api call to make sure we have all sections
        for($i=0; $i -le $records; $i = $i+$limit)
        {
            #generate dynamic url for querying the api, then make the api call
            $url = $endpoint + "?offset=" + $i
            $data = Invoke-RestMethod -Uri $url -ContentType application/json -Method GET -Headers $headers
            
            #loop through the returned records and compare with data set queried from powerschool to determine records to delete
            foreach ($enrollment in $data.enrollment) {
                $enrId = $enrollment.psId
                $search_expression = "ID = $enrId"
                write-host $search_expression
                if ($ds.Tables[0].Select($search_expression) -ne $null){
                    #Record Exists, do nothing
                } else {
                    #Record Doesn't Exist, delete from api
                    $deleteUrl = $endpoint+"/"+$enrollment.id
                    Invoke-RestMethod -Uri $deleteUrl -ContentType application/json -Method DELETE -Headers $headers
                }
            }
        }

    } else {
        write-host "Machine Environment Variable: PSchoolConnString does not exist, please set that and run again.  More info at: http://technet.microsoft.com/en-us/library/ff730964.aspx"
    }
} else {
    write-host "Machine Environment Variable: PSDApiToken does not exist, please set that and run again.  More info at: http://technet.microsoft.com/en-us/library/ff730964.aspx"
}

