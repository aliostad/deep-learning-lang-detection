function ReadDnsMessage {
  # .SYNOPSIS
  #   Reads a DNS message from a byte stream.
  # .DESCRIPTION
  #   Internal use only.
  #
  #                                    1  1  1  1  1  1
  #      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
  #    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
  #    /                    HEADER                     /
  #    /                                               /
  #    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
  #    /                   QUESTION                    /
  #    /                                               /
  #    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
  #    /                    ANSWER                     /
  #    /                                               /
  #    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
  #    /                   AUTHORITY                   /
  #    /                                               /
  #    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
  #    /                  ADDITIONAL                   /
  #    /                                               /
  #    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
  #
  # .PARAMETER Message
  #   A binary reader created by using New-BinaryReader containing a byte array representing a DNS message.
  #
  #   If a binary reader is not passed as an argument an empty DNS message is returned.
  # .INPUTS
  #   Indented.Sockets.SocketResponse
  #
  #   Response data is generated using Receive-Bytes.
  # .OUTPUTS
  #   Indented.DnsResolver.Message  
  # .NOTES
  #   Author: Chris Dent
  #   Team:   Core Technologies
  #
  #   Change log:
  #     14/01/2015 - Chris Dent - Refactored to fit in Indented.DnsResolver.

  [CmdLetBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateScript( { $_.PsObject.TypeNames -contains 'Indented.Sockets.SocketResponse' } )]
    $Message
  )

  $BinaryReader = New-BinaryReader -ByteArray $Message.Data

  $DnsMessage = NewDnsMessage
  $DnsMessage.Question = @()
  $DnsMessage.Size = $Message.Data.Length
  $DnsMessage.Server = $Message.RemoteEndPoint.Address

  $DnsMessage.Header = ReadDnsMessageHeader $BinaryReader

  for ($i = 0; $i -lt $DnsMessage.Header.QDCount; $i++) {
    $DnsMessage.Question += ReadDnsMessageQuestion $BinaryReader
  }
  for ($i = 0; $i -lt $DnsMessage.Header.ANCount; $i++) {
    $DnsMessage.Answer += ReadDnsResourceRecord $BinaryReader
  }
  for ($i = 0; $i -lt $DnsMessage.Header.NSCount; $i++) {
    $DnsMessage.Authority += ReadDnsResourceRecord $BinaryReader
  }
  for ($i = 0; $i -lt $DnsMessage.Header.ARCount; $i++) {
    $DnsMessage.Additional += ReadDnsResourceRecord $BinaryReader
  }

  return $DnsMessage
}
