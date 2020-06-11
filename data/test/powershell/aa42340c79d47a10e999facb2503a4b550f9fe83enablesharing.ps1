# 你连接到互联网的适配器名称
$name = "以太网"
# 共享网络 SSID
$ssid = "testssid"
# 共享网络密码
$key = "password"

Write "Internet Sharing Enabler v1.0 by James Swineson"

# chcp 437
# netsh wlan show drivers
# Write "> 停止热点"
# netsh wlan stop hostednetwork
# Write "> 禁用热点"
# netsh wlan set hostednetwork mode=disallow
Write "> 启动共享网络”
netsh wlan set hostednetwork mode=allow ssid=$ssid key=$key
netsh wlan start hostednetwork
#netsh wlan show hostednetwork

Write "> 设置共享网络通过 $name 连接到互联网"
# Register the HNetCfg library (once)
regsvr32 /s hnetcfg.dll

# Create a NetSharingManager object
$m = New-Object -ComObject HNetCfg.HNetShare

# List connections
# $m.EnumEveryConnection |% { $m.NetConnectionProps.Invoke($_) }

# Find connection
$c = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq $name }

# Get sharing configuration
$config = $m.INetSharingConfigurationForINetConnection.Invoke($c)

# See if sharing is enabled
# Write-Output $config.SharingEnabled

# See the role of connection in sharing
# 0 - public, 1 - private
# Only meaningful if SharingEnabled is True
# Write-Output $config.SharingType

# Enable sharing (0 - public, 1 - private)
$config.EnableSharing(0)

# Disable sharing
# $config.DisableSharing()

# Write "当前互联网状态："$config.SharingEnabled
Write "所有操作完成"
Write "======================= 系统网络接口状态 ======================="
netsh wlan show interfaces
Write "======================= 共享网络连接状态 ======================="
netsh wlan show hostednetwork
pause