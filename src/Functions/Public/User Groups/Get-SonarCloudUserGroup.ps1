function Get-SonarCloudUserGroup {
    <#
    .SYNOPSIS
    Get SonarCloud UserGroups

    .DESCRIPTION
    Get SonarCloud UserGroups

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER groupName
    SonarCloud Group Name

    .PARAMETER pageSize
    Specify how many records to return

    .INPUTS
    System.String.
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-SonarCloudUserGroup -organization 'organization1'

    .EXAMPLE
    Get-SonarCloudUserGroup -organization 'organization1' -groupName 'UserGroup A'
#>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory=$false,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$groupName,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$pageSize = 100
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/user_groups/search'
        function CalculateOutput([PSCustomObject]$userGroup){

            [PSCustomObject] @{

                Name = $userGroup.name
                Id = $userGroup.id
                Description = $userGroup.description
                MembersCount = $userGroup.membersCount
                Default = $userGroup.default
            }
        }
    }

    process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get UserGroup by name
                'ByName' {

                    foreach ($name in $groupName){

                        $queryParameters = @{

                            organization = $organization
                            q = $name
                            ps  = $pageSize
                        }

                        $response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                        foreach ($userGroup in $response.groups){

                            CalculateOutput $userGroup
                        }
                    }

                    break
                }
                # --- No parameters passed so return all UserGroups
                'Standard' {

                    $queryParameters = @{

                        organization = $organization
                        ps  = $pageSize
                    }
                    $Response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                    foreach ($userGroup in $response.groups){

                        CalculateOutput $userGroup
                    }
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
}