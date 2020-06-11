echo "Enable all required modules in the Apache configuration."
(cat C:\Apache2.2\conf\httpd.conf) | %{$_ -replace "#LoadModule rewrite_module modules/mod_rewrite.so", "LoadModule rewrite_module modules/mod_rewrite.so"} | Set-Content C:\Apache2.2\conf\httpd.conf
(cat C:\Apache2.2\conf\httpd.conf) | %{$_ -replace "#LoadModule ssl_module modules/mod_ssl.so", "LoadModule ssl_module modules/mod_ssl.so"} | Set-Content C:\Apache2.2\conf\httpd.conf
(cat C:\Apache2.2\conf\httpd.conf) | %{$_ -replace "#Include conf/extra/httpd-ssl.conf", "Include conf/extra/httpd-ssl.conf"} | Set-Content C:\Apache2.2\conf\httpd.conf
(cat C:\Apache2.2\conf\httpd.conf) | %{$_ -replace "#LoadModule proxy_module modules/mod_proxy.so", "LoadModule proxy_module modules/mod_proxy.so"} | Set-Content C:\Apache2.2\conf\httpd.conf
(cat C:\Apache2.2\conf\httpd.conf) | %{$_ -replace "#LoadModule proxy_balancer_module modules/mod_proxy_balancer.so", "LoadModule proxy_balancer_module modules/mod_proxy_balancer.so"} | Set-Content C:\Apache2.2\conf\httpd.conf
(cat C:\Apache2.2\conf\httpd.conf) | %{$_ -replace "#LoadModule proxy_http_module modules/mod_proxy_http.so", "LoadModule proxy_http_module modules/mod_proxy_http.so"} | Set-Content C:\Apache2.2\conf\httpd.conf
(cat C:\Apache2.2\conf\httpd.conf) | %{$_ -replace "#LoadModule proxy_ajp_module modules/mod_proxy_ajp.so", "LoadModule proxy_ajp_module modules/mod_proxy_ajp.so"} | Set-Content C:\Apache2.2\conf\httpd.conf
(cat C:\Apache2.2\conf\httpd.conf) | %{$_ -replace "#LoadModule headers_module modules/mod_headers.so", "LoadModule headers_module modules/mod_headers.so"} | Set-Content C:\Apache2.2\conf\httpd.conf

echo "copy the JDFS and CA certificate and the key for SSL communication."
cp E:\jdg_scripts\certificates\DigiCertCA.crt C:\Apache2.2\conf
cp E:\jdg_scripts\certificates\www_jdfs_co_za.crt C:\Apache2.2\conf
cp E:\jdg_scripts\certificates\star_jdfs_co_za.key C:\Apache2.2\conf

echo "modify httpd-ssl.conf"
(cat C:\Apache2.2\conf\extra\httpd-ssl.conf) | %{$_ -replace "SSLCertificateFile ""C:/Apache2.2/conf/server.crt""", "SSLCertificateFile C:\\Apache2.2\\conf\\www_jdfs_co_za.crt"} | Set-Content C:\Apache2.2\conf\extra\httpd-ssl.conf
(cat C:\Apache2.2\conf\extra\httpd-ssl.conf) | %{$_ -replace "SSLCertificateKeyFile ""C:/Apache2.2/conf/server.key""", "SSLCertificateKeyFile C:\\Apache2.2\\conf\\star_jdfs_co_za.key"} | Set-Content C:\Apache2.2\conf\extra\httpd-ssl.conf
(cat C:\Apache2.2\conf\extra\httpd-ssl.conf) | %{$_ -replace "#SSLCertificateChainFile ""C:/Apache2.2/conf/server-ca.crt""", "SSLCertificateChainFile C:\\Apache2.2\\conf\\DigiCertCA.crt"} | Set-Content C:\Apache2.2\conf\extra\httpd-ssl.conf
