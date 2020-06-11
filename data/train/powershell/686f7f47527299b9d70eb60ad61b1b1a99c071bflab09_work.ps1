# Task 1, will this work:
get-hotfix -computername (get-adcomputer -filter * | select-object -ExpandProperty name)
# Yes, since expand-property extracts the name only, feeding a string value to the -computername parameter

# Task 2, will this work:
get-adcomputer -filter * | get-hotfix

man get-hotfix -ShowWindow
# Nope, since the positonal doesn't take piped input, and the piped input -computername takes input by propertyname

# Task 3, will this work:
get-adcomputer -filter * | select-object @{l='computername';e={$_.name}} | get-hotfix
# I believe so? or does it require the -expand?

# Task 4, write command to use pipeline to retrieve a list of running processes form every computer in an AD:
get-process -computername (get-adcomputer -filter * | select-object -expandproperty name)

man get-process -ShowWindow

# Task 5, write a command that retrieves a list of installed services from every computer in an AD domain. Don't use pipeline input, instead use parenthetical command
man get-service -ShowWindow

(Get-ADComputer -Filter * | select-object @{l='computername';e={$_.name}} | get-service

# Task 6:
# Nope. Doesn't take pipeline input