function Get-SonarCloudUser {
    <#
    .SYNOPSIS
    Get SonarCloud Users

    .DESCRIPTION
    Get SonarCloud Users

    .PARAMETER userName
    SonarCloud User Name - filter on login, name or email

    .PARAMETER pageSize
    Specify how many records to return

    .INPUTS
    System.String.
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-SonarCloudUser -userName 'User A','User B'
#>
    [CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$userName,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$pageSize = 100
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/users/search'
        function CalculateOutput([PSCustomObject]$user){

            [PSCustomObject] @{

                Name = $user.name
                Login = $user.login
                Email = $user.email
                Active = $user.active
                Groups = $user.groups
                TokensCount = $user.tokensCount
                Local = $user.local
                ExternalIdentity = $user.externalIdentity
                ExternalProvider = $user.externalProvider
                LastConnectionDate = $user.lastConnectionDate
            }
        }
    }

    process {

        try {

            foreach ($name in $userName){

                $queryParameters = @{

                    q = $name
                    ps  = $pageSize
                }

                $response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                foreach ($user in $response.users){

                    CalculateOutput $user
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
}