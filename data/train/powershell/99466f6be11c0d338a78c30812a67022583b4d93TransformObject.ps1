<##################################################################################################
    Takes a user created object, transforms it to Native Data Store object.  
    
    This transformation adds a few extra properties and the Save() method. (self-aware feature)
##################################################################################################>
clear-host

### Load PSNativeDataStore!

Import-Module -Name PSNativeDataStore -DisableNameChecking


$prj = 'Inspector1'
$obj = 'tester4'

### Create an object using the hash table method.  
### This is a standard PowerShell object and exists only in memory
### It can not be used with NDS in this state

## define the properties
$properties = @{
    'BreakFast' = 'burger'
    'Lunch' = 'burger'
    'Supper' = 'I will gladly pay you Tuesday for a hamburger today'
}

## Create the object with the properties defined by the hash table object
$test4 = New-Object –TypeName PSObject –Property $properties


### Now we convert to standard PSObject into a PS Native Data Store object
### This adds additional properties and the 'self-aware' feature

TransformTo-NDSObject -inputobject $test4 -projectname $prj -objectname $obj 


### Now object has ability to save itself!

$test4.Save()
