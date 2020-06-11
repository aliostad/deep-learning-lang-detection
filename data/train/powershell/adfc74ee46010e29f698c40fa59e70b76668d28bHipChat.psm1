function Send-HipChatNotification
{
<#
.Synopsis
  A simple way to generate HipChat notifications from a Powershell script
  using their REST API.
.Description
  Allows or a sender, message, room id and color.  The room id may be a
  number or string name based on the HipChat API documentation.
.Parameter Message
  The message to send to HipChat.  Line breaks will be turned into HTML
  <br>. Other HTML content such as <a href> may be embedded.
.Parameter From
  The name of the member as it will appear in the room
.Parameter Success
  When success is set to $true, the notify flag will NOT be sent to
  HipChat. The notify flag determines if the room / icon should flash for
  your client. Success also determines the default color to use for the
  message.  Success true will generate a green message, while false will
  generate a red message.
.Parameter RoomId
  The room name or number to send the notification to.  Per the HipChat
  API, either will work.
.Parameter AuthToken
  The HipChat token used to send notifications.  Only a notification
  token is required, and not an administrative token.
.Parameter Color
  This value will override the success determined red or green default.
  Other valid colors are yellow, purple and random.
.Example
  Send-HipChatNotification -Message 'Go go Gadget' -From 'Inspector' `
    -Success $false -RoomId 'Penny' -AuthToken '1234234' -Color 'Purple'

  Description
  -----------
  This will send a message from Inspector to the Penny room given the
  AuthToken.  A success of false would normally generate a red message,
  but that color has been overridden with Purple.
#>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]
    [ValidateNotNull()]
    $Message,

    [Parameter(Mandatory=$true)]
    [string]
    [ValidateNotNull()]
    $From,

    [Parameter(Mandatory=$false)]
    [bool]
    $Success = $true,

    [Parameter(Mandatory=$true)]
    [string]
    [ValidateNotNull()]
    $RoomId,

    [Parameter(Mandatory=$True)]
    [string]
    [ValidateNotNull()]
    $AuthToken,

    [Parameter(Mandatory=$False)]
    [string]
    [AllowNull()]
    [ValidateSet('yellow', 'red', 'green', 'purple', 'random')]
    $Color
  )

  $data = New-Object Collections.Specialized.NameValueCollection
  $data.Add("room_id", $RoomId)
  $data.Add("from", $From)
  $data.Add("message", ($Message -replace "`n", '<br>'))
  $actionColor = if ($Success) { "green" } else { "red" }

  if ([String]::IsNullOrEmpty($Color)) { $Color = $actionColor }
  $data.Add("color", $Color)
  $notify = if ($Success) { "0" } else { "1" }
  $data.Add("notify", $notify)

  [Void](New-Object Net.WebClient).UploadValues(
    "https://api.hipchat.com/v1/rooms/message?auth_token=$AuthToken",
    $data)
}

Export-ModuleMember -Function Send-HipChatNotification