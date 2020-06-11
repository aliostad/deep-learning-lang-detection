$Port = New-Object System.IO.Ports.SerialPort COM2;
$Port.Open();
$message = @([byte]0x12, [byte]0x05);
$Port.Write($message,0,2);
$log = "";
$C = [char]($Port.ReadByte());
while ($C -ne 0x1a) {$log += $C; $C = [char]($Port.ReadByte());}
Write-Output $log
