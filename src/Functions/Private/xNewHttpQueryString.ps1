function xNewHttpQueryString {
<#
    .SYNOPSIS
    Generates HTTP Query String from URI and parameters

    .DESCRIPTION
    Generates HTTP Query String from URI and parameters
    Based on https://powershellmagazine.com/2019/06/14/pstip-a-better-way-to-generate-http-query-strings-in-powershell/

    .INPUTS
    String
    Hashtable

    .OUTPUTS
    String

    .EXAMPLE
    $parameters = @{
        organization = 'test-321'
        ps  = 100
    }
    $url = 'https://sonarcloud.io/api/projects/search'

    xNewHttpQueryString -Uri $url -QueryParameter $parameters
#>
[CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Uri,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$QueryParameter
    )
    # Add System.Web
    Add-Type -AssemblyName System.Web

    # Create a http name value collection from an empty string
    $nvCollection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

    foreach ($key in $QueryParameter.Keys) {
        $nvCollection.Add($key, $QueryParameter.$key)
    }

    # Build the uri
    $uriRequest = [System.UriBuilder]$uri
    $uriRequest.Query = $nvCollection.ToString()

    return $uriRequest.Uri.OriginalString
}