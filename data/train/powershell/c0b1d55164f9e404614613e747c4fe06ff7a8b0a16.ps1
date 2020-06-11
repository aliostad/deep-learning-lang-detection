# Oefening 16

# Bepaal alle event-klassen die expliciet door een provider zijn 
# toegevoegd (van welke klassen zijn ze afgeleid?).
# Orden dit overzicht op aantal eigen attributen properties 
# van elke klasse. 
# Geef eventueel ook een lijst met de eigen properties 
# voor elke klasse

clear

# get all the WMI objects as a list
$list = Get-WmiObject -List

# get all the explicit added classes
$addedClasses = $list | 
    where { $_.__DERIVATION -eq "__ExtrinsicEvent" } | 
    select $_

# show the class and property count of the explicit added classes
$addedClasses | 
    sort __Property_Count -Descending | 
    select __Class, __Property_Count

#----------------------------------------------------------------------

# show the property names for the found classes
$addedClasses |
    sort __PROPERTY_COUNT -Descending |
    foreach {
        $_.__CLASS +"("+$_.__Property_Count+" properties)" 
        $_.Properties | select Name | Format-Wide -AutoSize
    }