Function Get-DellExpressServiceCode{
<#
    .NOTES
    Author: John Tyndall (iTyndall.com)
    Version: 1.0.0.0

    .SYNOPSIS
    Gets a Dell Express Service Code from a Dell Service Tag.

    .DESCRIPTION
    The Get-DellExpressServiceCode cmdlet gets the Dell Express Service Code derived from a Dell Service Tag.

    A Dell Express Service Code is normally a 10-digit numeric number (i.e., a Base 10 numeral system), which is derived from a Dell Service Tag, which is normally a 5- to 7-digit alphanumeric number (i.e., a Base 36 numeral system). 

    .PARAMETER ServiceTag
    A Dell Service Tag (e.g., ABC1234).

    If this parameter is not provided, the Service Tag for the local system is used.

    .PARAMETER SkipSystemCheck
    The Get-DellExpressServiceCode is designed to get an Express Service Code from a Service Tag on Dell systems and checks the system manufacturer to ensure that it is a Dell.

    To bypass this system check, use the SkipSystemCheck switch.

    .INPUTS
    System.String. You can pipe one or more strings.

    .OUTPUTS
    System.Int64. This cmdlet returns a (long) integer. 

    .EXAMPLE
    Get-DellExpressServiceCode

    This commands gets the Express Service Code from the local system's Service Tag.

    .EXAMPLE
    Get-DellExpressServiceCode -SkipSystemCheck

    This command bypasses the system check (to see if the system is manufactured by Dell) and gets the Base 10 representation of the local system's serial number.

    If multiple Service Tags are passed, this system check is automatically bypassed.

    .EXAMPLE
    Get-DellExpressServiceCode ABC1234

    This commands gets the Express Service Code from a specified Service Tag (e.g., ABC1234): 22453156048

    .EXAMPLE
    "ABC1234", "XYZ5678" | Get-DellExpressServiceCode

    This command gets the Express Service Codes from an array of specified Service Tags (e.g., ABC1234, XYZ5678): 22453156048, 73948694948

    .LINK
    "Convert Dell Service Tag to Express Service Code" http://iTyndall.com/scripting/convert-dell-service-tag-to-express-service-code
#>

param(
    [Parameter(Mandatory=$False, Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="A Dell Service Tag (e.g., ABC1234).")][System.String]$ServiceTag=(Get-WmiObject Win32_Bios).SerialNumber,
    [switch]$SkipSystemCheck
)

    Begin{
        If($ServiceTag.Count > 1) {$SkipSystemCheck = $True}
    }

    Process{

        If([System.String]::IsNullOrEmpty($ServiceTag)) { Throw [System.Exception] "Could not retrieve system serial number." }

        If(-not $SkipSystemCheck){
            If((Get-WmiObject Win32_ComputerSystem).Manufacturer.ToLower() -notlike "*dell*") { Throw [System.Exception] "Dude, you don't have a Dell: $((Get-WmiObject Win32_ComputerSystem).Manufacturer)" }
        }

        $Alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        $ca = $ServiceTag.ToUpper().ToCharArray()
        [System.Array]::Reverse($ca)
        [System.Int64]$ExpressServiceCode=0
    
        $i=0
        foreach($c in $ca){
            $ExpressServiceCode += $Alphabet.IndexOf($c) * [System.Int64][System.Math]::Pow(36,$i)
            $i+=1
        }

        $ExpressServiceCode
    }

    End{}
    
}