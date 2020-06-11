function Show-Image($url) {
    # Load the WinForms assembly
    [void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
 
    # Get a temp filename, and download the picture
    $file = [System.IO.Path]::GetTempFileName()
    (new-object Net.WebClient).DownloadFile($url,$file)
 
    if ([System.IO.File]::Exists($file) -eq $false) {
        Write-Warning "Error downloading image"
        return
    }

    # Create an Image from the file
    $img = [System.Drawing.Image]::Fromfile($file);
 
    # Create a form with a PictureBox
    [System.Windows.Forms.Application]::EnableVisualStyles();
    $form = new-object Windows.Forms.Form
    $form.Text = "Image Viewer"
    $form.Width = $img.Size.Width;
    $form.Height =  $img.Size.Height;
    $pictureBox = new-object Windows.Forms.PictureBox
    $pictureBox.Dock = [System.Windows.Forms.DockStyle]::Fill
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
 
    $pictureBox.Image = $img;
    $form.controls.add($pictureBox)
    $form.Add_Shown( { $form.Activate() } )
    $form.ShowDialog()
    $form.Dispose()
}

function Search-Flickr ([string]$tags, [int]$count = 1) {
$api_key = "cb00a11683798919c3264dfb4ff2ad61"
$secret = "bb19a60407fb6a2b"
$search = Invoke-RestMethod -Uri "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=$api_key&secret=$secret&tags=$tags&extras=url_z&content_type=1&per_page=$count&format=rest" -Method Get
$search = [xml] $search

Write-Verbose $search.OuterXml

$url = $search.rsp.photos.photo.url_z
if ($url -eq $null -or $url[0] -eq $null) {
    return
}

$url | % { 
Write-Host $_
Show-Image $_
}

}