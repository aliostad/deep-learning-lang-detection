#Dvnm Version
$dnvmVersion = "1.0.0-beta8"

# Colors
$infoColor = "Green"
$optionColor = "Yellow"
$titleColor = "Cyan"
$suggestionColor = "Magenta"


# ToArray function to convert output into an array.
function ToArray {
	begin {
		$output = @(); 
	}
	process {
		$output += $_; 
	}
	end	{
		return ,$output; 
	}
}

function ListDnvmVersions {
	Write-Host "Getting dnvm versions..." -foregroundcolor $infoColor
	dnvm list
}

function PickDnvmVersion {
	$version = Read-Host "Type in a different version or hit enter to continue with $dnvmVersion"

	if ($version -ne '')
		{$dnvmVersion = $version}

	Write-Host "Using dnvm version $dnvmVersion" -foregroundcolor $infoColor

	return $dnvmVersion
}

ListDnvmVersions
$dnvmVersion = PickDnvmVersion
dnvm install $dnvmversion
dnvm use $dnvmVersion
dnu restore

function ListDbContexts {
	Write-Host "Getting dbcontexts..." -foregroundcolor $infoColor
	$dbContexts = dnx ef dbcontext list | ToArray
	
	Write-Host "DbContexts" -foregroundcolor $titleColor
	
	for ($i=0; $i -lt $dbContexts.length; $i++) {
		$dbContexts[$i] = $dbContexts[$i] -creplace '(?s)^.*\.', ''
		Write-Host "[$i]" $dbContexts[$i] -foregroundcolor $optionColor
	}

	return $dbContexts
}

function PickDbContext {
	$dbContexts = ListDbContexts
	$dbContextName = ''
	
	if (@($dbContexts).Count -gt 1) {
		$number = Read-Host 'Pick dbContext'
		
		$dbContextName = $dbContexts[$number]
	}
	else {
		$dbContextName = $dbContexts
	}
	
	return $dbContextName
}

$dbContextName = PickDbContext

function CreateMigration {
	$name = Read-Host 'Migration name or press enter to cancel'

	if ($name -ne '') {
		dnx ef migrations add $name -c $dbContextName
		Write-Host "Migration $name created." -foregroundcolor $infoColor
		Write-Host "Recommended actions: [A]pply or [D]elete" -foregroundcolor $suggestionColor
	}
}

function ApplyMigration($name) {
	dnx ef database update $name -c $dbContextName
	if ([String]::IsNullOrEmpty($name)) 
		{Write-Host "Migrations applied." -foregroundcolor $infoColor}
}

function DeleteMigration {
	dnx ef migrations remove -c $dbContextName
	Write-Host "Migrations removed." -foregroundcolor $infoColor
}

function RevertMigration {
	$migrations = ListMigrations
	Write-Host "[C]ancel" -foregroundcolor $optionColor
	
	$number = Read-Host 'Migration number'
	
	if ($number -lt $migrations.length)	{
	
		if ($number -eq 0) 
			{$migration = $number}
		else 
			{$migration = $migrations[$number]}

		ApplyMigration($migration)
		
		if ($migration -eq 0)
			{Write-Host "All migrations reverted." -foregroundcolor $infoColor}
		else
			{Write-Host "Migration reverted to $migration." -foregroundcolor $infoColor}
			
		Write-Host "Recommended actions: [D]elete or [A]pply" -foregroundcolor $suggestionColor
	}
}

function ListMigrations {
	Write-Host "Getting migrations..." -foregroundcolor $infoColor
	$migrations = dnx ef migrations list -c $dbContextName | ToArray
	$migrations[0] = "All migrations"
	
	if ([String]::IsNullOrEmpty($dbContextName)) 
		{Write-Host "DbContext migrations" -foregroundcolor $titleColor}
	else
		{Write-Host $dbContextName "migrations" -foregroundcolor $titleColor}
	
	for ($i=0; $i -lt $migrations.length; $i++) 
		{Write-Host "[$i]" $migrations[$i] -foregroundcolor $optionColor}

	return $migrations
}

function ScriptMigrations() {
	dnx ef migrations script -c $dbContextName -o MigrationScript.sql
	Write-Host "MigrationScript.sql generated in project folder." -foregroundcolor $infoColor
}

function Quit {
	#TODO: Figure out a better quit?
	#Write-Host "Press any key to continue ..."
	#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Menu {
	Do {
		Write-Host "------$dbContextName------" -foregroundcolor $titleColor
		Write-Host "------Manage Migrations------" -foregroundcolor $titleColor
		Write-Host "[C]reate Migration" -foregroundcolor $optionColor
		Write-Host "[A]pply Migration(s)" -foregroundcolor $optionColor
		Write-Host "[D]elete Migration(s)" -foregroundcolor $optionColor
		Write-Host "[L]ist Migrations & DbContexts" -foregroundcolor $optionColor
		Write-Host "[R]evert Migration(s)" -foregroundcolor $optionColor
		Write-Host "[S]cript Migrations" -foregroundcolor $optionColor
		Write-Host "[Q]uit" -foregroundcolor $optionColor
		Write-Host "-----------------------------" -foregroundcolor $titleColor
		$choice = read-host -prompt "Select option & press enter"
	} until ($choice -ne "")

	Switch ($choice) {
		"C" {
				CreateMigration
				Menu
			}
		"A" {
				ApplyMigration
				Menu
			}
		"D" {
				DeleteMigration
				Menu
			}
		"L" {
				ListMigrations > $null
				ListDbContexts > $null
				Menu
			}
		"R" {
				RevertMigration
				Menu
		}
		"S" {
				ScriptMigrations
				Menu
		}
		"P" {
				PickDbContext
				Menu
		}
		"Q" {Quit}
		default {Menu}
	}
}

Menu
