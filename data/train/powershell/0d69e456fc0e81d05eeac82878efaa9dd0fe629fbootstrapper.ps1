#
#  Copyright (c) Microsoft. All rights reserved.  
#  Licensed under the MIT license. See LICENSE file in the project root for full license information.
#

param (
    [string]$apiToken,
    [string]$appID,
    [string]$binaryPath,
    [string]$symbolsPath,
    [string]$notesPath,
    [string]$notes,
    [string]$publish,
    [string]$mandatory,
    [string]$notify,
    [string]$tags,
    [string]$teams,
    [string]$users
) 
  
$env:INPUT_apiToken = $apiToken
$env:INPUT_appID = $appID
$env:INPUT_binaryPath = $binaryPath
$env:INPUT_symbolsPath = $symbolsPath
$env:INPUT_notesPath = $notesPath
$env:INPUT_notes = $notes
$env:INPUT_publish = $publish
$env:INPUT_mandatory = $mandatory
$env:INPUT_notify = $notify
$env:INPUT_tags = $tags
$env:INPUT_teams = $teams
$env:INPUT_users = $users

node hockeyApp.js