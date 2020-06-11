function New-Obmen1CMessage
{
    $msg = [xml]'<?xml version="1.0" encoding="UTF-8"?>
    <message>
    	<id></id>
    	<body></body>
    </message>'
    $msg.message.id = (Get-Date).Ticks.ToString()
    $msg
}
function Add-Obmen1CMessageSender ($xmlmsg, $sender)
{
    if ($xmlmsg.SelectNodes('//message/sender[text()]').Count -eq 0)
    {
        $null = $xmlmsg.message.AppendChild($xmlmsg.CreateElement("sender"))
        $xmlmsg.message.sender = $sender
        $true
    }
    else {$false}
}
function Add-Obmen1CMessageRecipient ($xmlmsg, $recipient)
{
    if ($xmlmsg.SelectNodes("//message[recipient='$recipient']").Count -eq 0)
    {
        $xmlelem = $xmlmsg.CreateElement("recipient")
        $xmlelem.InnerText = $recipient
        $null = $xmlmsg.message.AppendChild($xmlelem)
        $true
    }
    else {$false}
}
function Remove-Obmen1CMessageRecipient ($xmlmsg, $recipient)
{
    $xmlelem=$xmlmsg.SelectSingleNode("//message/recipient[.='$recipient']")
    if ($xmlelem -ne $null)
    {
        $null = $xmlelem.parentNode.removeChild($xmlelem); 
    }
}
function Remove-Obmen1CMessageAllRecipients ($xmlmsg)
{
    $xmlmsg.SelectNodes("//message/recipient") | %{
        $null = $_.parentNode.removeChild($_)
    }
}
function Add-Obmen1CMessageBodyContent ($xmlmsg, $name, $value)
{
    if ($xmlmsg.SelectNodes("//message[$name='$value']").Count -eq 0)
    {
        $xmlelem = $xmlmsg.CreateElement("$name")
        $xmlelem.InnerText = $value
        $null = $xmlmsg.SelectSingleNode("//message/body").AppendChild($xmlelem)
        $true
    }
    else {$false}
}
function Send-Obmen1CMessage ($xmlmsg)
{
    if (Test-MSMQueue "Obmen1C.CommCenter")
    {
        Send-MSMQMessage (Get-MSMQueue "Obmen1C.CommCenter") $xmlmsg.outerXml.ToBase64String
        $true
    }
    else {$false}
}