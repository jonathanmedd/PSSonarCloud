function Add-SonarCloudUserGroupMember {
    <#
    .SYNOPSIS
    Add a SonarCloud User to a Group

    .DESCRIPTION
    Add a SonarCloud User to a Group

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER groupName
    SonarCloud Group Name

    .PARAMETER userLogin
    SonarCloud User Login, e.g. testuser1@gitlab

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Add-SonarCloudUserGroupMember -organization 'organization1' -groupName 'Group A' -userLogin 'testuser1@gitlab','testuser2@gitlab'
#>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$groupName,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$userLogin
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/user_groups/add_user'
    }

    process {

        try {

            foreach ($user in $userLogin){

                $queryParameters = @{

                    organization = $organization
                    name = $groupName
                    login = $user
                }

                if ($PSCmdlet.ShouldProcess($groupName)){

                    Invoke-SonarCloudRestMethod -Method POST -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
}