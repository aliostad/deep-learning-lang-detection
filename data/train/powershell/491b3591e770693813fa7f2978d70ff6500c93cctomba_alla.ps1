#Autor: Juri Kononov Rühm: A21
#Skriptimise kodutöö
#Powershelli skript http kaudu failide alladaadimiseks.

#Küsime kasutajalt algandmeid, kui sisend puudub kasutame testandmeid
$source = Read-Host "Sisesta linki, mida on vaja ära tõmmata, näiteks: http://tallinntrophy.eu/index.php"
if (!$source) {
    [System.Windows.Forms.MessageBox]::Show("Sa ei ole sisestanud mingeid andmeid, testimiseks kasutan: http://tallinntrophy.eu/index.php" , "Status")
    $source = "http://tallinntrophy.eu/index.php"
}
Write-Host "$source"

$destination = Read-Host "Sisesta asukoht, kuhu fail tuleb salvestada, näiteks: C:\test\"
if (!$destination) {
    [System.Windows.Forms.MessageBox]::Show("Sa ei ole sisestanud mingeid andmeid, testimiseks kasutan: C:\test\" , "Status")
    $destination = "C:\test\"
}
Write-Host "$source"

$filename = Read-Host "Kuidas nimetame faili? Näiteks: index.html"
if (!$filename) {
    [System.Windows.Forms.MessageBox]::Show("Sa ei ole sisestanud mingeid andmeid, testimiseks kasutan: index.html" , "Status")
    $filename = "index.html"
}

#kontrollime, kas antud kaust on olemas, või mitte, kui ei ole siis loome
if(!(Test-Path -Path $destination )){
    New-Item -ItemType directory -Path $destination
}
#kleebin kooku kausta ja faili nime 
$fdestination = $destination + $filename

#alustame web sessioni
$action = new-object system.net.webclient

#küsime kasutajalt kas on HTACCESS või mitte, vastavalt sellele kas küsime andmeid või mitte
$OUTPUT= [System.Windows.Forms.MessageBox]::Show("Kas antud aadress vajab HTACCESS autentimist?" , "Status" , 4)

if ($OUTPUT -eq "YES" ) 
{
$action.Credentials = Get-Credential #küsime htaccess andmeid igaks juhuks
$action.downloadfile($source,$fdestination)
} 
else 
{ 
Write-Host "Jätame HTACCESSi vahele"
} 
#laeme andmeid alla
$action.downloadfile($source,$fdestination)

#"Chau Pakaa"
Write-Host "Skript on edukalt oma töö lõpetanud"
