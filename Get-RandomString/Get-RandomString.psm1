##########################################################################################
##### Filename: Get-RandomString.psm1                                                #####
#####                                                                                #####
##### Author: John Tyndall (john@tyndalltech.com)                                    #####
#####                                                                                #####
##### Description: Returns a random alphanumeric string (e.g., a password).          #####
#####                                                                                #####
#####                                                                                #####
##### Version: 1.0 (3/12/2014)                                                       #####
#####                                                                                #####
##### Revision History:                                                              #####
#####  3/12/14: v.1.0.0 by John Tyndall                                              #####
#####                                                                                #####
##### Disclaimer: The Software contained herein are provided to you "AS IS"          #####
##### without any warranties of any kind. The implied warranties of                  #####
##### non-infringement, merchantability and fitness for a particular purpose         #####
##### are expressly disclaimed. Use this Software at your own risk.                  #####
#####                                                                                #####
##### License: You are free to use this script as long as this header remains        #####
##### in tact (original credit to John Tyndall and TyndallTech).                     #####
#####                                                                                #####
##### If edited, please update the Revision History.                                 #####
#####                                                                                #####
##### Version 1.0 Copyright (c) 2014 by TyndallTech Software                         #####
##### http://www.tyndalltech.com                                                     #####
#####                                                                                #####
##########################################################################################

##############################################################################
#####                                                                    #####
##### BEGIN: CONFIGURATION                                               #####
#####                                                                    #####
##############################################################################

# =====================================================================
# [NONE]
# =====================================================================
# =====================================================================

##############################################################################
#####                                                                    #####
##### END: CONFIGURATION                                                 #####
#####                                                                    #####
##############################################################################

#Helper Function
Function Get-Dictionary{
<#
    .REMARKS
    Author: John Tyndall (john@tyndalltech.com)
    Last modified: 3/12/2014

    .SYNOPSIS
    Returns a dictionary array of characters.

    .DESCRIPTION
    The Get-Dictionary cmdlet generates an array of characters depending
    on which option is selected.

    .PARAMETER Option
    Specifies how to construct the character dictionary. The default dictionary is all
    uppercase and lowercase letters ("LettersOnly"). Select from the following options for additional characters:
    - "AsciiAll" adds all numbers and special characters (except for SPACE)
    - "AsciiConservative" adds all numbers and only these special characters: - _ .
    - "AsciiSafe" adds all numbers and special characters except for: SPACE " ' ` & ( ) | < >
    - "AsciiXML" adds all numbers and special characters for these: " & , < > `
    - "LettersNumbers" adds all numbers

    .EXAMPLE
    Get-Dictionary

    This command returns a character dictionary of all uppercase and lowercase letters.

    .EXAMPLE
    Get-Dictionary -Option AsciiXML

    This command returns a character dictionary of all uppercase and lowecase letters, numbers, and XML-friendly special characters.

#>
    Param(
        [Parameter(Mandatory=$False, Position=0)] [ValidateSet("AsciiAll","AsciiConservative","AsciiSafe","AsciiXML","LettersNumbers","LettersOnly")] [string]$Option="LettersOnly"
    )
    $Exclude=@()
    Switch($Option){
        "AsciiAll"{$Include = 33,126} #Upper/lower letters, numbers, all special (except space, ASCII#32)
        "AsciiConservative"{$Include = 45,122; $Exclude=47,58,59,60,61,62,63,64,91,92,93,94,96} #Upper/lower letters, numbers, WebSphere special
        "AsciiSafe"{$Include = 33,122; $Exclude=34,38,39,40,41,60,62,96} #Upper/lower letters, numbers, safe special
        "AsciiXML"{$Include = 33,122; $Exclude=34,38,44,60,62,96} #Upper/lower letters, numbers, XML-friendly special
        "LettersNumbers"{$Include = 48,122; $Exclude=58,59,60,61,62,63,64,91,92,93,94,95,96} #Upper/lower, numbers
        default {$Include = 65,122; $Exclude=91,92,93,94,95,96} #Upper/lower letters
    }

    $Dictionary = $null
    For ($a=$Include[0]; $a –le $Include[1]; $a++){
        If($Exclude -notcontains $a){
            $Dictionary+=,[char][byte]$a
        }#End If
    }#End For
        
    $Dictionary
}#End Function Get-LetterDictionary


Function Get-RandomString() {
<#
    .REMARKS
    Author: John Tyndall (john@tyndalltech.com)
    Last modified: 3/12/2014

    .SYNOPSIS
    Returns a dictionary array of characters.

    .DESCRIPTION
    The Get-Dictionary cmdlet generates an array of characters depending
    on which option is selected.

    .PARAMETER Option
    Specifies how to construct the character dictionary. The default dictionary is all
    uppercase and lowercase letters ("LettersOnly"). Select from the following options for additional characters:
    - "AsciiAll" adds all numbers and special characters (except for SPACE)
    - "AsciiConservative" adds all numbers and only these special characters: - _ .
    - "AsciiSafe" adds all numbers and special characters except for: SPACE " ' ` & ( ) | < >
    - "AsciiXML" adds all numbers and special characters for these: " & , < > `
    - "LettersNumbers" adds all numbers

    .EXAMPLE
    Get-RandomString

    This command returns a 12-character string of random uppercase and lowercase letters.

    .EXAMPLE
    Get-RandomString -Length 32

    This command returns a 32-character string of random uppercase and lowercase letters.

    .EXAMPLE
    Get-RandomString -Length 32 -UseDictionary "AsciiSafe"

    This command returns a 32-character string of random uppercase and lowercase letters, numbers, and special characters safe for most applications.
#>
    Param(
        [Parameter(Mandatory=$False, Position=0, HelpMessage="The length of the string.")] [int]$Length=12,
        [Parameter(Mandatory=$False, Position=1)] [string[]]$Dictionary,
        [Parameter(Mandatory=$False, Position=2)] [ValidateSet("AsciiAll","AsciiConservative","AsciiSafe","AsciiXML","LettersNumbers","LettersOnly")] [string]$UseDictionary="LettersOnly"
    )

    #Use specified dictionary
    Switch ($UseDictionary){
        "AsciiAll" {$Dictionary = Get-Dictionary AsciiAll}
        "AsciiConservative" {$Dictionary = Get-Dictionary AsciiConservative}
        "AsciiSafe" {$Dictionary = Get-Dictionary AsciiSafe}
        "AsciiXML" {$Dictionary = Get-Dictionary AsciiXML}
        "LettersNumbers" {$Dictionary = Get-Dictionary LettersNumbers}
        default {$Dictionary = Get-Dictionary}
    }

    #Generate random string of length $Length
    For($I=0; $I -le ($Length-1); $I++){
        $RandomString += ($Dictionary | Get-Random)
    }

    $RandomString

}#End Function Get-RandomString