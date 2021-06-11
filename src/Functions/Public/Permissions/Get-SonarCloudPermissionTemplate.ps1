function Get-SonarCloudPermissionTemplate {
    <#
    .SYNOPSIS
    Get SonarCloud PermissionTemplates

    .DESCRIPTION
    Get SonarCloud PermissionTemplates

    .PARAMETER organization
    SonarCloud organization

    .PARAMETER permissionTemplateName
    SonarCloud permissionTemplateName

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-SonarCloudPermissionTemplate -organization 'organization1'

    .EXAMPLE
    Get-SonarCloudPermissionTemplate -organization 'organization1' -permissionTemplateName 'PermissionTemplate A'
#>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$permissionTemplateName
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/permissions/search_templates'
        function CalculateOutput([PSCustomObject]$permissionTemplate){

            [PSCustomObject] @{

                Name = $permissionTemplate.name
                Id = $permissionTemplate.id
                Description = $permissionTemplate.description
                ProjectKeyPattern = $permissionTemplate.projectKeyPattern
                CreatedAt = $permissionTemplate.createdAt
                UpdatedAt = $permissionTemplate.updatedAt
                Permissions = $permissionTemplate.permissions
            }
        }
    }

    process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get PermissionTemplate by name
                'ByName' {

                    foreach ($name in $permissionTemplateName){

                        $queryParameters = @{

                            organization = $organization
                            q = $name
                        }

                        $response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                        foreach ($permissionTemplate in $response.permissionTemplates){

                            CalculateOutput $permissionTemplate
                        }
                    }

                    break
                }
                # --- No parameters passed so return all PermissionTemplates
                'Standard' {

                    $queryParameters = @{

                        organization = $organization
                    }
                    $Response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                    foreach ($permissionTemplate in $response.permissionTemplates){

                        CalculateOutput $permissionTemplate
                    }
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
}