$nl = $SCRIPT:nl


<#
.SYNOPSIS
    
    CALLING pr_constant : 
     * you can call pr_constant multiple times with the exact same variables and it will succeed
     * if you call pr_constant more than once using the same $group and $name parameters
     ** it will fail horribly
     ** it may be changed in the future to catch certain errors and return simple messages
     ** for now, it is up to the developer to test their configuration of code :(

    TODO: evaluate & fix how better to manage duplicate constants

.EXAMPLE
    pr_constant "computer_memory_architecture" "bit_32" "32-bit"
    write-host "$([pr_c.bit_32].Name) = $([pr_c.bit_32])"
    Write-host "$([pr_c.bit_32].Name) = $([pratom.constants.computer_memory_architecture.bit_32])" 
.EXAMPLE
    pr_constant -group:"computer_memory_architecture" -name:"bit_64" -value:"64-bit"
    write-host "$([pr_c.bit_64].Name) = $([pr_c.bit_64])"
    Write-host "$([pr_c.bit_64].Name) = $([pratom.constants.computer_memory_architecture.bit_64])" 
.EXAMPLE
    function accept_constant ( $e )
    {
        write-host $e
    }
    pr_constant "computer_memory_architecture" "bit_32" "32-bit"
    accept_constant [pr_c.bit_32]
.EXAMPLE 
    function accept_constant2
    {
        [cmdletbinding()]
        Param (
              [Parameter(Mandatory=$True,Position=0)]     [string]    $e
              )

        write-host $e
    }
    pr_constant "computer_memory_architecture" "bit_32" "32-bit"
    accept_constant2 [pr_c.bit_32]
#>
function pr_constant 
{
    [cmdletbinding()]
    Param (
          [Parameter(Mandatory=$True,Position=0)]     [string]    $group
        , [Parameter(Mandatory=$True,Position=1)]     [string]    $name
        , [Parameter(Mandatory=$False,Position=2)]    [string]    $value
    )
    write-verbose "pr_constant : `$group=[$group].  `$name=[$name].  `$value=[$value]."

    # validation of names
        # is this constant_name already taken?
        # are any of the names invalid c# names?
        if ( ( is_numeric ( $name.substring(0,1) ) ) -eq $true )
        {
           $name = "_$name" 
        }
        <# bring any series of spaces down to a single space #>
        while ( "$name".Contains("  ") -eq $true ){
            $name = $name.Replace("  ", " ")
        }
        $name = $name.Replace(" ", "_")         <# replace spaces with underscores #>
        $name = $name.Replace("-", "_")         <# replace dashes with underscores #>


    # recording of names

    # get add_type string
    $csharp_code = c_sharp_constant_template -constant_group:$group -constant_name:$name -constant_value:$value

    # Add the type to our memory space
    Add-Type $csharp_code 

    write-verbose "-------pr_constant added a constant for `$group=[$group].  `$name=[$name].  `$value=[$value].
    USAGE :

    [pr_c.$name]
    [pr_c.$name].ToString()
    [pr_c.$name].fully_qualified_name
    [pratom.constants.$group.$name]::Value
    "
    return $null    
}







<#
.EXAMPLE
    $csharp_code = c_sharp_constant_template -constant_group:"Test1" -constant_name:"name1" -constant_value:"1"
    Add-Type $csharp_code
    write-host "$([pr_c.name1].Name) = $([pr_c.name1])" 

    $csharp_code = c_sharp_constant_template -constant_group:"Test1" -constant_name:"name2" -constant_value:"2"
    Add-Type $csharp_code
    write-host "$([pr_c.name2].Name) = $([pr_c.name2])" 

    $csharp_code = c_sharp_constant_template -constant_group:"Test1" -constant_name:"name3" -constant_value:"3"
    Add-Type $csharp_code
    write-host "$([pr_c.name3].Name) = $([pr_c.name3])" 

    $csharp_code = c_sharp_constant_template -constant_group:"Test1" -constant_name:"name4" -constant_value:"4"
    Add-Type $csharp_code
    write-host "$([pr_c.name4].Name) = $([pr_c.name4])"
#>
function c_sharp_constant_template
{

    [cmdletbinding()]
    Param (
          [Parameter(Mandatory=$True,Position=0)]     [string]    $constant_group
        , [Parameter(Mandatory=$True,Position=1)]     [string]    $constant_name
        , [Parameter(Mandatory=$True,Position=2)]     [string]    $constant_value
    )
    assert_caller_is_in_my_file
    write-verbose "c_sharp_constant_template is working on the template for : pratom.constants.$constant_group.$constant_name = $constant_value"

    [string] $ret_string = @'
namespace pratom.constants.$constant_group 
{
    public class $constant_name
    {
        public override string ToString()
        {
            return @"$constant_value" ;
        }

        public static string Value
        {
            get 
                {
                    return @"$constant_value";
                }
        }
    }
}

/// pr_c is the pratom namespace for constants
namespace pr_c 
{
    public class $constant_name
    {
        public override string  ToString()
        {
           return ( new pratom.constants.$constant_group.$constant_name() ).ToString() ; 
        }

        public string fully_qualified_name
        {
            get { return "pratom.constants.$constant_group.$constant_name" ; }
        }
    }
}

'@

    $ret_string = $ret_string.Replace("`$constant_group", $constant_group).Replace("`$constant_name", $constant_name).Replace("`$constant_value", $constant_value)

    write-debug "c_sharp_constant_template is returning the template : $($nl)$ret_string"

    return $ret_string
}