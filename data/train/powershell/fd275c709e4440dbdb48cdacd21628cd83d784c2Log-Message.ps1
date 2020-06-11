function Log-Message($message, $type = "message") {
    
    switch ($type.ToLower()){
        "message" { $messageColor = "Green" }
        "error"   { $messageColor = "Red" }
        "warning" { $messageColor = "Yellow" }
        "info"    { $messageColor = "Cyan" }
    }
    
    Write-Host -ForegroundColor $messageColor "`n==========================================="
    Write-Host -ForegroundColor $messageColor $message
    Write-Host -ForegroundColor $messageColor "===========================================`n"
}


