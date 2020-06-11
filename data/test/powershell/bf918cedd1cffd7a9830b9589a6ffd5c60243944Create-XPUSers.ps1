# ran one time for spare3  rgk 4/20/10

function create-account ([string]$accountName = "testuser") {    
   $hostname = hostname    
   $comp = [adsi] "WinNT://$hostname"   
   $user = $comp.Create("User", $accountName)    
   #$user.SetPassword("x") # it bitched and moaned about the x
   
   $user.SetPassword("Password1") # by default, they have no password  # 4/20 -- set a complicated one    
   $user.SetInfo()       
} 

###
###  create the set of users for this PC
###     remember to add them to  the administrators group afterwards
###
###    goto:  start->administrative Tools->Computer Management->Users & Groups->Users--> add new quys to the Administrator Group

   $usernames ="SNelson","John", "Jim","Bill", "CTUser", "VTUser", "MeUser"   
   
   # following is for spare3...
   $usernames ="NH1", "NH2", "MA1", "MA2", "Enfield1", "Enfield2", "VT1", 'VT2', "Auburn1", "Auburn2"
   foreach ($act in $usernames) {      
      create-account($act)
   }

   # note this does not add the users to administrators...
   # and it should....  rgk 2/25/10
   
#http://www.powershellpro.com/powershell-tutorial-introduction/powershell-tutorial-active-directory/      
#http://www.manageengine.com/products/free-windows-active-directory-tools/free-microsoft-windows-powershell-cmdlet-manage-local-users-tool.html

#create-account( "foo1")
#$user
#$user = $computer.Create("user", "MyNewUser") 
#$user.SetPassword("password") 
#$user.SetInfo() 
#$user.userflags = $user.userflags + 65536 # flag 
##ADS_UF_DONT_EXPIRE_PASSWD = &h10000 
#$user.SetInfo() 
