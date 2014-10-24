Function New-Base10FromBase36{
<#
    .NOTES
    Author: John Tyndall (iTyndall.com), adapted from convertTo-Base36
    Version: 1.0.0.0

    .SYNOPSIS
    Creates a Base10 integer from a Base36 alphanumeric string.

    .DESCRIPTION
    The New-Base10FromBase36 cmdlet creates a new Base10 integer converted from a specified Base36 alphanumeric string.

    This type of conversion is most useful for calculating (or creating) a numeric serial number from an alphanumeric serial number, e.g., calculating a Dell Express Service Code from a Dell Service Tag.

    .PARAMETER Base36
    A Base36 alphanumeric string (e.g., "ABC1234").

    .INPUTS
    System.String. You can pipe one or more alphanumeric strings.

    .OUTPUTS
    System.Int64. This cmdlet returns a (long) integer. 

    .EXAMPLE
    New-Base10FromBase36 ABC1234

    This command converts the alphanumeric (i.e., Base36) string ABC1234 to a Base10 integer: 22453156048

    .EXAMPLE
    "ABC1234", "XYZ5678" | New-Base10FromBase36

    This command converts an array of alphanumeric (i.e., Base36) strings (ABC1234, XYZ5678) to an array of Base10 integers (22453156048, 73948694948).

    .LINK
    "Convert Dell Service Tag to Express Service Code" http://iTyndall.com/scripting/convert-dell-service-tag-to-express-service-code

    .LINK
    "PowerShell Base 36 functions" http://ss64.com/ps/syntax-base36.html

    .LINK
    "Find My Express Service Code" http://www.dell.com/support/troubleshooting/us/en/19/Expressservice

#>

param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="A Base36 alphanumeric string, e.g., ABC1234.")][System.String]$Base36
)

    Begin{}

    Process{
        $Alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        $ca = $Base36.ToUpper().ToCharArray()
        [System.Array]::Reverse($ca)
        [System.Int64]$Base10=0
    
        $i=0
        foreach($c in $ca){
            $Base10 += $Alphabet.IndexOf($c) * [System.Int64][System.Math]::Pow(36,$i)
            $i+=1
        }

        $Base10
    }

    End{}
    
}