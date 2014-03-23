<#
    .NOTES
    Author:  John Tyndall (john@iTyndall.com)
    Version: 1.0.0

    .SYNOPSIS
    Loads a script configuration file.

    .DESCRIPTION
    Loads a PowerShell script.config file. This is an XML-based file that is similar
    to a .NET configuration file that can be used to store script settings.

    .PARAMETER ConfigFilePath
    The path to the script.config file. If no config file is specified, the script
    looks for "script.config" in the current working directory. 

    .INPUTS
    The full path to the script configuration file.

    .OUTPUTS
    A hash table containing the script configuration.

    .EXAMPLE
    Get-ScriptConfig

    This command attempts to load "script.config" from the current working directory.

    .EXAMPLE
    Get-ScriptConfig "C:\MyConfig.xml"

    This command attempts to load the "C:\MyConfig.xml" configuration file.
#>
param(
    [Parameter(Mandatory=$False, HelpMessage="The full path to the config file.")] [string]$ConfigFilePath=".\script.config"
)

If(-not(Test-Path $ConfigFilePath)){
    Write-Error "Could not find script configuration file at $($ConfigFilePath)." -ErrorAction Stop
}

[xml]$ScriptConfigXML = Get-Content $ConfigFilePath

$ScriptConfig = @{}

#add startup configuration
If($ScriptConfigXML.configuration.startup.HasChildNodes){
    $ScriptConfigXML.configuration.startup.ChildNodes | foreach{$ScriptConfig[$_.Name] = $_.Version -as "Version"}
}#End If

#add script settings configuration
If($ScriptConfigXML.configuration.scriptSettings.HasChildNodes){
    $ScriptConfigXML.configuration.scriptSettings.setting | foreach{$ScriptConfig[$_.Name] = $_.Value -as $_.serializeAs}
}

$ScriptConfig