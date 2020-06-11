# This uses the http://im.kayac.com/ Hub notification API
# I use this for getting notifications in my iphone when I leave my place with a long running process.

$postParams = @{ message='Build finished!'}
Invoke-WebRequest -Uri http://im.kayac.com/api/post/adrianpadilla -Method POST -Body $postParams