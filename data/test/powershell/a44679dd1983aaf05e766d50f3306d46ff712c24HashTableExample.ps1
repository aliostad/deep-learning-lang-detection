# hash table example


# initializer type syntax
$ourHT = @{1 = "one"; 2 = "two"; 3 = "three"}
# alternative add syntax.. 
$ourHT.Add( 4,"four")
 
$ourHT
 
Write-host
 
$ourHT.remove(1);
 
$ourHT

Write-host

# show the type

$ourHT | get-member

 