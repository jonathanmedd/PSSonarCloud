function Disconnect-SonarCloud {
<#
    .SYNOPSIS
    Disconnect from the SonarCloud API

    .DESCRIPTION
    Disconnect from the SonarCloud API by removing the script SonarCloudConnection variable from PowerShell

    .EXAMPLE
    Disconnect-SonarCloud

    .EXAMPLE
    Disconnect-SonarCloud -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param ()

    # --- Check for the presence of $Script:SonarCloudConnection
    xCheckScriptSonarCloudConnection

    if ($PSCmdlet.ShouldProcess($Script:SonarCloudConnection.url)){

        try {

            Write-Verbose -Message "Removing SonarCloudConnection Script Variable"
            Remove-Variable -Name SonarCloudConnection -Scope Script -Force -ErrorAction SilentlyContinue
        }
        catch [Exception]{

            throw

        }
    }
}