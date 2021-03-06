function Get-SonarCloudOrganizationMember {
    <#
    .SYNOPSIS
    Get SonarCloud Organization Members

    .DESCRIPTION
    Get SonarCloud Organization Members
    Note this is from an unsupported and undocumented part of the API, /organizations, so use with caution since it is subject to change / disruption

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER pageSize
    Specify how many records to return per page

    .INPUTS
    System.String.
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-SonarCloudOrganizationMember -organization 'organization1'
#>
    [CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Int]$pageSize = 100
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/organizations/search_members'
        function CalculateOutput([PSCustomObject]$member) {

            [PSCustomObject] @{

                Name       = $member.name
                Login      = $member.login
                Avatar     = $member.avatar
                GroupCount = $member.groupCount
                IsOrgAdmin = $member.isOrgAdmin
            }
        }
    }

    process {

        try {

            $page = 1
            do {
                $queryParameters = @{

                    organization = $organization
                    ps           = $pageSize
                    p            = $page
                }
                $response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                if ($response.users){

                    foreach ($member in $response.users) {

                        CalculateOutput $member
                    }

                    $page++
                }
                else {
                    $escape = $true
                }
            }
            until ($escape)
        }
        catch [Exception] {

            throw
        }
    }
}