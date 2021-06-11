function xCheckScriptSonarCloudConnection {
<#
    .SYNOPSIS
    Checks for the presence of $Script:SonarCloudConnection

    .DESCRIPTION
    Checks for the presence of $Script:SonarCloudConnection

    .INPUTS
    None

    .OUTPUTS
    None

    .EXAMPLE
    xCheckScriptSonarCloudConnection
#>

[CmdletBinding()]

    Param (

    )
    # --- Test for SonarCloud Connection
    if (-not $Script:SonarCloudConnection){

        throw "SonarCloud Connection variable does not exist. Please run Connect-SonarCloud first to create it"
    }
}