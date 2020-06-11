function Invoke-ShoutCloud
{
    PARAM(
        [PARAMETER(MANDATORY=$TRUE,VALUEFROMPIPELINE=$TRUE)]
        [STRING]$MESSAGE
    )

    BEGIN
    {
        $HEADERS = @{'Content-Type'='application/json'}
        $SERVICEURL = "HTTP://API.SHOUTCLOUD.IO/V1/SHOUT"
    }

    PROCESS
    {
        $BODY = @{ "INPUT" = $MESSAGE } | CONVERTTO-JSON
        
        WRITE-DEBUG $SERVICEURL
        WRITE-DEBUG $BODY

        $RESPONSE = INVOKE-WEBREQUEST $SERVICEURL -HEADERS $HEADERS -BODY $BODY -METHOD POST
        $JSON = CONVERTFROM-JSON $RESPONSE

        RETURN ($JSON.OUTPUT)
    }
}
