<#
    .SYNOPSIS
    Creates a new XML document.

    .COPYRIGHT
    John Tyndall (john@iTyndall.com)

    .VERSION
    1.0 (3/12/2014)

    .NOTES
    3/12/14: v.1.0.0

    Disclaimer: The Software contained herein are provided to you "AS IS" without any warranties of any kind. The implied warranties of non-infringement, merchantability and fitness for a particular purpose are expressly disclaimed. Use this Software at your own risk.
#>

##########################################################################################
##### Filename: XMLTools.psm1                                                        #####
#####                                                                                #####
##### Author: John Tyndall (john@iTyndall.com)                                       #####
#####                                                                                #####
##### Description: Contains several functions for working with XML documents.        #####
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
##### Version 1.0 Copyright (c) 2014 by John Tyndall                                 #####
##### http://www.iTyndall.com                                                        #####
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

function New-XMLDocument {
<#
    .NOTES
    Author: John Tyndall (john@tyndalltech.com)
    Last modified: 3/12/2014

    .COPYRIGHT
    John Tyndall (john@iTyndall.com)

    .SYNOPSIS
    Creates an XML document.

    .DESCRIPTION
    Creates an XML document with a root element, one parent element with
    attributes, and any number of child elements.

    .PARAMETER Root
    The root name. By default, "BESAPI"

    .PARAMETER Parent
    The name of the parent element.

    .PARAMETER $Children
    A hash table containing 0 or more child elements in a (Name, Value) pair.

    .PARAMETER $Attributes
    A hash table containing 0 or more parent attributes in a (Name, Value) pair.

    .EXAMPLE
    Get-BigFixConsoleOperator -Name "John"

    .EXAMPLE
    Get-BigFixConsoleOperator -Name "John" -MasterOperator (Connect-BigFixConsole -MasterOperator Get-BigFixMasterOperatorCredentials)

    .OUTPUTS
    A ConsoleOperator XML object containing a list of console operators

    Examples: 
    - ($ConsoleOperators.BESAPI.Operator) retrieves a list of console operators
    - ($ConsoleOperators.BESAPI.Operator[0].Name) is the name of the first console operator in the list
#>
    param(
        [Parameter(Mandatory=$False, Position=0)] [string]$Root="BESAPI",
        [Parameter(Mandatory=$False, Position=1)] [string]$Parent="",
        [Parameter(Mandatory=$False, Position=2)] [hashtable]$Children=@{},
        [Parameter(Mandatory=$False, Position=3)] [hashtable]$ParentAttributes=@{}
    )

    #Create XML header and root
    $XMLDocument = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`n"
    $XMLDocument += "<$Root>`n"

    #Create parent element
    $XMLDocument += "`t<$Parent"

    #Add parent attributes
    If($ParentAttributes) {
        foreach ($attribute in $ParentAttributes.GetEnumerator()){ 
            $XMLDocument += " $($attribute.Name)=`"$($attribute.Value)`""
        }#End foreach
    }#End If

    $XMLDocument += ">`n"

    #Add children items
    If($Children){
        foreach ($child in $Children.GetEnumerator()){
            $XMLDocument += "`t`t<$($child.Name)>$($child.Value)</$($child.Name)>`n"
        }#End foreach
    }#End If

    #Close parent element
    $XMLDocument += "`t</$Parent>`n"

    #Close root element
    $XMLDocument += "</$Root>`n"

    [xml]$XMLDocument

}#End Function New-XMLDocument 


Function Get-SaveFileLocation{
<#
    .NOTES
    Author: John Tyndall (john@tyndalltech.com)
    Last modified: 3/12/2014

    .SYNOPSIS
    Gets a user-select filename and path using the Windows SaveFileDialog form.

    .DESCRIPTION
    Displays a Windows SaveFileDialog form. A default filename and path are provided; however,
    the user can change the filename and select a different location. When the user clicks Save,
    the filename and path are returned.

    .PARAMETER FileName
    The initial filename (filename.extension).

    .PARAMETER Destination
    The initial folder location to save the document. Default is the current user's Documents folder.

    .EXAMPLE
    Get-SaveFileLocation

    This command shows a SaveFileDialog. The filename is blank, and the default directory is
    the current user's Documents folder. The cmdlet captures the file path that the user selects.
#>
    param(
        [Parameter(Mandatory=$False, Position=0, HelpMessage="The initial filename (filename.extension).")] [string]$Filename="*.*",
        [Parameter(Mandatory=$False, Position=1, HelpMessage="The initial folder location to save the document.")] [string]$Destination=[System.Environment]::GetFolderPath("MyDocuments")
    )

    Try {
        [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
        $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
        $SaveFileDialog.FileName = $Filename
        $SaveFileDialog.InitialDirectory = $Destination
        $SaveFileDialog.filter = "All files (*.*)| *.*"
        $SaveFileDialog.ShowDialog() | Out-Null

        $SaveFileDialog.FileName

    } Catch {
        [System.Exception]
        "ERROR: $($error[0])"
        $error[0].Exception.HResult
        $error[0].ScriptStackTrace
    }#End Try

}#End Function Get-SaveFileLocation


Function Save-Object{
<#
    .NOTES
    Author: John Tyndall (john@tyndalltech.com)
    Last modified: 3/12/2014

    .SYNOPSIS
    Saves an object as a file.

    .DESCRIPTION
    Saves a specified object as a file to a specified folder. The cmdlet can also
    prompt the user for a location using a SaveFile dialog.

    .PARAMETER Object
    The object to save.

    .PARAMETER FileName
    The filename to save as (filename.extension).

    .PARAMETER Destination
    The folder location to save the document. Default is the current user's Documents folder.

    .PARAMETER ShowSaveDialog
    The cmdlet normally saves silently to a specified folder; however, if ShowSaveDialog is set
    to TRUE, a Windows SaveFile dialog will prompt the user for a location.

    .EXAMPLE
    Save-Object $MyObject "MyObject.obj"

    This command saves MyObject as MyObjectL.obj to the current user's Documents folder.

    .EXAMPLE
    Save-Object $MyObject "MyObject.obj" "\\files.tyndalltech.com\XMLBackups"

    This command saves MyObject as MyObject.obj to a custom location.

    .EXAMPLE
    Save-Object $MyObject "MyObject.obj" -ShowSaveDialog $True

    This command displays a SaveFile dialog prompting the user to save the file manually.
    The initial directory is the current user's Documents folder. The user can change the
    file's name and save location.
#>

    param(
        [Parameter(Mandatory=$True, Position=0, HelpMessage="The object to save.")] $Object,
        [Parameter(Mandatory=$False, Position=1, HelpMessage="The filename to save as (filename.extension).")] [string]$FileName="*.*",
        [Parameter(Mandatory=$False, Position=2, HelpMessage="The folder location to save the document.")] [string]$Destination=[System.Environment]::GetFolderPath("MyDocuments"),
        [Parameter(Mandatory=$False, Position=3, HelpMessage="Set to TRUE to show a Windows SaveFileDialog.")] [string]$ShowSaveFileDialog=$False
    )  
    
    Try{
        If($ShowSaveFileDialog){
            $NewDestination = Get-SaveFileLocation -Filename $FileName -Destination $Destination
            $Object.Save("$NewDestination")
        } Else {
            $Object.Save("$Destination\$Filename")
        }
    } Catch {
        [System.Exception]
        "ERROR: $($error[0])"
        $error[0].Exception.HResult
        $error[0].ScriptStackTrace
    }#End Try

}#End Function Save-Object


Function Set-HashTableValue{
<#
    .NOTES
    Author: John Tyndall (john@tyndalltech.com)
    Last modified: 3/12/2014

    .SYNOPSIS
    Adds and sets the value of a hashtable element.

    .DESCRIPTION
    Sets a name and value for a hashtable element. The New-XMLDocument cmdlet uses a 
    hash table for parent node attributes and child elements. Since you may not necessarily
    want to have a blank attribute value (i.e., for child elements), you can use this
    function to prevent unexpected results when using a hashtable for XML documents. 
    Elements without a name will not be added to the hash table.

    .PARAMETER HashTable
    The hash table object.

    .PARAMETER Name
    The name of the element to add.

    .PARAMETER Value
    The value of the element to add.

    .EXAMPLE
    Set-HashTableValue $MyHashTable "Name" "John"

    This command sets the value of the Name element to John. If the element does not exist,
    it is created; if it exists, the current value is overwritten with the specified value.

    .EXAMPLE
    Set-HashTableValue $MyHashTable

    This command does not set any values since Name is not specified.
#>

    param(
        [Parameter(Mandatory=$False, Position=0)] [hashtable]$HashTable,
        [Parameter(Mandatory=$False, Position=1)] [string]$Name="",
        [Parameter(Mandatory=$False, Position=2)] [string]$Value=""
    )

    #Only add elements that have a name value
    If(-not [string]::IsNullOrEmpty($Name)){
       $HashTable.Add($Name,$Value)
    }#End If

}#End Function Set-HashTableValue

