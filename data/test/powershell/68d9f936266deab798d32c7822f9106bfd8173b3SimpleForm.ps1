#################################################
# 2013-04-07 - TGI
# Downloaded on http://blog.akril.net
# Free to use as you want
#################################################

# Chargement des Windows Form
#region
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#endregion            

# Creation de la form principale
$form = New-Object Windows.Forms.Form

# Pour bloquer le resize du form et supprimer les icones Minimize and Maximize
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $False
$form.MinimizeBox = $False

# Choix du titre
$form.Text = "Hello world... oui pas très innovant, je sais !"

# Choix de la taille
$form.Size = New-Object System.Drawing.Size(400,370)

# Affichage de la Windows
$form.ShowDialog()

#################################################
# END OF PROGRAM
#################################################
