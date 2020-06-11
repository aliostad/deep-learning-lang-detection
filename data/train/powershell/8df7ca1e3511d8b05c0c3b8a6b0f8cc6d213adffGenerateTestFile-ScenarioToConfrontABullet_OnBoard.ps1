param (
	$initialGameStateFilePath = 'C:\Competitions\EntelectChallenge2013\temp\InitialGameStates\board\InitialGame.xml',
    $modifiedGameStateFilePath = 'C:\Competitions\EntelectChallenge2013\temp\InitialGameStates\board\ModifiedGame_ConfrontABullet.xml'
)

cd ectest:\

.\Load-Assemblies.ps1
.\Load-GameStateFile.ps1 $initialGameStateFilePath

$gameState = .\Get-CurrentGameState.ps1

Write-Host "Loaded game state from $initialGameStateFilePath :" -foregroundColor Green
.\Show-GameState.ps1 $gameState

$down = .\Get-Dir.ps1 'DOWN'
$up = .\Get-Dir.ps1 'UP'
$left = .\Get-Dir.ps1 'LEFT'
$right = .\Get-Dir.ps1 'RIGHT'

.\Move-Bullet.ps1 $gameState 0 0 20 11 $up  # tank A's bullet

Write-Host "Modified game state for saving to $modifiedGameStateFilePath :" -foregroundColor Green
.\Show-GameState.ps1 $gameState

.\Save-GameStateFile.ps1 $modifiedGameStateFilePath
