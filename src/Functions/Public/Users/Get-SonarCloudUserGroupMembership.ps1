function Get-SonarCloudUserGroupMembership {
    <#
    .SYNOPSIS
    Get SonarCloud Groups a User belongs to

    .DESCRIPTION
    Get SonarCloud Groups a User belongs to

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER userLogin
    SonarCloud User Login

    .PARAMETER pageSize
    Specify how many records to return

    .INPUTS
    System.String.
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-SonarCloudUserGroupMembership -organization 'organization1' -userLogin 'usera@gitlab','userb@gitlab'
#>
    [CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$userLogin,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$pageSize = 25
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/users/groups'
        function CalculateOutput([PSCustomObject]$group, [String]$login){

            [PSCustomObject] @{

                Login = $login
                Name = $group.name
                Id = $group.id
                Description = $group.description
                Selected = $group.Selected
                Default = $group.default
            }
        }
    }

    process {

        try {

            foreach ($login in $userLogin){

                $queryParameters = @{

                    login = $login
                    organization = $organization
                    ps  = $pageSize
                }

                $response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                foreach ($group in $response.groups){

                    CalculateOutput $group $login
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
}