function Get-SonarCloudProject {
    <#
    .SYNOPSIS
    Get SonarCloud Projects

    .DESCRIPTION
    Get SonarCloud Projects

    .PARAMETER organization
    SonarCloud Organization

    .PARAMETER projectName
    SonarCloud Project Name

    .PARAMETER pageSize
    Specify how many records to return

    .INPUTS
    System.String.
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-SonarCloudProject -organization 'organization1'

    .EXAMPLE
    Get-SonarCloudProject -organization 'organization1' -projectName 'Project A'
#>
    [CmdletBinding(DefaultParameterSetName = "Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$organization,

        [parameter(Mandatory = $false, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$projectName,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Int]$pageSize = 100
    )

    begin {

        # --- Check for the presence of $Script:SonarCloudConnection
        xCheckScriptSonarCloudConnection

        $apiUrl = '/projects/search'
        function CalculateOutput([PSCustomObject]$project) {

            [PSCustomObject] @{

                Name         = $project.name
                Key          = $project.Key
                Organization = $project.organization
                Qualifier    = $project.qualifier
                Visibility   = $project.visibility
            }
        }
    }

    process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- Get Project by name
                'ByName' {

                    foreach ($name in $projectName) {

                        $queryParameters = @{

                            organization = $organization
                            q            = $name
                            ps           = $pageSize
                        }

                        $response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                        foreach ($project in $response.components) {

                            CalculateOutput $project
                        }
                    }

                    break
                }
                # --- No parameters passed so return all Projects
                'Standard' {

                    $page = 1
                    do {
                        $queryParameters = @{

                            organization = $organization
                            ps           = $pageSize
                            p            = $page
                        }
                        $Response = Invoke-SonarCloudRestMethod -Method GET -URI $apiUrl -queryParameters $queryParameters -Verbose:$VerbosePreference

                        if ($response.components){

                            foreach ($project in $response.components) {

                                CalculateOutput $project
                            }

                            $page++
                        }
                        else {
                            $escape = $true
                        }
                    }
                    until ($escape)
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
}