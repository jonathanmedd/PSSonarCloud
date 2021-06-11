function New-SonarCloudProject {
    <#
    .SYNOPSIS
    Create a SonarCloud Project

    .DESCRIPTION
    Create a SonarCloud Project

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER projectName
    SonarCloud Project Name

    .PARAMETER projectKey
    Project Key, e.g. GitLab repo id

    .PARAMETER visibility
    Whether the created project should be visible to everyone, or only specific user/groups

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-SonarCloudProject -organization 'organization1' -projectName 'Project A' -projectKey '32959331'
#>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$projectName,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$projectKey,

        [parameter(Mandatory=$false)]
        [ValidateSet('private', 'public', IgnoreCase=$false)]
        [String]$visibility = 'private'
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/projects/create'

        function CalculateOutput([PSCustomObject]$project){

            [PSCustomObject] @{

                Name = $project.name
                Key = $project.Key
                Qualifier = $project.qualifier
                Visibility = $project.visibility
            }
        }
    }

    process {

        try {

            $queryParameters = @{

                organization = $organization
                name = $projectName
                project = $projectKey
                visibility = $visibility
            }

            if ($PSCmdlet.ShouldProcess($projectName)){

                $response = Invoke-SonarCloudRestMethod -Method POST -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference
                CalculateOutput $response.project
            }

        }
        catch [Exception] {

            throw
        }
    }
}