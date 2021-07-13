function New-SonarCloudProjectALMIntegrated {
    <#
    .SYNOPSIS
    Create a SonarCloud Project Integrated with ALM

    .DESCRIPTION
    Create a SonarCloud Project Integrated with ALM, e.g. GitLab
    Note this is from an unsupported and undocumented part of the API, /alm_integration, so use with caution since it is subject to change / disruption

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER installationKeys
    SonarCloud InstallationKeys. For GitLab needs to be the ProjectId

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-SonarCloudProjectALMIntegrated -organization 'organization1' -installationKeys '32959331'
#>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$installationKeys
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/alm_integration/provision_projects'

        function CalculateOutput([PSCustomObject]$project){

            [PSCustomObject] @{

                Key = $project.projectKey
            }
        }
    }

    process {

        try {

            $queryParameters = @{

                organization = $organization
                installationKeys = $installationKeys
            }

            if ($PSCmdlet.ShouldProcess($installationKeys)){

                $response = Invoke-SonarCloudRestMethod -Method POST -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference
                CalculateOutput $response.projects
            }

        }
        catch [Exception] {

            throw
        }
    }
}