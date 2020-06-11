#We also need to be able to do this script resources. 
#So, if there was a script module “myscriptmodule.schema.psm1”,
#contained in a module myscriptmodule as:
# $PSModuleRoot\myscriptmodule\ myscriptmodule.schema.psm1 



configuration scriptRes2
{ 
    param ($message)

    Log l1
    {
        Message = "The message is:$message"
    }
}

#able to reference this module in a configuration just like I do a .schema.mof file 
#and use the script resource types just like one defined with MOF:

configuration foo
{
    param ($aparam)

    Log first
    {
        Message = "Top level module"
    }

    scriptRes2 abc1  
    {
        Message  = "A param is $aParam first call"
    }
    #notice instance id generated
    scriptRes2 abc2
    {
        Message  = "A param is $aParam second call"
    }
} 
 
foo -OutputPath c:\temp\config -aparam "param"

cat C:\temp\config\localhost.mof

Start-DscConfiguration c:\temp\config -ComputerName localhost -Wait -verbose