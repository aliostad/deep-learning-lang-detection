$enabled = netsh int show interface name="Wireless Network Connection" | select-string -pattern "Admin" | select-string -pattern "Enabled"
if (-not $enabled) {
   netsh interface set interface name="Wireless Network Connection" admin=ENABLED
}
else {
   netsh interface set interface name="Wireless Network Connection" admin=DISABLED
}