function Send-AMQMessage {
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,
		
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
		$InputObject,
		
		[Parameter(Mandatory=$true)]
		[string]$DestinationName,
		
		[ValidateSet("Queue","Topic")]
		[string]$DestinationType = "Queue",
		
		$Port = 61616,
		
		[Apache.NMS.MsgDeliveryMode]$DeliveryMode = [Apache.NMS.MsgDeliveryMode]::NonPersistent,
		
		[System.Collections.Hashtable]$Properties,
		
		[Int32]$Depth = 2
	)
	begin {
		$Uri = [Uri]("activemq:tcp://{0}:{1}" -f $ComputerName, $Port)
		$Factory = New-Object Apache.NMS.NMSConnectionFactory($Uri)
		
		$Connection = $Factory.CreateConnection()
		$Session = $Connection.CreateSession()
		
		if($DestinationType -eq "Queue") {
			$Destination = $Session.GetQueue($DestinationName)
		} else {
			$Destination = $Session.GetTopic($DestinationName)
		}
		$Producer = $Session.CreateProducer($Destination);
		$Producer.DeliveryMode = $DeliveryMode
		$Connection.Start()
	}
	process {
		if($InputObject -is [String]) {
			$Text = $InputObject
			$MimeType = "text/plain"
		} else {
			$Text = [System.Management.Automation.PSSerializer]::Serialize($InputObject, $Depth)
			$MimeType = "application/clixml+xml"
		}
		$Message = $Session.CreateTextMessage($Text)
		$Message.Properties["Content-Type"] = $MimeType
		if($Properties) {
			$Properties.Keys | %{
				$Message.Properties[$_] = $Properties[$_]
			}
		}
		$Producer.Send($Message)
	}
	end {
		$Connection.Stop()
		$Producer.Dispose()
		$Session.Dispose()
		$Connection.Dispose()
	}
}

function Receive-AMQMessage {
	[CmdletBinding(DefaultParameterSetName="WithTimeout")]
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,
		
		[Parameter(Mandatory=$true)]
		[string]$DestinationName,
		
		[ValidateSet("Queue","Topic")]
		[string]$DestinationType = "Queue",
		
		$Port = 61616,
		
		[Parameter(ParameterSetName="WithTimeout")]
		[TimeSpan]$Timeout,
		
		[Parameter(ParameterSetName="NoWait")]
		[switch]$NoWait,
		
		[switch]$Raw
	)
	$Uri = [Uri]("activemq:tcp://{0}:{1}" -f $ComputerName, $Port)
	$Factory = New-Object Apache.NMS.NMSConnectionFactory($Uri)
	
	$Connection = $Factory.CreateConnection()
	$Session = $Connection.CreateSession()
	if($DestinationType -eq "Queue") {
		$Destination = $Session.GetQueue($DestinationName)
	} else {
		$Destination = $Session.GetTopic($DestinationName)
	}
	$Consumer = $Session.CreateConsumer($Destination);
	$Connection.Start()
	try {
		if($PsCmdlet.ParameterSetName -eq "WithTimeout") {
			$OneSecond = New-TimeSpan -Seconds 1
			while(!$Message -and (!$Timeout -or $Timeout -gt 0)) {
				if($Timeout) {
					$Timeout = $Timeout.Subtract($OneSecond)
				}
				$Message = $Consumer.Receive($OneSecond)
			}
		} else {
			$Message = $Consumer.ReceiveNoWait()
		}
		if($Message) {
			if(!$Raw) {
				if($Message.Properties["Content-Type"] -eq "application/clixml+xml") {
					[System.Management.Automation.PSSerializer]::Deserialize($Message.Text)
				} else {
					$Message.Text
				}
			} else {
				$Message
			}
		}
	} finally {
		$Consumer.DeliverAcks()
		$Consumer.Close()
		$Consumer.Dispose()
		$Connection.Stop()
		$Session.Dispose()
		$Connection.Dispose()
	}
}

function Wait-AMQMessage {
	[CmdletBinding(DefaultParameterSetName="WithTimeout")]
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,
		
		[Parameter(Mandatory=$true)]
		[string]$DestinationName,
		
		[ValidateSet("Queue","Topic")]
		[string]$DestinationType = "Queue",
		
		$Port = 61616,
		
		[switch]$Raw
	)

	$Uri = [Uri]("activemq:tcp://{0}:{1}" -f $ComputerName, $Port)
	$Factory = New-Object Apache.NMS.NMSConnectionFactory($Uri)
	
	$Connection = $Factory.CreateConnection()
	$Session = $Connection.CreateSession()
	if($DestinationType -eq "Queue") {
		$Destination = $Session.GetQueue($DestinationName)
	} else {
		$Destination = $Session.GetTopic($DestinationName)
	}
	$Consumer = $Session.CreateConsumer($Destination);
	$Connection.Start()
	
	try {
		$OneSecond = New-TimeSpan -Seconds 1
		while($True) {
			$Message = $Consumer.Receive($OneSecond)
			if($Message) {
				if(!$Raw) {
					if($Message.Properties["Content-Type"] -eq "application/clixml+xml") {
						[System.Management.Automation.PSSerializer]::Deserialize($Message.Text)
					} else {
						$Message.Text
					}
				} else {
					$Message
				}
			}
		}
	} finally {
		$Consumer.DeliverAcks()
		$Consumer.Close()
		$Consumer.Dispose()
		$Connection.Stop()
		$Session.Dispose()
		$Connection.Dispose()
	}
}