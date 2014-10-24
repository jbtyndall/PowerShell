Function New-Base36FromBase10{
<#
    .NOTES
    Author: John Tyndall (iTyndall.com), adapted from convertFrom-Base36
    Version: 1.0.0.0

    .SYNOPSIS
    Creates a Base36 alphanumeric string from a Base10 integer.

    .DESCRIPTION
    The New-Base36FromBase10 cmdlet creates a new Base36 alphanumeric string converted from a specified Base10 integer.

    This type of conversion is most useful for calculating (or creating) an alphanumeric serial number from a numeric serial number, e.g., calculating a Dell Service Tag from a Dell Express Service Code.

    .PARAMETER Base10
    A Base10 integer (e.g., 12345678910).

    .INPUTS
    System.Int64. You can pipe one or more integers.

    .OUTPUTS
    System.String. This cmdlet returns an alphanumeric string. 

    .EXAMPLE
    New-Base36FromBase10 22453156048

    This command converts Base10 integer 22453156048 to an alphanumeric (i.e., Base36) string: ABC1234

    .EXAMPLE
    22453156048, 73948694948 | New-Base36FromBase10

    This command converts an array of alphanumeric (i.e., Base36) strings (22453156048, 73948694948) to an array of Base10 integers (ABC1234, XYZ5678).

    .LINK
    "Convert Dell Service Tag to Express Service Code" http://iTyndall.com/scripting/convert-dell-service-tag-to-express-service-code

    .LINK
    "PowerShell Base 36 functions" http://ss64.com/ps/syntax-base36.html

    .LINK
    "Find My Express Service Code" http://www.dell.com/support/troubleshooting/us/en/19/Expressservice

#>

param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="A Base10 integer, e.g., 22453156048.")][System.Int64]$Base10
)

    Begin{}

    Process{
        $Alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        $Base36=""

        do{
            $r = $Base10 % 36
            $c = $Alphabet.Substring($r,1)
            $Base36 = "$c$Base36"
            $Base10 = ($Base10 - $r)/36
        } while ($Base10 -gt 0)

        $Base36
    }

    End{}
    
}