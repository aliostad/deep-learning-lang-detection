#requires -version 4.0
param(
	[string]$config = "Mariasek.Console.exe.config",
	[string]$outputDir = "ConfigFiles"
)

#Include common functions
. .\Mariasek.Common.ps1

function AmendConfigForPlayer
{
	param(
		[xml]$xml,
		[string]$playerId,
		[PSObject]$player
	)
	$xml.selectSingleNode("/configuration/players/$playerId/@name").set_innerXml($player.name)
	$xml.selectSingleNode("/configuration/players/$playerId/@type").set_innerXml($player.type)
	$xml.selectSingleNode("/configuration/players/$playerId/@assembly").set_innerXml($player.assembly)
	$xml.selectSingleNode("/configuration/players/$playerId/parameter[@name='AiCheating']/@value").set_innerXml($player.AiCheating)
	$xml.selectSingleNode("/configuration/players/$playerId/parameter[@name='RoundsToCompute']/@value").set_innerXml($player.RoundsToCompute)
	$xml.selectSingleNode("/configuration/players/$playerId/parameter[@name='CardSelectionStrategy']/@value").set_innerXml($player.CardSelectionStrategy)
	$xml.selectSingleNode("/configuration/players/$playerId/parameter[@name='SimulationsPerRound']/@value").set_innerXml($player.SimulationsPerRound)
	$xml.selectSingleNode("/configuration/players/$playerId/parameter[@name='RuleThreshold']/@value").set_innerXml($player.RuleThreshold)
	$xml.selectSingleNode("/configuration/players/$playerId/parameter[@name='GameThreshold']/@value").set_innerXml($player.GameThreshold)
}

function AmendAndSaveConfig
{
	param(
		[PSObject]$player1,
		[PSObject]$player2,
		[PSObject]$player3,
		[string]$configId
	)
	[xml]$xml = Get-Content -Path $config
	AmendConfigForPlayer $xml 'player1' $player1
	AmendConfigForPlayer $xml 'player2' $player2
	AmendConfigForPlayer $xml 'player3' $player3

	$configPath = "{0}/{1}.config" -f $outputDir, $configId
	$xml.Save($configPath)
}

$startTime = $(Get-Date)

EnsureDirectoryExists $outputDir
Write-Host Generating config files to $outputDir/ ...

$playerConfigData = LoadPlayerConfig $config
$player1 = $playerConfigData | Where-Object { $_.Position -eq 'player1' }
$player2 = $playerConfigData | Where-Object { $_.Position -eq 'player2' }
$player3 = $playerConfigData | Where-Object { $_.Position -eq 'player3' }

[xml]$xml = Get-Content -Path $config

AmendAndSaveConfig $player1 $player2 $player3 "abc"
AmendAndSaveConfig $player1 $player3 $player2 "acb"
AmendAndSaveConfig $player2 $player1 $player3 "bac"
AmendAndSaveConfig $player2 $player3 $player1 "bca"
AmendAndSaveConfig $player3 $player1 $player2 "cab"
AmendAndSaveConfig $player3 $player2 $player1 "cba"

$elapsedTime = $(Get-Date) - $startTime
Write-Host Finished in ("{0:hh\:mm\:ss}" -f $elapsedTime)