function Invoke-SonarCloudRestMethod {
<#
    .SYNOPSIS
    Wrapper for Invoke-RestMethod/Invoke-WebRequest with SonarCloud specifics

    .DESCRIPTION
    Wrapper for Invoke-RestMethod/Invoke-WebRequest with SonarCloud specifics

    .PARAMETER Method
    REST Method:
    Supported Methods: GET, POST, PUT,DELETE

    .PARAMETER URI
    API URI, e.g. /projects/search

    .PARAMETER QueryParameters
    HTTP Query String Parameters

    .PARAMETER Headers
    Optionally supply custom headers

    .PARAMETER Body
    REST Body in JSON format

    .PARAMETER OutFile
    Save the results to a file

    .PARAMETER WebRequest
    Use Invoke-WebRequest rather than the default Invoke-RestMethod

    .INPUTS
    System.String
    Hashtable
    Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $parameters = @{
        organization = 'test-321'
        ps  = 100
    }

    Invoke-SonarCloudRestMethod -Method GET -URI '/projects/search' -queryParameters $parameters
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="Body")]
        [Parameter(Mandatory=$true, ParameterSetName="OutFile")]
        [ValidateSet("GET","POST","PUT","DELETE")]
        [String]$method,

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="Body")]
        [Parameter(Mandatory=$true, ParameterSetName="OutFile")]
        [ValidateNotNullOrEmpty()]
        [String]$uri,

        [Parameter(Mandatory=$true, ParameterSetName="Standard")]
        [Parameter(Mandatory=$true, ParameterSetName="Body")]
        [Parameter(Mandatory=$true, ParameterSetName="OutFile")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$queryParameters,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="Body")]
        [Parameter(Mandatory=$false, ParameterSetName="OutFile")]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$headers,

        [Parameter(Mandatory=$false, ParameterSetName="Body")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$body,

        [Parameter(Mandatory=$false, ParameterSetName="OutFile")]
        [ValidateNotNullOrEmpty()]
        [String]$outFile,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [Parameter(Mandatory=$false, ParameterSetName="Body")]
        [Parameter(Mandatory=$false, ParameterSetName="OutFile")]
        [Switch]$webRequest
    )

    # --- Test for existing connection to vRA
    if (-not $Script:SonarCloudConnection){

        throw "SonarCloud Connection variable does not exist. Please run Connect-SonarCloud first to create it"
    }

    # --- Create Invoke-RestMethod Parameters
    $fullURI = "$($Script:SonarCloudConnection.url)$($uri)"

    # --- Update full URI if queryParameters have been supplied
    if ($PSBoundParameters.ContainsKey("queryParameters")){

        $fullURI = xNewHttpQueryString -Uri $fullURI -QueryParameter $queryParameters
    }
    Write-Verbose "Full URI is: $($fullURI)"

    # --- Prepare API Key for authentication
    $auth = $Script:SonarCloudConnection.apiKey + ':'
    $encoded = [System.Text.Encoding]::UTF8.GetBytes($auth)
    $base64 = [System.Convert]::ToBase64String($encoded)
    $basicAuthValue = "Basic $base64"

    # --- Add default headers if not passed
    if (!$PSBoundParameters.ContainsKey("Headers")){

        $headers = @{

            "Authorization" = $basicAuthValue;
        }
    }

    Write-Verbose "Headers are: $($headers | ConvertTo-Json)"

    # --- Set up default parmaeters
    $params = @{

        method = $method
        headers = $headers
        uri = $fullURI
    }

    if ($PSBoundParameters.ContainsKey("body")){

        $params.Add("body", $body)

        # --- Log the payload being sent to the server
        Write-Debug -Message ($body | ConvertTo-Json -Depth 5)
    }

    if ($PSBoundParameters.ContainsKey("outfile")){

        $params.Add("outFile", $outFile)

    }

    try {

        # --- Use either Invoke-WebRequest or Invoke-RestMethod
        if ($WebRequest.IsPresent) {

            Invoke-WebRequest @params
        }
        else {

            Invoke-RestMethod @params
        }
    }
    catch {

        throw $_
    }
}