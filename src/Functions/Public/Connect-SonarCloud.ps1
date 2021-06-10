function Connect-SonarCloud {
<#
    .SYNOPSIS
    Make a connection to the SonarCloud API

    .DESCRIPTION
    Make a connection to the SonarCloud API. Set the SonarCloud API Key

    .PARAMETER APIKey
    SonarCloud API Key

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Connect-SonarCloud -APIKey 'xxxxxxxxxxxxxxxxx'
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param
    (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$apiKey
    )

    try {

        # --- Create Output Object
        $Script:sonarCloudConnection = [pscustomobject]@{

            apiKey = $apiKey
            url = 'https://sonarcloud.io/api'
        }
    }
    catch [Exception]{

        throw
    }
    finally {

        Write-Output $sonarCloudConnection
    }
}