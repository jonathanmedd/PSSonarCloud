function Add-SonarCloudOrganizationMember {
    <#
    .SYNOPSIS
    Add a member to a SonarCloud Organization

    .DESCRIPTION
    Add a member to a SonarCloud Organization
    Note this is from an unsupported and undocumented part of the API, /organizations, so use with caution since it is subject to change / disruption

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER userLogin
    SonarCloud User Login, e.g. testuser1@gitlab

    .INPUTS
    System.String.

    .OUTPUTS
    None

    .EXAMPLE
    Add-SonarCloudOrganizationMember -organization 'organization1' -userLogin 'testuser1@gitlab','testuser2@gitlab'
#>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$userLogin
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/organizations/add_member'

        function CalculateOutput([PSCustomObject]$member){

            [PSCustomObject] @{

                Name = $member.name
                Login = $member.login
                Avatar = $member.avatar
                GroupCount = $member.groupCount
            }
        }
    }

    process {

        try {

            foreach ($user in $userLogin){

                $queryParameters = @{

                    organization = $organization
                    login = $user
                }

                if ($PSCmdlet.ShouldProcess($groupName)){

                    $response = Invoke-SonarCloudRestMethod -Method POST -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference
                    CalculateOutput $response.user
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
}