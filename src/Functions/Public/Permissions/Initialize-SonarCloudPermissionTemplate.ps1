function Initialize-SonarCloudPermissionTemplate {
    <#
    .SYNOPSIS
    Apply a SonarCloud Permission Template

    .DESCRIPTION
    Apply a SonarCloud Permission Template

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER projectKey
    Project Key, e.g. GitLab repo id

    .PARAMETER permissionTemplateName
    Name of Permission Template to apply

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Initialize-SonarCloudPermissionTemplate -organization 'organization1' -projectKey '32959331' -permissionTemplateName 'PermissionTemplate A'
#>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$projectKey,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$permissionTemplateName
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/permissions/apply_template'
    }

    process {

        try {

            $queryParameters = @{

                organization = $organization
                projectKey = $projectKey
                templateName = $permissionTemplateName
            }

            if ($PSCmdlet.ShouldProcess($projectKey)){

                Invoke-SonarCloudRestMethod -Method POST -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference
            }

        }
        catch [Exception] {

            throw
        }
    }
}