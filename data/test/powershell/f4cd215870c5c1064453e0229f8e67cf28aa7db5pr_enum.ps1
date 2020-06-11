$nl = $SCRIPT:nl


<#
.SYNOPSIS
    
    CALLING pr_enum : 
     * you can call pr_enum multiple times with the exact same variables and it will succeed
     * if you call pr_enum more than once using the same $group and $name parameters
     ** it will fail horribly
     ** it may be changed in the future to catch certain errors and return simple messages
     ** for now, it is up to the developer to test their configuration of code :(

    TODO: evaluate & fix how better to manage duplicate enums

.EXAMPLE
    pr_enum "computer_memory_architecture" "bit_32" "32-bit"
    write-host "$([pr_e.bit_32].Name) = $([pr_e.bit_32])"
    Write-host "$([pr_e.bit_32].Name) = $([pratom.enums.computer_memory_architecture.bit_32])" 
.EXAMPLE
    pr_enum -group:"computer_memory_architecture" -name:"bit_64" -value:"64-bit"
    write-host "$([pr_e.bit_64].Name) = $([pr_e.bit_64])"
    Write-host "$([pr_e.bit_64].Name) = $([pratom.enums.computer_memory_architecture.bit_64])" 
.EXAMPLE
    function accept_enum ( $e )
    {
        write-host $e
    }
    pr_enum "computer_memory_architecture" "bit_32" "32-bit"
    accept_enum [pr_e.bit_32]
.EXAMPLE 
    function accept_enum2
    {
        [cmdletbinding()]
        Param (
              [Parameter(Mandatory=$True,Position=0)]     [string]    $e
              )

        write-host $e
    }
    pr_enum "computer_memory_architecture" "bit_32" "32-bit"
    accept_enum2 [pr_e.bit_32]
#>
function pr_enum 
{
    [cmdletbinding()]
    Param (
          [Parameter(Mandatory=$True,Position=0)]     [string]    $group
        , [Parameter(Mandatory=$True,Position=1)]     [string]    $name
        , [Parameter(Mandatory=$False,Position=2)]    [string]    $value
    )
    write-verbose "pr_enum : `$group=[$group].  `$name=[$name].  `$value=[$value]."


    #set value if empty
    if ( $value -eq '' -or $value -eq $null )
    {
        $value = $name
    }

    # validation of names
        # is this enum_name already taken?
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
    $csharp_code = c_sharp_enum_template -enum_group:$group -enum_name:$name -enum_value:$value

    # Add the type to our memory space
    Add-Type $csharp_code 

    write-verbose "-------pr_enum added an enum value for `$group=[$group].  `$name=[$name].  `$value=[$value].
    USAGE :

    [pr_e.$name]
    [pr_e.$name].ToString()
    [pr_e.$name].fully_qualified_name
    [pratom.enum.$group.$name]::Value
    "



    return $null    
}
<#
function validate_c_sharp_name
{
    # http://stackoverflow.com/questions/92841/is-there-a-net-function-to-validate-a-class-name
    System.CodeDom.Compiler.CodeGenerator.IsValidLanguageIndependentIdentifier(string value)
}

function c_sharp_name_fix
{
    # http://stackoverflow.com/questions/92841/is-there-a-net-function-to-validate-a-class-name
    CSharpCodeProvider codeProvider = new CSharpCodeProvider(); 
    string sFixedName = codeProvider.CreateValidIdentifier( "somePossiblyInvalidName" ); 
    CodeTypeDeclaration codeType = new CodeTypeDeclaration( sFixedName );
}

function validate_identifiers
{
    CodeCompiler.ValidateIdentifiers(class1);
}
#>






<#
.EXAMPLE
    $csharp_code = c_sharp_enum_template -enum_group:"Test1" -enum_name:"name1" -enum_value:"1"
    Add-Type $csharp_code
    write-host "$([pr_e.name1].Name) = $([pr_e.name1])" 

    $csharp_code = c_sharp_enum_template -enum_group:"Test1" -enum_name:"name2" -enum_value:"2"
    Add-Type $csharp_code
    write-host "$([pr_e.name2].Name) = $([pr_e.name2])" 

    $csharp_code = c_sharp_enum_template -enum_group:"Test1" -enum_name:"name3" -enum_value:"3"
    Add-Type $csharp_code
    write-host "$([pr_e.name3].Name) = $([pr_e.name3])" 

    $csharp_code = c_sharp_enum_template -enum_group:"Test1" -enum_name:"name4" -enum_value:"4"
    Add-Type $csharp_code
    write-host "$([pr_e.name4].Name) = $([pr_e.name4])"
#>
function c_sharp_enum_template
{

    [cmdletbinding()]
    Param (
          [Parameter(Mandatory=$True,Position=0)]     [string]    $enum_group
        , [Parameter(Mandatory=$True,Position=1)]     [string]    $enum_name
        , [Parameter(Mandatory=$True,Position=2)]     [string]    $enum_value
    )
    assert_caller_is_in_my_file
    write-verbose "c_sharp_enum_template is working on the template for : pratom.enums.$enum_group.$enum_name = $enum_value"

    [string] $ret_string = @'
namespace pratom.enums.$enum_group 
{
    public class $enum_name
    {
        public override string ToString()
        {
            return @"$enum_value" ;
        }

        public static string Value
        {
            get 
                {
                    return @"$enum_value";
                }
        }
    }
}

/// pr_e is the pratom namespace for enums
namespace pr_e 
{
    public class $enum_name
    {
        /// usage in in Powershell : [pr_e.$enum_name]
        /// usage in in Powershell : [pr_e.$enum_name].ToString()
        /// usage in in Powershell : "$([pr_e.$enum_name])"
        public override string  ToString()
        {
           return ( new pratom.enums.$enum_group.$enum_name() ).ToString() ; 
        }

        public string enum_fully_qualified_name
        {
            get { return "pratom.enums.$enum_group.$enum_name" ; }
        }
    }
}

'@

    $ret_string = $ret_string.Replace("`$enum_group", $enum_group).Replace("`$enum_name", $enum_name).Replace("`$enum_value", $enum_value)

    write-debug "c_sharp_enum_template is returning the template : $($nl)$ret_string"

    return $ret_string
}